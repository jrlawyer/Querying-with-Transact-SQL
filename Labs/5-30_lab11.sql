--Module 11 Lab

--Challenge 1:  Logging Errors
--1.Throw an error for non-existing orders

DECLARE @SalesOrderID INT =31;

BEGIN
	--Test to see if ID exists and delete entries if able.
	IF EXISTS
		(SELECT * FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID)
		BEGIN 
			DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
			DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
			
			PRINT 'Order ' + CAST(@SalesOrderID AS VARCHAR) + ' has been deleted.'
		END;
	--Throw error message if ID doesn't exist.
	ELSE
		BEGIN
			DECLARE @ErrorMsg VARCHAR(100);
			SET @ErrorMsg = 'Order ' + CAST(@SalesOrderID AS VARCHAR) + ' does not exist. No entries have been deleted.';
			THROW 50001, @ErrorMsg, 0
		END
END

--creating a new entry in the SalesOrderHeader and SalesOrderDetails tables to test our DELETE transaction
DECLARE @ID Table(id INT)
DECLARE @SalesOrderID INT;

BEGIN TRY
	INSERT INTO SalesLT.SalesOrderHeader(DueDate, CustomerID, ShipMethod)
	OUTPUT INSERTED.SalesOrderID
	INTO @ID
	VALUES
	(DATEADD(dd, 7, GETDATE()), 1, 'STD DELIVERY');

	SELECT @SalesOrderID = id FROM @ID;

	INSERT INTO SalesLT.SalesOrderDetail(SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
	VALUES
	(@SalesOrderID, 1, 680, 1431.50, 0.00);
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE();
END CATCH;

--Looking for our header and accompanying detail
SELECT 
h.SalesOrderID, --31
h.OrderDate,
h.CustomerID,
d.SalesOrderDetailID,  --113423
d.ProductID
FROM SalesLT.SalesOrderHeader AS h
JOIN SalesLT.SalesOrderDetail AS d
ON h.SalesOrderID = d.SalesOrderID
WHERE h.CustomerID = 1;

--2.  Handle Errors using catch

DECLARE @SalesOrderID INT = 32;

BEGIN TRY
	IF EXISTS
		(SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)
		BEGIN 
			DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
			DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID; 	
			
			PRINT 'Order ' + CAST(@SalesOrderID AS VARCHAR) + ' has been deleted.';
		END;
	ELSE
		BEGIN
			DECLARE @ErrorMsg VARCHAR(100);
			SET @ErrorMsg = 'Order ' + CAST(@SalesOrderID AS VARCHAR) + ' was not found; no entries were deleted.';
			THROW 50001, @ErrorMsg, 0; 
		END 
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE();
END CATCH;

SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = 1

--Challenge 2:  Ensuring Data Consistency
--1. Implement a transaction

DECLARE @SalesOrderID INT = 33;

BEGIN TRY
	IF EXISTS
		(SELECT * 
		FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)
		BEGIN
			BEGIN TRANSACTION
				DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
				--THROW 50002, 'Test Error', 0
				DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
			COMMIT TRANSACTION
			PRINT 'Order ' + CAST(@SalesOrderID AS VARCHAR) + ' has been deleted';
		END
	ELSE
		BEGIN
			DECLARE @ErrorMsg VARCHAR(100);
			SET @ErrorMsg = 'Order ' + CAST(@SalesOrderID AS VARCHAR) + ' was not found; no entries were deleted.';
			THROW 50001, @ErrorMsg, 0;
		END 
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION;
			THROW;
		END
	ELSE
		BEGIN
			PRINT ERROR_MESSAGE();
		END
END CATCH;