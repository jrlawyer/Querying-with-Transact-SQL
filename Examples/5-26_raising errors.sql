--Raising Errors Demo

--View a system error:  trying to insert a detail for an order that doesn't exist.
INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
VALUES
(100000, 1, 680, 1431.50, 0.00);

--Raise an error with RAISERROR
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductID = 0;

IF @@ROWCOUNT < 1
	RAISERROR('The product was not found; no products have been updated', 16, 0);
 --Automatically assigned 50000 ID number

 --Raise an error with THROW
 UPDATE SalesLT.Product
 SET DiscontinuedDate = GETDATE()
 WHERE ProductID = 0;

 IF @@ROWCOUNT < 1
	THROW 50001, 'The product was not found; no products have been updated', 0;  --no severity specified
