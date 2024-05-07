-- Select Statement To Pull Up Duplicate Country Code, FOO on top
SELECT COALESCE(country_code, 'FOO') Duplicate_Country_Code FROM continent_map
Group by country_code
Having count(*)>=2;

--Part 2:
--Create a temporary table with a new column ID as a row_number on the table after order by contry_code, continent_code*/
CREATE TABLE #myTempTable (
	ID nvarchar(30),
	country_code nvarchar(50),
	continent_code nvarchar(50)
	 
);-- Create a Temporary Table

WITH TEMP AS (
SELECT row_number() over (order by country_code, continent_code asc) as 'ID',country_code
      ,continent_code
  FROM continent_map) -- Create New column ID as a row_number

INSERT INTO #myTempTable 
SELECT  ID,
country_code
      ,continent_code
FROM TEMP --Insert the data into temp table

SELECT * FROM #myTempTable --Check the temp table

CREATE TABLE #myTempTable2 (
	ID nvarchar(30)
);--Create a temp table 2 

WITH TEMP2 AS (

	SELECT MIN(ID) AS ID FROM #myTempTable
	GROUP BY country_code
	
)--To find minium ID

INSERT INTO #myTempTable2 
SELECT ID
FROM TEMP2 --Insert the data

/*Delete the rows that dont have a min ID number after group by country_code*/
Delete From #myTempTable where ID NOT IN(select ID from #myTempTable2) ;

/*Reset continent_map table*/
Delete From continent_map;

/*Refill continent_map from temp_table*/

WITH continent_map AS (

	SELECT country_code, continent_code FROM #myTempTable
	
)

INSERT INTO dbo.continent_map 
SELECT country_code, continent_code
FROM continent_map 

SELECT count(*) FROM dbo.continent_map
;

 /*drop temporary tables*/
 DROP TABLE #myTempTable;
 DROP TABLE #myTempTable2;