--Stored Procedure Demo

--Create a stored procedure
CREATE PROCEDURE SalesLT.GetProductsByCategory (@CategoryID INT = NULL)
AS
IF @CategoryID IS NULL
	BEGIN
		SELECT ProductID, Name, Color, Size, ListPrice
		FROM SalesLT.Product
	END
ELSE
	BEGIN
		SELECT ProductID, Name, Color, Size, ListPrice
		FROM SalesLT.Product
		WHERE ProductCategoryID = @CategoryID
	END

--Execute the procedure without a parameter
EXECUTE SalesLT.GetProductsByCategory

--Execute the procedure with a parameter
EXECUTE SalesLT.GetProductsByCategory 5