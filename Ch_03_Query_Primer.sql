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

/* Switching to space instead of tab */

-- 07: View, a virtual table. It is created to hide columns from users 
-- and to simplify complex database designs.
create view employee_vw as 
   select emp_id, fname, lname,
      year(start_date) start_year
   from employee;

select emp_id, start_year
from employee_vw;

-- 08: Table links and table aliases (Join)
-- A few of the interesting things are learned here.
--    #1. Select the columns from the same table, write on the same line
--    #2. It is at work's practice I find cleaner to write each join @ new line
--    #3. I like the table aliases, a distintive table alisaes name clearly ref
--        I find e employee and d department really good.
--        I will start to apply c for claim, m for member, f for final table.
--        Really excited about this new idea!
select e.emp_id, e.fname, e.lname,
   d.name dept_name
from employee e 
   inner join department d on (e.dept_id = d.dept_id);

-- The where clause provide a way to filter out unwanted rows

-- 09: Where clause example
select emp_id, fname, lname, start_date, title
from employee
where title = 'Head Teller'
   and start_date > '2002-01-01'
order by lname, fname;

-- 10: If you mix operator, it is recommended to put () around them.
-- Good to learn new programming practices for work.
select emp_id, fname, lname, start_date, title
from employee
where (title = 'Head Teller' and start_date > '2000-01-01')
   or (title = 'Teller' and start_date > '2001-01-01'); 

