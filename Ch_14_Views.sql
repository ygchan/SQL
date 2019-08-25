-- Views provides a public interface and keep the implementation detail private.
-- When engineer make changes, the front end user will not experience/notice.

-- Views are useful because it keeps details and private information hidden.
-- This chapter will learn about

--    What views are?
--    How views are created?
--    When and how someone might use the view?

-- 01. What is view?
-- View is simply a mechanism for querying data. Unlike tables, views do not
-- involves data storage, view is really a query that acess data.

-- 02. Example of a view?
-- Think about SSN of the customers, the bank employee might need to verify
-- a member. But they only should see the last 4 digits.

create view vw_customer
(
   cust_id,
   fed_id,
   cust_type_cd,
   address,
   city,
   state,
   zipcode
)
as 
select cust_id,
   concat('ends in ', substr(fed_id, 8, 4)) fed_id,
   cust_type_cd,
   address,
   city,
   state,
   postal_code
from customer;

/* Output:
mysql> select * from vw_customer;
+---------+--------------+--------------+-----------------------+------------+-------+---------+
| cust_id | fed_id       | cust_type_cd | address               | city       | state | zipcode |
+---------+--------------+--------------+-----------------------+------------+-------+---------+
|       1 | ends in 1111 | I            | 47 Mockingbird Ln     | Lynnfield  | MA    | 01940   |
|       2 | ends in 2222 | I            | 372 Clearwater Blvd   | Woburn     | MA    | 01801   |
|       3 | ends in 3333 | I            | 18 Jessup Rd          | Quincy     | MA    | 02169   |
|       4 | ends in 4444 | I            | 12 Buchanan Ln        | Waltham    | MA    | 02451   |
|       5 | ends in 5555 | I            | 2341 Main St          | Salem      | NH    | 03079   |
|       6 | ends in 6666 | I            | 12 Blaylock Ln        | Waltham    | MA    | 02451   |
|       7 | ends in 7777 | I            | 29 Admiral Ln         | Wilmington | MA    | 01887   |
|       8 | ends in 8888 | I            | 472 Freedom Rd        | Salem      | NH    | 03079   |
|       9 | ends in 9999 | I            | 29 Maple St           | Newton     | MA    | 02458   |
|      10 | ends in 111  | B            | 7 Industrial Way      | Salem      | NH    | 03079   |
|      11 | ends in 222  | B            | 287A Corporate Ave    | Wilmington | MA    | 01887   |
|      12 | ends in 333  | B            | 789 Main St           | Salem      | NH    | 03079   |
|      13 | ends in 444  | B            | 4772 Presidential Way | Quincy     | MA    | 02169   |
+---------+--------------+--------------+-----------------------+------------+-------+---------+
13 rows in set (0.00 sec)
*/

-- Users can query the view as they would normal tables.
select cust_id, fed_id, cust_type_cd
from customer_vw;

/* Output:
+---------+--------------+--------------+
| cust_id | fed_id       | cust_type_cd |
+---------+--------------+--------------+
|       1 | ends in 1111 | I            |
|       2 | ends in 2222 | I            |
|       3 | ends in 3333 | I            |
|       4 | ends in 4444 | I            |
|       5 | ends in 5555 | I            |
|       6 | ends in 6666 | I            |
|       7 | ends in 7777 | I            |
|       8 | ends in 8888 | I            |
|       9 | ends in 9999 | I            |
|      10 | ends in 111  | B            |
|      11 | ends in 222  | B            |
|      12 | ends in 333  | B            |
|      13 | ends in 444  | B            |
+---------+--------------+--------------+
13 rows in set (0.01 sec)
*/

-- When a view is created, the query is not executed, the server simply stores
-- the views definition for future use.

select cust_type_cd, count(*)
from vw_customer
where state = 'MA'
group by cust_type_cd
order by 1;

-- 04: Why use views? Please provide 4 examples.
-- Data security, data aggregation, hiding complexity, joining partitioned data

-- 04.1: Data security: sometimes there are rows/columns that has sensitive 
-- information. Then you can use view to mask these column/rows.
-- Columns (exclude from select clause or substring the column to mask)
-- Rows    (exclude using where column = (condition))

-- Example of limiting what the user can access
create view business_customer_vw
(
   cust_id,
   fed_id,
   cust_type_cd,
   address,
   city,
   state,
   zipcode
)
as 
select cust_id,
   concat('ends in ', substr(fed_id, 8, 4)) fed_id,
   cust_type_cd,
   address,
   city,
   state,
   postal_code
from customer
where cust_type_cd = 'B';

