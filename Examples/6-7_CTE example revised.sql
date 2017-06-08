SELECT 
	map.SourceCatalogUID, 
	c.CatalogName + ISNULL(': Version ' + NULLIF(c.CatalogVersion,''), '') AS SourceCatalog,
	map.TargetCatalogUID,
	(SELECT 
		CatalogName + ISNULL(': Version' + NULLIF(CatalogVersion, ''), '')
	FROM dbo.SvrCatalog 
	WHERE map.TargetCatalogUID = CatalogUID) AS TargetCatalogName
FROM dbo.SvrMap AS map
JOIN dbo.SvrCatalog AS c
ON map.SourceCatalogUID = c.CatalogUID
ORDER BY c.CatalogName

--CTE option:  doesn't return all the information...

WITH UIDAndName AS
(
	SELECT CatalogUID, CatalogName + ISNULL(': Version' + NULLIF(CatalogVersion, ''), '') AS CatalogName
	FROM dbo.SvrCatalog
)
SELECT CatalogUID, CatalogName FROM UIDAndName AS a
JOIN dbo.SvrMap AS b ON a.CatalogUID = b.SourceCatalogUID
JOIN dbo.SvrMap AS c ON a.CatalogUID = c.TargetCatalogUID


--CTE option 
WITH CatalogUID (SourceCatalogUID, TargetCatalogUID) AS
(
	SELECT SourceCatalogUID, TargetCatalogUID
	FROM dbo.SvrMap
)
SELECT 
	SourceCatalogUID,
	b.CatalogName,
	TargetCatalogUID,
	c.CatalogName
FROM CatalogUID AS a
JOIN dbo.SvrCatalog AS b ON a.SourceCatalogUID = b.CatalogUID
JOIN dbo.SvrCatalog AS c ON a.TargetCatalogUID = c.CatalogUID
 
