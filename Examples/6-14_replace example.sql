/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [CustomerID]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[AccountOpened]
      ,[CreditLimit]
      ,[AccountManager]
  FROM [dbo].[Customer]

  SELECT REPLACE(FirstName, 'rigo', '') AS ReplacedName
  FROM dbo.Customer 

SELECT REPLACE('test , test', ' ,', ',') AS Test

--use a temp table to update the table by inserting the corrected values, using the IDs for reference...?