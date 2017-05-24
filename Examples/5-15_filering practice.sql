--Mod 2 Demo:

--Display a list of product colors
SELECT DISTINCT ISNULL(Color, 'None') AS Color 
FROM SalesLT.Product;

--Display a list of product colors with the word 'None' if the value is null sorted by color
SELECT DISTINCT ISNULL(Color, 'None') AS Color 
FROM SalesLT.Product
ORDER BY Color;

--Display a list of product colors with the word 'None' if the value is null and a dash if the size is null sorted by color
SELECT DISTINCT ISNULL(Color, 'None') AS Color, ISNULL(Size, '-') AS Size
FROM SalesLT.Product
ORDER BY Color;


--Display the top 100 products by list price
SELECT TOP 15 WITH TIES  Name, ListPrice 
FROM SalesLT.Product
ORDER BY ListPrice DESC;

--Display the first 10 products by product number
SELECT Name, ListPrice, ProductNumber
FROM SalesLT.Product
ORDER BY ProductNumber
OFFSET 0 Rows
FETCH FIRST 10 ROWS ONLY;

--Display the next 10 products by product number
SELECT Name, ListPrice, ProductNumber
FROM SalesLT.Product
ORDER BY ProductNumber
OFFSET 10 Rows
FETCH NEXT 10 ROWS ONLY;

