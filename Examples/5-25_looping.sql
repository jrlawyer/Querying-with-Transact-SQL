--Looping Demo

--Create demo table
CREATE TABLE SalesLT.DemoTable
(
	Description varchar(10) NULL
);
GO

DECLARE @Counter int = 1

WHILE @Counter <= 5

BEGIN
	INSERT SalesLT.DemoTable(Description)
	VALUES('Row ' + CONVERT(varchar(5), @Counter))
	SET @Counter = @Counter + 1
END
--5 messages of "(1 row(s) affected)" are displayed because we're looping through the rows individually

SELECT Description FROM SalesLT.DemoTable

--There may be instances where you want to loop indefinitely until a certain condition is met or true, then stop the loop.  
--This is atypical though since T-SQL is set based normally.

