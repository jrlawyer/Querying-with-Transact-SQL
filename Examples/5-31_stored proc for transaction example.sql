--Stored procedure for SCOPE_IDENTITY weirdness

--1st attempt
CREATE PROCEDURE SalesLT.GetSalesOrderHeaderID (@DueDate DATETIME, @CustomerID INT, @ShipMethod NVARCHAR)
AS
BEGIN
	DECLARE @ID INT;
	
	INSERT INTO SalesLT.SalesOrderHeader(DueDate, CustomerID, ShipMethod)
	VALUES
	(@DueDate, @CustomerID, @ShipMethod)

	SELECT @ID = SCOPE_IDENTITY();

	SELECT @ID;
END

--1st attempt
DECLARE @SalesOrderID INT;
BEGIN TRY
	BEGIN TRANSACTION
		DECLARE @DueDate DATETIME = DATEADD(dd, 7, GETDATE());
		
		EXEC @SalesOrderID = SalesLT.GetSalesOrderHeaderID @DueDate, 1, 'STD DELIVERY';
		PRINT @SalesOrderID;
		
		INSERT INTO SalesLT.SalesOrderDetail(SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
		VALUES
		(@SalesOrderID, 1, 99999, 1431.50, 0.00);
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		PRINT XACT_STATE();
		ROLLBACK TRANSACTION;
	END
	PRINT ERROR_MESSAGE();
	PRINT @SalesOrderID;
	THROW 50001, 'An insert failed; the transaction was cancelled.', 0;
END CATCH;


--Stored procedure: 2nd attempt (@SalesOrderID is still returning as NULL or as 0)
CREATE PROCEDURE SalesLT.GetSalesOrderHeaderID
	@DueDate DATETIME,
	@CustomerID INT, 
	@ShipMethod NVARCHAR,
	@ID INT OUTPUT
AS
	INSERT INTO SalesLT.SalesOrderHeader(DueDate, CustomerID, ShipMethod)
	VALUES
	(@DueDate, @CustomerID, @ShipMethod)

	SELECT @ID = SCOPE_IDENTITY();
RETURN

--3rd attempt, using table:
CREATE PROCEDURE SalesLT.GetSalesOrderHeaderID
	@DueDate DATETIME,
	@CustomerID INT, 
	@ShipMethod NVARCHAR,
	@ID INT OUTPUT
AS
	DECLARE @IDTable TABLE (ID INT)
	INSERT INTO SalesLT.SalesOrderHeader(DueDate, CustomerID, ShipMethod)
	OUTPUT INSERTED.SalesOrderID
	INTO @IDTable
	VALUES
	(@DueDate, @CustomerID, @ShipMethod)

	SELECT @ID = ID FROM @IDTable;
RETURN



--2nd attempt: (This works with the 3rd attempt of the stored procedure, which uses the table)
DECLARE @SalesOrderID INT;
BEGIN TRY
	BEGIN TRANSACTION
		DECLARE @DueDate DATETIME = DATEADD(dd, 7, GETDATE());
		
		EXEC SalesLT.GetSalesOrderHeaderID @DueDate, 1, 'STD DELIVERY', @ID = @SalesOrderID OUTPUT;
		PRINT @SalesOrderID;
		
		INSERT INTO SalesLT.SalesOrderDetail(SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
		VALUES
		(@SalesOrderID, 1, 680, 1431.50, 0.00);
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		PRINT XACT_STATE();
		ROLLBACK TRANSACTION;
	END
	PRINT ERROR_MESSAGE();
	PRINT @SalesOrderID;
	THROW 50001, 'An insert failed; the transaction was cancelled.', 0;
END CATCH;

SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = 52;
SELECT * FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = 52;



--Testing to see if SCOPE_IDENTITY	works in general
--It does not.  However, it does work on the CallLog table
INSERT INTO SalesLT.SalesOrderHeader(DueDate, CustomerID, ShipMethod)
	VALUES
	(DATEADD(dd, 7, GETDATE()), 1, 'STD DELIVERY');

SELECT SCOPE_IDENTITY() AS Header; --Returns NULL

--Orphaned Details
SELECT * 
FROM SalesLT.SalesOrderHeader AS h
LEFT JOIN SalesLT.SalesOrderDetail AS d
ON h.SalesOrderID = d.SalesOrderID
WHERE D.SalesOrderDetailID IS NULL;

--Clean up
DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = 47 OR SalesOrderID = 48