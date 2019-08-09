-- Keep track of your connection id, in case you need the DBA's help.
-- When your query passes the sytnax check, it is passed to the query optimizer
-- where its job to determine the most efficient way to execute your code.
-- They look at your tables from clause and see if any indexes are avaliable,
-- then they pick an execution plan.

-- 01: Empty set
select emp_id, fname, lname
	from employee
	where lname = 'NOT_REAL';

/* Output:
Empty set (0.00 sec)
*/

-- 02: Normal Select query
select fname, lname
	from employee;

-- Query Clauses
--    select,   determine which columns to include in the result set
--    from,     identify the tables to get the data, or join
--    where,    filter out unwanted data
--    group by, used to group rows together by common column values
--    having,   filter out unwanted group
--    order by, sort the rows of the final result set

-- Note select actually means different things
-- it specifies which of all possible columns to be icndlued in the result set.
-- That's why SAS are running so slow for people?

-- 03: Use a literal, expression and buildin function
select emp_id,
	'ACTIVE',
	emp_id * 2,
	upper(lname)
	from employee;

/* 
mysql> select version(), 
    -> user(),
    -> database();
+-----------+-----------------+------------+
| version() | user()          | database() |
+-----------+-----------------+------------+
| 5.6.26    | Study@localhost | bank       |
+-----------+-----------------+------------+
1 row in set (0.01 sec)
*/

-- 04: Column Aliases, you can rename the label by typing another name after it
-- or you can use 'AS' keywoord
select emp_id,
	'Active' status,
	emp_id * 2 empid_x_2,
	upper(lname) last_name_upper
	from employee;

-- 05: Select distinct records
-- But learn the understand your data, do not always use distinct just because.
select distinct cust_id
	from account;

-- The from clause
-- It defines the tables used by a query, along with the means of linking the
-- tables together.

-- Tables (Permanent, Temporary, Virtual Table)
-- Subquery-generated table, subquery is a query contained within another query
-- it is surrounded by parentheses and is visible by the outer query code.

-- 06: Subquery, this one didn't have where in the subquery
-- Usually the subquery uses where/groupby/having.
select e.emp_id, e.fname, e.lname
	from (select emp_id, fname, lname, start_date, title
			from employee) e