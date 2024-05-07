/*2. List the countries ranked 10-12 in each continent by the percent of year-over-year growth descending from 2011 to 2012.

The percent of growth should be calculated as: ((2012 gdp - 2011 gdp) / 2011 gdp)

The list should include the columns:

rank
continent_name
country_code
country_name
growth_percent*/
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
),
gpd2011 as (
SELECT 
        continent_name,
            country_code,
            country_name,
            gdp_per_capita AS gdp_2011
    FROM
        gdp_join
    WHERE
        year = 2011
),
gpd_growth_rank AS(
SELECT 
    t1.continent_name,
    t1.country_code,
    t1.country_name,
    CONCAT(ROUND(((t2.gdp_2012 - t1.gdp_2011) / t1.gdp_2011) * 100,
                    2),
            '%') AS growth_percent
           
           ,RANK() OVER (PARTITION BY t1.continent_name order by ((t2.gdp_2012 - t1.gdp_2011) / t1.gdp_2011) desc)  as rank
FROM
    (SELECT 
        continent_name,
            country_code,
            country_name,
            gdp_2011
    FROM
        gpd2011
    ) t1
        INNER JOIN
    (SELECT DISTINCT
        country_code, gdp_per_capita AS 'gdp_2012'
    FROM
        gdp_join
    WHERE
        year = 2012) t2 ON t1.country_code = t2.country_code
)

SELECT * FROM gpd_growth_rank

where rank > 9 and rank < 13;