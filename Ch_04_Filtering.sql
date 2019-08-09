-- Chapter 4: Filtering
-- There are a few situations where your query does not have where clause
--    Purging all data
--    Modifying all rows after a new column is created
--    Retrieving all rows from a table

-- Where condition separated by 'AND' only return rows with every condition
-- evaluated to True. Whereas 'OR' as long as one match, it turns.

-- Not operator nagate the expression.
-- In SQL to compare Null, use is null, NOT equal null.
-- null doesn't equal to anything.

-- Building a condition
-- Expression:
--    a number
--    a column
--    a string literal, such as 'Teller'
--    a build in function, such as conat('Learning', ' ', 'SQL')
--    a subquery, from (select membno from members where product like 'MCD%')
--    a list of expression, such as ('Teller', 'Head Teller', 'Manager')

-- Operator:
--    comparison operators (=, !=, <, >, <>, like, in, between)
--    arithmetic operators (+, -, * and /)

-- 01: Equality Conditions, 'column = expression'
select pt.name product_type, p.name product
from product p
   inner join product_type pt on (p.product_type_cd = pt.product_type_cd)
/* The rows with column product type equals to string 'Customer Accounts' */
where pt.name = 'Customer Accounts';

/* Output:
+-------------------+------------------------+
| product_type      | product                |
+-------------------+------------------------+
| Customer Accounts | certificate of deposit |
| Customer Accounts | checking account       |
| Customer Accounts | money market account   |
| Customer Accounts | savings account        |
+-------------------+------------------------+
4 rows in set (0.01 sec)
*/

-- 02: Inequality Conditions, assert that 2 expressions are not equal
select pt.name product_type, p.name product
from product p
   inner join product_type pt on (p.product_type_cd = pt.product_type_cd)
where pt.name <> 'Customer Accounts';

-- 03: Data modification using equality Conditions
delete from account
where status = 'CLOSED' and year(close_date) = 1989;

-- 04: Range condition, using >, >= or <, <= or between operators
select emp_id, fname, lname, start_date
from employee
where start_date < '2007-01-01';

-- 05: Between operator, remember to put the lower limit of the range first
-- and then put the higher limit. Because in effect the server is generating
-- two conditions from your single condition using <= and >= operator
select emp_id, fname, lname, start_date
from employee
where start_date between '2000-01-01' and '2003-01-01';

select emp_id, fname, lname, start_date
from employee
where start_date >= '2001-01-01'
   and start_date <= '2003-01-01';

-- 06: Between date range, number range, and string range

select cust_id, fed_id
from Customer 
where cust_type_cd = 'I'
   and fed_id between '500-00-0000' and '999-99-9999';

/* Output:
+---------+-------------+
| cust_id | fed_id      |
+---------+-------------+
|       5 | 555-55-5555 |
|       6 | 666-66-6666 |
|       7 | 777-77-7777 |
|       8 | 888-88-8888 |
|       9 | 999-99-9999 |
+---------+-------------+
5 rows in set (0.00 sec)
*/

-- 07: Membership conditions, using the in operator
-- it is the same of a series of or conditions comparing strings.
select account_id, product_cd, cust_id, avail_balance
from account
where product_cd in ('CHK', 'SAV', 'CD', 'MM');

-- 08: Using subqueries
select account_id, product_cd, cust_id, avail_balance
from account
where product_cd in (select product_cd from product
   where product_type_cd = 'ACCOUNT');

-- 09: Using not in operator
select account_id, product_cd, cust_id, avail_balance
from account
where product_cd not in ('CHK', 'SAV', 'CD', 'MM');

-- 10: Partial string matches
select emp_id, fname, lname
from employee
where left(lname, 1) = 'T';

-- 11: Wild card to search for partial string matches
-- The _ matches exactly one character
-- The % matches any of of the character (or no character)
select lname
from employee
where lname like '_a%e%';

-- 12: Matching a SSN pattern, underscore represents exactly one character
select cust_id, fed_id
from customer
where fed_id like '___-__-____';

-- 13: Multiple search expressions (LIKE)
-- This query finds all employee whose last name beings with F or G.
select emp_id, fname, lname
from employee
where lname like 'F%' or lname like 'G%';

-- 14: Using regular expressions
-- This query finds all employee whose last name beings with F or G.
select emp_id, fname, lname
from employee
where lname regexp '^[FG]';

-- 15: Null values - not applicable, value not known yet, undefined
-- An expression can be null, but it can never equal null
-- Two nulls are never equal to each other
select emp_id, fname, lname, superior_emp_id
from employee
/* Remember to use is null operator to test if an expression is null */
where superior_emp_id is null;

-- 16: Trick question: identify all employees who are not managed by Helen 
-- whose employee is is 6. 
select emp_id, fname, lname, superior_emp_id
from employee
where superior_emp_id != 6
   /* You must account for the possibility that some rows might contain null */
   or superior_emp_id is null;

-- Good idea to find out which columns allow nulls so you can take appropriate
-- measures with your filter conditions.

create table some_transcation
(
   txn_id smallint unsigned ,
   txn_date date,
   account_id smallint unsigned ,
   txn_type_cd char(3),
   amount float(4, 2),
   constraint pk_txn_id primary key (txn_id)
);

alter table some_transcation 
   modify txn_id smallint unsigned auto_increment;

insert into some_transcation (txn_date, account_id, txn_type_cd, amount)
   values('2005-02-22', 101, 'CDT', 1000.00);
insert into some_transcation (txn_date, account_id, txn_type_cd, amount)
   values('2005-02-23', 102, 'CDT', 525.75);
insert into some_transcation (txn_date, account_id, txn_type_cd, amount)
   values('2005-02-24', 101, 'DBT', 100.00);
insert into some_transcation (txn_date, account_id, txn_type_cd, amount)
   values('2005-02-24', 103, 'CDT', 55);
insert into some_transcation (txn_date, account_id, txn_type_cd, amount)
   values('2005-02-25', 101, 'DBT', 50);
insert into some_transcation (txn_date, account_id, txn_type_cd, amount)
   values('2005-02-25', 103, 'DBT', 25);
insert into some_transcation (txn_date, account_id, txn_type_cd, amount)
   values('2005-02-25', 102, 'CDT', 125.37);
insert into some_transcation (txn_date, account_id, txn_type_cd, amount)
   values('2005-02-26', 103, 'DBT', 10);
insert into some_transcation (txn_date, account_id, txn_type_cd, amount)
   values('2005-02-27', 101, 'CDT', 75);

/* Output:
mysql> select *
    -> from some_transcation;
+--------+------------+------------+-------------+--------+
| txn_id | txn_date   | account_id | txn_type_cd | amount |
+--------+------------+------------+-------------+--------+
|      1 | 2005-02-22 |        101 | CDT         |  99.99 |
|      2 | 2005-02-23 |        102 | CDT         |  99.99 |
|      3 | 2005-02-24 |        101 | DBT         |  99.99 |
|      4 | 2005-02-24 |        103 | CDT         |  55.00 |
|      5 | 2005-02-25 |        101 | DBT         |  50.00 |
|      6 | 2005-02-25 |        103 | DBT         |  25.00 |
|      7 | 2005-02-25 |        102 | CDT         |  99.99 |
|      8 | 2005-02-26 |        103 | DBT         |  10.00 |
|      9 | 2005-02-27 |        101 | CDT         |  75.00 |
+--------+------------+------------+-------------+--------+
9 rows in set (0.00 sec)
*/

-- Test your knowledge!!
-- 4.1 









