--DENSE_RANK

SELECT ProductID, UnitPrice,
	DENSE_RANK() OVER(ORDER BY UnitPrice DESC) AS RankByPrice
FROM SalesLT.SalesOrderDetail 

--could create a table and then pull back by RankByPrice 


--Four Ranking Functions used in the same query...could use customer City

SELECT * FROM SalesLT.vCustomerAddress

SELECT 
	FirstName, 
	LastName, 
	ROW_NUMBER() OVER(ORDER BY StateProvince) AS 'Row Number',
	RANK() OVER(ORDER BY StateProvince) AS 'Rank',
	DENSE_RANK() OVER(ORDER BY StateProvince) AS 'Dense Rank',
	NTILE(100) OVER (ORDER BY StateProvince) AS 'Quartile',
	StateProvince
FROM SalesLT.vCustomerAddress 