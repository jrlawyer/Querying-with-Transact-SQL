--Inserting Data into Tables Demo

--Create a table to log calls from a salesperson to a customer
CREATE TABLE SalesLT.CallLog
(
	CallID int IDENTITY PRIMARY KEY NOT NULL,
	CallTime datetime NOT NULL DEFAULT GETDATE(), --uses default value if a date is not specified.
	SalesPerson nvarchar(256) NOT NULL,
	CustomerID int NOT NULL REFERENCES SalesLT.Customer(CustomerID), --foreign key to Customer table
	PhoneNumber nvarchar(25) NOT NULL,
	Notes nvarchar(max) NULL
);
GO

--Insert a row
--Reminder: The CallID is generated automatically so you don't need to include it in the specified VALUES
--Based on ordinal position of data and columns
INSERT INTO SalesLT.CallLog
VALUES
('2015-01-01T12:30:00', 'adventure-works\pamela0', 1, '245-555-0173', 'Returning call re: enquiry about delivery');

SELECT * FROM SalesLT.CallLog;

--Insert defaults and nulls
INSERT INTO SalesLT.CallLog
VALUES
(DEFAULT, 'adventure-works\david8', 2, '170-555-0127', NULL);

SELECT * FROM SalesLT.CallLog;

--What if you don't know the sequence of the columns?
--Note:  If the columns doesn't allow NULL, doesn't have a default, and isn't an identifer, you will get an error and you'll have to supply a value.
--Insert a row with explicit columns
INSERT INTO SalesLT.CallLog (SalesPerson, CustomerID, PhoneNumber)
VALUES
('adventure-works\jillian0', 3, '279-555-0130');

SELECT * FROM SalesLt.CallLog;

--Insert multiple rows
INSERT INTO SalesLT.CallLog
VALUES
(DATEADD(mi, -2, GETDATE()), 'adventure-works\jillian0', 4, '710-555-0173', NULL),
(DEFAULT, 'adventure-works\shu0', 5, '828-555-0186', 'Called to arrange delivery of order 10987');

SELECT * FROM SalesLt.CallLog;

--Insert the results of a query
INSERT INTO SalesLT.CallLog (SalesPerson, CustomerID, PhoneNumber, Notes)
SELECT SalesPerson, CustomerID, Phone, 'Sales promotion call'
FROM SalesLT.Customer
WHERE CompanyName = 'Big-Time Bike Store';

SELECT * FROM SalesLt.CallLog;

--Retrieving inserted identity (from the current scope)
INSERT INTO SalesLT.CallLog(SalesPerson, CustomerID, PhoneNumber)
VALUES
('adventure-works\jose1', 10, '150-555-0127');

SELECT SCOPE_IDENTITY() AS LastIdentity;

SELECT * FROM SalesLt.CallLog;

--Overriding identity by explicitly assigning the CallID
SET IDENTITY_INSERT SalesLT.CallLog ON; --allows us to assign the value

INSERT INTO SalesLT.CallLog(CallID, SalesPerson, CustomerID, PhoneNumber)
VALUES
(9, 'adventure-works\jose1', 11, '926-555-0159');

SET IDENTITY_INSERT SalesLT.CallLog OFF;  --Note: It will continue to increment as expected after the insertion.

SELECT * FROM SalesLt.CallLog;
