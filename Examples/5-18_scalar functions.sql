--SCALAR FUNCTIONS DEMO

SELECT YEAR(SellStartDate) AS SellStartYear, ProductID, Name
FROM SalesLT.Product
ORDER BY SellStartYear; 

--DATENAME will return different values based on the parameters passed into it.
--Each time, we are passing the SellStartDate, but the first parameter is the datepart or the part of the date to return.
SELECT 
	YEAR(SellStartDate) AS SellStartYear,
	DATENAME(mm, SellStartDate) AS SellStartMonth,
	DAY(SellStartDate) AS SellStartDay,
	DATENAME(dw, SellStartDate) AS SellStartWeekday,
	ProductID,
	Name
FROM SalesLT.Product
ORDER BY SellStartYear;

--Comparing dates
SELECT 
	DATEDIFF(yy, SellStartDate, GETDATE()) AS YearsSold,
	ProductID,
	Name
FROM SalesLT.Product
ORDER BY 1, 3;

--Converting string to UPPER case; there is a LOWER as well.
SELECT 
	UPPER(Name) AS ProductName		
FROM SalesLT.Product;

--Concatinating strings.
SELECT 
	CONCAT(FirstName + ' ', LastName) AS FullName
FROM SalesLT.Customer;

--Looking for the first 2 characters on the left of the ProductNumber
--There is a RIGHT function as well.
SELECT
	Name,
	ProductNumber,
	LEFT(ProductNumber, 2) AS ProductType
FROM SalesLT.Product;

SELECT
	Name,
	ProductNumber,
	REVERSE(RIGHT(ProductNumber, 3)) AS ProductType
FROM SalesLT.Product;

SELECT 
	Name,
	ProductNumber,
	LEFT(ProductNumber, 2) AS ProductType,
	SUBSTRING(ProductNumber, CHARINDEX('-', ProductNumber) + 1, 4) AS ModelCode,
	--SUBSTRING (expression, start, length)
	--CHARINDEX(expression to find, expression to search, [start_location])
		--if start location is not specified, a negative number or zero,  search starts at the beginning of expression to search.
	SUBSTRING(ProductNumber, LEN(ProductNumber) - CHARINDEX('-', REVERSE(RIGHT(ProductNumber, 3))) + 2, 2) AS SizeCode
	--use the REVERSE so that you are getting the - at the end, instead of the first one, then add 2 to the CHARINDEX value itself
	--remember that you will be subtracting it from the overall length, order of operations - add/subtract from left to right
FROM SalesLT.Product;

--LOGICAL FUNCTIONS DEMO

--ISNUMERIC
SELECT Name, Size AS NumericSize
FROM SalesLT.Product
WHERE ISNUMERIC(Size) = 1;
--ISNUMERIC IS LIKE A BOOLEAN, TRUE (1) OR FALSE (0); so 1 doesn't mean the number 1 in this instance.

--IIF
SELECT
	Name,
	IIF(ProductCategoryID IN (5,6,7), 'Bike', 'Other') AS ProductType
FROM SalesLT.Product

--COMBINING THE TWO ABOVE
SELECT
	Name,
	IIF(ISNUMERIC(Size) = 1, 'Numeric', 'Non Numeric') AS SizeType
FROM SalesLT.Product;

--CHOOSE
SELECT 
	prd.Name AS ProductName,
	cat.Name AS Category,
	CHOOSE (cat.ParentProductCategoryID, 'Bikes', 'Components', 'Clothing', 'Accessories') AS ProductType
FROM SalesLT.Product AS prd
JOIN SalesLT.ProductCategory AS cat
ON prd.ProductCategoryID = cat.ProductCategoryID;


--WINDOW FUNCTIONS

SELECT TOP(100) ProductID, Name, ListPrice,
	RANK() OVER(ORDER BY ListPrice DESC) AS RankByPrice
FROM SalesLT.Product AS p
ORDER BY RankByPrice;

--Adding in a PARTITION BY to split the products into their separate categories.
--Ranks products per Category

SELECT c.Name AS Category, p.Name AS Product, ListPrice,
	RANK() OVER(PARTITION BY c.Name ORDER BY ListPrice DESC) as RankByPrice
FROM SalesLT.Product AS p
JOIN SalesLT.ProductCategory AS c
ON p.ProductCategoryID = c.ProductCategoryID
ORDER BY Category, RankByPrice;

--AGGREGATE FUNCTIONS:

SELECT 
	COUNT(*) AS Products, 
	COUNT(DISTINCT ProductCategoryID) AS Categories, 
	AVG(ListPrice) AS AveragePrice
FROM SalesLT.Product; 

--Filtering

SELECT 
	COUNT(p.ProductID) AS BikeModels,
	AVG(p.ListPrice) AS AveragePrice
FROM SalesLT.Product AS p
JOIN SalesLT.ProductCategory AS c
ON p.ProductCategoryID = c.ProductCategoryID
WHERE c.Name LIKE '%Bikes';

--GROUP BY

SELECT 
	CustomerID, 
	COUNT(*) AS Orders
FROM SalesLT.SalesOrderHeader
GROUP BY CustomerID;

-- Looking at total sales revenue (sum) for each or grouped by SalesPerson
SELECT
	c.Salesperson,
	ISNULL(SUM(oh.SubTotal), 0.00) AS SalesRevenue
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
GROUP BY c.Salesperson
ORDER BY SalesRevenue DESC;

--Looking at total sales revenue for earch SalesPerson and customer

SELECT
	c.SalesPerson,
	CONCAT(c.FirstName + ' ', c.LastName) AS Customer,
	ISNULL(SUM(oh.SubTotal), 0.00) as SalesRevenue
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
GROUP BY c.SalesPerson, CONCAT(c.FirstName + ' ', c.LastName) --The "CONCAT" needs to be included too since it is not an aggregate function, although it is a function.
ORDER BY SalesRevenue DESC, Customer;

--Filtering with HAVING Demo

SELECT 
	CustomerID, 
	COUNT(*) AS Orders
FROM SalesLT.SalesOrderHeader
GROUP BY CustomerID
HAVING COUNT(*) > 10;

SELECT
	sod.ProductID,
	SUM(sod.OrderQty) AS Quantity
FROM SalesLT.SalesOrderDetail as sod
JOIN SalesLT.SalesOrderHeader as soh
ON sod.SalesOrderID = soh.SalesOrderID
WHERE YEAR(soh.OrderDate) = 2008 --Can't put aggregate in the where clause since it is executed before the select and the aggregate is executed as part of the select.
GROUP BY ProductID
HAVING SUM(sod.OrderQty) > 50;


