--JOINs
--LEFT (OUTER) JOIN
SELECT 
	c.FirstName,
	c.LastName,
	c.SalesPerson,
	soh.SalesOrderID,
	soh.TotalDue
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS soh
ON c.CustomerID = soh.CustomerID
WHERE NULLIF(TotalDue, 0.00) IS NOT NULL --Removes all the NULLS and the instances where TotalDue is 0.00.
ORDER BY TotalDue DESC 

--INNER JOIN
SELECT 
	c.FirstName,
	c.LastName,
	c.SalesPerson,
	soh.SalesOrderID,
	soh.TotalDue
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS soh
ON c.CustomerID = soh.CustomerID
WHERE NULLIF(TotalDue, 0.00) IS NOT NULL --Removes all of the instances where TotalDue is 0.00; NULLs are already removed.
ORDER BY TotalDue DESC
