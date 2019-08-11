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
-- 		max()		return the maximum value within a set
--		min()		return the minimum value within a set
--		avg()		return the average value across a set
--		sum()		return the sum of the values across a set
--		count()		return the number of values in a set

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









