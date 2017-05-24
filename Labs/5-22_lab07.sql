--Mod 7 Lab

--Challenge 1: Retrieve product information
--1. Retrieve product model descriptions

SELECT
	p.ProductID,
	p.Name,
	cd.Name AS ProductModelName,
	cd.Summary AS ProductModelSummary
FROM SalesLT.Product AS p
INNER JOIN SalesLT.vProductModelCatalogDescription AS cd
ON p.ProductModelID = cd.ProductModelID
ORDER BY p.ProductID;

--2. Create a table of distinct colors
DECLARE @Colors AS TABLE (Color VARCHAR(15));

INSERT INTO @Colors
SELECT DISTINCT Color FROM SalesLT.Product;

SELECT
	p.ProductID,
	p.Name,
	c.Color
FROM SalesLT.Product AS p
INNER JOIN @Colors as c
ON p.Color = c.Color
ORDER BY p.ProductID;

--OR...Returns the same number of rows.
SELECT
	ProductID,
	Name,
	Color
FROM SalesLT.Product
WHERE Color IN
	(SELECT Color FROM @Colors);

--3.  Retrieve product parent catagories
SELECT * FROM dbo.ufnGetAllCategories();

SELECT 
	p.ProductID,
	p.Name AS ProductName,
	gac.ParentProductCategoryName,
	gac.ProductCategoryName
FROM SalesLT.Product AS p
INNER JOIN dbo.ufnGetAllCategories() as gac
ON p.ProductCategoryID = gac.ProductCategoryID;

--Challenge 2:  Retrieve Customer Sales Revenue
--1:  Retrieve sales revenue by customer and contact

--CTE

WITH SalesRevenue(CompanyName, FirstName, LastName, TotalDue)
AS
	(
		SELECT
			c.CompanyName,
			c.FirstName,
			c.LastName,
			soh.TotalDue
		FROM SalesLT.Customer AS c
		LEFT JOIN SalesLT.SalesOrderHeader AS soh
		ON c.CustomerID = soh.CustomerID
	)
SELECT 
	CONCAT(CompanyName, ' (', FirstName, ' ', LastName, ')') AS Contact, 
	ISNULL(SUM(TotalDue), 0.00 )AS TotalRevenue
FROM SalesRevenue
GROUP BY CompanyName, FirstName, LastName
ORDER BY TotalRevenue DESC; 

--CTE Rework...Different way of defining columns/aliases

WITH SalesRevenue(CompanyAndContact, TotalDue)
AS
	(
		SELECT
			CONCAT(c.CompanyName, ' (', c.FirstName, ' ', c.LastName, ')') AS CompanyAndContact,
			soh.TotalDue
		FROM SalesLT.Customer AS c
		LEFT JOIN SalesLT.SalesOrderHeader AS soh
		ON c.CustomerID = soh.CustomerID
	)
SELECT 
	CompanyAndContact, 
	ISNULL(SUM(TotalDue), 0.00 )AS TotalRevenue
FROM SalesRevenue
GROUP BY CompanyAndContact
ORDER BY TotalRevenue DESC; 

--Derived table with externally defined aliases

SELECT 
	CONCAT(CompanyName, ' (', FirstName, ' ', LastName, ')') AS Contact,
	ISNULL(SUM(TotalDue), 0.00 )AS TotalRevenue
FROM
	(SELECT
		c.CompanyName,
		c.FirstName,
		c.LastName,
		soh.TotalDue
	FROM SalesLT.Customer AS c
	LEFT JOIN SalesLT.SalesOrderHeader as soh
	ON c.CustomerID = soh.CustomerID) AS SalesRevenue(CompanyName, FirstName, LastName, TotalDue)  --works without the aliases added here, since it uses the columns that are pulled from the table.
GROUP BY CompanyName, FirstName, LastName
ORDER BY TotalRevenue DESC;

--Derived table with internally defined alias
--If you try to define TotalRevenue internally, it expects a Grouping since SUM is an aggregate function and we aren't looking for all of them (*)

SELECT 
	Contact,
	ISNULL(SUM(TotalDue), 0.00) AS TotalRevenue
FROM
	(SELECT
		CONCAT (c.CompanyName, ' (', c.FirstName, c.LastName, ')') AS Contact,
		soh.TotalDue
	FROM SalesLT.Customer AS c
	LEFT JOIN SalesLT.SalesOrderHeader as soh
	ON c.CustomerID = soh.CustomerID) AS SalesRevenue
GROUP BY Contact
ORDER BY TotalRevenue DESC;

--See results prior to Grouping
SELECT
	CONCAT (c.CompanyName, ' (', c.FirstName, c.LastName, ')') AS Contact,
	soh.TotalDue
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader as soh
ON c.CustomerID = soh.CustomerID
ORDER BY Contact






