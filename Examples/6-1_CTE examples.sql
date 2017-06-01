--CTE with multiple references - isn't working

WITH CTECustomers AS
(
	SELECT SalesPerson, CompanyName
	FROM SalesLt.Customer
	GROUP BY CompanyName, SalesPerson
),
TotalCount AS
(
	SELECT COUNT(*) AS Total FROM CTECustomers
)
/*Final_Result AS
(
	SELECT 
		ROW_NUMBER() OVER(PARTITION BY SalesPerson ORDER BY CompanyName) AS RowNumber,
		SalesPerson, 
		CompanyName,
		--(SELECT Total FROM TotalCount) AS Total
		COUNT(*) AS Total
		FROM CTECustomers
		GROUP BY CompanyName, SalesPerson
)*/

SELECT * FROM TotalCount, CTECustomers

--2nd attempt
WITH CTECustomers AS
(
	SELECT SalesPerson, CompanyName
	FROM SalesLt.Customer
	GROUP BY CompanyName, SalesPerson
),
Total AS 
(
	SELECT 
	ROW_NUMBER() OVER(PARTITION BY SalesPerson ORDER BY CompanyName) AS RowNumber,
	SalesPerson, 
	CompanyName
	--(SELECT Total FROM TotalCount) AS Total
	--COUNT(*) AS Total
	FROM CTECustomers
	--GROUP BY CompanyName, SalesPerson
)

SELECT RowNumber, SalesPerson, CompanyName, COUNT(RowNumber) AS TotalCount
FROM Total
GROUP BY SalesPerson, CompanyName, RowNumber

--JOIN practice:
	
SELECT 
	p.Name,
	pd.Description,
	pmpd.Culture
FROM SalesLT.Product AS p
LEFT JOIN SalesLT.ProductModelProductDescription AS pmpd
ON p.ProductModelID = pmpd.ProductModelID
LEFT JOIN SalesLT.ProductDescription AS pd
ON pmpd.ProductDescriptionID = pd.ProductDescriptionID
WHERE pmpd.Culture LIKE '%en%'
--WHERE p.productmodelID = 116 
--AND pmpd.Culture LIKE '%en%'


--multiple CTEs in a single query

WITH CategoryAndNumberOfProducts(ProductCategoryID, Name, NumberOfProducts) AS
(
	SELECT 
		ProductCategoryID, 
		Name,
		(SELECT COUNT(*) 
			FROM SalesLT.Product AS p
			WHERE p.ProductCategoryID = c.ProductCategoryID) AS NumberOfProducts
	FROM SalesLT.ProductCategory AS c
	WHERE c.ParentProductCategoryID IS NOT NULL
),
ProductsOverTenDollars (ProductID, ProductCategoryID, Name, ListPrice) AS
(
	SELECT
		ProductID,
		ProductCategoryID,
		Name,
		ListPrice
	FROM SalesLT.Product
	WHERE ListPrice > 10.0
)
SELECT
	c.Name AS CategoryName,
	c.NumberOfProducts,
	p.Name AS ProductName,
	ROUND(p.ListPrice, 2, 1) AS Price
FROM CategoryAndNumberOfProducts AS c
JOIN ProductsOverTenDollars AS p
ON c.ProductCategoryID = p.ProductCategoryID
ORDER BY CategoryName, ListPrice

--Another attempt:  pulling back Total for products and product categories

SELECT
	ProductID,
	Name,
	(SELECT SUM(LineTotal)
	FROM SalesLT.SalesOrderDetail AS d
	WHERE d.ProductID = p.ProductID) AS Total
FROM SalesLT.Product AS p --returns null values - join instead

--Product and Detail JOIN, soon to be CTE

WITH TOTALPURCHASED (ProductID, ProductName, Total) AS
(
	SELECT
		p.ProductID,
		p.Name AS ProductName,
		SUM(ROUND(d.LineTotal, 2, 1)) AS Total
	FROM SalesLT.Product AS p
	JOIN SalesLT.SalesOrderDetail AS d
	ON p.ProductID = d.ProductID
	GROUP BY p.ProductID, p.Name
	--ORDER BY ProductID
),

--Product and Category
ProductCategories (ProductCategoryID, CategoryName, ProductID, ProductName) AS
(
	SELECT
		c.ProductCategoryID,
		c.Name AS CategoryName,
		p.ProductID,
		p.Name AS ProductName
	FROM SalesLT.Product AS p
	JOIN SalesLT.ProductCategory AS c
	ON p.ProductCategoryID = c.ProductCategoryID
	WHERE c.ParentProductCategoryID IS NOT NULL
)

SELECT
	TOP(10)c.CategoryName,
	p.ProductName,
	p.Total,
	RANK() OVER(ORDER BY p.Total DESC) AS RankByPrice
FROM TotalPurchased AS p
JOIN ProductCategories AS c
ON p.ProductID = c.ProductID
--ORDER BY c.CategoryName, p.Total DESC
--ORDER BY p.Total DESC, c.CategoryName
ORDER BY RankByPrice

--could pivot results by categoryName...?

