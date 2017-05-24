CREATE TABLE SalesLT.Employees
(EmployeeID int IDENTITY PRIMARY KEY,
FirstName nvarchar(50),
LastLName nvarchar(50));
GO 

INSERT INTO SalesLT.Employees(FirstName, LastName)
VALUES ('Jennifer', 'Lawyer');

INSERT INTO SalesLT.Employees(FirstName, LastName)
VALUES ('Orlando', 'Gee'),
('Stephanie', 'Lawyer'),
('Anthony', 'Gage'),
('Amond', 'Gage'),
('Eli', 'Gage'),
('Nicole', 'Thompson'),
('Sean', 'Ghelhausen'),
('Maria', 'Morales'),
('London', 'Parker'),
('Jeff', 'Baker');