/*
mysql> select * from business_customer_vw;
+---------+-------------+--------------+-----------------------+------------+-------+---------+
| cust_id | fed_id      | cust_type_cd | address               | city       | state | zipcode |
+---------+-------------+--------------+-----------------------+------------+-------+---------+
|      10 | ends in 111 | B            | 7 Industrial Way      | Salem      | NH    | 03079   |
|      11 | ends in 222 | B            | 287A Corporate Ave    | Wilmington | MA    | 01887   |
|      12 | ends in 333 | B            | 789 Main St           | Salem      | NH    | 03079   |
|      13 | ends in 444 | B            | 4772 Presidential Way | Quincy     | MA    | 02169   |
+---------+-------------+--------------+-----------------------+------------+-------+---------+
4 rows in set (0.00 sec)
*/

-- 04.2: Data Aggregation
create view customer_totals_vw
(
   cust_id,
   cust_type_cd,
   cust_name,
   num_accounts,
   tot_deposits
) 
as 
select cst.cust_id, cst.cust_type_cd,
   case
      when cst.cust_type_cd = 'B' Then
      (select bus.name from business bus where bus.cust_id = cst.cust_id)
      else 
      (select concat(ind.fname, ' ', ind.lname)
       from individual ind
       where ind.cust_id = cst.cust_id)
   end cust_name,
   sum(case when act.status = 'ACTIVE' then 1 else 0 end) tot_active_accounts,
   sum(case when act.status = 'ACTIVE' then act.avail_balance else 0 end) 
      tot_balance
from customer cst 
   inner join account act
group by cst.cust_id, cst.cust_type_cd;


-- This is a quick and easy way to "download the entire view"
-- But in production I think it might take a long time.
-- For example, in the XYZ table, it is over 14 GB to download.
-- Maybe make a view that is dropping more columns, or limiting a range.
create table customer_totals
as 
select * from customer_totals_vw;

-- I think a view is as good as a pre-stored query.

/* Output:
+---------+--------------+------------------------+--------------+--------------+
| cust_id | cust_type_cd | cust_name              | num_accounts | tot_deposits |
+---------+--------------+------------------------+--------------+--------------+
|       1 | I            | James Hadley           |           24 |    170754.46 |
|       2 | I            | Susan Tingley          |           24 |    170754.46 |
|       3 | I            | Frank Tucker           |           24 |    170754.46 |
|       4 | I            | John Hayward           |           24 |    170754.46 |
|       5 | I            | Charles Frasier        |           24 |    170754.46 |
|       6 | I            | John Spencer           |           24 |    170754.46 |
|       7 | I            | Margaret Young         |           24 |    170754.46 |
|       8 | I            | Louis Blake            |           24 |    170754.46 |
|       9 | I            | Richard Farley         |           24 |    170754.46 |
|      10 | B            | Chilton Engineering    |           24 |    170754.46 |
|      11 | B            | Northeast Cooling Inc. |           24 |    170754.46 |
|      12 | B            | Superior Auto Body     |           24 |    170754.46 |
|      13 | B            | AAA Insurance Inc.     |           24 |    170754.46 |
+---------+--------------+------------------------+--------------+--------------+
13 rows in set (0.01 sec)
*/

-- New: Create or replace syntax
create or replace view customer_totals_vw
(
   cust_id,
   cust_type_cd,
   cust_name,
   num_accounts,
   tot_deposits
)
as
select cust_id, cust_type_cd, cust_name, num_accounts, tot_deposits
from customer_totals;

-- If you provide the end user a view, then you can have greater flexibility
-- on how these data are aggregated, live (query) or pre-aggregated.

-- 04.3: Hiding complexity
-- If the report created each month is really complicated, it is easier to hand
-- the view to the end users, than to provide a complex way to join tables.

-- 04.4: Joining partitioned data
-- This is the classical example (3 years data) vs. (all historical data)

create view transcation_vw
(
   txn_date,
   account_id,
   txn_type_cd,
   amount,
   teller_emp_id,
   execution_branch_id,
   funds_avail_date
)
as
select txn_Date, account_id, txn_type_cd, amount, teller_emp_id,
   execution_branch_id, funds_avail_date
from transcation_historic
union all
select txn_Date, account_id, txn_type_cd, amount, teller_emp_id,
   execution_branch_id, funds_avail_date
from transcation_current;

-- 05. Updatable Views
-- MySQL, Oracle Database and SQL Server all allow you to modify data 
-- through a view, as long as you abide by certain restrictions.

-- In MySQL, the conditions are:
-- 1. No aggregate functions are used (max, min, avg, etc)
-- 2. The view does not employ group by or having clauses
-- 3. No subquery exist in the select or from clause, or any subqueries
--    in the where clause do not refer to tables in the from clause.
-- 4. The view does not utilize union, union all, or distinct.
-- 5. The from clause includes at least one table/updatable view.
-- 6. The from clause uses only inner join, if there is more than 1 table/view.

