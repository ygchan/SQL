-- Indexes and Constraints
-- This chapter focus on two other aspect of SQL, indexes and constraints

-- When a user insert a new row of data, the server simply writes the data two
-- the next avaliable free location of the table. When you run a query, the
-- server will scan the entire table.

-- This is okay if your table size is small, but once it passes a few million
-- rows, this will take a long time. (over multiple minutes)

-- What is the definition of full table scan?
-- The server is checking each row in the table and inspect its content.

-- An index is simply a mechanism for finding a specific item within a resource.
-- The role of indexes is to faciliate the retrieval of subset of a table's row
-- and columns without the need to inspect every row in the table.

-- 01. How you add an index to a table
alter table department
add index department_name_idx (name);

/* Output:
+---------+----------------------+------+-----+---------+----------------+
| Field   | Type                 | Null | Key | Default | Extra          |
+---------+----------------------+------+-----+---------+----------------+
| dept_id | smallint(5) unsigned | NO   | PRI | NULL    | auto_increment |
| name    | varchar(20)          | NO   | MUL | NULL    |                |
+---------+----------------------+------+-----+---------+----------------+
2 rows in set (0.02 sec)
*/

-- Note, just because an index is created, the SQL optimizer might decide it 
-- is faster to read the entire table.

-- 02. If you want to see the index, issue the following command
show index from department;

/* Output:
+------------+------------+---------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table      | Non_unique | Key_name            | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+------------+------------+---------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| department |          0 | PRIMARY             |            1 | dept_id     | A         |           2 |     NULL | NULL   |      | BTREE      |         |               |
| department |          1 | department_name_idx |            1 | name        | A         |           2 |     NULL | NULL   |      | BTREE      |         |               |
+------------+------------+---------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
2 rows in set (0.01 sec)
*/

-- The reason why you see there are 2 indexes, it is because the engineer who
-- created this table issued the following statement.
create table department
(dept_id smallint unsigned not null auto_increment,
 name varchar(20) not null
 constraint pk_department primary key (dept_id));

-- 03. If for some reason you want to drop the index
alter table department
drop index department_name_idx;

-- Unique Index prevent duplicate, it is worthy to know, if a given table has 
-- say clamno as unique index. Then you do not have to worry about dup.
-- Because it will not be allowed to insert duplicate records.

-- Maybe this is another understanding to not use distinct / union all.
-- (In some cases of course)

-- 04. How to create a uniue index?
alter table department
add unique department_name_idx (name);

/* Output:
Query OK, 0 rows affected (0.03 sec)
Records: 0  Duplicates: 0  Warnings: 0Query OK, 0 rows affected (0.03 sec)
Records: 0  Duplicates: 0  Warnings: 0
*/

-- Note, please do not create unique indexes on your primary key column(s)
-- Because the server already checks for uniqueness for primary key value.
-- You may, however! Create more than one uniuqe index on the same
-- table if you feel that it is warranted.

-- 05. How to create multicolumn indexes?
-- You can still get a performance boost by using lname only on this 
-- multicolumn index, but you can't use it for fname lookup. It will
-- still perform a full table scan on you.
alter table employee
add index emp_names_idx (lname, fname);

-- 06. What are the types of indexes in SQL?
-- B-tree, Bitmap and Text indexes.

-- B-tree indexes are organized as trees, with one or more level of branch
-- nodes leading to a single level of leaf nodes. Branch nodes are used
-- for navigating the tree, while leaf nodes hold the actual values and
-- location information.

-- 07. What about Bitmap? Tell me about them.
-- Bitmap indexes
-- B-tree indexes are great a handling columns that has many different values
-- such as a customer's first/last name. But they can become unwiedly when
-- built on a column that allow for a small number of values.

-- Bitmap indexes generate a bitmap for each value stored in the column

-- value/row 1 2 3 4 5
-- BUS       0 0 1 0 1
-- CD        1 0 0 0 0
-- CHK       0 1 0 1 0

-- Bitmap indexes are great for low-cardinality data. But if the number of
-- values stored in the column climbs too high in relations to the number
-- of rows. Then it will struggle to perform.

-- Question: is it a good idea to build bitmap index of your primary key?
-- Think about it like this.
-- value/row  1 2 3 4 5 6 7 8 .. 300T 
-- 001        0 1 0 0 0 0 0 0 
-- 002        1 0 0 0 0 0 0 0
-- 003        0 0 0 1 0 0 0 0
-- 004        ....

-- The answer is no, because the number of distinct value is n, and the number
-- of row is also n. This will be an n^2 matrix, very poor performance.

-- Oracle user would type this to create a bitmap index
create bitmap index acc_prod_idx on account(product_cd);

-- Bitmap indexes are commonly used in data warehouse environment, where
-- large amount of data are generally indexed on columns containing relatively
-- few values (think about sales quarter, geographic regions, products etc)

-- How is index actually used?
-- The sever quickly locates the row using the index, and then visit each row
-- and retreive the columns requested.

-- If the index contains everything needed to satisfy the query, then the query
-- doesn't need to visits the associated table.

select cust_id, sum(avail_balance) tot_bal
from account
where cust_id in (1, 5, 9, 11)
group by cust_id;

/*
+---------+----------+
| cust_id | tot_bal  |
+---------+----------+
|       1 |  4557.75 |
|       5 |  2237.97 |
|       9 | 10971.22 |
|      11 |  9345.55 |
+---------+----------+
4 rows in set (0.01 sec)
*/

