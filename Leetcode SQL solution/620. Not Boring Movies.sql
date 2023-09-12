-- Table: Cinema

-- +----------------+----------+
-- | Column Name    | Type     |
-- +----------------+----------+
-- | id             | int      |
-- | movie          | varchar  |
-- | description    | varchar  |
-- | rating         | float    |
-- +----------------+----------+
-- id is the primary key (column with unique values) for this table.
-- Each row contains information about the name of a movie, its genre, and its rating.
-- rating is a 2 decimal places float in the range [0, 10]
 

-- Write a solution to report the movies with an odd-numbered ID and a description that is not "boring".

-- Return the result table ordered by rating in descending order.

-- The result format is in the following example.

 

-- Example 1:

-- Input: 
-- Cinema table:
-- +----+------------+-------------+--------+
-- | id | movie      | description | rating |
-- +----+------------+-------------+--------+
-- | 1  | War        | great 3D    | 8.9    |
-- | 2  | Science    | fiction     | 8.5    |
-- | 3  | irish      | boring      | 6.2    |
-- | 4  | Ice song   | Fantacy     | 8.6    |
-- | 5  | House card | Interesting | 9.1    |
-- +----+------------+-------------+--------+
-- Output: 
-- +----+------------+-------------+--------+
-- | id | movie      | description | rating |
-- +----+------------+-------------+--------+
-- | 5  | House card | Interesting | 9.1    |
-- | 1  | War        | great 3D    | 8.9    |
-- +----+------------+-------------+--------+
-- Explanation: 
-- We have three movies with odd-numbered IDs: 1, 3, and 5. The movie with ID = 3 is boring so we do not include it in the answer.


--solution:
# Write your MySQL query statement below
SELECT id, movie, description, rating
FROM Cinema
WHERE id mod 2 != 0
AND description != 'boring'
ORDER BY rating DESC


## **[620. Not Boring Movies](https://leetcode.com/problems/not-boring-movies/): Easy**

### Get Odd Number in SQL

- Reference: https://tableplus.com/blog/2019/09/select-rows-odd-even-value.html
1. **In PostgreSQL, My SQL, and Oracle**, we use `MOD` function to check the remainder.

For Even values:  mod(column, 2) = 0

```
SELECT *
FROM table_name
WHERE mod(column_name,2) = 0;
```

For Odd values: mod(column, 2) ≠ 0

```
SELECT *
FROM table_name
WHERE mod(column_name,2) <> 0;
```

1. **In MS SQL Server**, there is no MOD function and you can use **%.**

For Even values:  column % 2 = 0

```
SELECT *
FROM table_name
where column_name % 2 = 0;
```

For Even values:  column % 2 ≠ 0

```
SELECT *
FROM table_name
where column_name % 2 <> 0;
```

## **[1050. Actors and Directors Who Cooperated At Least Three Times](https://leetcode.com/problems/actors-and-directors-who-cooperated-at-least-three-times/): Easy**

Q: Write a solution to find all the pairs `(actor_id, director_id)` where the actor has **cooperated with the director** at least three times.

Return the result table in **any order**.

💡思路：

1. Group two columns (same value of two columns)
2. Count number of times they appear
3. Filter the number of times ≥ n

📚Solution:

1. We can use `Group By` + `Having` to find the pair of two columns that show same values: `Group By X, Y`

```sql
# Write your MySQL query statement below
SELECT actor_id, director_id
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING count(*) >= 3
```

1. Make the number of appearances as a column, then filter the appearances.

```sql
SELECT actor_id, director_id 
FROM (
SELECT actor_id,director_id, count(timestamp) as times
FROM ActorDirector 
GROUP BY actor_id, director_id) AS cte
where times >= 3
```

## When to use Aggregate Function? (Max(), Count() etc.,)

1. An aggregate function performs a calculation on **a set of values**, and returns **a single value**. 
2. Note: Except for COUNT(*) , aggregate functions ignore null values in the calculation
    - 除了Count()在计算中不忽略null values，其他agg function都会忽略
3. Aggregate functions are **often used with the GROUP BY** clause of the **SELECT** statement:
    
    ```sql
    SELECT X, AGG()
    FROM Table
    Group By X
    ```
    
4. An aggregate function can be used in a WHERE clause **only if** that clause **is part of a subquery of a HAVING clause** and the column name specified in the expression is a correlated reference to a **group**.

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/787cf93a-8381-48d7-bf02-4d3185c7b113/2a4d1c27-7982-40d7-8b7a-6de486815284/Untitled.png)
