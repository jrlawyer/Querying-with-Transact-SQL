--CTE practice
WITH Sales_CTE (SalesOrderID, ProductID, SalesYear, LineTotal) AS
(SELECT
	SalesOrderID,
	ProductID,
	YEAR(ModifiedDate) AS SalesYear,
	LineTotal
FROM SalesLT.SalesOrderDetail
)
SELECT 
	SalesOrderID,
	COUNT(ProductID) AS SalesCount, 
	SalesYear,
	ROUND(SUM(LineTotal), 2) AS TotalSales
FROM Sales_CTE
GROUP BY SalesOrderID, SalesYear
ORDER BY SalesCount, SalesYear


--subquery practice
--We have a order header without an order detail...
SELECT SalesOrderID, OrderDate,
	(SELECT MAX(UnitPrice)
	FROM SalesLT.SalesOrderDetail AS sod
	WHERE soh.SalesOrderID = sod.SalesOrderID
	AND sod.SalesOrderDetailID IS NOT NULL) AS MaxUnitPrice
FROM SalesLT.SalesOrderHeader AS soh

--INNER JOIN removes NULLS
SELECT soh.SalesOrderID, soh.OrderDate, MAX(sod.UnitPrice) AS MaxUnitPrice
FROM SalesLT.SalesOrderHeader AS soh
JOIN SalesLT.SalesOrderDetail as sod
ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY soh.SalesOrderID, soh.OrderDate