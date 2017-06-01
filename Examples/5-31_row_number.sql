--ROW NUMBER

--Test query to return data
SELECT 
	SalesOrderID,
	CustomerID,
	ROUND(TotalDue, 2,1) AS	Total
FROM SalesLT.SalesOrderHeader
WHERE TotalDue <> 0
ORDER BY Total DESC

--Returning the row number
SELECT ROW_NUMBER() OVER(ORDER BY TotalDue DESC) AS Row,
	SalesOrderID, CustomerID, ROUND(TotalDue, 2, 1) AS Total
FROM SalesLT.SalesOrderHeader
WHERE TotalDue <> 0

--Test query to return data
	SELECT
		c.FirstName,
		c.LastName,
		ROUND(SUM(h.TotalDue),2,1) AS Total
	FROM SalesLT.SalesOrderHeader AS h
	JOIN SalesLT.Customer AS c
	ON h.CustomerID = c.CustomerID
	GROUP BY c.FirstName, c.LastName
	HAVING ROUND(SUM(h.TotalDue),2,1) <> 0
	ORDER BY Total DESC

--Returning the row number with a Join
SELECT ROW_NUMBER() OVER(ORDER BY h.TotalDue DESC) AS ROW, --ORDER BY IS WHAT DETERMINES THE ROW COUNT
	c.FirstName, c.LastName, ROUND(SUM(h.TotalDue),2,1) AS Total
	FROM SalesLT.SalesOrderHeader AS h
	JOIN SalesLT.Customer AS c
	ON h.CustomerID = c.CustomerID
	GROUP BY c.FirstName, c.LastName, h.TotalDue
	HAVING ROUND(SUM(h.TotalDue), 2,1) <> 0			

--Returning a subset of rows
;WITH OrderedOrders AS
(
	SELECT SalesOrderID, TotalDue,
	ROW_NUMBER() OVER (ORDER BY TotalDue DESC) AS RowNumber
	FROM SalesLT.SalesOrderHeader
	WHERE TotalDue <> 0
)
SELECT SalesOrderID, TotalDue, RowNumber
FROM OrderedOrders
WHERE RowNumber BETWEEN 1 AND 10;

--Test query to return data
SELECT
	a.FirstName,
	a.LastName,
	a.StateProvince,
	ROUND(SUM(h.TotalDue),2,1) AS Total
FROM SalesLT.vCustomerAddress AS a
JOIN SalesLT.SalesOrderHeader AS h
ON a.CustomerID = h.CustomerID
GROUP BY a.FirstName, a.LastName, a.StateProvince
HAVING ROUND(SUM(h.TotalDue),2,1) <> 0
ORDER BY a.StateProvince, Total DESC

--Using ROW_NUMBER with PARTITION

SELECT
	a.FirstName,
	a.LastName,
	a.StateProvince,
	ROUND(SUM(h.TotalDue), 2,1) AS Total,
	ROW_NUMBER() OVER(PARTITION BY a.StateProvince ORDER BY h.TotalDue DESC) AS Row
FROM SalesLT.vCustomerAddress AS a
JOIN SalesLT.SalesOrderHeader AS h
ON a.CustomerID = h.CustomerID
GROUP BY a.FirstName, a.LastName, a.StateProvince, h.TotalDue
HAVING ROUND(SUM(h.TotalDue),2,1) <> 0
ORDER BY a.StateProvince
	
--We don't need to group by since there aren't any customers with multiple orders.
SELECT
	a.FirstName,
	a.LastName,
	a.StateProvince,
	ROUND(h.TotalDue, 2,1) AS Total,
	ROW_NUMBER() OVER(PARTITION BY a.StateProvince ORDER BY h.TotalDue DESC) AS Row
FROM SalesLT.vCustomerAddress AS a
JOIN SalesLT.SalesOrderHeader AS h
ON a.CustomerID = h.CustomerID
WHERE ROUND(h.TotalDue, 2, 1) <> 0
ORDER BY a.StateProvince

--City, instead of StateProvince
SELECT
	a.FirstName,
	a.LastName,
	a.City,
	ROUND(h.TotalDue, 2,1) AS Total,
	ROW_NUMBER() OVER(PARTITION BY a.City ORDER BY h.TotalDue DESC) AS Row
FROM SalesLT.vCustomerAddress AS a
JOIN SalesLT.SalesOrderHeader AS h
ON a.CustomerID = h.CustomerID
WHERE ROUND(h.TotalDue, 2, 1) <> 0
ORDER BY a.City

--creating a subset of partitioned results
--DECLARE @MaxRow INT;

WITH OrdersByState AS
(
	SELECT
		a.FirstName,
		a.LastName,
		a.StateProvince,
		ROUND(h.TotalDue, 2,1) AS Total,
		ROW_NUMBER() OVER(PARTITION BY a.StateProvince ORDER BY h.TotalDue DESC) AS RowNumber
	FROM SalesLT.vCustomerAddress AS a
	JOIN SalesLT.SalesOrderHeader AS h
	ON a.CustomerID = h.CustomerID
	WHERE ROUND(h.TotalDue, 2, 1) <> 0
)

