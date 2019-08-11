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

-- 04: The all operator
-- The in operator is used to check an expression can be found within a set
-- The all operator allows you to make comparisons between a single value
-- and every value in a set. Note, you have to use all operator in conjunction
-- with one of the comparison operators (=, <>, >, <, etc)

-- Ex1: = any (subquery statement...) <-- very good example.
-- This is the same as in (subquery)

-- Ex2: <> all (subquery statement...)
-- This is the same as not in (subquery)

-- Ex3: > all (subquery statement)
-- This is comparing the expression with all the values returned.

select emp_id, fname, lname, title
from employee
where emp_id <> all (
   select superior_emp_id
   from employee
   where superior_emp_id is not null
);

-- Becareful not to compare a value with (null), because any attempt to
-- equate a value to null yields unknown.

select emp_id, fname, lname, title
from employee
where emp_id not in (1, 2, null);

/* Output:
Empty set (0.00 sec)
*/

-- This all operator shines when you are comparing >, >=, <, <=
select account_id, cust_id, product_cd, avail_balance
from account
where avail_balance < all (
   select a.avail_balance
   from account a
      inner join individual i on (a.cust_id = i.cust_id)
);

/* Output:
+------------+---------+------------+---------------+
| account_id | cust_id | product_cd | avail_balance |
+------------+---------+------------+---------------+
|         25 |      10 | BUS        |          0.00 |
+------------+---------+------------+---------------+
1 row in set (0.02 sec)
*/

-- I imagine you can also select min value and compare it that way.
-- This is an example of subquery used in where clause.

-- 05: Any operator

-- Getting Frank's account
select a.avail_balance
from account a 
   inner join individual i on (a.cust_id = i.cust_id)
where i.fname = 'Frank' and i.lname = 'Tucker';

/* Output:
+---------------+
| avail_balance |
+---------------+
|       1057.75 |
|       2212.50 |
+---------------+
2 rows in set (0.00 sec)
*/

select account_id, cust_id, product_cd, avail_balance
from account
where avail_balance > any (
   select a.avail_balance
   from account a
      inner join individual i on (a.cust_id = i.cust_id)
   where i.fname = 'Frank' and i.lname = 'Tucker'
);

-- Reminder = any() is the same is in ()

-- Multicolumn Subqueries
-- An example to show query that uses 2 subqueries to identify the ID of the 
-- Woburn branch and the IDs of all the bank tellers.

select account_id, product_cd, cust_id
from account
where open_branch_id = (
   select branch_id
   from branch
   where name = 'Woburn Branch'
) and open_emp_id in (
   select emp_id
   from employee
   where title in ('Teller', 'Head Teller')
);

/* Output:
+------------+------------+---------+
| account_id | product_cd | cust_id |
+------------+------------+---------+
|          1 | CHK        |       1 |
|          2 | SAV        |       1 |
|          3 | CD         |       1 |
|          4 | CHK        |       2 |
|          5 | SAV        |       2 |
|         17 | CD         |       7 |
|         27 | BUS        |      11 |
+------------+------------+---------+
*/

-- To combine the 2 subqueries together
-- Wrap the condition filter in parenthese, similiar to Python's tuple unpack
select account_id, product_cd, cust_id
from account
where (open_branch_id, open_emp_id) in (
   select b.branch_id, e.emp_id
   from branch b 
      inner join employee e on (b.branch_id = e.assigned_branch_id)
   where b.name = 'Woburn Branch'
      and e.title in ('Teller', 'Head Teller')
);

-- *** NEW ***
-- Correlated Subqueries

-- This query uses a correlated subquery to count the number of accounts for 
-- each customer, and the containing query then retrieves those customers
-- having exactly 2 account
select c.cust_id, c.cust_type_cd, c.city
from customer c
where 2 = (
   select count(*)
   from account a
   where a.cust_id = c.cust_id
);

/* Output:
+---------+--------------+---------+
| cust_id | cust_type_cd | city    |
+---------+--------------+---------+
|       2 | I            | Woburn  |
|       3 | I            | Quincy  |
|       6 | I            | Waltham |
|       8 | I            | Salem   |
|      10 | B            | Salem   |
+---------+--------------+---------+
5 rows in set (0.01 sec)
*/

-- The subquery here is correlated to the row being consider by
-- the containing query.
-- The reference to the c.cust_id at the end, is what makes this subquery 
-- correlated, the containing query must supply values for c.cust_id
-- for the subquery to execute.

-- The containing query retrieves all 13 rows from the customer table,
-- and excecute once for each customer, passing the appropriate customer
-- id for each execution, if the subquery returns value 2, then the filter
-- condition is met and the row is added to the result set.

-- 07: Another example (Simplier)
select c.cust_id, c.cust_type_cd, c.city
from customer c
where (
   select sum(a.avail_balance)
   from account a
   where a.cust_id = c.cust_id
) between 5000 and 10000;

