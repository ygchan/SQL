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
