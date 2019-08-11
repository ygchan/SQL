-- Other ways in which you can join tables
-- including the outer join and the cross join.

-- Left outer join / Right outer join
-- They are the same, jus a difference of telling the server which table 
-- dictate the number of rows in the query.

-- 01. Left join
Select e.fname, e.lname, 
	e_mgr.fname mgr_fname, e_mgr.lname mgr_lname
from employee e 
	left join employee e_mgr on (e.superior_emp_id = e_mgr.emp_id);

/* Output:
+----------+-----------+-----------+-----------+
| fname    | lname     | mgr_fname | mgr_lname |
+----------+-----------+-----------+-----------+
| Michael  | Smith     | NULL      | NULL      |
| Susan    | Barker    | Michael   | Smith     |
| Robert   | Tyler     | Michael   | Smith     |
| Susan    | Hawthorne | Robert    | Tyler     |
| John     | Gooding   | Susan     | Hawthorne |
| Helen    | Fleming   | Susan     | Hawthorne |
| Chris    | Tucker    | Helen     | Fleming   |
| Sarah    | Parker    | Helen     | Fleming   |
| Jane     | Grossman  | Helen     | Fleming   |
| Paula    | Roberts   | Susan     | Hawthorne |
| Thomas   | Ziegler   | Paula     | Roberts   |
| Samantha | Jameson   | Paula     | Roberts   |
| John     | Blake     | Susan     | Hawthorne |
| Cindy    | Mason     | John      | Blake     |
| Frank    | Portman   | John      | Blake     |
| Theresa  | Markham   | Susan     | Hawthorne |
| Beth     | Fowler    | Theresa   | Markham   |
| Rick     | Tulman    | Theresa   | Markham   |
+----------+-----------+-----------+-----------+
18 rows in set (0.00 sec)
*/

-- 02. Cross join, usually used by accident when programmer forgot to add
-- a join condition. However, if you decided to use it, try to use it with
-- cross join keywords. (Cartesian product)
select pt.name, p.product_cd, p.name
from product p
   cross join product_type pt;

/* Output:
+-------------------------------+------------+-------------------------+
| name                          | product_cd | name                    |
+-------------------------------+------------+-------------------------+
| Customer Accounts             | AUT        | auto loan               |
| Insurance Offerings           | AUT        | auto loan               |
| Individual and Business Loans | AUT        | auto loan               |
| Customer Accounts             | BUS        | business line of credit |
| Insurance Offerings           | BUS        | business line of credit |
| Individual and Business Loans | BUS        | business line of credit |
| Customer Accounts             | CD         | certificate of deposit  |
| Insurance Offerings           | CD         | certificate of deposit  |
| Individual and Business Loans | CD         | certificate of deposit  |
| Customer Accounts             | CHK        | checking account        |
| Insurance Offerings           | CHK        | checking account        |
| Individual and Business Loans | CHK        | checking account        |
| Customer Accounts             | MM         | money market account    |
| Insurance Offerings           | MM         | money market account    |
| Individual and Business Loans | MM         | money market account    |
| Customer Accounts             | MRT        | home mortgage           |
| Insurance Offerings           | MRT        | home mortgage           |
| Individual and Business Loans | MRT        | home mortgage           |
| Customer Accounts             | SAV        | savings account         |
| Insurance Offerings           | SAV        | savings account         |
| Individual and Business Loans | SAV        | savings account         |
| Customer Accounts             | SBL        | small business loan     |
| Insurance Offerings           | SBL        | small business loan     |
| Individual and Business Loans | SBL        | small business loan     |
+-------------------------------+------------+-------------------------+
24 rows in set (0.02 sec)
*/

-- 04. Author's special example of cross join
-- Suppose you want to create a table with 1 year worth of dates

-- Really slow way.
select '2019-01-01'dt
union all
select '2019-01-02'dt
union all
/* ... */
select '2019-12-31'dt;

/* Output:
+------------+
| dt         |
+------------+
| 2019-01-01 |
| 2019-01-02 |
| 2019-12-31 |
+------------+
3 rows in set (0.00 sec)
*/

-- But not only this is tedious, you still have to figure out how to handle 
-- leap years.

-- How about this?
select date_add('2019-01-01', 
   interval(ones.num + tens.num + hundreds.num) day) dt
