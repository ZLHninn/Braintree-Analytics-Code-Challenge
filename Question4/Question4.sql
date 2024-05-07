/*
4a. What is the count of countries and sum of their related gdp_per_capita values for the year 2007 where the string 'an' (case insensitive) appears anywhere in the country name?
4b. Repeat question 4a, but this time make the query case sensitive.
*/

/* This code creates a Common Table Expression (CTE) named gdp_join that joins the continent_map,countries, continents, and per_capita tables. 
It then selects the total count of records and the sum of the gdp_per_capita from the gdp_join CTE where the year is 2007 and the country_name contains ‘an’.
The LIKE clause is used to perform (case insensitive)*/

WITH gdp_join AS(
SELECT capi.country_code AS country_code,
       c.country_name AS country_name,
       conti.continent_code AS continent_code,
       conti.continent_name AS continent_name,
       capi.year AS year,
       capi.gdp_per_capita AS gdp_per_capita
		FROM continent_map as cmap
INNER JOIN countries c ON cmap.country_code = c.country_code
INNER JOIN continents conti  ON cmap.continent_code = conti.continent_code
INNER JOIN per_capita capi ON cmap.country_code = capi.country_code
)
SELECT 
    COUNT(*) AS Total_Count, SUM(gdp_per_capita) AS Total_gdp_per_capita
FROM
    gdp_join
WHERE
    year = 2007 AND country_name LIKE '%an%';

/*This code creates a Common Table Expression (CTE) named gdp_join that joins the continent_map,countries, continents, and per_capita tables. 
It then selects the total count of records and the sum of the gdp_per_capita from the gdp_join CTE where the year is 2007 and the country_name contains ‘an’. 
The LIKE BINARY clause is used to perform a case-sensitive search.*/
WITH gdp_join AS(
SELECT capi.country_code AS country_code,
       c.country_name AS country_name,
       conti.continent_code AS continent_code,
       conti.continent_name AS continent_name,
       capi.year AS year,
       capi.gdp_per_capita AS gdp_per_capita
		FROM continent_map as cmap
INNER JOIN countries c ON cmap.country_code = c.country_code
INNER JOIN continents conti  ON cmap.continent_code = conti.continent_code
INNER JOIN per_capita capi ON cmap.country_code = capi.country_code
)
SELECT COUNT(*) AS Total_Count, SUM(gdp_per_capita) AS Total_gdp_per_capita
FROM gdp_join
WHERE year = 2007 AND country_name  COLLATE SQL_Latin1_General_CP1_CS_AS LIKE '%an%';