--SELECT @MaxRow = MAX(RowNumber) --Issue might be that it's out of scope after the first SELECT: how do we reference CTEs multiple times within the same batch...if we can actually do that?
--FROM OrdersByState
--PRINT @MaxRow;
	
SELECT 
	FirstName,
	LastName,
	StateProvince, 
	Total,
	RowNumber
FROM OrdersByState
--WHERE RowNumber BETWEEN 3 AND 5;
--WHERE RowNumber = 1;
--WHERE RowNumber > 4;
ORDER BY RowNumber DESC;
--WHERE RowNumber = @MaxRow

--Creating a temporary table to use; it produces the results I want.
CREATE TABLE #OrdersByState (FirstName NVARCHAR(50), LastName NVARCHAR(50), StateProvince NVARCHAR(50), Total MONEY, RowNumber INT)

--DROP TABLE #OrdersByState

INSERT INTO #OrdersByState
	SELECT
		a.FirstName,
		a.LastName,
		a.StateProvince,
		ROUND(h.TotalDue, 2,1) AS Total,
		ROW_NUMBER() OVER(PARTITION BY a.StateProvince ORDER BY h.TotalDue DESC) AS RowNumber
	FROM SalesLT.vCustomerAddress AS a
	JOIN SalesLT.SalesOrderHeader AS h
	ON a.CustomerID = h.CustomerID
	WHERE ROUND(h.TotalDue, 2, 1) <> 0
	
--SELECT * FROM #OrdersByState

DECLARE @MaxRow INT;
SELECT @MaxRow = MAX(RowNumber) FROM #OrdersByState;
--PRINT @MaxRow

SELECT
	FirstName,
	LastName,
	StateProvince,
	Total,
	RowNumber
FROM #OrdersByState
WHERE RowNumber = @MaxRow


--More practice with ROW_NUMBER:

SELECT
	ROW_NUMBER() OVER(PARTITION BY SalesPerson ORDER BY LastName) AS RowNumber,
	FirstName, LastName, SalesPerson
	FROM SalesLT.Customer
	WHERE CustomerID < 100;

WITH CustomerPerSalesPerson AS
(
	SELECT
	ROW_NUMBER() OVER(PARTITION BY SalesPerson ORDER BY LastName) AS RowNumber,
	FirstName, LastName, SalesPerson
	FROM SalesLT.Customer
	WHERE CustomerID < 100
)

SELECT 
	RowNumber,
	FirstName,
	LastName,
	SalesPerson
FROM CustomerPerSalesPerson
WHERE RowNumber >= 10;

--CTE and SELECT to count the number of customers per SalesPerson
WITH CustomerPerSalesPerson AS
(
	SELECT DISTINCT
	DENSE_RANK() OVER(PARTITION BY SalesPerson ORDER BY LastName) AS RowNumber,  --ROW_NUMBER returns duplicates
	FirstName, LastName, SalesPerson
	FROM SalesLT.Customer
	--ORDER BY SalesPerson, RowNumber
)

SELECT
	SalesPerson,
	COUNT(RowNumber) AS NumberOfCustomers
FROM CustomerPerSalesPerson
GROUP BY SalesPerson
ORDER BY NumberOfCustomers DESC

--Trying different things
SELECT 
	RowNumber
	FirstName,
	LastName,
	SalesPerson
FROM CustomerPerSalesPerson
WHERE RowNumber < 10



SELECT   --returns duplicates on first and last names because of distinct customerIDs
	SalesPerson,
	COUNT(CustomerID) AS NumberOfCustomers
FROM SalesLT.Customer
GROUP BY SalesPerson

SELECT FirstName, LastName, SalesPerson  --doen't return duplicates
FROM SalesLT.Customer
GROUP BY SalesPerson, LastName, FirstName

--Derived Table with row number, similar to Symedical stored proc

SELECT RowNumber, ProductCategoryName, Name, Price 
FROM
(
	SELECT 
		--ROW_NUMBER() OVER(PARTITION BY ProductCategoryName ORDER BY ListPrice DESC) AS RowNumber,
		RANK() OVER(PARTITION BY ProductCategoryName ORDER BY ListPrice DESC) AS RowNumber,
		ProductCategoryName, 
		Name,
		Round(ListPrice,2,1) AS Price
	FROM SalesLT.Product as p
	JOIN SalesLT.vGetAllCategories as c
	ON p.ProductCategoryID = c.ProductCategoryID
) AS ProductTable
WHERE ProductTable.RowNumber <= 3 --If the ListPrice is the same, it still numbers them consecutively.  RANK might help with this.
ORDER BY ProductCategoryName;