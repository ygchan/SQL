-- Subqueries
-- A subquery is a query contained within another SQL statement
-- It can happens in where/from claues. It is also always enclosed within parentheses.

-- Usually executed prior to the containing statement.

-- Subquery acts like a temporary table with statement scope, meaning that
-- the server frees up any memory allocated to the subquery after the SQL
-- statement has finished execution.

-- This is good because you save lines of code that to "drop" the tables.
-- I imagine this is especially useful after you confirmed your code works,
-- then any intermediate temp tables can be re-written as subquery.

-- 01: Simpe example of subquery

select account_id, product_cd, avail_balance
from account
where account_id = (
   select max(account_id)
   from account
);

-- This query selects the largest account_id, and filter it using such ID
-- which is unknown to the user prior to writing this code.

/* Output:
+------------+------------+---------------+
| account_id | product_cd | avail_balance |
+------------+------------+---------------+
|         29 | SBL        |      50000.00 |
+------------+------------+---------------+
1 row in set (0.01 sec)
*/

-- Subquery has 2 type: 
--    Noncorrelated subquery: Self contained
--    Correlated subquery: reference columns from the containing statement

-- Noncorrelated Subquery, it may be executed by itself and does not
-- reference anything from from the containing statement.

-- Single row and column = scalar subquery and can be appear on either side of
-- condition such as =, <>, <, <=, >, >=

-- 02: Noncorrelated Scalar Subquery
-- This subquery returns all the accounts not opened by the head teller at
-- the Woburn branch.
select account_id, product_cd, cust_id, avail_balance
from account
where open_emp_id <> (
   select e.emp_id
   from employee e 
      inner join branch b on (e.assigned_branch_id = b.branch_id)
   where e.title = 'Head Teller' and b.city = 'Woburn'
);

/* Output:
+------------+------------+---------+---------------+
| account_id | product_cd | cust_id | avail_balance |
+------------+------------+---------+---------------+
|          7 | CHK        |       3 |       1057.75 |
|          8 | MM         |       3 |       2212.50 |
|         10 | CHK        |       4 |        534.12 |
|         11 | SAV        |       4 |        767.77 |
|         12 | MM         |       4 |       5487.09 |
|         13 | CHK        |       5 |       2237.97 |
|         14 | CHK        |       6 |        122.37 |
|         15 | CD         |       6 |      10000.00 |
|         18 | CHK        |       8 |       3487.19 |
|         19 | SAV        |       8 |        387.99 |
|         21 | CHK        |       9 |        125.67 |
|         22 | MM         |       9 |       9345.55 |
|         23 | CD         |       9 |       1500.00 |
|         24 | CHK        |      10 |      23575.12 |
|         25 | BUS        |      10 |          0.00 |
|         28 | CHK        |      12 |      38552.05 |
|         29 | SBL        |      13 |      50000.00 |
+------------+------------+---------+---------------+
17 rows in set (0.02 sec)
*/

-- If you use the subquery in an equality condition, and it returns
-- more than one row, you will get an error message.
-- You can fix this however, by using a different operator.

-- 03: The in and not in operator
select branch_id, name, city
from branch
where name in ('Headquarters', 'Quincy Branch');

select emp_id, fname, lname, title
from employee
where emp_id in (
   select superior_emp_id
   from employee
);

-- Keep in mind the other options: not in, is not null, is null etc.

/* Output:
+--------+---------+-----------+--------------------+
| emp_id | fname   | lname     | title              |
+--------+---------+-----------+--------------------+
|      1 | Michael | Smith     | President          |
|      3 | Robert  | Tyler     | Treasurer          |
|      4 | Susan   | Hawthorne | Operations Manager |
|      6 | Helen   | Fleming   | Head Teller        |
|     10 | Paula   | Roberts   | Head Teller        |
|     13 | John    | Blake     | Head Teller        |
|     16 | Theresa | Markham   | Head Teller        |
+--------+---------+-----------+--------------------+
7 rows in set (0.01 sec)
*/