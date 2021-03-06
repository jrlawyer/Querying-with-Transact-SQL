--NULL NUMBERS = 0
SELECT Name, ISNULL(TRY_CAST(Size AS Integer),0) AS NumericSize
FROM SalesLT.Product;

-- NULL strings = blank string
SELECT ProductNumber, ISNULL(Color, '') + ', ' + ISNULL(Size, '') AS ProductDetails
FROM SalesLT.Product;

-- Multi-Color = NULL 
SELECT Name, NullIF(Color, 'Multi') AS SingleColor
FROM SalesLT.Product;

--Find first non-NULL date
SELECT Name, COALESCE(DiscontinuedDate, SellEndDate, SellStartDate) AS LastActivity 
FROM SalesLT.Product;

--Searched case
SELECT Name,
	CASE
		WHEN SellEndDate IS NULL THEN 'On Sale'
		ELSE 'Discontinued'
	END AS SalesStatus
FROM SalesLT.Product;

--Combining Coalesce and Case...Not quite right yet
SELECT Name, 
	COALESCE(DisontinuedDate, SellEndDate, SellStartDate) AS LastActivity
	CASE
		WHEN DiscontinuedDate IS NOT NULL THEN 'Discontinued'
		WHEN SellEndDate IS NOT NULL THEN 'Pending'
		WHEN SellStartDate IS NOT NULL THEN 'Selling'
	END AS SalesStatus
FROM SalesLT.Product;

--Simple case
SELECT Name,
	CASE Size
		WHEN 'S' THEN 'Small'
		WHEN 'M' THEN 'Medium'
		WHEN 'L' THEN 'Large'
		WHEN 'XL' THEN 'Extra-Large'
		ELSE ISNULL(Size, 'n/a')
	END AS ProductSize
FROM SalesLT.Product;
