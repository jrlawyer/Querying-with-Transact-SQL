--Filtering practice

SELECT * FROM SalesLT.Product;

--List information about product model 6
SELECT Name, Color, Size 
FROM SalesLT.Product
WHERE ProductModelID <> 6;

--List information about products that have a product number beginning with FR
SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
WHERE ProductNumber LIKE 'FR%';

--List information about products that have a product number ending with 58
SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
WHERE ProductNumber LIKE '%58';

--List information about products that have a product number containing R
SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
WHERE ProductNumber LIKE '%R%';

--Filter the previous query to ensure that the product number contains two sets of two digits.
SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
WHERE ProductNumber LIKE 'FR-_[0-9][0-9]_-[0-9][0-9]';

--Find products that have no sell end date
SELECT Name
FROM SalesLT.Product
WHERE SellEndDate IS NOT NULL;

--Find products that have a sell end date in 2006
SELECT Name, SellEndDate
FROM SalesLT.Product
WHERE SellEndDate BETWEEN '2006/1/1' AND '2006/12/31';

--Find products that have a category ID of 5, 6, or 7
SELECT ProductCategoryID, Name, ListPrice
FROM SalesLT.Product
WHERE ProductCategoryID IN (5, 6, 7)
ORDER BY ProductCategoryID;

--Find products that have a category ID of 5, 6, or 7 and have a sell end date
SELECT ProductCategoryID, Name, ListPrice, SellEndDate
FROM SalesLT.Product
WHERE ProductCategoryID IN (5, 6, 7)
AND SellEndDate IS NULL
ORDER BY ProductCategoryID;

--Select products that have a category ID of 5, 6, 7 and a product number that begins with FR
SELECT ProductCategoryID, Name, ProductNumber
FROM SalesLT.Product
WHERE ProductNumber LIKE 'FR%'
OR ProductCategoryID IN (5, 6, 7)
ORDER BY ProductCategoryID;