from (
   select 0 num union all
   select 1 num union all
   select 2 num union all
   select 3 num union all
   select 4 num union all
   select 5 num union all
   select 6 num union all
   select 7 num union all
   select 8 num union all
   select 9 num
) ones cross join (
   select 0 num union all
   select 10 num union all
   select 20 num union all
   select 30 num union all
   select 40 num union all
   select 50 num union all
   select 60 num union all
   select 70 num union all
   select 80 num union all
   select 90 num
) tens cross join (
   select 0 num union all
   select 100 num union all
   select 200 num union all
   select 300 num 
) hundreds
where date_add('2019-01-01', 
   interval(ones.num + tens.num + hundreds.num) day) < '2020-01-01'
order by dt;

/* Output:
+------------+
| dt         |
+------------+
| 2019-01-01 |
| 2019-01-02 |
| 2019-01-03 |
| 2019-01-04 |
| 2019-01-05 |
| 2019-01-06 |
| 2019-01-07 |
| 2019-01-08 |
| 2019-01-09 |
| 2019-01-10 |
| 2019-01-11 |
| 2019-01-12 |
| 2019-01-13 |
| 2019-01-14 |
| 2019-01-15 |
| 2019-01-16 |
| 2019-01-17 |
| 2019-01-18 |
| 2019-01-19 |
| 2019-01-20 |
| 2019-01-21 |
| 2019-01-22 |
| 2019-01-23 |
| 2019-01-24 |
| 2019-01-25 |
| 2019-01-26 |
| 2019-01-27 |
| 2019-01-28 |
| 2019-01-29 |
| 2019-01-30 |
| 2019-01-31 |
| 2019-02-01 |
| 2019-02-02 |
| 2019-02-03 |
| 2019-02-04 |
| 2019-02-05 |
| 2019-02-06 |
| 2019-02-07 |
| 2019-02-08 |
| 2019-02-09 |
| 2019-02-10 |
| 2019-02-11 |
| 2019-02-12 |
| 2019-02-13 |
| 2019-02-14 |
| 2019-02-15 |
| 2019-02-16 |
| 2019-02-17 |
| 2019-02-18 |
| 2019-02-19 |
| 2019-02-20 |
| 2019-02-21 |
| 2019-02-22 |
| 2019-02-23 |
| 2019-02-24 |
| 2019-02-25 |
| 2019-02-26 |
| 2019-02-27 |
| 2019-02-28 |
| 2019-03-01 |
| 2019-03-02 |
| 2019-03-03 |
| 2019-03-04 |
| 2019-03-05 |
| 2019-03-06 |
| 2019-03-07 |
| 2019-03-08 |
| 2019-03-09 |
| 2019-03-10 |
| 2019-03-11 |
| 2019-03-12 |
| 2019-03-13 |
| 2019-03-14 |
| 2019-03-15 |
| 2019-03-16 |
| 2019-03-17 |
| 2019-03-18 |
| 2019-03-19 |
| 2019-03-20 |
| 2019-03-21 |
| 2019-03-22 |
| 2019-03-23 |
| 2019-03-24 |
| 2019-03-25 |
| 2019-03-26 |
| 2019-03-27 |
| 2019-03-28 |
| 2019-03-29 |
| 2019-03-30 |
| 2019-03-31 |
| 2019-04-01 |
| 2019-04-02 |
| 2019-04-03 |
| 2019-04-04 |
| 2019-04-05 |
| 2019-04-06 |
| 2019-04-07 |
| 2019-04-08 |
| 2019-04-09 |
| 2019-04-10 |
| 2019-04-11 |
| 2019-04-12 |
| 2019-04-13 |
| 2019-04-14 |
| 2019-04-15 |
| 2019-04-16 |
| 2019-04-17 |
| 2019-04-18 |
| 2019-04-19 |
| 2019-04-20 |
| 2019-04-21 |
| 2019-04-22 |
| 2019-04-23 |
| 2019-04-24 |
| 2019-04-25 |
| 2019-04-26 |
| 2019-04-27 |
| 2019-04-28 |
| 2019-04-29 |
| 2019-04-30 |
| 2019-05-01 |
| 2019-05-02 |
| 2019-05-03 |
| 2019-05-04 |
| 2019-05-05 |
| 2019-05-06 |
| 2019-05-07 |
| 2019-05-08 |
| 2019-05-09 |
| 2019-05-10 |
| 2019-05-11 |
| 2019-05-12 |
| 2019-05-13 |
| 2019-05-14 |
| 2019-05-15 |
| 2019-05-16 |
| 2019-05-17 |
| 2019-05-18 |
| 2019-05-19 |
| 2019-05-20 |
| 2019-05-21 |
| 2019-05-22 |
| 2019-05-23 |
| 2019-05-24 |
| 2019-05-25 |
| 2019-05-26 |
| 2019-05-27 |
| 2019-05-28 |
| 2019-05-29 |
| 2019-05-30 |
| 2019-05-31 |
| 2019-06-01 |
| 2019-06-02 |
| 2019-06-03 |
| 2019-06-04 |
| 2019-06-05 |
| 2019-06-06 |
| 2019-06-07 |
| 2019-06-08 |
| 2019-06-09 |
| 2019-06-10 |
| 2019-06-11 |
| 2019-06-12 |
| 2019-06-13 |
| 2019-06-14 |
| 2019-06-15 |
| 2019-06-16 |
| 2019-06-17 |
| 2019-06-18 |
| 2019-06-19 |
| 2019-06-20 |
| 2019-06-21 |
| 2019-06-22 |
| 2019-06-23 |
| 2019-06-24 |
| 2019-06-25 |
| 2019-06-26 |
| 2019-06-27 |
| 2019-06-28 |
| 2019-06-29 |
| 2019-06-30 |
| 2019-07-01 |
| 2019-07-02 |
| 2019-07-03 |
| 2019-07-04 |
| 2019-07-05 |
| 2019-07-06 |
| 2019-07-07 |
| 2019-07-08 |
| 2019-07-09 |
| 2019-07-10 |
| 2019-07-11 |
| 2019-07-12 |
| 2019-07-13 |
| 2019-07-14 |
| 2019-07-15 |
| 2019-07-16 |
| 2019-07-17 |
| 2019-07-18 |
| 2019-07-19 |
| 2019-07-20 |
| 2019-07-21 |
| 2019-07-22 |
| 2019-07-23 |
| 2019-07-24 |
| 2019-07-25 |
| 2019-07-26 |
| 2019-07-27 |
| 2019-07-28 |
| 2019-07-29 |
| 2019-07-30 |
| 2019-07-31 |
| 2019-08-01 |
| 2019-08-02 |
| 2019-08-03 |
| 2019-08-04 |
| 2019-08-05 |
| 2019-08-06 |
| 2019-08-07 |
| 2019-08-08 |
| 2019-08-09 |
| 2019-08-10 |
| 2019-08-11 |
| 2019-08-12 |
| 2019-08-13 |
| 2019-08-14 |
| 2019-08-15 |
| 2019-08-16 |
| 2019-08-17 |
| 2019-08-18 |
| 2019-08-19 |
| 2019-08-20 |
| 2019-08-21 |
| 2019-08-22 |
| 2019-08-23 |
| 2019-08-24 |
| 2019-08-25 |
| 2019-08-26 |
| 2019-08-27 |
| 2019-08-28 |
| 2019-08-29 |
| 2019-08-30 |
| 2019-08-31 |
| 2019-09-01 |
| 2019-09-02 |
| 2019-09-03 |
| 2019-09-04 |
| 2019-09-05 |
| 2019-09-06 |
| 2019-09-07 |
| 2019-09-08 |
| 2019-09-09 |
| 2019-09-10 |
| 2019-09-11 |
| 2019-09-12 |
| 2019-09-13 |
| 2019-09-14 |
| 2019-09-15 |
| 2019-09-16 |
| 2019-09-17 |
| 2019-09-18 |
| 2019-09-19 |
| 2019-09-20 |
| 2019-09-21 |
| 2019-09-22 |
| 2019-09-23 |
| 2019-09-24 |
| 2019-09-25 |
| 2019-09-26 |
| 2019-09-27 |
| 2019-09-28 |
| 2019-09-29 |
| 2019-09-30 |
| 2019-10-01 |
| 2019-10-02 |
| 2019-10-03 |
| 2019-10-04 |
| 2019-10-05 |
| 2019-10-06 |
| 2019-10-07 |
| 2019-10-08 |
| 2019-10-09 |
| 2019-10-10 |
| 2019-10-11 |
| 2019-10-12 |
| 2019-10-13 |
| 2019-10-14 |
| 2019-10-15 |
| 2019-10-16 |
| 2019-10-17 |
| 2019-10-18 |
| 2019-10-19 |
| 2019-10-20 |
| 2019-10-21 |
| 2019-10-22 |
| 2019-10-23 |
| 2019-10-24 |
| 2019-10-25 |
| 2019-10-26 |
| 2019-10-27 |
| 2019-10-28 |
| 2019-10-29 |
| 2019-10-30 |
| 2019-10-31 |
| 2019-11-01 |
| 2019-11-02 |
| 2019-11-03 |
| 2019-11-04 |
| 2019-11-05 |
| 2019-11-06 |
| 2019-11-07 |
| 2019-11-08 |
| 2019-11-09 |
| 2019-11-10 |
| 2019-11-11 |
| 2019-11-12 |
| 2019-11-13 |
| 2019-11-14 |
| 2019-11-15 |
| 2019-11-16 |
| 2019-11-17 |
| 2019-11-18 |
| 2019-11-19 |
| 2019-11-20 |
| 2019-11-21 |
| 2019-11-22 |
| 2019-11-23 |
| 2019-11-24 |
| 2019-11-25 |
| 2019-11-26 |
| 2019-11-27 |
| 2019-11-28 |
| 2019-11-29 |
| 2019-11-30 |
| 2019-12-01 |
| 2019-12-02 |
| 2019-12-03 |
| 2019-12-04 |
| 2019-12-05 |
| 2019-12-06 |
| 2019-12-07 |
| 2019-12-08 |
| 2019-12-09 |
| 2019-12-10 |
| 2019-12-11 |
| 2019-12-12 |
| 2019-12-13 |
| 2019-12-14 |
| 2019-12-15 |
| 2019-12-16 |
| 2019-12-17 |
| 2019-12-18 |
| 2019-12-19 |
| 2019-12-20 |
| 2019-12-21 |
| 2019-12-22 |
| 2019-12-23 |
| 2019-12-24 |
| 2019-12-25 |
| 2019-12-26 |
| 2019-12-27 |
| 2019-12-28 |
| 2019-12-29 |
| 2019-12-30 |
| 2019-12-31 |
+------------+
*/

