--1.1 Total sales by month
SELECT
	MONTH(datum) as "Month"
	--Optional - depending if we prefer names than numbers of months.
	--CASE
	--	WHEN MONTH(datum) = 1	THEN 'January'
	--	WHEN MONTH(datum) = 2	THEN 'February'
	--	WHEN MONTH(datum) = 3	THEN 'March'
	--	WHEN MONTH(datum) = 4	THEN 'April'
	--	WHEN MONTH(datum) = 5	THEN 'May'
	--	WHEN MONTH(datum) = 6	THEN 'June'
	--	WHEN MONTH(datum) = 7	THEN 'July'
	--	WHEN MONTH(datum) = 8	THEN 'August'
	--	WHEN MONTH(datum) = 9	THEN 'September'
	--	WHEN MONTH(datum) = 10	THEN 'October'
	--	WHEN MONTH(datum) = 11	THEN 'November'
	--	WHEN MONTH(datum) = 12	THEN 'December'
	--END AS MonthName
	,CAST(SUM(M01AB)  as DECIMAL(10,2)) AS M01AB
	,CAST(SUM(M01AE)  as DECIMAL(10,2)) AS M01AE
	,CAST(SUM(N02BA)  as DECIMAL(10,2)) AS N02BA
	,CAST(SUM(N02BE)  as DECIMAL(10,2)) AS N02BE
	,CAST(SUM(N05C)   as DECIMAL(10,2)) AS N05C
	,CAST(SUM(R03)    as DECIMAL(10,2)) AS R03
	,CAST(SUM(R06)    as DECIMAL(10,2)) AS R06
	,CAST(SUM(M01AB + M01AE + N02BA + N02BE + R03 + R06) AS DECIMAL(10,2)) AS "TotalUnitsSold"
FROM SalesMonthly
WHERE datum < CONVERT(DATETIME, '2019-10-01')
GROUP BY MONTH(datum)

--1.2 Average sales by month
SELECT
	MONTH(datum) as MonthName
	,CAST(AVG(M01AB)  as DECIMAL(10,2)) AS M01AB
	,CAST(AVG(M01AE)  as DECIMAL(10,2)) AS M01AE
	,CAST(AVG(N02BA)  as DECIMAL(10,2)) AS N02BA
	,CAST(AVG(N02BE)  as DECIMAL(10,2)) AS N02BE
	,CAST(AVG(N05C)   as DECIMAL(10,2)) AS N05C
	,CAST(AVG(R03)    as DECIMAL(10,2)) AS R03
	,CAST(AVG(R06)    as DECIMAL(10,2)) AS R06
	,CAST(AVG(M01AB + M01AE + N02BA + N02BE + R03 + R06) AS DECIMAL(10,2)) AS "AvgUnitsSold"
FROM SalesMonthly
WHERE datum < CONVERT(DATETIME, '2019-10-01')
GROUP BY MONTH(datum)

--2.1 Total sales by weekday
SELECT
	[Weekday Name]
	,CAST(SUM(M01AB)  as DECIMAL(10,2)) AS M01AB
	,CAST(SUM(M01AE)  as DECIMAL(10,2)) AS M01AE
	,CAST(SUM(N02BA)  as DECIMAL(10,2)) AS N02BA
	,CAST(SUM(N02BE)  as DECIMAL(10,2)) AS N02BE
	,CAST(SUM(N05C)   as DECIMAL(10,2)) AS N05C
	,CAST(SUM(R03)    as DECIMAL(10,2)) AS R03
	,CAST(SUM(R06)    as DECIMAL(10,2)) AS R06
	,CAST(SUM(M01AB + M01AE + N02BA + N02BE + R03 + R06) AS DECIMAL(10,2)) AS "TotalUnitsSold"
FROM SalesDaily
GROUP BY [Weekday Name]
ORDER BY CASE
			WHEN [Weekday Name] = 'Monday' THEN '1'
			WHEN [Weekday Name] = 'Tuesday' THEN '2'
			WHEN [Weekday Name] = 'Wednesday' THEN '3'
			WHEN [Weekday Name] = 'Thursday' THEN '4'
			WHEN [Weekday Name] = 'Friday' THEN '5'
			WHEN [Weekday Name] = 'Saturday' THEN '6'
			WHEN [Weekday Name] = 'Sunday' THEN '7'
		END

