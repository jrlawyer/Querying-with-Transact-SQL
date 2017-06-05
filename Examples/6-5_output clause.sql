--OUTPUT clause

--OUTPUT with INSERT
INSERT INTO dbo.Customer
OUTPUT INSERTED.CustomerID
VALUES
	('Sam', 'K', 'Miller', DEFAULT, 750, 3)

--OUTPUT with DELETE
DELETE FROM dbo.Customer
OUTPUT DELETED.CustomerID, DELETED.LastName, DELETED.AccountManager
WHERE CustomerID = 8

--OUTPUT with UPDATE
UPDATE dbo.Customer
SET CreditLimit = 900.00
OUTPUT DELETED.LastName, DELETED.CreditLimit, INSERTED.CreditLimit
WHERE CustomerID = 7

--using OUTPUT with tables(archiving)

CREATE TABLE dbo.Customer_Inserted
(CustomerID INTEGER CONSTRAINT PK_Customer_Inserted_CustomerID PRIMARY KEY,
FirstName NVARCHAR(20) NOT NULL,
MiddleName NVARCHAR(20) NULL,
LastName NVARCHAR(20) NULL,
AccountOpened DATETIME DEFAULT GETDATE(),
CreditLimit DECIMAL(6,2) DEFAULT 1000.00,
AccountManager INT NULL)


INSERT INTO dbo.Customer (FirstName, LastName, AccountManager)
OUTPUT INSERTED.* INTO dbo.Customer_Inserted
VALUES('Elizabeth', 'Bennett', 3)

DROP TABLE dbo.Customer_Inserted

SELECT * FROM dbo.Customer
SELECT * FROM dbo.Customer_Inserted

--storing values in "Deleted" table
CREATE TABLE dbo.Customer_Deleted
(CustomerID INTEGER,
FirstName NVARCHAR(20) NOT NULL,
MiddleName NVARCHAR(20) NULL,
LastName NVARCHAR(20) NULL,
AccountOpened DATETIME NOT NULL,
CreditLimit DECIMAL(6,2) NOT NULL,
AccountManager INT NULL)

DELETE FROM dbo.Customer
OUTPUT DELETED.* INTO dbo.Customer_Deleted
WHERE CustomerID IN (9, 10, 11)

SELECT * FROM dbo.Customer
SELECT * FROM dbo.Customer_Inserted
SELECT * FROM dbo.Customer_Deleted

--outputting results into Temporary table

CREATE Table dbo.#Customer_Deleted
(CustomerID INTEGER,
FirstName NVARCHAR(20) NOT NULL,
MiddleName NVARCHAR(20) NULL,
LastName NVARCHAR(20) NULL,
AccountOpened DATETIME NOT NULL,
CreditLimit DECIMAL(6,2) NOT NULL,
AccountManager INT NULL)
GO

DELETE FROM dbo.Customer
OUTPUT DELETED.* INTO dbo.#Customer_Deleted
WHERE CustomerID = 12;
GO

SELECT * FROM dbo.Customer;
SELECT * FROM dbo.#Customer_Deleted;

--outputting intoa table variable: Don't use GO since that creates separate batches and the table variable goes out of scope.

DECLARE @Customer_Deleted TABLE
(CustomerID INTEGER,
FirstName NVARCHAR(20) NOT NULL,
MiddleName NVARCHAR(20) NULL,
LastName NVARCHAR(20) NULL,
AccountOpened DATETIME NOT NULL,
CreditLimit DECIMAL(6,2) NOT NULL,
AccountManager INT NULL)

DELETE FROM dbo.Customer
OUTPUT DELETED.* INTO @Customer_Deleted
WHERE CustomerID = 7;

SELECT * FROM dbo.Customer;
SELECT * FROM @Customer_Deleted;

