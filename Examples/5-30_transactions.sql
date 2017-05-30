--Transactions Demo

--no transaction

BEGIN TRY 
	DECLARE @ID TABLE(id INT)  --creating table to put SalesOrderID into since SCOPE_IDENTITY, etc, isn't working

	INSERT INTO SalesLT.SalesOrderHeader(DueDate, CustomerID, ShipMethod)
	OUTPUT INSERTED.SalesOrderID
	INTO @ID
	VALUES
	(DATEADD(dd, 7, GETDATE()), 1, 'STD DELIVERY');
	
	--DECLARE @SalesOrderID INT = SCOPE_IDENTITY(); --keeps returning null (@@IDENTITY AND IDENT_CURRENT() also return null, like it's already out of scope...parallel execution plans?)
	DECLARE @SalesOrderID INT;
	SELECT @SalesOrderID = id FROM @ID;
		
	INSERT INTO SalesLT.SalesOrderDetail(SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
	VALUES
	(@SalesOrderID, 1, 99999, 1431.50, 0.00);
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE();
END CATCH;

--view orphaned orders
SELECT 
	h.SalesOrderID, 
	h.DueDate,
	h.CustomerID,
	h.ShipMethod,
	d.SalesOrderDetailID
FROM SalesLT.SalesOrderHeader AS h
LEFT JOIN SalesLT.SalesOrderDetail AS d
ON h.SalesOrderID = d.SalesOrderID
WHERE d.SalesOrderDetailID IS NULL;

--manually delete orphaned records
DELETE FROM SalesLT.SalesOrderHeader 
WHERE PurchaseOrderNumber IS NULL 
AND AccountNumber IS NULL

--Use a transaction
DECLARE @SalesOrderID INT;
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO SalesLT.SalesOrderHeader(DueDate, CustomerID, ShipMethod)
		VALUES
		(DATEADD(dd, 7, GETDATE()), 1, 'STD DELIVERY');

		SET @SalesOrderID = SCOPE_IDENTITY(); --this is still returning null, instead of a value

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
	THROW 50001, 'An insert failed; the transaction was cancelled.', 0;
END CATCH;

SELECT
	h.SalesOrderID,
	h.DueDate,
	h.CustomerID,
	h.ShipMethod,
	d.SalesOrderDetailID
FROM SalesLT.SalesOrderHeader AS h
LEFT JOIN SalesLT.SalesOrderDetail AS d
ON h.SalesOrderID = d.SalesOrderID
WHERE SalesOrderDetailID IS NULL;

--using XACT-ABORT

SET XACT_ABORT ON;
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO SalesLT.SalesOrderHeader(DueDate, CustomerID, ShipMethod)
		VALUES
		(DATEADD(dd, 7, GETDATE()), 1, 'STD DELIVERY');

		DECLARE @SalesOrderID INT = SCOPE_IDENTITY(); --this is still returning null, instead of a value

		INSERT INTO SalesLT.SalesOrderDetail(SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
		VALUES
		(@SalesOrderID, 1, 99999, 1431.50, 0.00);
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE();
	THROW 50001, 'An insert failed; the transaction was cancelled.', 0; --No ROLLBACK needed
END CATCH
SET XACT_ABORT OFF;


SELECT
	H.SalesOrderID,
	H.DueDate,
	H.CustomerID,
	H.ShipMethod,
	D.SalesOrderDetailID
FROM SalesLT.SalesOrderHeader AS H
LEFT JOIN SalesLT.SalesOrderDetail AS D
ON H.SalesOrderID = D.SalesOrderID
WHERE D.SalesOrderDetailID IS NULL