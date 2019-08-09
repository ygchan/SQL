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































