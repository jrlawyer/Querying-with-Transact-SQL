SELECT * FROM SalesLT.Customer
WHERE FirstName LIKE '[a-m]%'

SELECT
	CASE WHEN FirstName LIKE '[a-m]%' THEN 'A to M'
		 WHEN FirstName LIKE '[n-z]%' THEN 'N to Z'
		 ELSE NULL END AS Names,
		 COUNT(*) AS NameCount
FROM SalesLT.Customer
GROUP BY CASE WHEN FirstName LIKE '[a-m]%' THEN 'A to M'
		 WHEN FirstName LIKE '[n-z]%' THEN 'N to Z'
		 ELSE NULL END
ORDER BY Names