--Lab02

--CHALLENGE 1: retrieve data for transportation reports
--1. retrieve a list of cities

SELECT * FROM SalesLT.Address;

SELECT DISTINCT City, StateProvince
FROM SalesLT.Address;

--2.  Retrieve the heaviest products
SELECT * FROM SalesLT.Product;

SELECT TOP 10 Name, Weight
FROM SalesLT.Product
ORDER BY Weight DESC;

--3.  Retrieve the heaviest 100 products not including the heaviest 10
SELECT Name, Weight
FROM SalesLT.Product
ORDER BY Weight DESC
OFFSET 10 ROWS
FETCH NEXT 100 ROWS ONLY;

--Challege 2:  Retrieve product data

--1.  Retrieve product details for product model 1

SELECT Name, Color, Size, ProductModelID
FROM SalesLT.Product
WHERE ProductModelID = 1; 
--OR ProductModelID = 2
--ORDER BY ProductModelID;

SELECT Name, Color, Size, ProductModelID
FROM SalesLT.Product
WHERE ProductModelID IN (1, 2)
ORDER BY ProductModelID;


--2.  Filter products by color and size

SELECT Name, ProductNumber, Color, Size
FROM SalesLT.Product
WHERE Color IN ('Black', 'Red', 'White')
AND Size IN ('S', 'M')
ORDER BY ProductNumber;

--3.  Retrieve products by product number

SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
WHERE ProductNumber LIKE 'BK-%';

--4.  Retrieve specific products by product number

SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
WHERE ProductNumber LIKE 'BK-[^R]%-[0-9][0-9]'
--WHERE ProductNumber LIKE 'BK-[A-Q, S-Z]_%_%_%-[0-9][0-9]'
ORDER BY ProductNumber;






