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