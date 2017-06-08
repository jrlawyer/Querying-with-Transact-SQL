--CET with multiple references example

--pulling back sales order id and product id
SELECT	
	SalesOrderID,
	ProductID
FROM SalesLT.SalesOrderDetail 


SELECT	
	sod.SalesOrderID,
	soh.OrderDate,
	sod.ProductID,
	prod.Name AS ProductName
FROM SalesLT.SalesOrderDetail AS sod
INNER JOIN SalesLT.SalesOrderHeader AS soh
ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN SalesLT.Product AS prod
ON sod.ProductID = prod.ProductID

SELECT	
	sod.SalesOrderID,
	soh.OrderDate,
	sod.ProductID	
FROM SalesLT.SalesOrderDetail AS sod
INNER JOIN SalesLT.SalesOrderHeader AS soh
ON sod.SalesOrderID = soh.SalesOrderID

SELECT	
	sod.SalesOrderID,
	sod.ProductID,
	prod.Name AS ProductName
FROM SalesLT.SalesOrderDetail AS sod
INNER JOIN SalesLT.Product AS prod
ON sod.ProductID = prod.ProductID

WITH SalesAndProduct AS 
(
	SELECT
		SalesOrderID,
		ProductID
	FROM SalesLT.SalesOrderDetail
)
SELECT  
	sap.SalesOrderID,
	soh.OrderDate,
	sap.ProductID,
	prod.Name AS ProductName
FROM SalesAndProduct AS sap
INNER JOIN SalesLT.SalesOrderHeader AS soh ON sap.SalesOrderID = soh.SalesOrderID
INNER JOIN SalesLT.Product AS prod ON sap.ProductID = prod.ProductID



SELECT	
	sod.SalesOrderID,
	soh.OrderDate,
	sod.ProductID,
	(SELECT
		Name  
	FROM SalesLT.Product
	WHERE ProductID = sod.ProductID) AS ProductName	
FROM SalesLT.SalesOrderDetail AS sod
INNER JOIN SalesLT.SalesOrderHeader AS soh
ON sod.SalesOrderID = soh.SalesOrderID