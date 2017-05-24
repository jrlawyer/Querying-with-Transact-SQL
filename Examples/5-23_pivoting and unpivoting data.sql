--Pivoting Data Demo

SELECT * 
FROM 
	(SELECT
		p.ProductID,
		pc.Name,
		ISNULL(p.Color, 'Uncolored') AS Color
	FROM SalesLT.ProductCategory AS pc
	INNER JOIN SalesLT.Product AS p
	ON pc.ProductCategoryID = p.ProductCategoryID
	) AS ppc
PIVOT(COUNT(ProductID) 
	FOR Color IN
		([Red], [Blue],[Black],[Silver],[Yellow],[Grey],[Multi],[Silver/Black],[Uncolored])) AS pvt
ORDER BY Name;

--Unpivoting Data Demo

CREATE TABLE #ProductColorPivot
(Name varchar(50), Red int, Blue int, Black int, Silver int, Yellow int, Grey int, Multi int, Uncolored int);

INSERT INTO #ProductColorPivot
SELECT * 
FROM 
	(SELECT
		p.ProductID,
		pc.Name,
		ISNULL(p.Color, 'Uncolored') AS Color
	FROM SalesLT.ProductCategory AS pc
	INNER JOIN SalesLT.Product AS p
	ON pc.ProductCategoryID = p.ProductCategoryID
	) AS ppc
PIVOT(COUNT(ProductID) 
	FOR Color IN
		([Red], [Blue],[Black],[Silver],[Yellow],[Grey],[Multi],[Uncolored])) AS pvt
ORDER BY Name;

SELECT * FROM #ProductColorPivot;

SELECT
	Name, 
	Color,
	ProductCount
FROM
	(SELECT 
		Name,
		[Red], [Blue], [Black], [Silver], [Yellow], [Grey], [Multi], [Uncolored]
	FROM #ProductColorPivot) AS pcp
UNPIVOT
	(ProductCount FOR Color IN
		([Red], [Blue], [Black], [Silver], [Yellow], [Grey], [Multi], [Uncolored])
		) AS ProductCounts
