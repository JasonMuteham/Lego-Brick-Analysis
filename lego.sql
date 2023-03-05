/*markdown
---
*/

/*markdown
Create a report to summarize your findings. Include:
1. What is the average number of Lego sets and parts released each year, excluding mini figures?
2. If you wanted to make every set released how many sets & parts would be required, include mini figures?
3. Show the trend of sets & parts over time
4. Top 10 sets with the most parts.
5. How many Star Wars themed set are there?
6. [Optional] What proportion of Lego parts are transparent?
7. [Optional] What are the 5 rarest lego bricks?
*/

/*markdown
![rebrickable schema](https://rebrickable.com/static/img/diagrams/downloads_schema_v3.png)
Schema & data from [rebrickable](https://rebrickable.com)

---
*/

/*markdown
**Q. What is the average number of Lego sets and parts released each year, excluding mini figures?**
*/

SELECT COUNT(*) AS 'Total Sets',
       MAX(year) - MIN(year) AS 'Years Est',
       COUNT(year) / (MAX(year) - MIN(year))  AS 'Avg Sets per Year',
       SUM(num_parts) AS 'Total Parts',
       SUM(num_parts) / (MAX(year) - MIN(year))  AS 'Avg Parts per Year'
FROM sets

/*markdown
**Q. If you wanted to make every set released how many sets & parts would be required, include mini figures?**

Note: Sets can contain multiples of other sets, we are assuming that reusing sets is not allowed!
*/

--Set can be made up of parts, other sets or both so we need to gather the data from a few tables.
SELECT (SELECT MAX(year) - MIN(year)
        FROM sets) AS 'Years Est',
        SUM(num_sets) as 'Sets',
        SUM(num_sets) / (SELECT MAX(year) - MIN(year)
            FROM sets) AS 'Avg Sets per Year',
        SUM(tot_parts) AS 'Total Parts Required', 
        SUM(tot_parts) / SUM(num_sets) AS 'Average Part per Set',
        SUM(tot_parts) / (SELECT MAX(year) - MIN(year)
            FROM sets) AS 'Avg Parts per Year'
FROM (
SELECT SUM(1) as num_sets, SUM(s.num_parts) as tot_parts
FROM inventories AS i
INNER JOIN sets as s
USING(set_num)

UNION ALL

SELECT SUM(inv.quantity) as num_sets, SUM(inv.quantity * ss.num_parts) as tot_parts
FROM inventory_sets AS inv
INNER JOIN sets as ss
USING(set_num)

UNION ALL
--minifigures have parts but are not sets
SELECT SUM(0) as num_sets, SUM(im.quantity * m.num_parts) as tot_parts
FROM inventory_minifigs AS im
INNER JOIN minifigs as m
USING(fig_num)
)

/*markdown
**Q. Show the trend of sets & parts over time.** 
*/

SELECT year AS 'Release Year', COUNT(*) AS 'Sets Released', SUM(num_parts) AS 'Parts Required'
  FROM sets
WHERE year BETWEEN '2010' AND '2022'
GROUP BY year 
ORDER By year;

/*markdown
![Chart](Images/Sets%20Released%20vs%20Release%20Year.svg)
*/

/*markdown
**Q. Top 10 sets with the most parts.**
*/

/*markdown
The number of parts in a set can be calculate by two methods.  The **sets** table has a field called **num_parts**. Alternatively the inventory_parts table can be aggregated. The results between the methods highlight a small difference in the number of parts, this discrepancy is possibly due to the **sets** table **num_parts** field not being updated correctly? Despite the difference the top 10 is the same. 
*/

SELECT set_num AS set_number, name AS 'Name', year AS 'Year', num_parts AS Total_Parts
FROM sets
ORDER by Total_Parts DESC
LIMIT 10

SELECT (SELECT set_num
        FROM inventories AS i
        WHERE inventory_id = id) AS set_number,
        s.name AS 'Name', s.year AS 'Year',
        SUM(quantity) AS Total_Parts
FROM inventory_parts
JOIN sets AS s
ON set_number = s.set_num
GROUP BY inventory_id
ORDER BY Total_Parts DESC
LIMIT 10

/*markdown
**Q. What is the total number of unique sets and unique mini figures release?** 
*/

SELECT COUNT(sets.name) AS 'Total Sets', (SELECT COUNT(name) FROM minifigs) AS 'Total Mini figures'
FROM sets

SELECT year AS 'Year', SUM(num_sets) as 'Sets',SUM(tot_parts) AS 'No. Parts Required'
FROM (
SELECT s.year as year, SUM(1) as num_sets, SUM(s.num_parts) as tot_parts
FROM inventories AS i
INNER JOIN sets as s
USING(set_num)
WHERE s.year < 2023
GROUP BY s.year

UNION ALL

SELECT ss.year as year, SUM(inv.quantity) as num_sets, SUM(inv.quantity * ss.num_parts) as tot_parts
FROM inventory_sets AS inv
INNER JOIN sets as ss
USING(set_num)
WHERE ss.year < 2023
GROUP BY ss.year
)
WHERE year BETWEEN '2010' AND '2022'
GROUP BY year
ORDER BY year DESC

/*markdown
**Q. How many Star Wars themed set are there?**
*/

SELECT t.name AS 'Theme Name', COUNT(s.set_num) AS 'Number of Sets'
FROM sets AS s
JOIN themes AS t
ON s.theme_id = t.id
WHERE t.name LIKE '%star wars%'
GROUP BY t.name