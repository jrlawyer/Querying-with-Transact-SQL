--Mod 11 Lab Rework

--Challenge 1, Q1:  Throw an Error for non existent orders

DECLARE @SalesOrderID INT = 0;

IF NOT EXISTS
	(SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)
	BEGIN	
		THROW 50001, 'This order does not exist', 0;
	END
ELSE
	BEGIN
		DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
		DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
		PRINT 'The order has been deleted.';
	END

-- Challenge 1, Q2:  Handle errors

DECLARE @SalesOrderID INT = 0;

BEGIN TRY
	IF NOT EXISTS
		(SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)
		BEGIN
			THROW 50001, 'This order does not exist.', 0;
		END
	ELSE
		BEGIN
			DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
			DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
			PRINT 'The order has been deleted.';
		END
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE();
END CATCH;

--Challege 2, Q1:  Implement a transaction

DECLARE @SalesOrderID INT = 34;

BEGIN TRY
	IF NOT EXISTS
		(SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)
		BEGIN
			THROW 50001, 'This order does not exist.', 0;
		END
	ELSE
		BEGIN TRANSACTION
			DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
			--THROW 50002, 'Test Error', 0;
			DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
			PRINT 'The order has been deleted.';
		COMMIT TRANSACTION
END TRY
BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION;
				THROW
			END
		ELSE
			BEGIN
				PRINT ERROR_MESSAGE();
			END
END CATCH;

SELECT MIN(SalesOrderID) FROM SalesLT.SalesOrderHeader 