--CASE practice

SELECT
	c.CustomerID,
	c.FirstName,
	c.LastName,
	soh.SalesOrderID,
	soh.TotalDue,
	CASE WHEN NULLIF(soh.TotalDue, 0.00) IS NULL THEN 'No'
		 ELSE 'Yes' END AS HasCustomerPurchased
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS soh
ON c.CustomerID = soh.CustomerID
ORDER BY TotalDue DESC

SELECT
	c.FirstName,
	c.LastName,
	soh.TotalDue,
	CASE WHEN NULLIF(soh.TotalDue, 0.00) IS NULL THEN 'No purchases'
		 WHEN soh.TotalDue >= 10000 THEN 'Over 10,000'
		 WHEN soh.TotalDue < 10000 AND soh.TotalDue >= 1000 THEN 'Between 1,000 - 10,000'
		 WHEN soh.TotalDue < 1000 AND soh.TotalDue >= 100 THEN 'Between 100 - 1,000' 
		 ELSE 'Less than 100' END AS TotalDueRange
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS soh
ON c.CustomerID = soh.CustomerID
ORDER BY TotalDue DESC

--
SELECT CASE WHEN Color = 'Red' THEN 'Red'
		    ELSE 'Not Red' END AS ColorSelection,
			COUNT(*) AS ColorCount
FROM SalesLT.Product
GROUP BY CASE WHEN Color = 'Red' THEN 'Red'
		    ELSE 'Not Red' END 

--option where you are supposed to be able to use a number or ColorSelection to group by but this isn't working
--specifying all of the other columns in the group by does work.  
SELECT CASE WHEN Color = 'Red' THEN 'Red'
		    WHEN Color = 'White' THEN 'White'
			WHEN Color = 'Black' THEN 'Black'
			ELSE 'To Be Determined' END AS ColorSelection,
			COUNT(*) AS ColorCount
FROM SalesLT.Product
GROUP BY CASE WHEN Color = 'Red' THEN 'Red'
		    WHEN Color = 'White' THEN 'White'
			WHEN Color = 'Black' THEN 'Black'
			ELSE 'To Be Determined' END 

--looking at weight 
SELECT * FROM SalesLT.Product WHERE Weight > 2000

SELECT 
	Color, 
	COUNT(*) AS ColorCount 
FROM SalesLT.Product
WHERE Color IS NOT NULL
GROUP BY Color
ORDER BY ColorCount

SELECT CASE WHEN Color = 'Red' THEN 'Red'
			WHEN Color = 'White' THEN 'White'
			WHEN Color = 'Black' THEN 'Black'
			When Color = 'Silver' THEN 'Silver'
			ELSE 'To be determined' END AS ColorSelection,
			COUNT(*) AS ColorCount 
FROM SalesLT.Product
WHERE Weight > 2000
GROUP BY CASE WHEN Color = 'Red' THEN 'Red'
			  WHEN Color = 'White' THEN 'White'
			  WHEN Color = 'Black' THEN 'Black'
			  WHEN Color = 'Silver' THEN 'Silver'
			  ELSE 'To be determined' END

--combined weight

SELECT CASE WHEN Color = 'Red' OR Color = 'White' THEN 'Red and White'
			WHEN Color = 'Black' OR Color = 'Silver' THEN 'Black and Silver'
			ELSE 'To be determined' END AS ColorCombo,
			SUM(Weight) AS CombinedWeight
FROM SalesLT.Product
WHERE Weight is not null
GROUP BY  CASE WHEN Color = 'Red' OR Color = 'White' THEN 'Red and White'
			WHEN Color = 'Black' OR Color = 'Silver' THEN 'Black and Silver'
			ELSE 'To be determined' END

SELECT SUM(Weight) AS CombinedWeight
FROM SalesLT.Product

--

SELECT ProductCategoryID,
	CASE WHEN Color = 'Red' THEN 'Red'
		 WHEN Color = 'Black' THEN 'Black'
		 WHEN Color = 'White' THEN 'White'
	ELSE 'To be Determined' END AS ColorSelection, 
	COUNT(*) AS ColorCount
FROM SalesLT.Product
WHERE Color IS NOT NULL 
GROUP BY ProductCategoryID,
	CASE WHEN Color = 'Red' THEN 'Red'
	WHEN Color = 'Black' THEN 'Black'
	WHEN Color = 'White' THEN 'White'
	ELSE 'To be Determined' END

SELECT ProductCategoryID, 
		Color,
		COUNT(*) AS ItemCount,
		COUNT(ProductID) AS OverallCount
FROM SalesLT.Product
WHERE Color IS NOT NULL
GROUP BY ProductCategoryID, Color
Order by ProductCategoryID

--pivoted the data so that itemcount would be a row
SELECT ProductCategoryID,
	CASE WHEN Color = 'Red' THEN 'Red'
	WHEN Color = 'Black' THEN 'Black'
	WHEN Color = 'White' THEN 'White'
	WHEN Color = 'Silver' THEN 'Silver'
	ELSE 'To be determined' END AS ColorSelection,
	COUNT(*) AS ItemCount
FROM SalesLT.Product
GROUP BY ProductCategoryID, 
	CASE WHEN Color = 'Red' THEN 'Red'
	WHEN Color = 'Black' THEN 'Black'
	WHEN Color = 'White' THEN 'White'
	WHEN Color = 'Silver' THEN 'Silver'
	ELSE 'To be determined' END
Order by ProductCategoryID	

SELECT ProductCategoryID,
Count(*) AS OverallCount
FROM SalesLT.Product
Group by ProductCategoryID

--pivoting data
SELECT COUNT(CASE WHEN Color = 'Red' THEN 1 ELSE NULL END) AS 'ColorRed',
	   COUNT(CASE WHEN Color = 'Black' THEN 1 ELSE NULL END) AS 'ColorBlack',
	   COUNT(CASE WHEN Color = 'White' THEN 1 ELSE NULL END) AS 'White',
	   COUNT(CASE WHEN Color = 'Silver' THEN 1 ELSE NULL END) AS 'Silver'
FROM SalesLT.Product 


SELECT ProductCategoryID,
	   COUNT(CASE WHEN Color = 'Red' THEN 1 ELSE NULL END) AS 'Red',
	   COUNT(CASE WHEN Color = 'Black' THEN 1 ELSE NULL END) AS 'Black',
	   COUNT(CASE WHEN Color = 'White' THEN 1 ELSE NULL END) AS 'White',
	   COUNT(CASE WHEN Color = 'Silver' THEN 1 ELSE NULL END) AS 'Silver',
	   COUNT(CASE WHEN Color = 'Blue' THEN 1 ELSE NULL END) AS 'Blue',
	   COUNT(CASE WHEN Color = 'Multi' THEN 1 ELSE NULL END) AS 'Multi',
	   COUNT(CASE WHEN Color = 'Grey' THEN 1 ELSE NULL END) AS 'Grey',
	   COUNT(CASE WHEN Color = 'Yellow' THEN 1 ELSE NULL END) AS 'Yellow',
	   COUNT(*) AS OverallCount
FROM SalesLT.Product 
GROUP BY ProductCategoryID

SELECT DISTINCT color FROM SalesLT.Product
