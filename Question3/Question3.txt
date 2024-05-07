/*
3. For the year 2012, create a 3 column, 1 row report showing the percent share of gdp_per_capita for the following regions:

(i) Asia, (ii) Europe, (iii) the Rest of the World. Your result should look something like

For example : Asia	Europe	Rest of World
              25.0%	 25.0%	 50.0% 
*/

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
    CONCAT(ROUND(((
	SELECT SUM(gdp_per_capita)
    FROM gdp_join
    WHERE year = 2012 AND continent_name = 'Asia') / (SELECT SUM(gdp_per_capita) FROM gdp_join
    WHERE year = 2012)) * 100,1),'%') 
	AS Asia,
    CONCAT(ROUND(((
	SELECT SUM(gdp_per_capita) FROM gdp_join
    WHERE year = 2012 AND continent_name = 'Europe') / (SELECT SUM(gdp_per_capita) FROM gdp_join
    WHERE year = 2012)) * 100, 1),'%') AS Europe,
    CONCAT(ROUND(((
	SELECT SUM(gdp_per_capita) FROM gdp_join
    WHERE year = 2012 AND continent_name != 'Asia' AND continent_name != 'Europe') / (SELECT SUM(gdp_per_capita)
    FROM gdp_join WHERE year = 2012)) * 100, 1),'%') AS 'Rest of World';