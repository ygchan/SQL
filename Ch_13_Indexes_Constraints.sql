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

-- Here is how you add an index to a table
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