-- 06. Updating simple views.
-- George, do you still remember the very simple view, it had been from a few
-- days now.

-- Customer view hide the SSN number from internal team, 
-- only allow them to see the last 4 digits.
create view customer_vw
(
   cust_id,
   fed_id,
   cust_type_cd,
   address,
   city,
   state,
   zipcode
)
as 
select cust_id,
   concat('ends in ', substr(fed_id, 8, 4)) fed_id,
   cust_type_cd,
   address,
   city,
   state,
   postal_code
from customer;

/* Output:
+---------+--------------+--------------+-----------------------+------------+-------+---------+
| cust_id | fed_id       | cust_type_cd | address               | city       | state | zipcode |
+---------+--------------+--------------+-----------------------+------------+-------+---------+
|       1 | ends in 1111 | I            | 47 Mockingbird Ln     | Lynnfield  | MA    | 01940   |
|       2 | ends in 2222 | I            | 372 Clearwater Blvd   | Woburn     | MA    | 01801   |
|       3 | ends in 3333 | I            | 18 Jessup Rd          | Quincy     | MA    | 02169   |
|       4 | ends in 4444 | I            | 12 Buchanan Ln        | Waltham    | MA    | 02451   |
|       5 | ends in 5555 | I            | 2341 Main St          | Salem      | NH    | 03079   |
|       6 | ends in 6666 | I            | 12 Blaylock Ln        | Waltham    | MA    | 02451   |
|       7 | ends in 7777 | I            | 29 Admiral Ln         | Wilmington | MA    | 01887   |
|       8 | ends in 8888 | I            | 472 Freedom Rd        | Salem      | NH    | 03079   |
|       9 | ends in 9999 | I            | 29 Maple St           | Newton     | MA    | 02458   |
|      10 | ends in 111  | B            | 7 Industrial Way      | Salem      | NH    | 03079   |
|      11 | ends in 222  | B            | 287A Corporate Ave    | Wilmington | MA    | 01887   |
|      12 | ends in 333  | B            | 789 Main St           | Salem      | NH    | 03079   |
|      13 | ends in 444  | B            | 4772 Presidential Way | Quincy     | MA    | 02169   |
+---------+--------------+--------------+-----------------------+------------+-------+---------+
13 rows in set (0.02 sec)
*/

-- Analysis: the customer_vw view queries a single table, and only one
-- of the 7 columns is derived via an expression. 

-- Therefore, you can use it to modify data in the customer table.
update customer_vw
   set city = 'Woooburn'
   where city = 'Woburn';

/* Output:
mysql> select * from customer_vw where cust_id = 2;
+---------+--------------+--------------+---------------------+----------+-------+---------+
| cust_id | fed_id       | cust_type_cd | address             | city     | state | zipcode |
+---------+--------------+--------------+---------------------+----------+-------+---------+
|       2 | ends in 2222 | I            | 372 Clearwater Blvd | Woooburn | MA    | 01801   |
+---------+--------------+--------------+---------------------+----------+-------+---------+
1 row in set (0.01 sec)
*/

-- We can also check the underlying cusomter table just to be sure
select distinct city from customer;

/* Output:
+------------+
| city       |
+------------+
| Lynnfield  |
| Woooburn   |
| Quincy     |
| Waltham    |
| Salem      |
| Wilmington |
| Newton     |
+------------+
7 rows in set (0.01 sec)
*/

-- But you are not allowed to change fed_id column, because it is an 
-- derived column.
update customer_vw
   set city = 'Woburn', fed_id = '999999999'
   where city = 'Woooburn';

/* Output:
mysql> update customer_vw
    ->    set city = 'Woburn', fed_id = '999999999'
    ->    where city = 'Woooburn';
ERROR 1348 (HY000): Column 'fed_id' is not updatable
*/

-- You may not insert rows in view with derived columns too, sorry.
insert into customer_vw(cust_id, cust_type_cd, city)
   values (999, 'I', 'Worcester');

/* Output:
mysql> insert into customer_vw(cust_id, cust_type_cd, city)
    ->    values (999, 'I', 'Worcester');
ERROR 1471 (HY000): The target table customer_vw of the INSERT is not insertable-into
*/

-- A more complicated view example
create view business_customer_vw
(
   cust_id,
   address,
   city,
   state,
   postal_code,
   business_name,
   state_id,
   incorp_date
)
as 
select cst.cust_id,
   cst.fed_id,
   cst.city,
   cst.state,
   cst.postal_code,
   bsn.name,
   bsn.state_id,
   bsn.incorp_date