-- 05: Natural Join, let the server figure it out
-- Probably will (should) never use it. Skipped.

select a.account_id, a.cust_id, c.cust_type_cd, c.fed_id
from account a
   natural join customer c;

-- Even if it works / really simple, always use explicit join.

-- Test your knowledge!!

-- 10.1 Write a query that returns all the product name alog with the account
-- based on that product (use the product_cd column in the account table to
-- link to link to the that product.)
-- Include all products, even if no accounts have been opened for that product.
select p.name, a.account_id
from product p
   left join account a on (p.product_cd = a.product_cd);

/* Output:
+-------------------------+------------+
| name                    | account_id |
+-------------------------+------------+
| auto loan               |       NULL |
| business line of credit |         25 |
| business line of credit |         27 |
| certificate of deposit  |          3 |
| certificate of deposit  |         15 |
| certificate of deposit  |         17 |
| certificate of deposit  |         23 |
| checking account        |          1 |
| checking account        |          4 |
| checking account        |          7 |
| checking account        |         10 |
| checking account        |         13 |
| checking account        |         14 |
| checking account        |         18 |
| checking account        |         21 |
| checking account        |         24 |
| checking account        |         28 |
| money market account    |          8 |
| money market account    |         12 |
| money market account    |         22 |
| home mortgage           |       NULL |
| savings account         |          2 |
| savings account         |          5 |
| savings account         |         11 |
| savings account         |         19 |
| small business loan     |         29 |
+-------------------------+------------+
26 rows in set (0.00 sec)
*/