/* Output:
+---------+--------------+------------+
| cust_id | cust_type_cd | city       |
+---------+--------------+------------+
|       4 | I            | Waltham    |
|       7 | I            | Wilmington |
|      11 | B            | Wilmington |
+---------+--------------+------------+
3 rows in set (0.01 sec)
*/

-- The correlated subquery is an advanced feature, allow you to execute
-- the containing query once, and the subquery will be running for each account.

-- 08: Exists Operator

select a.account_id, a.product_cd, a.cust_id, a.avail_balance
from account a
/* All the transcation occured on '2008-09-22' */
where exists (
   select 1
   from transaction t
   where t.account_id = a.account_id
      and t.txn_date = '2008-09-22'
);

-- The most common operator used to build conditinos that utilize correlated
-- subqueries is the exists operator.

-- You use it when you want to identify that a relationship exists without
-- regard for the condition

-- 09: Subqueries are used heavily in update, delete and insert

-- This query modify the last_activity_date of every row
-- by finding the latest transaction date for each account.
update account a
   set a.last_activity_date =
   (
      select max(t.txn_date)
      from transcation t
      where t.account_id = a.account_id
   );

-- 10: Update query using subqueries
update account a
   set a.last_activity_date =
   (
      select max(t.txn_date)
      from transcation t
      where t.account_id = a.ccount_id
   )
   /* This is new to me, and it is really handy! */
   /* Select a True value (since anything other 0) is True, if the account id
      matches with transcation table. This also protect against null. */
   where exists (
      select 1
      from transcation t
      where t.account_id = a.account_id
   );

-- In MySQL, table aliases are not allowed in delete statement.
-- That's why author referred to the full table name.
delete from department 
   where not exists (
      select 1 
      from employee
      where employee.dept_id = department.dept_id
   );

-- More examples on how to contruct table, build conditions and generate
-- columns using subqueries.

-- 11: Subquery as data source

-- This query returns the department id, department name and the count of 
-- employee belongs to that department.
select d.dept_id, d.name, e_cnt.how_many num_employees
from department d
   inner join (
      select dept_id, count(*) how_many
      from employee
      group by dept_id
   ) e_cnt on (d.dept_id = e_cnt.dept_id);

/* Output:
+---------+----------------+---------------+
| dept_id | name           | num_employees |
+---------+----------------+---------------+
|       1 | Operations     |            14 |
|       2 | Loans          |             1 |
|       3 | Administration |             3 |
+---------+----------------+---------------+
3 rows in set (0.01 sec)
*/

-- Note: Subqueries used in the from clause must be non-correlated. 
-- They are executed first and the data is hel in memory until the containing
-- query finishes execution.

-- Data Fabrication
-- Some Customer Balance Groups
-- Group name    | Lower Limit       | Upper Limit
-- Small         | 0                 | $4,999.99
-- Average       | $5,000            | $9,999.99
-- Large         | $10,000           | $9,999,999.99

-- Define your group using union
select 'Small' name, 0 low_limit, 4999.9 high_limit
union all
select 'Average' name, 5000 low_limit, 9999.99 high_limit
union all
select 'Large' name, 10000 low_limit, 9999999.99 high_limit;

/* Output:
+---------+-----------+------------+
| name    | low_limit | high_limit |
+---------+-----------+------------+
| Small   |         0 |    4999.90 |
| Average |      5000 |    9999.99 |
| Large   |     10000 | 9999999.99 |
+---------+-----------+------------+
3 rows in set (0.02 sec)
*/

-- Now let's write a query that will count the groups
select groups.name, count(*) num_customers
from (
   select sum(a.avail_balance) cust_balance
   from account a 
      inner join product p on (a.product_cd = p.product_cd)
   where p.product_type_cd = 'ACCOUNT'
   group by a.cust_id
) cust_rollup
inner join (
   select 'Small' name, 0 low_limit, 4999.9 high_limit
   union all
   select 'Average' name, 5000 low_limit, 9999.99 high_limit
   union all
   select 'Large' name, 10000 low_limit, 9999999.99 high_limit
) groups on (cust_rollup.cust_balance between groups.low_limit 
   and groups.high_limit
)
group by groups.name;

/* Output:
+---------+---------------+
| name    | num_customers |
+---------+---------------+
| Average |             2 |
| Large   |             4 |
| Small   |             5 |
+---------+---------------+
3 rows in set (0.00 sec)
*/

-- Although you can build a permanent table to hold the group definitions, the
-- author suggested to think twice about it. Because very qickly you will find
-- your database littered with many special purpose table after a while
-- and you won't remember the reason for which most of them are created for.
-- This also created a problem with memory storage allocation issue, and also
-- table lost during server upgrade.

-- For example like above, it is better to create a temp subquery table. 










