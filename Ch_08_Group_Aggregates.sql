-- Grouping and Aggregates

-- Users are dealing with the data in the database and usually consume them
-- after using SQL statement to "cook" or process them on the server.

-- For example: When users wants to know how many accounts are opened
select open_emp_id
from account;

-- This query will return a lot of account id, but difficult to know
-- how many there are.

/* Output:
+-------------+
| open_emp_id |
+-------------+
|           1 |
|           1 |
|           1 |
|           1 |
|           1 |
|           1 |
|           1 |
|           1 |
|          10 |
|          10 |
|          10 |
|          10 |
|          10 |
|          10 |
|          10 |
|          13 |
|          13 |
|          13 |
|          16 |
|          16 |
|          16 |
|          16 |
|          16 |
|          16 |
+-------------+
24 rows in set (0.03 sec)
*/

-- Group by allow you to see the account data by employee_ID
select open_emp_id
from account
group by open_emp_id;

-- 01: Counting distinct open_emp_id from accounts
select open_emp_id, count(*) as how_many
from account 
group by open_emp_id;

/* Output:
+-------------+----------+
| open_emp_id | how_many |
+-------------+----------+
|           1 |        8 |
|          10 |        7 |
|          13 |        3 |
|          16 |        6 |
+-------------+----------+
4 rows in set (0.01 sec)
*/

-- Remember you can't refer to the aggregate function such as count(*)
-- in your where clause, because groups has not been generated yet.

-- 02: If you want to filter groups, use having clause
select open_emp_id, count(*) how_many
from account
group by open_emp_id
having count(*) > 4;

/* Output:
+-------------+----------+
| open_emp_id | how_many |
+-------------+----------+
|           1 |        8 |
|          10 |        7 |
|          16 |        6 |
+-------------+----------+
3 rows in set (0.02 sec)
*/

-- 03: Aggregate functions
--       max()    return the maximum value within a set
--    min()    return the minimum value within a set
--    avg()    return the average value across a set
--    sum()    return the sum of the values across a set
--    count()     return the number of values in a set

-- A query that uses all the common aggregate functions to
-- analyze the available balances for all the checking account
select max(avail_balance) max_balance,
   min(avail_balance) min_balance,
   avg(avail_balance) avg_balance,
   sum(avail_balance) sum_balance
from account
where product_cd = 'CHK';

/* Output:
+-------------+-------------+-------------+-------------+
| max_balance | min_balance | avg_balance | sum_balance |
+-------------+-------------+-------------+-------------+
|    38552.05 |      122.37 | 7300.800985 |    73008.01 |
+-------------+-------------+-------------+-------------+
1 row in set (0.02 sec)
*/

-- Remember where comes before group by, you can't have that aggregate info
-- used in the where clause, have it in the group by.

-- 04: Group by column
select product_cd,
   max(avail_balance) max_balance,
   min(avail_balance) min_balance,
   avg(avail_balance) avg_balance,
   sum(avail_balance) sum_balance
from account
group by product_cd;

-- 05: Counting distinct values
select count(distinct open_emp_id)
from account;

/* Output:
+-----------------------------+
| count(distinct open_emp_id) |
+-----------------------------+
|                           4 |
+-----------------------------+
1 row in set (0.01 sec)
*/

-- 06: Using expressions as argument to aggregated function
-- Query to find the maximum uncleared account amount
select max(pending_balance - avail_balance) max_uncleared
from account;

/* Output:
+---------------+
| max_uncleared |
+---------------+
|        660.00 |
+---------------+
1 row in set (0.01 sec)
*/

-- 07. Example of how nulls are handled
create table number_tbl (
   val smallint
);

insert into number_tbl (val) values (1);
insert into number_tbl (val) values (5);
insert into number_tbl (val) values (3);

select count(*) num_rows,
   count(val) num_vals,
   sum(val) total,
   max(val) max_val,
   avg(val) avg_val
from number_tbl;

/* Output:
+----------+----------+-------+---------+---------+
| num_rows | num_vals | total | max_val | avg_val |
+----------+----------+-------+---------+---------+
|        3 |        3 |     9 |       5 |  3.0000 |
+----------+----------+-------+---------+---------+
1 row in set (0.01 sec)
*/

insert into number_tbl (val) values (null);

-- 08. count(*) count all rows, count(val) ignore null values.
select count(*) num_rows,
   count(val) num_vals,
   sum(val) total,
   max(val) max_val,
   avg(val) avg_val
from number_tbl;

/* Output:
+----------+----------+-------+---------+---------+
| num_rows | num_vals | total | max_val | avg_val |
+----------+----------+-------+---------+---------+
|        4 |        3 |     9 |       5 |  3.0000 |
+----------+----------+-------+---------+---------+
*/

-- 09. Single-Column Grouping
select product_cd, sum(avail_balance) prod_balance
from account
group by product_cd;

