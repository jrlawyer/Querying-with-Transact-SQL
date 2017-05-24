--Mod 06 Lab Exercises

--Challenge 1:  
--1.  Retrieve products whose list price is higher than the average price

SELECT 
	ProductID,
	Name,
	ListPrice
FROM SalesLT.Product
WHERE ListPrice > 
	(SELECT AVG(UnitPrice)
	FROM SalesLT.SalesOrderDetail) --result of subquery: 382.87
ORDER BY ProductID;

--2.  Retrieve products with a list price of $100 or more that have been sold for less than $100

SELECT
	ProductID,
	Name,
	ListPrice
FROM SalesLT.Product
WHERE ListPrice >= 100
AND ProductID IN		--Multi-valued subquery since we'll need multiple values returned
	(SELECT ProductID
	FROM SalesLT.SalesOrderDetail
	WHERE UnitPrice < 100)
ORDER BY ProductID;

--3.  Retrieve the cost, list price, and average selling price for each product (Correlated query)

SELECT
	p.ProductID,
	p.Name,
	p.StandardCost AS Cost,
	p.ListPrice,
	ISNULL((SELECT AVG(UnitPrice)
	FROM SalesLT.SalesOrderDetail AS sod
	WHERE p.ProductID = sod.ProductID), 0.00) AS AvgUnitPrice
FROM SalesLT.Product AS p
ORDER BY AvgUnitPrice DESC, p.ProductID; 
	

--4. Retrieve products that have an average selling price that is lower than the cost.

SELECT
	p.ProductID,
	p.Name,
	p.ListPrice,
	p.StandardCost AS Cost,
	(SELECT AVG(UnitPrice)
	FROM SalesLT.SalesOrderDetail as sod
	WHERE p.ProductID = sod.ProductID) AS AvgUnitPrice
FROM SalesLT.Product as p
WHERE p.StandardCost >	
	(SELECT AVG(UnitPrice)
	FROM SalesLT.SalesOrderDetail as sod
	WHERE p.ProductID = sod.ProductID)
Order by AvgUnitPrice DESC;

--Challenge 2:  Retrieve Customer  Information
--1.  Retrieve customer information for all sales orders

SELECT
	soh.SalesOrderID,
	gci.CustomerID,
	gci.FirstName,
	gci.LastName,
	soh.TotalDue
FROM SalesLT.SalesOrderHeader AS soh
CROSS APPLY dbo.ufnGetCustomerInformation(soh.CustomerID) AS gci
ORDER BY soh.SalesOrderID;

--2.  Retrieve customer address information

SELECT
	gci.CustomerID,
	gci.FirstName,
	gci.LastName,
	a.AddressLine1,
	a.City
FROM SalesLT.CustomerAddress AS ca
INNER JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
OUTER APPLY dbo.ufnGetCustomerInformation(ca.CustomerID) AS gci
ORDER BY gci.CustomerID;

