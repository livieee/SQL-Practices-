-- Question 184
-- The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.

-- +----+-------+--------+--------------+
-- | Id | Name  | Salary | DepartmentId |
-- +----+-------+--------+--------------+
-- | 1  | Joe   | 70000  | 1            |
-- | 2  | Jim   | 90000  | 1            |
-- | 3  | Henry | 80000  | 2            |
-- | 4  | Sam   | 60000  | 2            |
-- | 5  | Max   | 90000  | 1            |
-- +----+-------+--------+--------------+
-- The Department table holds all departments of the company.

-- +----+----------+
-- | Id | Name     |
-- +----+----------+
-- | 1  | IT       |
-- | 2  | Sales    |
-- +----+----------+
-- Write a SQL query to find employees who have the highest salary in each of the departments. 
-- For the above tables, your SQL query should return the following rows (order of rows does not matter).

-- +------------+----------+--------+
-- | Department | Employee | Salary |
-- +------------+----------+--------+
-- | IT         | Max      | 90000  |
-- | IT         | Jim      | 90000  |
-- | Sales      | Henry    | 80000  |
-- +------------+----------+--------+
-- Explanation:

-- Max and Jim both have the highest salary in the IT department and Henry has the highest salary in the Sales department.

-- Solution1
Select d.name as Department, e.name as Employee,
e.Salary as Salary
From Employee as e
Join Department as d on d.id = e.departmentId
Where (departmentId, salary) In
(Select departmentId, max(salary)
From Employee
Group By departmentId)


-- Solution2
select a.Department, a.Employee, a.Salary
from(
select d.name as Department, e.name as Employee, Salary,
rank() over(partition by d.name order by salary desc) as rk
from employee e
join department d
on e.departmentid = d.id) a
where a.rk=1

-- Solution 3
-- 1. Employee_1: get the max salary for each dept id
-- 2. Employee_2: get the employee where they have the max salary within each dept id
-- 3. Joined: get the dept name from the "Department" table based on dept id
-- 4. Ready: 
with
Employee_1 as
（select *, MAX(salary) OVER (PARTITION BY departmentId) as maxSalary from Employee),
Employee_2 as 
(SELECT * from Employee_1 where salary = maxSalary),
Joined as 
(select D.name as Department, E.name as Employee, E.salary as Salary from
	(
(select * from Employee_2) E
LEFT Join
(select * from Department) D
ON E.maxSalary = D.id)),
select * from Joined

