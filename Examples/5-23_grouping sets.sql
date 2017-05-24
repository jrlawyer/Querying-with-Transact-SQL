--Grouping Sets Demo

--Standard GROUP BY
--Displays results for ParentProductCategoryName, ProductCategoryName, and Product Count within those combinations.
SELECT 
	cat.ParentProductCategoryName,
	cat.ProductCategoryName,
	COUNT(prd.ProductID) AS Products
FROM SalesLT.vGetAllCategories AS cat
LEFT JOIN SalesLT.Product AS prd
ON prd.ProductCategoryID = cat.ProductCategoryID
GROUP BY cat.ParentProductCategoryName,	cat.ProductCategoryName
ORDER BY cat.ParentProductCategoryName,	cat.ProductCategoryName;

--GROUPING SETS
--Displays grand total, totals for ProductCategoryName, and totals for ParentProductCategoryName
SELECT 
	cat.ParentProductCategoryName,
	cat.ProductCategoryName,
	COUNT(prd.ProductID) AS Products
FROM SalesLT.vGetAllCategories AS cat
LEFT JOIN SalesLT.Product AS prd
ON prd.ProductCategoryID = cat.ProductCategoryID
GROUP BY GROUPING SETS(cat.ParentProductCategoryName, cat.ProductCategoryName, ())
ORDER BY cat.ParentProductCategoryName,	cat.ProductCategoryName;

--ROLLUP
--Returns grand total, totals for each ParentProductCategoryName, and then combinations of the parent and sub categories
--Doesn't return totals for ProductCategoryName
SELECT 
	cat.ParentProductCategoryName,
	cat.ProductCategoryName,
	COUNT(prd.ProductID) AS Products
FROM SalesLT.vGetAllCategories AS cat
LEFT JOIN SalesLT.Product AS prd
ON prd.ProductCategoryID = cat.ProductCategoryID
GROUP BY ROLLUP(cat.ParentProductCategoryName, cat.ProductCategoryName)
ORDER BY cat.ParentProductCategoryName,	cat.ProductCategoryName;

--CUBE
--Returns every possible combination
SELECT 
	cat.ParentProductCategoryName,
	cat.ProductCategoryName,
	COUNT(prd.ProductID) AS Products
FROM SalesLT.vGetAllCategories AS cat
LEFT JOIN SalesLT.Product AS prd
ON prd.ProductCategoryID = cat.ProductCategoryID
GROUP BY CUBE(cat.ParentProductCategoryName, cat.ProductCategoryName)
ORDER BY cat.ParentProductCategoryName,	cat.ProductCategoryName;