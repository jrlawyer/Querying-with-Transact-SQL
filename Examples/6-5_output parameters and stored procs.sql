--OUTPUT parameters with stored procedures

--Getting manager's salary
CREATE PROCEDURE dbo.GetManagerSalary @AccountManager NVARCHAR(20), @Salary DECIMAL(10,2) OUTPUT
AS 
	SELECT
			@Salary = Salary
			FROM dbo.AccountManagers
			WHERE LastName = @AccountManager;
	RETURN


--Declare variables
DECLARE @SalaryPerManager DECIMAL(10,2);
DECLARE @Name VARCHAR(20) = 'Witt';

--Execute procedure by specifying a last name for the input parameter
--and saving the output value in the variable @SalaryPerManager
--EXEC dbo.GetManagerSalary 8411, @SalaryPerManager OUTPUT; --option where stored proc paramter name is not passed
EXEC dbo.GetManagerSalary @Name, @Salary = @SalaryPerManager OUTPUT; --option where stored proc parameter name is passed

--Display the value returned by the proc
PRINT 'The annual salary for Manager ' + @Name + ' is $' + CONVERT(VARCHAR(15), @SalaryPerManager) + '.';

--trying something out
SELECT * 
FROM SalesLT.vCustomerAddress
WHERE StateProvince IN ('Washington', 'Wyoming')
ORDER BY StateProvince

--getting back customer information by StateProvince

CREATE PROCEDURE SalesLT.GetCustomersByStateProvince @StateProvince NVARCHAR(50) = NULL, @City NVARCHAR(30) = NULL
AS
	SELECT * 
	FROM SalesLT.vCustomerAddress
	WHERE StateProvince = ISNULL(@StateProvince, StateProvince)
	AND City LIKE '%' + ISNULL(@City, City) + '%'
RETURN

EXEC SalesLT.GetCustomersByStateProvince --returns all customers

EXEC SalesLT.GetCustomersByStateProvince @StateProvince = 'Utah' 

EXEC SalesLT.GetCustomersByStateProvince @City = 'Cedar' 

EXEC SalesLT.GetCustomersByStateProvince @StateProvince = 'Texas', @City = 'Cedar'

--getting back count by StateProvince
CREATE PROCEDURE SalesLT.GetCustomerCount @StateProvince NVARCHAR(50) = NULL, @CustomerCount INT OUTPUT --can use 'OUT' too
AS
	SELECT @CustomerCount = COUNT(*)  
	FROM SalesLT.vCustomerAddress
	WHERE StateProvince = ISNULL(@StateProvince, StateProvince)
RETURN

DECLARE @CustomerCount INT
EXEC SalesLT.GetCustomerCount @StateProvince = 'Utah', @CustomerCount = @CustomerCount OUTPUT --specify both parameters
--EXEC SalesLT.GetCustomerCount @CustomerCount = @CustomerCount OUTPUT --returns a total count
SELECT @CustomerCount AS CustomerCount
	 
DECLARE @CustomerCount INT
EXEC SalesLT.GetCustomerCount 'Colorado', @CustomerCount OUTPUT --either neither of the parameters
SELECT @CustomerCount AS CustomerCount


--Passing by reference

CREATE PROCEDURE SalesLT.UpdateListPrice @ProductID INT, @ListPrice MONEY OUTPUT
AS
	UPDATE SalesLT.Product
	SET ListPrice = @ListPrice + 1
	WHERE ProductID = @ProductID
RETURN 

DECLARE @NewPrice MONEY 
SET @NewPrice = 3.00
PRINT @NewPrice
EXEC SalesLT.UpdateListPrice 1005, @NewPrice OUTPUT
PRINT @NewPrice
EXEC SalesLT.UpdateListPrice 1005, @NewPrice OUTPUT
PRINT @NewPrice

--altering proc
ALTER PROCEDURE SalesLT.UpdateListPrice @ProductID INT, @NewPrice MONEY OUTPUT
AS
	UPDATE SalesLT.Product
	--SET ListPrice = @NewPrice + 1.00, --@NewPrice wasn't being updated after the fact
		--@NewPrice = ListPrice
	SET @NewPrice = @NewPrice + 1,
		ListPrice = @NewPrice
	WHERE ProductID = @ProductID


--reset
UPDATE SalesLT.Product
SET ListPrice = 12.99
WHERE ProductID = 1005
