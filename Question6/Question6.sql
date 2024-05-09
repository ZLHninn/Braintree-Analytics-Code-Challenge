---creating temptable ranking each country per continent starting from countries where running total of gdp_per_capita meets or exceeds
-- Declare a table variable
DECLARE @running_total TABLE (
    continent_code VARCHAR(50),
    country_code VARCHAR(50),
    country_name VARCHAR(50),
    gdp_per_capita MONEY,
    running MONEY
)

-- Insert into the table variable
INSERT INTO @running_total
SELECT
    rt.continent_code,
    rt.country_code,
    rt.country_name,
    rt.gdp_per_capita,
    rt.running
FROM 
(
    SELECT
        continents.continent_code,
        per_capita.country_code,
        countries.country_name,
        CAST(per_capita.gdp_per_capita AS NUMERIC(15,2)) as gdp_per_capita,
        CAST(SUM(per_capita.gdp_per_capita) OVER (
            PARTITION BY continents.continent_code 
            ORDER BY continents.continent_code, SUBSTRING(countries.country_name, 2, 3) DESC 
            ROWS UNBOUNDED PRECEDING
        ) AS NUMERIC(15,2)) as running
    FROM 
        per_capita 
    LEFT JOIN 
        continent_map ON per_capita.country_code = continent_map.country_code
    LEFT JOIN 
        continents ON continent_map.continent_code = continents.continent_code
    LEFT JOIN
        countries ON continent_map.country_code = countries.country_code
    WHERE 
        continents.continent_code IS NOT NULL
) AS rt
WHERE 
    rt.running > 69999.99

--  returning only the first record from the ordered list
SELECT 
    rt.continent_code,
    rt.country_code,
    rt.country_name,
    rt.gdp_per_capita,
    rt.running,
    rt.rank
FROM 
(
    SELECT 
        continent_code,
        country_code,
        country_name,
        gdp_per_capita,
        running,
        RANK() OVER(PARTITION BY continent_code ORDER BY running) as [rank]
    FROM 
        @running_total
) AS rt
WHERE 
    rt.rank = 1
