-- Broken data into separate pieces known as normalization.
-- In order to bring the data together for a report, you need to "join" them.
-- This chapter focus on inner join on multiple tables.

-- Cartesian product, a result of every permutation of the two tables
-- 18 employee x 3 departments = 54 permutations.
-- This is also known as a cross-join.

-- 01. Inner joins, one to one relationship, interaction of the two.
select e.fname, e.lname, d.name department_name
from employee e
	/* Note the use of on subclause */
	inner join department d on (e.dept_id = d.dept_id);

-- However, if you want to include the rows regardless of matches
-- then maybe you want to use outer join.
-- each department with, or without employee with return in result set
-- each employee with, or without department with return in result set

-- This is new to me: if the columns used are identical in both tables
-- in MySQL / SQL you can use the using subclause instead of the on.
select e.fname, e.lname, d.name department_name
from employee e
	/* But author does not recommend this, good to know only */
	inner join department d using (dept_id);

-- 02. ANSI join syntax (same query)
select e.fname, e.lname, d.name department_name
from employee e, department d
where e.dept_id = d.dept_id;

-- However, the SQL92 join syntax are more clear to separate join condition
-- and filter condition because the usage of on subclause and where clause.

-- 03. Complicated join
select a.account_id, a.cust_id, a.open_date, a.product_cd
from account a
	inner join employee e on (a.open_emp_id = e.emp_id)
	inner join branch b on (a.open_branch_id = b.branch_id)
where e.start_Date < '2010-01-01'
	and (e.title = 'Teller' or e.title = 'Head Teller')
	and b.name = 'Woburn Branch';

/* Output:
+------------+---------+------------+------------+
| account_id | cust_id | open_date  | product_cd |
+------------+---------+------------+------------+
|          1 |       1 | 2000-01-15 | CHK        |
|          2 |       1 | 2000-01-15 | SAV        |
|          3 |       1 | 2004-06-30 | CD         |
|          4 |       2 | 2001-03-12 | CHK        |
|          5 |       2 | 2001-03-12 | SAV        |
|         17 |       7 | 2004-01-12 | CD         |
|         27 |      11 | 2004-03-22 | BUS        |
+------------+---------+------------+------------+
7 rows in set (0.00 sec)
*/

-- Join order does not matter because SQL is nonprocedural language,
-- the database server determine what is the best execution plan.
-- It uses statistics from your database object to guess.
-- But you can provide hint or force the join order using 'STRAIGHT_JOIN'.

-- 04: Using subquery as table
select a.account_id, a.cust_id, a.open_date, a.product_cd
from account a
	inner join (
		select emp_id, assigned_branch_id
		from employee
		where start_date < '2010-01-01'
			and (title = 'Teller' or title = 'Head Teller')
	) e on (a.open_emp_id = e.emp_id)
	inner join (
		select branch_id from branch
		where name = 'Woburn Branch' 
	) b on (e.assigned_branch_id = b.branch_id);

/* Output:
+------------+---------+------------+------------+
| account_id | cust_id | open_date  | product_cd |
+------------+---------+------------+------------+
|          1 |       1 | 2000-01-15 | CHK        |
|          2 |       1 | 2000-01-15 | SAV        |
|          3 |       1 | 2004-06-30 | CD         |
|          4 |       2 | 2001-03-12 | CHK        |
|          5 |       2 | 2001-03-12 | SAV        |
|         17 |       7 | 2004-01-12 | CD         |
|         27 |      11 | 2004-03-22 | BUS        |
+------------+---------+------------+------------+
7 rows in set (0.01 sec)
*/

-- 05: Using the same table twice
-- This query finds the account, and branches it opens in,
-- find the employee who opens the account, and the branch they currently work
-- in. Note b_a (branch_account_open), b_e (branch_employee_working_in).
select a.account_id, e.emp_id,
	b_a.name open_branch, b_e.name emp_branch
from account a 
	inner join branch b_a on (a.open_branch_id = b_a.branch_id)
	inner join employee e on (a.open_emp_id = e.emp_id)
	inner join branch b_e on (e.assigned_branch_id = b_e.branch_id)
where a.product_cd = 'CHK';

/* Output:
+------------+--------+---------------+---------------+
| account_id | emp_id | open_branch   | emp_branch    |
+------------+--------+---------------+---------------+
|         10 |      1 | Headquarters  | Headquarters  |
|         14 |      1 | Headquarters  | Headquarters  |
|         21 |      1 | Headquarters  | Headquarters  |
|          1 |     10 | Woburn Branch | Woburn Branch |
|          4 |     10 | Woburn Branch | Woburn Branch |
|          7 |     13 | Quincy Branch | Quincy Branch |
|         13 |     16 | So. NH Branch | So. NH Branch |
|         18 |     16 | So. NH Branch | So. NH Branch |
|         24 |     16 | So. NH Branch | So. NH Branch |
|         28 |     16 | So. NH Branch | So. NH Branch |
+------------+--------+---------------+---------------+
10 rows in set (0.03 sec)
*/

-- 06: Self-Join with self referencing foreign key
-- The superior_emp_id is pointing to emp_id of the employee table
select e.fname, e.lname, 
	e_mgr.fname mgr_fname, e_mgr.lname mgr_lname
from employee e 
	inner join employee e_mgr on (e.superior_emp_id = e_mgr.emp_id);
































