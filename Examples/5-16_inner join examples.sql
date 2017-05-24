--INNER JOIN DEMO

--Basic inner join with schema, etc, defined
SELECT SalesLT.Product.Name AS ProductName, SalesLT.ProductCategory.Name AS Category
FROM SalesLT.Product
INNER JOIN SalesLT.ProductCategory
ON SalesLT.Product.ProductCategoryID = SalesLT.ProductCategory.ProductCategoryID;

--Doesn't seem like order matters in this case.
SELECT SalesLT.Product.Name AS ProductName, SalesLT.ProductCategory.Name AS Category
FROM SalesLT.ProductCategory
INNER JOIN SalesLT.Product
ON SalesLT.Product.ProductCategoryID = SalesLT.ProductCategory.ProductCategoryID;

--Table aliases(same query as above)
SELECT p.Name AS ProductName, c.Name AS Category
FROM SalesLT.Product AS p
INNER JOIN SalesLT.ProductCategory AS c
ON p.ProductCategoryID = c.ProductCategoryID;

--Joining more than 2 tables
SELECT oh.OrderDate, oh.SalesOrderNumber, p.Name AS ProductName, od.OrderQty, od.UnitPrice, od.LineTotal
FROM SalesLT.SalesOrderHeader AS oh
INNER JOIN SalesLT.SalesOrderDetail AS od
ON od.SalesOrderID = oh.SalesOrderID
INNER JOIN SalesLT.Product AS p
ON od.ProductID = p.ProductID
ORDER BY oh.OrderDate, oh.SalesOrderID, od.SalesOrderDetailID;

--Multiple Join Predicates
SELECT oh.OrderDate, oh.SalesOrderNumber, p.Name AS ProductName, od.OrderQty, od.UnitPrice, od.LineTotal, p.ListPrice
FROM SalesLT.SalesOrderHeader AS oh
INNER JOIN SalesLT.SalesOrderDetail AS od
ON od.SalesOrderID = oh.SalesOrderID
INNER JOIN SalesLT.Product AS p
ON od.ProductID = p.ProductID AND od.UnitPrice < p.ListPrice --Note Multiple Predicates
ORDER BY oh.OrderDate, oh.SalesOrderID, od.SalesOrderDetailID;

