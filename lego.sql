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

---
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
WHERE year BETWEEN '2010' AND '2020'
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

SELECT *
FROM sets
WHERE set_num = '5004559-1'

SELECT *
FROM inventories
WHERE set_num = '5004559-1'

SELECT *
FROM inventory_sets
WHERE inventory_id = '35'

SELECT *
FROM sets
WHERE set_num IN ('75912-1','75911-1')

SELECT *
FROM sets
WHERE set_num = '8088-1'

SELECT *
FROM inventories
WHERE set_num = '8088-1'

SELECT *
FROM inventory_sets
WHERE inventory_id IN ('1700','23731')

SELECT *
FROM sets
WHERE set_num = 'K3433-1'

SELECT *
FROM inventories
WHERE set_num = "K3433-1"

SELECT *
FROM inventory_sets
WHERE inventory_id = '14222'

SELECT *
FROM sets
WHERE set_num IN ('10121-1','3433-1')

SELECT *
FROM inventory_sets
WHERE set_num IN ('10121-1','3433-1')

/*markdown
![rebrickable schema](https://rebrickable.com/static/img/diagrams/downloads_schema_v3.png)
*/

SELECT COUNT(*) AS 'Number of Sets'
FROM sets

SELECT COUNT(*) AS 'Number of Mini Figures'
FROM minifigs

SELECT COUNT(DISTINCT set_num)
FROM inventory_sets

SELECT COUNT(DISTINCT set_num)
FROM inventories
WHERE set_num IS NOT NULL

SELECT COUNT(set_num)
FROM inventories
