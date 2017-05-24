--Mod 4: 

--UNION Demo
SELECT FirstName, LastName, 'Employee' AS Type
FROM SalesLT.Employees
UNION ALL
SELECT FirstName, LastName, 'Customer'
FROM SalesLT.Customer
ORDER BY LastName;

--INTERSECT Demo
SELECT FirstName, LastName 
FROM SalesLT.Employees
INTERSECT 
SELECT FirstName, LastName
FROM SalesLT.Customer
ORDER BY LastName;


--EXCEPT Demo
SELECT FirstName, LastName
FROM SalesLT.Employees
EXCEPT
SELECT FirstName, LastName
FROM SalesLT.Customer
ORDER BY LastName;
