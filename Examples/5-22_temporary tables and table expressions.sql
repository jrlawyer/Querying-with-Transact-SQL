--Mod 7:  Temporary Tables and Table Variables

--Temporary Table
--Each set of commands can be executed individually, because you're still in the same session.

CREATE TABLE #Colors
(Color varchar(15));

INSERT INTO #Colors
SELECT DISTINCT Color FROM SalesLT.Product;

SELECT * FROM #Colors;

-- Table Variable
--Individual lines cannot be executed; all lines must be ran together for it to be in the same batch.
DECLARE @Colors AS TABLE (Color varchar(15));

INSERT INTO @Colors
SELECT DISTINCT Color FROM SalesLT.Product;

SELECT * FROM @Colors;

--New Batch

SELECT * FROM #Colors;

SELECT * FROM @Colors; --Now out of scope.
