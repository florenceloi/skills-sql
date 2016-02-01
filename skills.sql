-- Part 1:

-- 1. Select all columns for all brands in the brands table.

SELECT * FROM brands;


-- 2. Select all columns for all car models made by Pontiac in the models table.

SELECT * FROM models WHERE brand_name = 'Pontiac';


-- 3. Select the brand name and model name for all models made in 1964 from the 
--    models table.

SELECT brand_name, name FROM models WHERE year = 1964;


-- 4. Select the model name, brand name, and headquarters for the Ford Mustang 
--    from the models and brands tables.

SELECT models.name, models.brand_name, brands.headquarters FROM models 
    JOIN brands ON (models.brand_name = brands.name) 
    WHERE (models.brand_name = 'Ford' AND models.name = 'Mustang');


-- 5. Select all rows for the three oldest brands from the brands table (Hint: 
--    you can use LIMIT and ORDER BY).

SELECT * FROM brands ORDER BY founded LIMIT 3;


-- 6. Count the Ford models in the database (output should be a number).

SELECT COUNT(*) FROM models WHERE brand_name = 'Ford';


-- 7. Select the name of any and all car brands that are not discontinued.

SELECT name FROM brands WHERE discontinued IS NULL;


-- 8. Select everything from rows 15-25 of the models table in alphabetical 
--    order by name. (Hint: how can you show only part of a result set?)

SELECT * FROM models WHERE id BETWEEN 15 AND 25 ORDER BY name;


-- 9. Select the brand, name, and year the model’s brand was founded for all of 
--    the models from 1960. Include row(s) for model(s) even if its brand is not
--    in the brands table. (The year the brand was founded should be NULL if the 
--    brand is not in the brands table.)

SELECT models.brand_name AS brand_name, 
       models.name AS model_name, 
       brands.founded AS brand_founded 
    FROM brands FULL OUTER JOIN models 
        ON (brands.name = models.brand_name) 
    WHERE models.year >= 1960;





-- Part 2:

-- 1. Modify this query so it shows all brands that are not discontinued regardless
--    of whether they have any models in the models table.

SELECT b.name AS brand_name,
       b.founded AS brand_founded,
       m.name AS model_name
FROM brands AS b
  LEFT JOIN models AS m
    ON b.name = m.brand_name
WHERE b.discontinued IS NULL; 


-- 2. Modify this left join so it only selects models that have brands in the 
--    brands table.

SELECT m.name,
       m.brand_name,
       b.founded
FROM brands AS b
  LEFT JOIN models AS m
    ON b.name = m.brand_name
WHERE m.name IS NOT NULL;

--    Discussion question: In your own words, describe the difference between
--    leftjoins and inner joins. Answer this question a comment below the query
--    (prepend the line with -- to leave a comment in SQL).

--    Answer: Inner joins only return row data (from each table) where each table 
--    has a matching field (selected with the ON or USING). Left joins are similar 
--    but they also return all the row data of the first mentioned table regardless
--    if the selected field matches with the second table.


-- 3. Modify the query so that it only selects brands that don’t have any models 
--    in the models table. (Hint: it should only show Tesla.)

SELECT b.name,
       b.founded
FROM brands AS b
  LEFT JOIN models AS m
    ON b.name = m.brand_name
WHERE m.brand_name IS NULL;

-- 4. Extra Hard: Modify the query to add another column to the results that gives
--    the number of years from the year of the model until the brand becomes 
--    discontinued. Display this column with the name years_until_brand_discontinued.

SELECT b.name,
       m.name,
       m.year,
       b.discontinued,
       (b.discontinued - m.year) AS years_until_brand_discontinued
FROM models AS m
  LEFT JOIN brands AS b
    ON m.brand_name = b.name
WHERE b.discontinued IS NOT NULL;





-- Part 3: Further Study

-- 1. Select the name of any brand with more than 5 models in the database.

SELECT brand_name FROM models GROUP BY brand_name HAVING COUNT(name) > 5;

-- 2. Add the following rows to the models table.
--      - 2015, Chevrolet, Malibu
--      - 2015, Subaru, Outback
--    Note: columns are (year, name, brand_name)

-- FLORENCE'S NOTE: I think the instructions are mixed up - Chevrolet and Subaru
-- should be the brand_names. My solution reflects this change.

INSERT INTO models (year, brand_name, name) VALUES (2015, 'Chevrolet', 'Malibu');
INSERT INTO models (year, brand_name, name) VALUES (2015, 'Subaru', 'Outback');

-- 3. Write a SQL statement to create a table called Awards with columns name, year,
--    and winner_id. Choose an appropriate datatype and nullability for each column.

CREATE TABLE Awards(
    name VARCHAR(50),
    year INTEGER,
    winner_id INTEGER
        REFERENCES models);

-- 4. Write a SQL statement that adds the following rows to the Awards table 
--    (no need to do subqueries here).
--      - IIHS Safety Award, 2015, (id from the models table for the 2015 Chevrolet 
--        Malibu)
--      - IIHS Safety Award, 2015, (id from the models table for the 2015 Subaru
--        Outback)
--    Note: column names are (name, year, winner_id)

INSERT INTO Awards VALUES ('IIHS Safety Award', 2015, 49);
INSERT INTO Awards (name, year, winner_id) 
    SELECT name, year, 50 
    FROM Awards 
    WHERE winner_id = 49;

-- 5. Using a subquery, select only the name of any model whose year is the same
--    year that any brand was founded.

SELECT name FROM models WHERE year IN
    (
    SELECT founded
    FROM brands
    ); 