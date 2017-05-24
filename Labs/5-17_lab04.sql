-- Mod 4 Lab

--Challenge 1:  Retrieve Customer Address

--1. Retrieve Billing Addresses

SELECT c.CompanyName, a.AddressLine1, a.City, 'Billing' AS AddressType, ca.AddressType --Added AddressType to validate
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.CustomerAddress as ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address as a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Main Office'
ORDER BY c.CompanyName;

--2.  Retrieve Shipping address

SELECT c.CompanyName, a.AddressLine1, a.City, 'Shipping' AS AddressType
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address as a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName;


--3.  Combine billing and shipping addresses
--I think that the number of rows doesn't change between UNION and UNION ALL because the rows would be distinct because of the addresses being different.

SELECT c.CompanyName, a.AddressLine1, a.City, 'Billing' AS AddressType
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.CustomerAddress as ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Main Office'
UNION ALL
SELECT c.CompanyName, a.AddressLine1, a.City, 'Shipping'
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName, AddressType;

--Challenge 2: Filter Customer Addresses

--1.  Retrieve customers with only a main office address 

SELECT c.CompanyName
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.CustomerAddress as ca
ON c.CustomerID = ca.CustomerID
WHERE ca.AddressType = 'Main Office'
EXCEPT
SELECT c.CompanyName
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName;

--2.  Retrieve customers with a main office address and a shipping address

SELECT c.CompanyName
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
WHERE ca.AddressType = 'Main Office'
INTERSECT
SELECT c.CompanyName
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName;

--Number of customers that do not have an address: 440 rows returned.
SELECT c.CompanyName
FROM SalesLT.Customer AS c
LEFT OUTER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
WHERE ca.CustomerID IS NULL
ORDER BY c.CompanyName;

--Returns all of the customers and whether they have an addressID or NULL
SELECT c.CompanyName, ca.AddressID
FROM SalesLT.Customer AS c
LEFT OUTER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
ORDER BY ca.AddressID DESC, c.CompanyName;



