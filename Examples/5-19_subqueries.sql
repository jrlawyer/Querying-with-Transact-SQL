--MOD 6 DEMO

--Using Subquery

--Display a list of products whose list price is higher than the unit price (building up the query in stages)

SELECT
	MAX(UnitPrice)
FROM SalesLT.SalesOrderDetail;

--result = $1466.01

SELECT * 
FROM SalesLT.Product
WHERE ListPrice > 1466.01;
--Not very scalable to use a literal value.

--Subquery example

SELECT *
FROM SalesLT.Product
WHERE ListPrice >
	(SELECT MAX(UnitPrice)
	FROM SalesLT.SalesOrderDetail);

--Correlated subquery 
--For each customer list all sales on the last day they made any sales

--pulling back info in general
SELECT
	CustomerID,
	SalesOrderID,
	OrderDate
FROM SalesLT.SalesOrderHeader AS SOH1
ORDER BY CustomerID, OrderDate;

--pulling back info based on the overall MAX OrderDate (2008-06-01)
SELECT
	CustomerID,
	SalesOrderID,
	OrderDate
FROM SalesLT.SalesOrderHeader AS SOH1
WHERE OrderDate =
	(SELECT MAX(OrderDate)
	FROM SalesLT.SalesOrderHeader)
ORDER BY CustomerID, OrderDate;

--pulling back info for each customer on their own MAX OrderDate
--query cannot be built up like a self contained query due to the dependence of the inner query on the outer query
SELECT
	CustomerID,
	SalesOrderID,
	OrderDate
FROM SalesLT.SalesOrderHeader AS SOH1
WHERE OrderDate =
	(SELECT MAX(OrderDate)
	FROM SalesLT.SalesOrderHeader AS SOH2
	WHERE SOH1.CustomerID = SOH2.CustomerID)
ORDER BY CustomerID;
--Note that correlated subqueries are complex and difficult to check


--CROSS APPLY example
--Table value function (SalesLt.udfMaxUnitPrice) does not exist.
--Setup:

CREATE FUNCTION SalesLt.udfMaxUnitPrice (@SalesOrderID int)
RETURNS TABLE
AS
RETURN
SELECT SalesOrderID, MAX(UnitPrice) as MaxUnitPrice 
FROM SalesLT.SalesOrderDetail
WHERE SalesOrderID = @SalesOrderID
GROUP BY SalesOrderID;

--Display the sales order details for the items that are equal to 
--the maxium unit price for that sales order.

SELECT
	SOH.SalesOrderID,
	MUP.MaxUnitPrice
FROM SalesLT.SalesOrderHeader AS SOH
CROSS APPLY SalesLt.udfMaxUnitPrice(SOH.SalesOrderID) AS MUP
ORDER BY SOH.SalesOrderID; 
