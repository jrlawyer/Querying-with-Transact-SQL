--create a table
CREATE TABLE dbo.Customer
(CustomerID INTEGER IDENTITY PRIMARY KEY,
FirstName NVARCHAR(20) NOT NULL,
MiddleName NVARCHAR(20) NULL,
LastName NVARCHAR(20) NULL,
AccountOpened DATETIME DEFAULT GETDATE(),
CreditLimit DECIMAL(6,2) DEFAULT 1000.00);
GO

--insert with values correlating to columns
INSERT INTO dbo.Customer
VALUES ('Dan', 'D', 'Drayton', '1/1/2016', 500.00);

--insert using null and defaults
INSERT INTO dbo.Customer
VALUES ('Rodrigo', NULL, 'Drayton', DEFAULT, DEFAULT);

--insert specific columns
INSERT INTO dbo.Customer(FirstName, LastName)
VALUES ('Naomi', 'Sharp');

SELECT * FROM dbo.Customer

--Are NULL credit limits allowed, even though it has a default?
INSERT INTO dbo.Customer
VALUES ('Sophia', 'S', 'Garner', '1/1/2016', NULL);
--They are since the database is setup to allow null if it isn't specified explicitly on the column.

--select columns
SELECT CustomerID, FirstName, LastName
FROM dbo.Customer;

--select caluculated columns
SELECT	CustomerID,
		FirstName + ' ' + LastName AS FullName,
		DATEDIFF(dd, AccountOpened, GETDATE())AS AccountDays
FROM dbo.Customer;

--fixing weirdness
UPDATE dbo.Customer 
SET AccountOpened = '1/1/2016'
WHERE CustomerID = 4;

--Filter rows
SELECT CustomerID, FirstName, LastName, CreditLimit
FROM dbo.Customer
WHERE CreditLimit > 500;

CREATE TABLE dbo.AccountManagers
(EmployeeID INTEGER IDENTITY PRIMARY KEY,
 FirstName VARCHAR(20) NOT NULL,
 LastName NVARCHAR(20) NULL,
 DateOfBirth DATE NOT NULL,
 Salary DECIMAL(10,2)NOT NULL);
 GO 

 --formatted to match data types
 INSERT INTO dbo.AccountManagers
 VALUES
 ('Lucas', 'Sondergaard', '1971-03-07', 92000.00)

 --different formatting for date and salary
 --still works because SQL Server recognizes it
 INSERT INTO dbo.AccountManagers
 VALUES
 ('Rosie', 'Reeves', '12/12/1988', 85000)

--SQL Server interprets number as string
INSERT INTO dbo.AccountManagers
VALUES
('Deanna', 8411, '1/1/1970', 75000.25)

--dollar sign is OK because it's associated with numbers
INSERT INTO dbo.AccountManagers
VALUES
('Aisha', 'Witt', '8/5/1970', $120000)


--salary with dollar sign and as a string will throw an error because its too inconsistent
--error converting data type varchar to numeric
INSERT INTO dbo.AccountManagers
VALUES
('Elwood', 'McGee', '9/7/1976', '$120000')

--as just a string, it's OK though
INSERT INTO dbo.AccountManagers
VALUES
('Elwood', 'McGee', '9/7/1976', '120000')

--DateOfBirth formatted with day first
--conversion failed when converting date and/or time from character string
INSERT INTO dbo.AccountManagers
VALUES
('Zachary', 'Fellows', '30/7/1978', 120000)

INSERT INTO dbo.AccountManagers
VALUES
('Zachary', 'Fellows', '7/30/1978', 120000)

SELECT * FROM dbo.AccountManagers

--adding 2 integers together...doesn't make sense but it works
SELECT EmployeeID + Salary AS WeirdNumber
FROM dbo.AccountManagers 

--Concatinating strings together...also works
SELECT FirstName + LastName AS WeirdName
FROM dbo.AccountManagers

--trying to add varchar and decimal together; SQL Server can't convert
SELECT FirstName + Salary
FROM dbo.AccountManagers

--date and numeric doesn't work either:  operand type clash
SELECT DateOfBirth + EmployeeID
FROM dbo.AccountManagers

--string to date: incompatible data types
SELECT FirstName + DateOfBirth
FROM dbo.AccountManagers


--Add a column with a foreign key constraint
ALTER TABLE dbo.Customer ADD
	AccountManager INT NULL REFERENCES dbo.AccountManagers(EmployeeID);
GO

--Set the existing customer account managers
UPDATE dbo.Customer
SET AccountManager = 1;

--Add a new customer with an account manager
INSERT INTO dbo.Customer
VALUES
('Rhonda', NULL, 'Hughes', DEFAULT, 1000, 2);

--Add a new customer with a non-existent account manager 
--results in a foreign key constraint error
INSERT INTO dbo.Customer
VALUES
('Arnold', NULL, 'Valenti', DEFAULT, 500, 9);


--CRUD operations

--stored procedure 
CREATE PROCEDURE dbo.GetAccountManager (@CustomerID INT = NULL)
AS
	IF @CustomerID IS NULL
		BEGIN
			PRINT 'Please supply a customer ID.'
		END
	ELSE
		BEGIN
			SELECT
				c.FirstName + ' ' + c.LastName AS Customer,
				m.EmployeeID,
				m.FirstName + ' ' + m.LastName AS AccountManager
			FROM dbo.AccountManagers AS m
			JOIN dbo.Customer AS c
			ON m.EmployeeID = c.AccountManager
			WHERE c.CustomerID = @CustomerID
		END

EXEC dbo.GetAccountManager

EXEC dbo.GetAccountManager 5

--getting products based on ParentProductCategory

SELECT
	gac.ParentProductCategoryName AS ParentCategoryName,
	gac.ProductCategoryName AS CategoryName,
	p.Name AS ProductName
FROM SalesLT.Product AS p
JOIN SalesLT.vGetAllCategories AS gac
ON p.ProductCategoryID = gac.ProductCategoryID
WHERE gac.ParentProductCategoryName LIKE '%Bikes%'
ORDER BY gac.ProductCategoryName

--getting counts: parent product categories and product categories
SELECT
	gac.ParentProductCategoryName AS CategoryName,
	COUNT(p.ProductID) AS ItemsPerCategory
FROM SalesLT.Product AS p
JOIN SalesLT.vGetAllCategories AS gac
ON p.ProductCategoryID = gac.ProductCategoryID
GROUP BY gac.ParentProductCategoryName
UNION
SELECT	
	gac.ProductCategoryName,
	COUNT(p.ProductID) 
FROM SalesLT.Product AS p
JOIN SalesLT.vGetAllCategories AS gac
ON p.ProductCategoryID = gac.ProductCategoryID
GROUP BY gac.ProductCategoryName
ORDER BY CategoryName