-- 10.2 Reformulate your query from 10-1 to use the other join.
-- Make sure the result is the same.
select p.name, a.account_id
from account a 
   right join product p on (a.product_cd = p.product_cd);

/* Output:
+-------------------------+------------+
| name                    | account_id |
+-------------------------+------------+
| auto loan               |       NULL |
| business line of credit |         25 |
| business line of credit |         27 |
| certificate of deposit  |          3 |
| certificate of deposit  |         15 |
| certificate of deposit  |         17 |
| certificate of deposit  |         23 |
| checking account        |          1 |
| checking account        |          4 |
| checking account        |          7 |
| checking account        |         10 |
| checking account        |         13 |
| checking account        |         14 |
| checking account        |         18 |
| checking account        |         21 |
| checking account        |         24 |
| checking account        |         28 |
| money market account    |          8 |
| money market account    |         12 |
| money market account    |         22 |
| home mortgage           |       NULL |
| savings account         |          2 |
| savings account         |          5 |
| savings account         |         11 |
| savings account         |         19 |
| small business loan     |         29 |
+-------------------------+------------+
26 rows in set (0.00 sec)
*/

-- 10.3 Outer join the account table to both the individual and business
-- tables via the account.cust_id column, such taht the result set contains
-- one row per account.
select a.account_id, a.product_cd, i.fname, i.lname, b.name
from account a
   left join individual i on (a.cust_id = i.cust_id)
   left join business b on (a.cust_id = b.cust_id);

