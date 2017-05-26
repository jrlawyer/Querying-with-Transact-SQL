--Handling Errors Demo

--Catch an error
BEGIN TRY
	UPDATE SalesLT.Product
	SET ProductNumber = ProductID / ISNULL(Weight, 0);
END TRY
BEGIN CATCH
	PRINT 'The following error occurred:';
	PRINT ERROR_MESSAGE();
END CATCH;
--Text in message window isn't red since SSMS doesn't view this as an error; our code handled it.

--Catch and rethrow an error
BEGIN TRY
	UPDATE SalesLT.Product
	SET ProductNumber = ProductID / ISNULL(Weight, 0);
END TRY
BEGIN CATCH
	PRINT 'The following error occurred:'
	PRINT ERROR_MESSAGE();
	THROW; --Without parameters will throw the error you've caught, instead of a custom error.
END CATCH;
--Now we see the original error that was caught and the error that was thrown to the client

--Catch, log, and throw a custom error
BEGIN TRY
	UPDATE SalesLT.Product
	SET ProductNumber = ProductID / ISNULL(Weight, 0);
END TRY
BEGIN CATCH
	DECLARE @ErrorLogID AS INT, @ErrorMsg AS VARCHAR(250);
	EXECUTE dbo.uspLogError @ErrorLogID OUTPUT;
	SET @ErrorMsg =	'The update failed because of an error. View error #'
					+ CAST(@ErrorLogID AS VARCHAR)
					+ ' in the error log for details.';
	THROW 50001, @ErrorMsg, 0;
END CATCH;

--view the error log
SELECT * FROM dbo.ErrorLog;