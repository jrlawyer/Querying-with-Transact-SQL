--Mod 7:  View Demo

--Create a view
CREATE VIEW  SalesLT.vCustomerAddress
AS
SELECT 
	C.CustomerID, 
	FirstName,
	LastName,
	AddressLine1,
	City,
	StateProvince
FROM
SalesLT.Customer AS C JOIN SalesLT.CustomerAddress AS CA
ON C.CustomerID = CA.CustomerID
JOIN SalesLT.Address AS A
ON CA.AddressID = A.AddressID;

--Query the view
SELECT CustomerID, City
FROM SalesLT.vCustomerAddress;

--Join the view to a table

SELECT
	c.StateProvince,
	c.City,
	ISNULL(SUM(s.TotalDue), 0.00) AS Revenue
FROM SalesLT.vCustomerAddress AS c
LEFT JOIN SalesLT.SalesOrderHeader AS s
ON c.CustomerID = s.CustomerID
GROUP BY c.StateProvince, c.City
ORDER BY c.StateProvince, Revenue DESC;
