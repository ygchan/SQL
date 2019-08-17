-- Views provides a public interface and keep the implementation detail private.
-- When engineer make changes, the front end user will not experience/notice.

-- Views are useful because it keeps details and private information hidden.
-- This chapter will learn about

--		What views are?
--		How views are created?
--		When and how someone might use the view?

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
