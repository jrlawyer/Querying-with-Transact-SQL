--Using Variables Demo

--Search by city using a variable
DECLARE @City VARCHAR(20) = 'Toronto'
SET @City = 'Bellevue'  --initializing variable with a different value

--GO  (separating logic into batches)

SELECT 
	FirstName +' '+ LastName AS [Name], 
	AddressLine1 AS Address, 
	City 
FROM SalesLT.Customer AS c
JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE City = @City;

--Use a variable as an output (drop value into the variable or populate it from a select statement)
DECLARE @Result MONEY
SELECT @Result = MAX(TotalDue)
FROM SalesLT.SalesOrderHeader
--variable is declared and initilized but that's it.

PRINT @Result  
--Do something with variable