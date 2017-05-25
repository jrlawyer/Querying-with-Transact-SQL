--Conditional Branching Demo

--Simple logical test
IF 'Yes' = 'No'
PRINT 'True'
--will evaluate but it won't do anything since it evaulates to false

IF 'Yes' = 'No'
	PRINT 'True'
ELSE 
	PRINT 'False'

--Change code based on condition
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductID = 1

IF @@ROWCOUNT < 1
	BEGIN
		PRINT 'Product was not found'
	END
ELSE
	BEGIN	
		PRINT 'Product updated'
	END


SELECT * 
FROM SalesLT.Product
WHERE ProductID = 1;