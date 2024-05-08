/*5\. Find the sum of gpd_per_capita by year and the count of countries for each year that have non-null gdp_per_capita where 
(i) the year is before 2012 and (ii) the country has a null gdp_per_capita in 2012. Your result should have the columns:

- year
- country_count
- total
*/
/*
(i) the year is before 2012
*/
SELECT Year
	, COUNT(country_code) AS Country_count
	, SUM(gdp_per_capita) AS Total
FROM
	per_capita
WHERE 
	gdp_per_capita IS NOT NULL
AND
	year < 2012
GROUP BY Year
;
/*
(ii) the country has a null gdp_per_capita in 2012. Your result should have the columns
*/
SELECT Year
	, COUNT(country_code) AS Country_count
	, SUM(gdp_per_capita) AS Total
FROM
	per_capita
WHERE 
	gdp_per_capita IS NULL
AND
	year = 2012

GROUP BY Year
;