/* Output:
+------------+------------+----------+---------+------------------------+
| account_id | product_cd | fname    | lname   | name                   |
+------------+------------+----------+---------+------------------------+
|         24 | CHK        | NULL     | NULL    | Chilton Engineering    |
|         25 | BUS        | NULL     | NULL    | Chilton Engineering    |
|         27 | BUS        | NULL     | NULL    | Northeast Cooling Inc. |
|         28 | CHK        | NULL     | NULL    | Superior Auto Body     |
|         29 | SBL        | NULL     | NULL    | AAA Insurance Inc.     |
|          1 | CHK        | James    | Hadley  | NULL                   |
|          2 | SAV        | James    | Hadley  | NULL                   |
|          3 | CD         | James    | Hadley  | NULL                   |
|          4 | CHK        | Susan    | Tingley | NULL                   |
|          5 | SAV        | Susan    | Tingley | NULL                   |
|          7 | CHK        | Frank    | Tucker  | NULL                   |
|          8 | MM         | Frank    | Tucker  | NULL                   |
|         10 | CHK        | John     | Hayward | NULL                   |
|         11 | SAV        | John     | Hayward | NULL                   |
|         12 | MM         | John     | Hayward | NULL                   |
|         13 | CHK        | Charles  | Frasier | NULL                   |
|         14 | CHK        | John     | Spencer | NULL                   |
|         15 | CD         | John     | Spencer | NULL                   |
|         17 | CD         | Margaret | Young   | NULL                   |
|         18 | CHK        | Louis    | Blake   | NULL                   |
|         19 | SAV        | Louis    | Blake   | NULL                   |
|         21 | CHK        | Richard  | Farley  | NULL                   |
|         22 | MM         | Richard  | Farley  | NULL                   |
|         23 | CD         | Richard  | Farley  | NULL                   |
+------------+------------+----------+---------+------------------------+
24 rows in set (0.01 sec)
*/

-- 10.4 Devise a query that will generate the set {1, 2, 3, ..., 99, 100}.
-- Hint: Use a cross join

-- Version 1
select sum
from (
   select (ones.num + tens.num) sum
   from (
      select 0 num union all
      select 1 num union all
      select 2 num union all
      select 3 num union all
      select 4 num union all
      select 5 num union all
      select 6 num union all
      select 7 num union all
      select 8 num union all
      select 9 num
   ) ones cross join (
      select 0 num union all
      select 10 num union all
      select 20 num union all
      select 30 num union all
      select 40 num union all
      select 50 num union all
      select 60 num union all
      select 70 num union all
      select 80 num union all
      select 90 num 
   ) tens
   where (ones.num + tens.num) > 0
) a
union all (
   select 100 sum 
);

-- Version 2
select (ones.num + tens.num + hundreds.num) sum
from (
   select 0 num union all
   select 1 num union all
   select 2 num union all
   select 3 num union all
   select 4 num union all
   select 5 num union all
   select 6 num union all
   select 7 num union all
   select 8 num union all
   select 9 num
) ones cross join (
   select 0 num union all
   select 10 num union all
   select 20 num union all
   select 30 num union all
   select 40 num union all
   select 50 num union all
   select 60 num union all
   select 70 num union all
   select 80 num union all
   select 90 num 
) tens cross join (
   select 0 num union all
   select 100 num
) hundreds 
where (ones.num + tens.num + hundreds.num) >= 1
   and (ones.num + tens.num + hundreds.num) <= 100
order by (ones.num + tens.num + hundreds.num);

-- The Book has a even smarter solution
-- Using the plus 1
select (ones.num + tens.num) + 1 sum
from (
   select 0 num union all
   select 1 num union all
   select 2 num union all
   select 3 num union all
   select 4 num union all
   select 5 num union all
   select 6 num union all
   select 7 num union all
   select 8 num union all
   select 9 num
) ones cross join (
   select 0 num union all
   select 10 num union all
   select 20 num union all
   select 30 num union all
   select 40 num union all
   select 50 num union all
   select 60 num union all
   select 70 num union all
   select 80 num union all
   select 90 num 
) tens;