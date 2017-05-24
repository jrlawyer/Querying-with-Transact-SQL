--Cross Joins Demo

SELECT p.Name, c.FirstName, c.LastName, c.Phone
FROM SalesLT.Product AS p
CROSS JOIN SalesLT.Customer AS c;

--Self Joins Demo

--create an employee table
CREATE TABLE SalesLT.Employee
(EmployeeID int IDENTITY PRIMARY KEY,
EmployeeName nvarchar(256),
ManagerID int);
GO 

--Get salesperson from Customer table and generate managers
INSERT INTO SalesLT.Employee (EmployeeName, ManagerID) 
SELECT DISTINCT Salesperson, NULLIF(CAST(RIGHT(SalesPerson, 1)AS INT), 0)
FROM SalesLT.Customer
GO
UPDATE SalesLT.Employee
SET ManagerID = (SELECT MIN(EmployeeID) FROM SalesLT.Employee WHERE ManagerID IS NULL)
WHERE ManagerID IS NULL
AND EmployeeID > (SELECT MIN(EmployeeID) FROM SalesLT.Employee WHERE ManagerID IS NULL);
GO

SELECT * FROM SalesLT.Employee;

--SELF-JOIN DEMO
SELECT e.EmployeeName, m.EmployeeName AS ManagerName
FROM SalesLT.Employee AS e
LEFT JOIN SalesLT.Employee AS m
ON e.ManagerID = m.EmployeeID
ORDER BY e.ManagerID;