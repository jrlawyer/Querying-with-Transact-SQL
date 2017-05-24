--Mod 06 Lab Rework

--Challenge 1:  Retrieve product price information
--1.  Retrieve products whose list price is higher than the average unit price for all products. (scalar subquery)

SELECT
	ProductID,
	Name,
	ListPrice
FROM SalesLT.Product
WHERE ListPrice > 
	(SELECT AVG(UnitPrice)
	FROM SalesLT.SalesOrderDetail); --382.87

--2.  Retrieve products with a list price of $100 or more that have been sold for less $100. (multi-valued subquery)

SELECT
	ProductID,
	Name,
	ListPrice
FROM SalesLT.Product
WHERE ListPrice >= 100 
AND ProductID IN
	(SELECT
		ProductID
	FROM SalesLT.SalesOrderDetail
	WHERE UnitPrice < 100)
ORDER BY ProductID;

--3.  Retrieve the cost, list price, and average selling price for each product.

SELECT
	p.ProductID,
	p.Name,
	p.StandardCost,
	p.ListPrice,
	(SELECT AVG(UnitPrice)
	FROM SalesLT.SalesOrderDetail AS sod
	WHERE p.ProductID = sod.ProductID) AS AvgUnitPrice
FROM SalesLT.Product as p
ORDER BY AvgUnitPrice DESC;

--4.  Retrieve products that have an average selling price that is lower than the cost.

SELECT
	p.ProductID,
	p.Name,
	p.ListPrice,
	p.StandardCost,
	(SELECT AVG(UnitPrice)
	FROM SalesLT.SalesOrderDetail AS sod
	WHERE p.ProductID = sod.ProductID) AS AvgUnitPrice
FROM SalesLT.Product as p
WHERE p.StandardCost >
	(SELECT AVG(UnitPrice)
	FROM SalesLT.SalesOrderDetail as sod
	WHERE p.ProductID = sod.ProductID)
ORDER BY AvgUnitPrice DESC;

--Challenge 2:
--1.  Retrieve customer information for all sales orders

SELECT
	soh.SalesOrderID,
	gci.CustomerID,
	gci.FirstName,
	gci.LastName,
	soh.TotalDue
FROM SalesLT.SalesOrderHeader as soh
CROSS APPLY dbo.ufnGetCustomerInformation(soh.CustomerID) AS gci
ORDER BY soh.TotalDue DESC;

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
CROSS APPLY dbo.ufnGetCustomerInformation(ca.CustomerID) AS gci
ORDER BY gci.CustomerID;

--Extra examples:

SELECT	CustomerID,
		CompanyName,
	(SELECT COUNT(*)
	FROM SalesLT.SalesOrderHeader AS soh
	WHERE soh.CustomerID = c.CustomerID) AS OrderCount
FROM SalesLT.Customer AS c
ORDER BY OrderCount DESC;

--retrieving information based on State/Province
SELECT
	soh.SalesOrderID,
	soh.OrderDate,
	soh.TotalDue,
	soh.CustomerID,
	(SELECT CompanyName
	FROM SalesLT.Customer AS c
	WHERE c.CustomerID = soh.CustomerID) AS Company
FROM SalesLT.SalesOrderHeader as soh
WHERE ShipToAddressID IN
	(SELECT AddressID
	FROM SalesLT.Address
	WHERE StateProvince = 'England')
ORDER BY SalesOrderID;



