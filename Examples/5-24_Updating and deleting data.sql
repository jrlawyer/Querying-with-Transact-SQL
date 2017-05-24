--Updating and Deleting Data Demo

--Update a table
UPDATE SalesLT.CallLog
SET Notes = 'No Notes'
WHERE Notes IS NULL;

SELECT * FROM SalesLT.CallLog;

--Update multiple columns
UPDATE SalesLT.CallLog
SET SalesPerson = '', PhoneNumber = '';
--This will insert an empty string into each row for these 2 columns.

SELECT * FROM SalesLT.CallLog;

--Update from results of a query
UPDATE SalesLT.CallLog		--target table
SET SalesPerson = c.SalesPerson, PhoneNumber = c.Phone
FROM SalesLT.Customer as c	--source table
WHERE c.CustomerID = SalesLT.CallLog.CustomerID;

SELECT * FROM SalesLT.CallLog;

--Delete rows
DELETE FROM SalesLT.CallLog
WHERE CallTime <DATEADD(dd, -7, GETDATE());

SELECT * FROM SalesLT.CallLog;

--Truncate the table
TRUNCATE TABLE SalesLT.CallLog;

SELECT * FROM SalesLT.CallLog;
