--Mod 8 Lab

--Challenge 1:  Retrieve Regional Sales Totals
--1:  Retrieve totals fro country/region and state/province

--Original query
SELECT
	a.CountryRegion,
	a.StateProvince,
	SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
GROUP BY a.CountryRegion, a.StateProvince
ORDER BY a.CountryRegion, a.StateProvince;

--Revised query
SELECT
	a.CountryRegion,
	a.StateProvince,
	SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;

--2.  Indicate the grouping level in the results

SELECT
	a.CountryRegion,
	a.StateProvince,
	SUM(soh.TotalDue) AS Revenue,
	 CASE
		WHEN GROUPING_ID(a.CountryRegion, a.StateProvince) = 0 THEN a.StateProvince + ' Total'
		WHEN GROUPING_ID(a.CountryRegion, a.StateProvince) = 1 THEN a.CountryRegion + 'Total'
		WHEN GROUPING_ID(a.CountryRegion, a.StateProvince) = 3 THEN 'Total'
	END AS 'Level'
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;

--Getting the levels involved
--Added in City for Task #3
SELECT 
	GROUPING_ID(a.CountryRegion, a.StateProvince, a.City) AS Level,
	a.CountryRegion,
	a.StateProvince,
	a.City,
	SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince, a.City)
ORDER BY a.CountryRegion, a.StateProvince, a.City;

--3.  Add a grouping level for cities

SELECT
	a.CountryRegion,
	a.StateProvince,
	a.City,
	SUM(soh.TotalDue) AS Revenue,
	 CASE
		WHEN GROUPING_ID(a.CountryRegion, a.StateProvince, a.City) = 0 THEN a.City + 'Total'
		WHEN GROUPING_ID(a.CountryRegion, a.StateProvince, a.City) = 1 THEN a.StateProvince + ' Total'
		WHEN GROUPING_ID(a.CountryRegion, a.StateProvince, a.City) = 3 THEN a.CountryRegion + 'Total'
		WHEN GROUPING_ID(a.CountryRegion, a.StateProvince, a.City) = 7 THEN 'Total'
	END AS 'Level'
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince, a.City)
ORDER BY a.CountryRegion, a.StateProvince, a.City;

--Challenge 2:  Retrieve Customer Sales Revenue by Category
--1. Retrieve customer sales revenue for each parent category

SELECT * 
FROM	
	(SELECT
		c.CompanyName,
		sod.LineTotal,
		gac.ParentProductCategoryName
	FROM SalesLT.Product AS p
	JOIN SalesLT.vGetAllCategories AS gac ON p.ProductCategoryID = gac.ProductCategoryID
	JOIN SalesLT.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID
	JOIN SalesLT.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
	JOIN SalesLT.Customer AS c ON soh.CustomerID = c.CustomerID
	) AS ParentCategorySales
PIVOT(SUM(LineTotal)
	FOR ParentProductCategoryName IN
		([Accessories], [Bikes], [Clothing], [Components])) AS PcsPivot
ORDER BY CompanyName;

--Unpivot for fun...

--Creating the table from our pivot
CREATE TABLE #CategorySalesPivot
(CompanyName nvarchar(128), Accessories numeric(38,6), Bikes numeric(38,6), Clothing numeric(38,6), Components numeric(38,6));

INSERT INTO #CategorySalesPivot
SELECT * 
FROM	
	(SELECT
		c.CompanyName,
		sod.LineTotal,
		gac.ParentProductCategoryName
	FROM SalesLT.Product AS p
	JOIN SalesLT.vGetAllCategories AS gac ON p.ProductCategoryID = gac.ProductCategoryID
	JOIN SalesLT.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID
	JOIN SalesLT.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
	JOIN SalesLT.Customer AS c ON soh.CustomerID = c.CustomerID
	) AS ParentCategorySales
PIVOT(SUM(LineTotal)
	FOR ParentProductCategoryName IN
		([Accessories], [Bikes], [Clothing], [Components])) AS PcsPivot
ORDER BY CompanyName;

--testing table results
SELECT * FROM #CategorySalesPivot;

--Unpivot
SELECT 
	CompanyName,
	ParentCategory,
	LineTotal
FROM
	(SELECT
		CompanyName,
		[Accessories], [Bikes], [Clothing], [Components]
	FROM #CategorySalesPivot) AS csp 
UNPIVOT
	(LineTotal FOR ParentCategory IN
		([Accessories], [Bikes], [Clothing], [Components])
	) AS LineTotals

--Results show the line total for each of the 4 ParentCategories for each company name; the totals have been aggregated, instead of seeing each individual line total

