-- Challenge 1

-- 1. Retrieve all customer details
SELECT * FROM SalesLT.Customer;

-- 2. Retrieve customer name data
SELECT Title, FirstName, MiddleName, LastName, Suffix
FROM SalesLT.Customer;

-- 3. Retrieve customer names and phone numbers
SELECT SalesPerson, Title + ' ' + LastName AS CustomerName, Phone
FROM SalesLT.Customer;

--Challenge 2

--1.  Customer companies
SELECT CAST (CustomerID AS varchar(5)) + ': ' + CompanyName AS CustomerCompanies
FROM SalesLT.Customer;

-- Convert does the same thing with a different syntax...
SELECT CONVERT(varchar(5), CustomerID) + ': ' + CompanyName AS CustomerCompanies
FROM SalesLT.Customer;

--2.  Retrieve a list of sales order revisions
SELECT * FROM SalesLT.SalesOrderHeader;

-- using convert
SELECT SalesOrderNumber + ' (' + CONVERT(varchar(5), RevisionNumber) + ')' AS SalesOrderAndRevision, 
	CONVERT(nvarchar(30), OrderDate, 102) AS FormattedDate
FROM SalesLT.SalesOrderHeader;

--using STR
SELECT SalesOrderNumber + ' (' + STR(RevisionNumber, 1) + ')' AS SalesOrderAndRevision, 
	CONVERT(nvarchar(30), OrderDate, 102) AS FormattedDate
FROM SalesLT.SalesOrderHeader;

-- Challenge 3

--1. retrieve customer names with middle names if known
-- Looking at data:
SELECT * FROM SalesLT.Customer;

-- You can add formatting into the parameter for ISNULL
SELECT FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS CustomerName
FROM SalesLT.Customer;

-- Including Title too
SELECT ISNULL(Title + ' ', '') + FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS CustomerName
FROM SalesLT.Customer;

-- 2. Retrieve primary contact details

--Updating table to have some null values for EmailAddress
UPDATE SalesLT.Customer
SET EmailAddress = NULL
WHERE CustomerID % 7 = 1; 

-- PrimaryContact
SELECT CustomerID, COALESCE(EmailAddress, Phone) AS PrimaryContact 
FROM SalesLT.Customer;

-- 3. Retrieve shipping status

-- Looking at data:
SELECT * FROM SalesLT.SalesOrderHeader;

-- Updating ShipDate with some null values:
UPDATE SalesLT.SalesOrderHeader
SET ShipDate = NULL
WHERE SalesOrderID > 71899;

-- ShippingStatus
SELECT SalesOrderID, 
	CASE
		WHEN ShipDate IS NULL THEN 'Awaiting Shipment'
		ELSE 'Shipped'
	END AS ShippingStatus
FROM SalesLT.SalesOrderHeader;

