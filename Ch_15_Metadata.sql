-- Metadata - data about the database's object
-- How to access the Metadata and how to use it to build flexible systems.

-- 01. What is Metadata?
-- Meta data is data about database's data. Such as table name, storage
-- information, engine, column's (name, datatype, default values).
-- primary key column, name of the primary key index, index type, sort order
-- foreign key, and associated table columns for foreign keys.

-- SQL Server includes a special schema called information schema
-- that provided automatically within each database.

-- 02. Information_Schema

-- Config and setup information
-- export PATH=$PATH:/usr/local/mysql/bin
-- mysql -u Study -p bank 'xyz'

select table_name, table_type
from information_schema.tables
/* This is the bank database schema */
where table_schema = 'bank'
order by table_name;

/* Output:
mysql> select table_name, table_type
    -> from information_schema.tables
    -> where table_schema = 'bank'
    -> order by table_name;
+------------------------+------------+
| table_name             | table_type |
+------------------------+------------+
| account                | BASE TABLE |
| branch                 | BASE TABLE |
| branch_avil_balance_vw | VIEW       |
| business               | BASE TABLE |
| business_customer_vw   | VIEW       |
| claims                 | BASE TABLE |
| customer               | BASE TABLE |
| customer_totals        | BASE TABLE |
| customer_totals_vw     | VIEW       |
| customer_vw            | VIEW       |
| department             | BASE TABLE |
| emloyee_vw             | VIEW       |
| employee               | BASE TABLE |
| employee_org_chart_vw  | VIEW       |
| employee_vw            | VIEW       |
| individual             | BASE TABLE |
| number_tbl             | BASE TABLE |
| officer                | BASE TABLE |
| product                | BASE TABLE |
| product_type           | BASE TABLE |
| some_transcation       | BASE TABLE |
| string_tbl             | BASE TABLE |
| t                      | BASE TABLE |
| transaction            | BASE TABLE |
| vw_customer            | VIEW       |
+------------------------+------------+
25 rows in set (0.02 sec)
*/

-- Let's say you only want to select table's only.
select table_name, table_type
from information_schema.tables
where table_schema = 'bank' and table_type = 'Base Table'
order by table_name;

-- If you are ONLY interested in view, and want to learn if they are updatable
select table_name, is_updatable
from information_schema.views
where table_schema = 'bank'
order by 1;

/* Output:
+------------------------+--------------+
| table_name             | is_updatable |
+------------------------+--------------+
| branch_avil_balance_vw | NO           |
| business_customer_vw   | YES          |
| customer_totals_vw     | NO           |
| customer_vw            | YES          |
| emloyee_vw             | YES          |
| employee_org_chart_vw  | NO           |
| employee_vw            | YES          |
| vw_customer            | YES          |
+------------------------+--------------+
8 rows in set (0.02 sec)
*/

-- If I want to exclude any views, simply add another condition to the where 
-- clause. 

select table_name, table_type
from information_schema.tables
where table_schema = 'bank' and table_type = 'BASE TABLE'
order by 1;

/* Output:
+------------------+------------+
| table_name       | table_type |
+------------------+------------+
| account          | BASE TABLE |
| branch           | BASE TABLE |
| business         | BASE TABLE |
| claims           | BASE TABLE |
| customer         | BASE TABLE |
| customer_totals  | BASE TABLE |
| department       | BASE TABLE |
| employee         | BASE TABLE |
| individual       | BASE TABLE |
| number_tbl       | BASE TABLE |
| officer          | BASE TABLE |
| product          | BASE TABLE |
| product_type     | BASE TABLE |
| some_transcation | BASE TABLE |
| string_tbl       | BASE TABLE |
| t                | BASE TABLE |
| transaction      | BASE TABLE |
+------------------+------------+
17 rows in set (0.01 sec)
*/

-- information about columns (in columns view)

select column_name, data_type, character_maximum_length char_max_len,
   numeric_precision num_prcsn, numeric_scale num_scale
from information_schema.columns
where table_schema = 'bank' and table_name = 'account'
order by ordinal_position;

-- information about indexes (in statistics view)

select index_name, non_unique, seq_in_index, column_name
from information_schema.statistics
where table_schema = 'bank' and table_name = 'account'
order by 1, 3;

/* Output:
+----------------+------------+--------------+----------------+
| index_name     | non_unique | seq_in_index | column_name    |
+----------------+------------+--------------+----------------+
| acc_bal_idx    |          1 |            1 | cust_id        |
| acc_bal_idx    |          1 |            2 | avail_balance  |
| cust_prod_idx  |          0 |            1 | cust_id        |
| cust_prod_idx  |          0 |            2 | product_cd     |
| fk_a_branch_id |          1 |            1 | open_branch_id |
| fk_a_emp_id    |          1 |            1 | open_emp_id    |
| fk_product_cd  |          1 |            1 | product_cd     |
| PRIMARY        |          0 |            1 | account_id     |
+----------------+------------+--------------+----------------+
8 rows in set (0.00 sec)
*/

























