SELECT 
	map.MapUID,
	map.SourceCatalogUID, 
	map.TargetCatalogUID,
	c.CatalogName + ISNULL( ' - ' + c.CatalogVersion, '') AS SourceCatalog,
	(SELECT 
		CatalogName
	FROM dbo.SvrCatalog 
	WHERE map.TargetCatalogUID = CatalogUID) AS TargetCatalogName
FROM dbo.SvrMap AS map
JOIN dbo.SvrCatalog AS c
ON map.SourceCatalogUID = c.CatalogUID

