--Mod 9 Lab

--Challenge 1: Inserting products

--1. Insert a product, using nulls and defaults
INSERT INTO SalesLT.Product
VALUES
('LED Lights', 'LT-L123', NULL, 2.56, 12.99, NULL, NULL, 37, NULL, GETDATE(), NULL, NULL, NULL, NULL, DEFAULT, DEFAULT);

--Determine the ProductID
SELECT SCOPE_IDENTITY();

--View the row
SELECT * FROM SalesLT.Product
WHERE ProductID = '1001';

--Alternative: Insert a product by specifying the columns
INSERT INTO SalesLT.Product(Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES
('Fancy LED Lights', 'LT-L124', 2.56, 12.99, 37, GETDATE());

SELECT * FROM SalesLT.Product
WHERE ProductID = 1005;

--2. Insert a new category with two products
--New category, using defaults
INSERT INTO SalesLT.ProductCategory
VALUES
(4, 'Bells and Horns', DEFAULT, DEFAULT);

--Determine the ProductID
SELECT SCOPE_IDENTITY();

--View the row
SELECT * FROM SalesLT.ProductCategory
WHERE ProductCategoryID = 42;

--New products, using nulls and defaults
INSERT INTO SalesLT.Product
VALUES
('Bicycle Bell', 'BB-RING', NULL, 2.47, 4.99, NULL, NULL, 42, NULL, GETDATE(), NULL, NULL, NULL, NULL, DEFAULT, DEFAULT),
('Bicycle Horn', 'BB-PARP', NULL, 1.29, 3.75, NULL, NULL, 42, NULL, GETDATE(), NULL, NULL, NULL, NULL, DEFAULT, DEFAULT);

--View the new rows
SELECT * FROM SalesLT.Product
WHERE ProductCategoryID = 42;

--Alternative:  Inserting new category and products by specifying the columns
INSERT INTO SalesLT.ProductCategory(ParentProductCategoryID, Name)
VALUES
(4, 'Bells and Horns');

SELECT SCOPE_IDENTITY();

SELECT * FROM SalesLT.ProductCategory
WHERE ProductCategoryID = 43;

INSERT INTO SalesLT.Product(Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES
('Bicycle Bell', 'BB-RING', 2.47, 4.99, 43, GETDATE()),
('Bicycle Horn', 'BB-PARP', 1.29, 3.75, IDENT_CURRENT('SalesLT.ProductCategory'), GETDATE());

SELECT * FROM SalesLT.Product
WHERE ProductCategoryID = 43;

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

--Deleting products and category using subquery

DELETE 
FROM SalesLT.Product
WHERE ProductCategoryID = 
	(SELECT	ProductCategoryID
	FROM SalesLT.ProductCategory
	WHERE Name = 'Bells and Horns');

SELECT * 
FROM SalesLT.Product 
WHERE ProductCategoryID = '43';

DELETE
FROM SalesLT.ProductCategory
WHERE ProductCategoryID =
	(SELECT ProductCategoryID
	FROM SalesLT.ProductCategory
	WHERE Name = 'Bells and Horns');

SELECT * 
FROM SalesLT.ProductCategory 
WHERE ProductCategoryID = '43';

--MERGE EXAMPLE

--Create a table with an existing call log entry and a new call log entry.

SELECT * FROM SalesLT.CallLog;

SELECT * FROM SalesLT.Customer
WHERE SalesPerson = 'adventure-works\david8'

CREATE TABLE SalesLT.TempCallLog
(	
	CallID int IDENTITY PRIMARY KEY NOT NULL,
	CallTime datetime NOT NULL DEFAULT(GETDATE()),
	SalesPerson nvarchar(256) NOT NULL,
	CustomerID int NOT NULL REFERENCES SalesLT.Customer(CustomerID),
	PhoneNumber nvarchar(25) NOT NULL,
	Notes nvarchar(max) NULL 
);
GO
--insert row with CallID of 1 to see if it updates or not
--it updated up adding it to the bottom with a new ID number so it recognized that it was different
INSERT INTO SalesLT.TempCallLog (SalesPerson, CustomerID, PhoneNumber, Notes)
VALUES
('adventure-works\david8', 20, '582-555-0113', 'Follow up on delivery');

SELECT * FROM SalesLT.TempCallLog

--insert row with CallID of 2 with the intent of updating notes.
INSERT INTO SalesLT.TempCallLog (SalesPerson, CustomerID, PhoneNumber, Notes)
VALUES
('adventure-works\david8', 2, '170-555-0127', 'Call to schedule delivery');

--insert row with CallID of 10
SET IDENTITY_INSERT SalesLT.TempCallLog ON;

INSERT INTO SalesLT.TempCallLog (CallID, SalesPerson, CustomerID, PhoneNumber, Notes)
VALUES
(10, 'adventure-works\david8', 2, '170-555-0127', 'Follow up on service issues');

SET IDENTITY_INSERT SalesLT.TempCallLog OFF;

--MERGE

MERGE INTO SalesLT.CallLog AS clog
	USING SalesLT.TempCallLog AS temp
	ON clog.CallID = temp.CallID
WHEN MATCHED THEN
	UPDATE SET
	clog.CallTime = temp.CallTime, clog.Notes = temp.Notes
WHEN NOT MATCHED THEN
	INSERT (CallTime, SalesPerson, CustomerID, PhoneNumber, Notes)
	VALUES (temp.CallTime, temp.SalesPerson, temp.CustomerID, temp.PhoneNumber, temp.Notes);

SELECT * FROM SalesLT.CallLog

--Clearing table
TRUNCATE TABLE SalesLT.TempCallLog