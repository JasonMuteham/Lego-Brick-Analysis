/*markdown
---
*/

/*markdown
Create a report to summarize your findings. Include:
1. What is the average number of Lego sets released per year?
2. What is the average number of Lego parts required for the sets released each year?
3. Create a visualization for item 2.
4. What are the 5 most popular colors used in Lego parts?
5. [Optional] What proportion of Lego parts are transparent?
6. [Optional] What are the 5 rarest lego bricks?
7. Summarize your findings.
*/

/*markdown
![rebrickable schema](https://rebrickable.com/static/img/diagrams/downloads_schema_v3.png)
Schema & data from [rebrickable](https://rebrickable.com)

---
*/

/*markdown
**Q. What is the average number of Lego sets released per year?**
*/

SELECT COUNT(*) AS 'Total Sets',
       MAX(year) - MIN(year) AS 'Years Est',
       COUNT(year) / (MAX(year) - MIN(year))  AS 'Avg sets per year'
FROM sets

SELECT year AS 'Release Year', COUNT(*) AS 'Sets Released'
  FROM sets
--WHERE year BETWEEN '2010' AND '2020'
GROUP BY year 
ORDER By year DESC;

SELECT year AS 'Release Year', COUNT(*) AS 'Sets Released'
  FROM sets
WHERE year BETWEEN '2010' AND '2022'
GROUP BY year 
ORDER By year;

/*markdown
![Chart](images/Sets%20Released%20vs%20Release%20Year.svg)
*/

/*markdown
 **Q. What is the average number of Lego parts required for the sets released each year?**
*/

SELECT SUM(num_parts) AS 'Total Parts',
       MAX(year) - MIN(year) AS 'Years Est',
       SUM(num_parts) / (MAX(year) - MIN(year))  AS 'Avg parts per year'
FROM sets

/*markdown
**Q. Top 10 sets with the most parts.**
*/

SELECT set_num, name, year, num_parts AS total_parts
FROM sets
ORDER by total_parts DESC
LIMIT 10

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
GROUP BY year
ORDER BY year DESC

SELECT SUM(num_sets) as 'Sets',SUM(tot_parts) AS 'No. Parts Required', SUM(tot_parts) / SUM(num_sets) AS 'Average Part per Set'
FROM (
SELECT SUM(1) as num_sets, SUM(s.num_parts) as tot_parts
FROM inventories AS i
INNER JOIN sets as s
USING(set_num)
WHERE s.year < 2023
GROUP BY s.year

UNION ALL

SELECT SUM(inv.quantity) as num_sets, SUM(inv.quantity * ss.num_parts) as tot_parts
FROM inventory_sets AS inv
INNER JOIN sets as ss
USING(set_num)
WHERE ss.year < 2023
GROUP BY ss.year
)

/*markdown
**Q. How many Star Wars themed set are there?**
*/

SELECT t.name AS 'Theme Name', COUNT(s.set_num) AS 'Number of Sets'
FROM sets AS s
JOIN themes AS t
ON s.theme_id = t.id
WHERE t.name LIKE '%star wars%'
GROUP BY t.name