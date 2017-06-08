--Indexes Demo

--View the contents of the table (heap)
SELECT * FROM SalesLT.SalesOrderDetail

--Set stats on so we can see how many pages are read
SET STATISTICS IO ON

--Show the actual execution plan

--Get products and quantities for a specific order
SELECT ProductID, OrderQty
FROM SalesLT.SalesOrderDetail
WHERE SalesOrderID = 71783;

--Create a clustered index
CREATE CLUSTERED INDEX idx_SalesOrderID
ON SalesLT.SalesOrderDetail(SalesOrderID)

--Try the query again
SELECT ProductID, OrderQty
FROM SalesLT.SalesOrderDetail
WHERE SalesOrderID = 71783;

--get orders by product
SELECT SalesOrderID
FROM SalesLT.SalesOrderDetail
WHERE ProductID = 799;

--Create a nonclustered index
CREATE NONCLUSTERED INDEX idx_ProductID
ON SalesLT.SalesOrderDetail(ProductID)

--try again
SELECT SalesOrderID
FROM SalesLT.SalesOrderDetail
WHERE ProductID = 799;

--include a non-indexed field:  uses both indexes to return data
SELECT SalesOrderID, OrderQty
FROM SalesLT.SalesOrderDetail
WHERE ProductID = 799;

SET STATISTICS IO OFF