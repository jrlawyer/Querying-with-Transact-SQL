--Mod 5 Lab Exercises

--Challenge 1:
--1.  Retrieve the name and approximate weight of each product.

SELECT
	ProductID,
	UPPER(Name) AS Name,
	ISNULL(ROUND(Weight, 0), 0.00) AS ApproximateWeight
FROM SalesLT.Product
ORDER BY ApproximateWeight DESC, ProductID;

--2.  Retrieve the year and month in which products were first sold

SELECT
	ProductID,
	UPPER(Name) AS Name,
	ISNULL(ROUND(Weight, 0), 0.00) AS ApproximateWeight,
	DATENAME (mm, SellStartDate) AS SellStartMonth,
	YEAR(SellStartDate) AS SellStartYear
FROM SalesLT.Product
ORDER BY ProductID;

--3.  Extract product types from product numbers
SELECT
	ProductID,
	UPPER(Name) AS Name,
	ISNULL(ROUND(Weight, 0), 0.00) AS ApproximateWeight,
	DATENAME (mm, SellStartDate) AS SellStartMonth,
	YEAR(SellStartDate) AS SellStartYear,
	LEFT(ProductNumber, 2) AS ProductType
FROM SalesLT.Product
ORDER BY ProductID;

--4.  Retrieve only products with a numeric size
SELECT
	ProductID,
	UPPER(Name) AS Name,
	ISNULL(ROUND(Weight, 0), 0.00) AS ApproximateWeight,
	DATENAME (mm, SellStartDate) AS SellStartMonth,
	YEAR(SellStartDate) AS SellStartYear,
	LEFT(ProductNumber, 2) AS ProductType,
	Size --For testing
FROM SalesLT.Product
WHERE ISNUMERIC(size) = 1
ORDER BY ProductID;

--Challenge 2:  
--1. Rank Customer by Revenue

SELECT 
	c.CompanyName,
	ROUND(soh.TotalDue, 0) AS TotalDue,
RANK() OVER(ORDER BY soh.TotalDue DESC) AS RankByTotal
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.SalesOrderHeader AS  soh
ON c.CustomerID = soh.CustomerID
--ORDER BY c.CompanyName; 
ORDER BY RankByTotal, c.CompanyName;

--Challenge 3:
--1.  Retrieve total sales by product

SELECT
	p.Name,
	CAST(ROUND(ISNULL(SUM(sod.LineTotal), 0), 0) AS INT) AS TotalRevenue
FROM SalesLT.Product AS p
LEFT JOIN SalesLT.SalesOrderDetail AS sod
ON p.ProductID = sod.ProductID
GROUP BY p.Name
ORDER BY TotalRevenue DESC;

--2.  Filter the product sales list to include only products that cost over $1,000

SELECT
	p.Name,
	p.ListPrice,  --Testing
	CAST(ROUND(ISNULL(SUM(sod.LineTotal), 0), 0) AS INT) AS TotalRevenue
FROM SalesLT.Product AS p
LEFT JOIN SalesLT.SalesOrderDetail AS sod
ON p.ProductID = sod.ProductID
WHERE p.ListPrice > 1000
GROUP BY p.Name, p.ListPrice
ORDER BY TotalRevenue DESC;

--3.  Filter the product sales group to include on total sales over $20,000

SELECT
	p.Name,
	p.ListPrice,  
	CAST(ROUND(ISNULL(SUM(sod.LineTotal), 0), 0) AS INT) AS TotalRevenue
FROM SalesLT.Product AS p
LEFT JOIN SalesLT.SalesOrderDetail AS sod
ON p.ProductID = sod.ProductID
WHERE p.ListPrice > 1000
GROUP BY p.Name, p.ListPrice
HAVING SUM(sod.LineTotal) > 20000 --Can't use TotalRevenue column since SELECT is executed after the HAVING; it doesn't know what it is until then.
ORDER BY TotalRevenue DESC;



