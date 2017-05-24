--Mod 9 Lab

--Challenge 1: Inserting products

--1. Insert a product
INSERT INTO SalesLT.Product
VALUES
('LED Lights', 'LT-L123', NULL, 2.56, 12.99, NULL, NULL, 37, NULL, GETDATE(), NULL, NULL, NULL, NULL, DEFAULT, DEFAULT);

--Determine the ProductID
SELECT SCOPE_IDENTITY();

--View the row
SELECT * FROM SalesLT.Product
WHERE ProductID = '1001';

--2. Insert a new category with two products
--New category
INSERT INTO SalesLT.ProductCategory
VALUES
(4, 'Bells and Horns', DEFAULT, DEFAULT);

--Determine the ProductID
SELECT SCOPE_IDENTITY();

--View the row
SELECT * FROM SalesLT.ProductCategory
WHERE ProductCategoryID = 42;

--New products
INSERT INTO SalesLT.Product
VALUES
('Bicycle Bell', 'BB-RING', NULL, 2.47, 4.99, NULL, NULL, 42, NULL, GETDATE(), NULL, NULL, NULL, NULL, DEFAULT, DEFAULT),
('Bicycle Horn', 'BB-PARP', NULL, 1.29, 3.75, NULL, NULL, 42, NULL, GETDATE(), NULL, NULL, NULL, NULL, DEFAULT, DEFAULT);

--View the new rows
SELECT * FROM SalesLT.Product
WHERE ProductCategoryID = 42;

--Challenge 2:  Updating Products

--1. Update product pricing
UPDATE SalesLT.Product
SET ListPrice = (ListPrice * 1.1)  --5.489 & 4.125
WHERE ProductCategoryID = 42;


SELECT * FROM SalesLT.Product
WHERE ProductCategoryID = 42;

--2.  Discontinue products
--Looking at lighting products
SELECT * FROM SalesLT.Product
WHERE ProductCategoryID = 37;

UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE SellStartDate <DATEADD(dd, -1, GETDATE())
AND ProductCategoryID = 37;  --Didn't have this originally.

--oops...trying to "fix" things
SELECT * FROM SalesLT.Product
WHERE DiscontinuedDate = '2017-05-24 19:24:42.893'
ORDER BY ProductCategoryID;

UPDATE SalesLT.Product
SET DiscontinuedDate = NULL
WHERE DiscontinuedDate = '2017-05-24 19:24:42.893' 
AND SellEndDate IS NULL;

SELECT * FROM SalesLT.Product
WHERE DiscontinuedDate IS NULL
AND SellEndDATE IS NULL
ORDER BY ProductCategoryID;

--Challenge 3: Deleting products
--1.  Delete a product category and its products

--Delete products first to avoid error
SELECT * FROM SalesLT.Product
WHERE ProductCategoryID = 42;

DELETE FROM SalesLT.Product
WHERE ProductCategoryID = 42;

--Delete product category
SELECT * FROM SalesLT.ProductCategory
WHERE ProductCategoryID = 42;

DELETE FROM SalesLT.ProductCategory
WHERE ProductCategoryID = 42;