from customer cst 
   inner join business bsn on cst.cust_id = bsn.cust_id
where cust_type_cd = 'B';

-- This sort of update across multiple tables are ok
update business_customer_vw
   set postal_code = '9999'
   where cust_id = 10;

update business_customer_vw
   set incorp_date = '2008-11-17'
   where cust_id = 10;

-- But you are not allowed to update two table at once
update business_customer_vw
   set postal_code = '88888', 
      incorp_date = '2008-10-31'
   where cust_id = 10;

-- PL/SQL or Transact-SQL has additional features
-- known as stead of triggers, allow you to intercept insert, update
-- and delete statement against a view. For production (nontrivial application)
-- This will be really helpful.

-- Test your knownledge!!
-- 14.1 Create a view that queries the employee table and generates the
-- following output when queried with no where clause.
create view employee_org_chart_vw as 
   select concat(s.fname, ' ', s.lname) as supervisor_name,
      concat(e.fname, ' ', e.lname) as employee_name
   from employee e
      left join employee s on (e.superior_emp_id = s.emp_id)
   order by e.emp_id;

/* Output:
mysql> select * from employee_org_chart_vw;
+-----------------+------------------+
| supervisor_name | employee_name    |
+-----------------+------------------+
| NULL            | Michael Smith    |
| Michael Smith   | Susan Barker     |
| Michael Smith   | Robert Tyler     |
| Robert Tyler    | Susan Hawthorne  |
| Susan Hawthorne | John Gooding     |
| Susan Hawthorne | Helen Fleming    |
| Helen Fleming   | Chris Tucker     |
| Helen Fleming   | Sarah Parker     |
| Helen Fleming   | Jane Grossman    |
| Susan Hawthorne | Paula Roberts    |
| Paula Roberts   | Thomas Ziegler   |
| Paula Roberts   | Samantha Jameson |
| Susan Hawthorne | John Blake       |
| John Blake      | Cindy Mason      |
| John Blake      | Frank Portman    |
| Susan Hawthorne | Theresa Markham  |
| Theresa Markham | Beth Fowler      |
| Theresa Markham | Rick Tulman      |
+-----------------+------------------+
18 rows in set (0.01 sec)
*/

-- 14.2 The bank president would like to have a report showing the name 
-- and the city of each branch, along with the total balances of all accounts
-- opened at the branch. Create a view to generate the data.

-- To solve this problem, I issued the following commands
-- show tables;            << To see what are the resources
-- select * from branch;   << To see what data are there
-- select * from account;  << To see what data are there

create view branch_avil_balance_vw as 
   select b.name, b.city,
      a.sum_avil_balance
   from branch b
      inner join (
         select distinct open_branch_id, 
            sum(avail_balance) as sum_avil_balance
         from account
         group by open_branch_id
      ) a on (b.branch_id = a.open_branch_id);

-- This does not work.
-- View's select can't contain a subquery...
/* Output:
ERROR 1349 (HY000): View's SELECT contains a subquery in the FROM clause 
*/

-- This solution is much simplier and easy to understand.
create view branch_avil_balance_vw as 
   select b.name, b.city, sum(avail_balance)
   from branch b
      inner join account a on (b.branch_id = a.open_branch_id)
   group by b.name, b.city;

/* Output:
mysql> select * from branch_avil_balance_vw;
+---------------+---------+--------------------+
| name          | city    | sum(avail_balance) |
+---------------+---------+--------------------+
| Headquarters  | Waltham |           27882.57 |
| Quincy Branch | Quincy  |           53270.25 |
| So. NH Branch | Salem   |           68240.32 |
| Woburn Branch | Woburn  |           21361.32 |
+---------------+---------+--------------------+
4 rows in set (0.00 sec)
*/

-- 14.1 Answer. While George's solution works alright, the syntax and format
-- doesn't quite match what the model answers.
create view supervisor_vw
(
   supervisor_name,
   employee_name
) as
select concat(spr.fname, ' ', spr.lname),
   concat(emp.fname, ' ', emp.lname)
from employee emp
   left join employee spr on (emp.superior_emp_id = spr.emp_id);

-- This answer has the additional clarity that mine doesn't .
-- This can easily see what the the new columns are
-- without confusing with the logics.

select * from supervisor_vw;

-- 14.2 Answer.
create view branch_summary_vw
(
   branch_name,
   branch_city,
   total_balance
)
as 
select b.name, b.city, 
   sum(a.avail_balance)
from branch b inner join account a
   on b.branch_id = a.open_branch_id
group by b.name, b.city;