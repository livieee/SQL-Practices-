-- Table: Project

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | project_id  | int     |
-- | employee_id | int     |
-- +-------------+---------+
-- (project_id, employee_id) is the primary key (combination of columns with unique values) of this table.
-- employee_id is a foreign key (reference column) to Employee table.
-- Each row of this table indicates that the employee with employee_id is working on the project with project_id.
 

-- Table: Employee

-- +------------------+---------+
-- | Column Name      | Type    |
-- +------------------+---------+
-- | employee_id      | int     |
-- | name             | varchar |
-- | experience_years | int     |
-- +------------------+---------+
-- employee_id is the primary key (column with unique values) of this table.
-- Each row of this table contains information about one employee.
 

-- Write a solution to report all the projects that have the most employees.

-- Return the result table in any order.

-- The result format is in the following example.

 

-- Example 1:

-- Input: 
-- Project table:
-- +-------------+-------------+
-- | project_id  | employee_id |
-- +-------------+-------------+
-- | 1           | 1           |
-- | 1           | 2           |
-- | 1           | 3           |
-- | 2           | 1           |
-- | 2           | 4           |
-- +-------------+-------------+
-- Employee table:
-- +-------------+--------+------------------+
-- | employee_id | name   | experience_years |
-- +-------------+--------+------------------+
-- | 1           | Khaled | 3                |
-- | 2           | Ali    | 2                |
-- | 3           | John   | 1                |
-- | 4           | Doe    | 2                |
-- +-------------+--------+------------------+
-- Output: 
-- +-------------+
-- | project_id  |
-- +-------------+
-- | 1           |
-- +-------------+
-- Explanation: The first project has 3 employees while the second one has 2.

# # Write your MySQL query statement below
SELECT project_id
FROM Project
GROUP BY project_id
HAVING COUNT(employee_id) =
(
  #get the max employee number among all group
  SELECT max(e_num)
  FROM (
    SELECT project_id, count(employee_id) as e_num
    FROM Project
    GROUP BY project_id
   ) temp_table
)

# 1. group by project_id
# 2. using rank() to rank the # of employee for each group
# 3. then select the project with rank = 1
with cte as(
    select project_id, 
    rank() over(order by count(employee_id) desc) as enum_rank
    from Project
    group by project_id
)
select project_id
from cte
where enum_rank = 1






