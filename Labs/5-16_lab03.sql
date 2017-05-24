--Module 3_Lab

--Challenge 1:  Generate Invoice Reports

--1 and 2:  Retrieve customer orders and retrieve customer orders with addresses
SELECT c.CompanyName, oh.SalesOrderID, oh.TotalDue, a.AddressLine1, a.AddressLine2, a.City, a.StateProvince, a.CountryRegion, a.PostalCode, ca.AddressType  
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.SalesOrderHeader as oh
ON c.CustomerID = oh.CustomerID
INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE AddressType LIKE '%Main Office%'
ORDER BY c.CompanyName;

--Challenge 2:  Retrieve Sales Data

--1:  Retrieve a list of all customers and their orders
SELECT c.CompanyName, c.FirstName, c.LastName, oh.SalesOrderID, oh.TotalDue
FROM SalesLT.Customer AS c
LEFT OUTER JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
ORDER BY oh.SalesOrderID DESC, c.CompanyName;

--2:  Retrieve a list of customers with no address
SELECT c.CustomerID, c.CompanyName, c.FirstName + ' ' + c.LastName AS CustomerName, c.Phone, a.AddressID
FROM SalesLT.Customer AS c
LEFT OUTER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID 
LEFT OUTER JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE a.AddressID IS NULL
ORDER BY c.CustomerID;

--3.  Retrieve a list of customers and products without orders
SELECT c.CustomerID, p.ProductID
FROM SalesLT.Customer AS c
FULL JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
FULL JOIN SalesLT.SalesOrderDetail AS od
ON oh.SalesOrderID = od.SalesOrderID
FULL JOIN SalesLT.Product as p
ON od.ProductID = p.ProductID
WHERE oh.SalesOrderID IS NULL
Order by c.CustomerID;

--Returns the same number of results as query above... 153 products, 815 customers
SELECT c.CustomerID, p.ProductID
FROM SalesLT.Customer AS c
LEFT OUTER JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
LEFT OUTER JOIN SalesLT.SalesOrderDetail AS od
ON oh.SalesOrderID = od.SalesOrderID
FULL JOIN SalesLT.Product as p
ON od.ProductID = p.ProductID
WHERE oh.SalesOrderID IS NULL
Order by c.CustomerID, p.ProductID;

--Using UNION...Not quite the same
SELECT c.CustomerID AS ID, 'Customer' as Type
FROM SalesLT.Customer AS c
LEFT OUTER JOIN SalesLT.SalesOrderHeader as oh
ON c.CustomerID = oh.CustomerID
WHERE oh.SalesOrderID IS NULL
UNION
SELECT p.ProductID, 'Product'
FROM SalesLT.Product AS p
LEFT OUTER JOIN SalesLT.SalesOrderDetail as od
ON p.ProductID = od.ProductID
WHERE od.ProductID IS NULL
ORDER BY Type; 