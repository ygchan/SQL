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

-- 11: Group by and having clauses. Having filter group, just like where 
-- filter records (rows) by column value (variables).
select d.name, count(e.emp_id) num_employees
from department d 
   inner join employee e on (d.dept_id = e.dept_id)
group by d.name /* Department name */
/* Noticed the usage of count(e.emp_id) */
having count(e.emp_id) > 2;

-- 12: Order by clause. Sort your result set using raw column or expression.
-- The result set has now been sorted by employeeID and then by account type.
select open_emp_id, product_cd /* Product code */
from account
order by open_emp_id, product_cd;

/* Output:
+-------------+------------+
| open_emp_id | product_cd |
+-------------+------------+
|           1 | CD         |
|           1 | CD         |
|           1 | CHK        |
|           1 | CHK        |
|           1 | CHK        |
|           1 | MM         |
|           1 | MM         |
|           1 | SAV        |
|          10 | BUS        |
|          10 | CD         |
|          10 | CD         |
|          10 | CHK        |
|          10 | CHK        |
|          10 | SAV        |
|          10 | SAV        |
|          13 | CHK        |
|          13 | MM         |
|          13 | SBL        |
|          16 | BUS        |
|          16 | CHK        |
|          16 | CHK        |
|          16 | CHK        |
|          16 | CHK        |
|          16 | SAV        |
+-------------+------------+
24 rows in set (0.00 sec)
*/

-- 13: Ascending vs. Descending sort order. (Asecending is default)
select account_id, product_cd, open_date, avail_balance
from account
order by avail_balance desc;

-- 14: Sorting via expression
select cust_id, cust_type_cd, city, state, fed_id
from customer
order by right(fed_id, 3);

/* Output:
+---------+--------------+------------+-------+-------------+
| cust_id | cust_type_cd | city       | state | fed_id      |
+---------+--------------+------------+-------+-------------+
|       1 | I            | Lynnfield  | MA    | 111-11-1111 |
|      10 | B            | Salem      | NH    | 04-1111111  |
|       2 | I            | Woburn     | MA    | 222-22-2222 |
|      11 | B            | Wilmington | MA    | 04-2222222  |
|       3 | I            | Quincy     | MA    | 333-33-3333 |
|      12 | B            | Salem      | NH    | 04-3333333  |
|      13 | B            | Quincy     | MA    | 04-4444444  |
|       4 | I            | Waltham    | MA    | 444-44-4444 |
|       5 | I            | Salem      | NH    | 555-55-5555 |
|       6 | I            | Waltham    | MA    | 666-66-6666 |
|       7 | I            | Wilmington | MA    | 777-77-7777 |
|       8 | I            | Salem      | NH    | 888-88-8888 |
|       9 | I            | Newton     | MA    | 999-99-9999 |
+---------+--------------+------------+-------+-------------+
13 rows in set (0.01 sec)
*/

-- 15: Sorting by numeric placeholders. It is okay to do this when you are
-- testing and ad-hoc one time use lookup. But it is a bad practice to use 
-- this for production, because the code can become unpredicatable.
select emp_id, title, start_date, fname, lname
from employee
order by 2, 5;

-- Test your knowledge!
-- 3.1 Get the employee id, first name, last name for all the bank employee
-- and sort by last name, then first name.
select emp_id, fname, lname
from employee 
order by lname, fname;

-- 3.2 Get the account id, customer id, available balance for all accounts
-- whose status = 'ACTIVE' and whose available balance > $2500.
select account_id, cust_id, avail_balance
from account 
where status = 'ACTIVE' 
   and avail_balance > 2500;

-- 3.3 Get the ID of the employees who opened the accounts
-- use the account.open_emp_id, include a single row for each distinct employee.
select distinct open_emp_id
from account
order by open_emp_id;

-- 3.4 Fill in the blanks
-- This question I used desc table, and select * from product to understand 
-- what is in each table and their column names.
select p.product_cd, 
   a.cust_id, a.avail_balance
from product p
   inner join account a on (p.product_cd = a.product_cd)
where p.product_type_cd = 'ACCOUNT' /* product name */
order by p.product_cd, a.cust_id;