-- 08. How to show the execution plan?
-- To see how MySQL query optimizer decides to execute the query,
-- I use the explain statement to ask the server to show the execution plan 
-- for the query rather than excuting the query.

explain select cust_id, sum(avail_balance) tot_bal
from account
where cust_id in (1, 5, 9, 11)
group by cust_id;

/*
+----+-------------+---------+-------+---------------+--------------+---------+------+------+-------------+
| id | select_type | table   | type  | possible_keys | key          | key_len | ref  | rows | Extra       |
+----+-------------+---------+-------+---------------+--------------+---------+------+------+-------------+
|  1 | SIMPLE      | account | index | fk_a_cust_id  | fk_a_cust_id | 4       | NULL |   24 | Using where |
+----+-------------+---------+-------+---------------+--------------+---------+------+------+-------------+
1 row in set (0.00 sec)
*/

-- Looking at this execution plan, the fk_a_cust_id index is used to find rows
-- the account table that satisfy the where clause.

-- After reading the index, the server is expects to read all 24 rows of the 
-- account table, because it doesn't know that there might be other customer 
-- besides 1, 5, 9, 11.

-- But I think there is a better way, how about we create a new index on both
-- the cust_id and avail_balance column?

alter table account
add index acc_bal_idx (cust_id, avail_balance);

-- Then run our query again

explain select cust_id, sum(avail_balance) tot_bal
from account
where cust_id in (1, 5, 9, 11)
group by cust_id \G

/*
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: account
         type: range
possible_keys: acc_bal_idx
          key: acc_bal_idx
      key_len: 4
          ref: NULL
         rows: 8
        Extra: Using where; Using index
1 row in set (0.00 sec)
*/

-- Three things to note:
-- One, the optimizer is using acc_bal_idx instead of fk_a_cust_id
-- Two, the optimizer anticipates needing only 8 rows instead of 24 rows
-- Three, the account table is not needed. (designated by using index in extra)

-- The server can use an index as though it were a table as long as the index
-- contains all the columns needed by the query.

-- 09. Downside of Indexes
-- Everytime a row is added or removed from a table, all indexes on that table
-- must be modified. The more index you have, more work server will need to do
-- to keep everything up to date.

-- Indexes also require disk space. A good practice is to add the index, run
-- a routine and then drop it. Or another way (for data team), drop the index
-- before loading data, and add them back afterward.

-- I am very interested what is the current method used?

-- Consider building additional indexes on a subset of primary key columns
-- or on all the primary key columns but in a different order than primary
-- key data.

-- 10. What are the 4 different type of constraints?
-- They are: Primary key constraints, foreign key constraints,
-- unique constraints and check constraints.

-- Pimary key constraints - identify the column that guarantee uniqueness
-- with in a table.

-- Foreign key constraints - restrict one / more columns to cotain only values
-- found in another table's pimary key columns, and may also restrict the 
-- allowable values in other tables if update cascade or delete cascade rules.

-- Unique constraints - restrict one / more columns to contain unique value
-- within a table (primary key) constraints are a special type of unqiue 
-- constraint.

-- Check constraints - Restrict the allowable values for a column. 

-- 11. What is an orphaned rows?
-- It is a record without a corresponding record in another table.
-- For example, an customer ID is changed in the customer table,
-- but the account ID's customer table was never updated.
-- The account table's row is now consider orphaned row.

-- Note, if you want to use the foreign key constraints with MySQL
-- server, then you must use the InnoDB storage engine.

-- 12. How to create a Constraint?
create table product
(
   product_cd varchar(10) not null,
   name varchar(50) not null,
   product_type_cd varchar(10) not null,
   date_offered date,
   date_retired date,
      constraint fk_product_type_cd foreign key (product_type_cd)
         references product_type (product_type_cd),
      constraint pk_product primary key (product_cd)
);

-- You can also add/remove them after via the alter table statement
alter table product
add constraint pk_product primary key (product_cd);

alter table product
add constraint fk_product foreign key (product_type_cd)
   references product_type (product_type_cd);

-- Author pointed out that it is unusual to drop a primary key constraint
-- but foreign on the other hand, it is common to see it dropped during
-- maintenance and then reestablished.

-- Look at this table:
/*
   Constraint Type    | MySQL 
   Pk constraints     | Generate unique index
   Fk constraints     | Generate index
   Unique constraints | Generate unique index
*/

-- 13. Cascading Constraints
-- The foreign key contraint doesn't allow you to change the child row,
-- if there is no corresponding value in the parent.

-- At the same time, the server's default behavior also does not allow
-- you to change the parent table by themselves. You may instruct the server
-- to propagate the change to all child rows for you.

-- 14. What is an cascading update?
-- cascading update is a variation of the foreign key contraints that
-- can be installed by removing the existing foreign key and adding a new one
-- that includes on the update cascade clause.

alter table product
drop foreign key fk_product_type_cd;

alter table product
add constraint fk_product_type_cd foreign key (product_type_cd)
   references product_type (product_type_cd)
   on update cascade;

-- You may not update the product_type table (parent)
update product_type
   set product_type_cd = 'XYZ'
   where product_type_cd = 'Loan';

/* Output:
mysql> update product_type
    ->    set product_type_cd = 'XYZ'
    ->    where product_type_cd = 'Loan';
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0
*/

