SELECT * FROM dbo.[HIPPS/IRF-only]

--IMPORTANT: all columns should be checked for NULL values
SELECT * 
FROM dbo.[HIPPS/IRF-only]
--WHERE [HIPPS code] IS NULL
--WHERE [Code Effective From Date] IS NULL
WHERE [Code Effective Through Date] IS NOT NULL
--WHERE [Payment System Indicator] IS NULL
--WHERE [Description] IS NULL

--checking distinct-ness on code for Primary key
SELECT DISTINCT [HIPPS code]
FROM dbo.[HIPPS/IRF-only]

--looking at max length so we can update the table design
SELECT 
	MAX(LEN([HIPPS code])) AS Code,
	MAX(LEN([Code Effective From Date])) AS EffectiveFromDate,
	MAX(LEN([Code Effective Through Date])) AS EffectiveThroughDate,
	MAX(LEN([Payment System Indicator])) AS PaymentSystemIndicator,
	MAX(LEN([Description])) AS Description
FROM dbo.[HIPPS/IRF-only]

--pulling back data related to longer date value
SELECT *
FROM dbo.[HIPPS/IRF-only]
WHERE LEN([Code Effective From Date]) = 10

--looking at max length to see if we need to trim data in the loader
SELECT 
	MAX(LEN(RTrim([HIPPS code]))) AS Code,
	MAX(LEN(RTrim([Code Effective From Date]))) AS EffectiveFromDate,
	MAX(LEN(RTrim([Code Effective Through Date]))) AS EffectiveThroughDate,
	MAX(LEN(RTrim([Payment System Indicator]))) AS PaymentSystemIndicator,
	MAX(LEN(RTrim([Description]))) AS Description
FROM dbo.[HIPPS/IRF-only]

--first practice
SELECT
	MAX(LEN(RTRIM([Description]))) AS Description
FROM dbo.[HIPPS/IRF-only]


