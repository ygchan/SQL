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

-- 07: Non_equi-join
select e.emp_id, e.fname, e.lname, e.start_date
from employee e
	inner join product p on (e.start_date >= p.date_offered and e.start_date <= p.date_retired)
where p.name = 'no-fee checking';

-- 08: Create an interesting chesse tournament matchup
-- They can't play against themselves, so hence != emp_id.
select e1.fname, e1.lname, 'VS' vs, e2.fname, e2.lname
from employee e1 
	/* Using the > operator, it reduced the reversed pair effect */
	inner join employee e2 on (e1.emp_id > e2.emp_id)
where e1.title = 'Teller'
	and e2.title = 'Teller';

-- Test your knowledge!!

-- 5.1 Fill in the blanks
select e.emp_id, e.fname, e.lname, b.name
from employee e
	inner join branch b on (e.assigned_Branch_id = b.branch_id);

/* Output:
+--------+----------+-----------+---------------+
| emp_id | fname    | lname     | name          |
+--------+----------+-----------+---------------+
|      1 | Michael  | Smith     | Headquarters  |
|      2 | Susan    | Barker    | Headquarters  |
|      3 | Robert   | Tyler     | Headquarters  |
|      4 | Susan    | Hawthorne | Headquarters  |
|      5 | John     | Gooding   | Headquarters  |
|      6 | Helen    | Fleming   | Headquarters  |
|      7 | Chris    | Tucker    | Headquarters  |
|      8 | Sarah    | Parker    | Headquarters  |
|      9 | Jane     | Grossman  | Headquarters  |
|     10 | Paula    | Roberts   | Woburn Branch |
|     11 | Thomas   | Ziegler   | Woburn Branch |
|     12 | Samantha | Jameson   | Woburn Branch |
|     13 | John     | Blake     | Quincy Branch |
|     14 | Cindy    | Mason     | Quincy Branch |
|     15 | Frank    | Portman   | Quincy Branch |
|     16 | Theresa  | Markham   | So. NH Branch |
|     17 | Beth     | Fowler    | So. NH Branch |
|     18 | Rick     | Tulman    | So. NH Branch |
+--------+----------+-----------+---------------+
18 rows in set (0.00 sec)
*/

-- 5.2 Write a query that returns the account ID for each nonbusiness
-- customer (customer.cust_type_cd = 'I') with customer's federal ID 
-- (customer.fed_id) and the name of the product which the account is based.
-- (product.name)
select a.account_id, c.cust_type_cd, c.fed_id, p.name
from customer c
	inner join account a on (c.cust_id = a.cust_id)
	inner join product p on (a.product_cd = p.product_cd)
where c.cust_type_cd = 'I'
order by a.account_id;

/* Output:
+------------+--------------+-------------+------------------------+
| account_id | cust_type_cd | fed_id      | name                   |
+------------+--------------+-------------+------------------------+
|          1 | I            | 111-11-1111 | checking account       |
|          2 | I            | 111-11-1111 | savings account        |
|          3 | I            | 111-11-1111 | certificate of deposit |
|          4 | I            | 222-22-2222 | checking account       |
|          5 | I            | 222-22-2222 | savings account        |
|          7 | I            | 333-33-3333 | checking account       |
|          8 | I            | 333-33-3333 | money market account   |
|         10 | I            | 444-44-4444 | checking account       |
|         11 | I            | 444-44-4444 | savings account        |
|         12 | I            | 444-44-4444 | money market account   |
|         13 | I            | 555-55-5555 | checking account       |
|         14 | I            | 666-66-6666 | checking account       |
|         15 | I            | 666-66-6666 | certificate of deposit |
|         17 | I            | 777-77-7777 | certificate of deposit |
|         18 | I            | 888-88-8888 | checking account       |
|         19 | I            | 888-88-8888 | savings account        |
|         21 | I            | 999-99-9999 | checking account       |
|         22 | I            | 999-99-9999 | money market account   |
|         23 | I            | 999-99-9999 | certificate of deposit |
+------------+--------------+-------------+------------------------+
*/

-- 5.3 Write a query to find all employee whose supervisor is assigned to a
-- different department. 
select e.emp_id, e.fname, e.lname, e.dept_id, 
	e.superior_emp_id, e.fname, e.lname, e_sup.dept_id
from employee e
	inner join employee e_sup on (e.superior_emp_id = e_sup.emp_id)
where e.dept_id != e_sup.dept_id;

























