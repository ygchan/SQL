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


