/* Output:
+------------+--------------+
| product_cd | prod_balance |
+------------+--------------+
| BUS        |      9345.55 |
| CD         |     19500.00 |
| CHK        |     73008.01 |
| MM         |     17045.14 |
| SAV        |      1855.76 |
| SBL        |     50000.00 |
+------------+--------------+
6 rows in set (0.00 sec)
*/

-- 10. Multicolumn Grouping
-- Groups can span more than one column, and what is the total for both product
-- and branches (total balance for all checking account opened?)
select product_cd, open_branch_id,
   sum(avail_balance) tot_balance
from account
group by product_cd, open_branch_id;

-- 11. Grouping via Expressions
-- build groups based on the values generated by expressions
select extract(year from start_date) year,
   count(*) how_many
from employee
group by extract(year from start_date);

/* Output:
+------+----------+
| year | how_many |
+------+----------+
| 2000 |        3 |
| 2001 |        2 |
| 2002 |        8 |
| 2003 |        3 |
| 2004 |        2 |
+------+----------+
*/

-- 12. Rollup, the total of each product/branch combination
select product_cd, open_branch_id,
   sum(avail_balance) tot_balance
from account
group by product_cd, open_branch_id with rollup;

/* Output:
+------------+----------------+-------------+
| product_cd | open_branch_id | tot_balance |
+------------+----------------+-------------+
| BUS        |              2 |     9345.55 |
| BUS        |              4 |        0.00 |
| BUS        |           NULL |     9345.55 |
| CD         |              1 |    11500.00 |
| CD         |              2 |     8000.00 |
| CD         |           NULL |    19500.00 |
| CHK        |              1 |      782.16 |
| CHK        |              2 |     3315.77 |
| CHK        |              3 |     1057.75 |
| CHK        |              4 |    67852.33 |
| CHK        |           NULL |    73008.01 |
| MM         |              1 |    14832.64 |
| MM         |              3 |     2212.50 |
| MM         |           NULL |    17045.14 |
| SAV        |              1 |      767.77 |
| SAV        |              2 |      700.00 |
| SAV        |              4 |      387.99 |
| SAV        |           NULL |     1855.76 |
| SBL        |              3 |    50000.00 |
| SBL        |           NULL |    50000.00 |
| NULL       |           NULL |   170754.46 |
+------------+----------------+-------------+
21 rows in set (0.00 sec)
*/

-- The null value is provided for the open_branch_id column, 
-- These are your product/branch total
-- For Grand Total, you will see null, null for both column.

-- If you want to rollup on a subset of the columns in the group by clause
-- group by a, rollup(b, c) <- This is for Oracle only.

-- 13: Group filter conditions
-- where filter columns, and having filter groups
select product_cd, sum(avail_balance) prod_balance
from account
where status = 'ACTIVE'
group by product_cd
having sum(avail_balance) >= 10000;

-- 14: Lastly, you may include aggregate function in the having clause
-- that do not appear in the select clause

-- Write a query to get the product code, and sum of balance
-- for accounts with active status and between 1000 and 100000 balance.
select product_cd, sum(avail_balance) prod_balance
from account
where status = 'ACTIVE'
group by product_cd
having min(avail_balance) >= 1000
   and max(avail_balance) <= 10000;

-- Test your knowledge!!

-- 8.1 Write a query that counts number of rows in the account table
select count(*) num_rows
from account;

/* Output:
+----------+
| num_rows |
+----------+
|       24 |
+----------+
1 row in set (0.01 sec)
*/

-- 8.2 Modify your query to count the number of accounts held by each
-- customer. Show the customer ID and number of accounts for each customer
select cust_id, count(account_id) num_of_accounts
from account
group by cust_id;

/* Output:
+---------+-----------------+
| cust_id | num_of_accounts |
+---------+-----------------+
|       1 |               3 |
|       2 |               2 |
|       3 |               2 |
|       4 |               3 |
|       5 |               1 |
|       6 |               2 |
|       7 |               1 |
|       8 |               2 |
|       9 |               3 |
|      10 |               2 |
|      11 |               1 |
|      12 |               1 |
|      13 |               1 |
+---------+-----------------+
*/

-- 8.3 Modify your query to include whose customers with at least 2 accounts
select cust_id, count(account_id) num_of_accounts
from account
group by cust_id
having count(account_id) >= 2;

/* Output:
+---------+-----------------+
| cust_id | num_of_accounts |
+---------+-----------------+
|       1 |               3 |
|       2 |               2 |
|       3 |               2 |
|       4 |               3 |
|       6 |               2 |
|       8 |               2 |
|       9 |               3 |
|      10 |               2 |
+---------+-----------------+
8 rows in set (0.00 sec)
*/

-- 8.4 Find the total available balance by product and branch
-- where there is more than one account per product and branch.
-- Order the results by total balance (highest to lowest)
select product_cd, open_branch_id, sum(avail_balance)
from account
group by product_cd, open_branch_id
having count(*) > 1
order by 3 desc;
