--Module 10 Lab 

--Challenge 1:  Creating scripts to insert sales orders

--1. Write code to insert an order header

DECLARE @OrderDate DATETIME = GETDATE();
DECLARE @DueDate DATETIME = DATEADD(day, 7, GETDATE());
DECLARE @CustomerID INT = 1;
DECLARE @OrderID INT;  

SET @OrderID = NEXT VALUE FOR SalesLT.SalesOrderNumber;  
	
INSERT INTO SalesLT.SalesOrderHeader (SalesOrderID, OrderDate, DueDate, CustomerID, ShipMethod)
VALUES
	(@OrderID, @OrderDate, @DueDate, @CustomerID, 'CARGO TRANSPORT 5');

--SET @OrderID = IDENT_CURRENT('SalesLT.SalesOrderHeader');  --Alternative way of doing it but it doesn't print the @OrderID for some reason.

PRINT @OrderID;

SELECT * FROM SalesLT.SalesOrderHeader WHERE CustomerID = 1;

--2. Write code to insert an order detail

DECLARE @SalesOrderID INT = 11;
--DECLARE @SalesOrderID INT = 0;
DECLARE @ProductID INT = 760;
DECLARE @OrderQty SMALLINT = 1;
DECLARE @UnitPrice MONEY = 782.99;

IF EXISTS
	(SELECT *
	FROM SalesLT.SalesOrderHeader 
	WHERE SalesOrderID = @SalesOrderID) BEGIN
		INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice)
		VALUES (@SalesOrderID, 
		@ProductID, 
		@OrderQty, 
		@UnitPrice);
		PRINT 'Insert successful.' END ELSE PRINT 'The order does not exist.'

SELECT * FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = 10


--Challenge 2:  Updating Bike Prices

--1.  Write a WHILE loop to update bike prices
--First attempt:

DECLARE @MarketAvg MONEY = 2500;
DECLARE @MarketMax MONEY = 5000;
DECLARE @AvgPrice MONEY = 1586.74;
DECLARE @MaxPrice MONEY = 3578.27;

WHILE @AvgPrice < @MarketAvg 
	BEGIN
		UPDATE SalesLT.Product
		SET ListPrice = (ListPrice * 1.1)
		WHERE ProductID IN 
			(SELECT p.ProductID 
			FROM SalesLT.Product AS p
			JOIN SalesLT.vGetAllCategories AS gac
			ON p.ProductCategoryID = gac.ProductCategoryID
			WHERE gac.ParentProductCategoryName = 'Bikes');
			
			SET @AvgPrice =
			(SELECT AVG(p.ListPrice)
			FROM SalesLT.Product as p
			JOIN SalesLT.vGetAllCategories as gac
			ON p.ProductCategoryID = gac.ProductCategoryID
			WHERE gac.ParentProductCategoryName = 'Bikes');

			SET @MaxPrice =  
			(SELECT MAX(p.ListPrice)
			FROM SalesLT.Product as p
			JOIN SalesLT.vGetAllCategories as gac
			ON p.ProductCategoryID = gac.ProductCategoryID
			WHERE gac.ParentProductCategoryName = 'Bikes');
	
	IF @MaxPrice >= @MarketMax
		BREAK;
	END;

	



--OTHER CODE...
	SELECT 
			AVG(p.ListPrice) AS AvgPrice,
			MAX(p.ListPrice) AS MaxPrice
		FROM SalesLT.Product as p
		JOIN SalesLT.vGetAllCategories as gac
		ON p.ProductCategoryID = gac.ProductCategoryID
		WHERE gac.ParentProductCategoryName = 'Bikes';

		SET @AvgPrice = AvgPrice;
		SET @MaxPrice = MaxPrice;

		SELECT *
		FROM SalesLT.Product as p
		JOIN SalesLT.vGetAllCategories as gac
		ON p.ProductCategoryID = gac.ProductCategoryID
		WHERE gac.ParentProductCategoryName = 'Bikes';