--2.2 Average sales by weekday
SELECT
	[Weekday Name]
	,CAST(AVG(M01AB)  as DECIMAL(10,2)) AS M01AB
	,CAST(AVG(M01AE)  as DECIMAL(10,2)) AS M01AE
	,CAST(AVG(N02BA)  as DECIMAL(10,2)) AS N02BA
	,CAST(AVG(N02BE)  as DECIMAL(10,2)) AS N02BE
	,CAST(AVG(N05C)   as DECIMAL(10,2)) AS N05C
	,CAST(AVG(R03)    as DECIMAL(10,2)) AS R03
	,CAST(AVG(R06)    as DECIMAL(10,2)) AS R06
	,CAST(AVG(M01AB + M01AE + N02BA + N02BE + R03 + R06) AS DECIMAL(10,2)) AS "AvgUnitsSold"
FROM SalesDaily
GROUP BY [Weekday Name]
ORDER BY CASE
			WHEN [Weekday Name] = 'Monday' THEN '1'
			WHEN [Weekday Name] = 'Tuesday' THEN '2'
			WHEN [Weekday Name] = 'Wednesday' THEN '3'
			WHEN [Weekday Name] = 'Thursday' THEN '4'
			WHEN [Weekday Name] = 'Friday' THEN '5'
			WHEN [Weekday Name] = 'Saturday' THEN '6'
			WHEN [Weekday Name] = 'Sunday' THEN '7'
		END

--3.1 Total sales by hour

-- I used 2 different ways to achieve Rolling Total, first one using regular query and the second one with subquery - I could also use CTE but my chosen method was more intuitive for me.
SELECT
	Hour
	,CAST(SUM(M01AB)  as DECIMAL(10,2)) AS M01AB
	,CAST(SUM(M01AE)  as DECIMAL(10,2)) AS M01AE
	,CAST(SUM(N02BA)  as DECIMAL(10,2)) AS N02BA
	,CAST(SUM(N02BE)  as DECIMAL(10,2)) AS N02BE
	,CAST(SUM(N05C)   as DECIMAL(10,2)) AS N05C
	,CAST(SUM(R03)    as DECIMAL(10,2)) AS R03
	,CAST(SUM(R06)    as DECIMAL(10,2)) AS R06
	,CAST(SUM(M01AB + M01AE + N02BA + N02BE + R03 + R06) AS DECIMAL(10,2)) AS "TotalUnitsSold"
	,CAST(SUM(SUM(M01AB + M01AE + N02BA + N02BE + R03 + R06)) OVER (ORDER BY Hour ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS DECIMAL(10,2)) AS "RollingUnitsSold"
FROM SalesHourly
GROUP BY Hour
ORDER BY Hour

	SELECT *
	FROM SalesHourly
	WHERE Hour = 23
	ORDER BY N02BA DESC

--3.2 Average sales by hour
SELECT
    Hour
    ,M01AB
    ,M01AE
    ,N02BA
    ,N02BE
    ,N05C
    ,R03
    ,R06
    ,AvgUnitsSold
    ,CAST(SUM("AvgUnitsSold") OVER (ORDER BY Hour ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS DECIMAL(10,2)) AS "AvgRollingUnitsSold"
FROM
    (
    SELECT
        Hour
        ,CAST(AVG(M01AB) AS DECIMAL(10,2)) AS M01AB
        ,CAST(AVG(M01AE) AS DECIMAL(10,2)) AS M01AE
        ,CAST(AVG(N02BA) AS DECIMAL(10,2)) AS N02BA
        ,CAST(AVG(N02BE) AS DECIMAL(10,2)) AS N02BE
        ,CAST(AVG(N05C) AS DECIMAL(10,2)) AS N05C
        ,CAST(AVG(R03) AS DECIMAL(10,2)) AS R03
        ,CAST(AVG(R06) AS DECIMAL(10,2)) AS R06
        ,CAST(AVG(M01AB + M01AE + N02BA + N02BE + R03 + R06) AS DECIMAL(10,2)) AS "AvgUnitsSold"
    FROM SalesHourly
    GROUP BY Hour
    )p
ORDER BY Hour