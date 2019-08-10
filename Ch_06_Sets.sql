-- How to sign back onto the SQL server.
/*
export PATH=$PATH:/Applications/MySQLWorkbench.app/Contents/MacOS
mysql -u Study -p bank;
*/

-- SQL set operators
-- Both data sets must have the same number of columns
-- The data type must be the same

-- 01: Compound query, "adding them vertically."
-- combines multiple but otherwise independent queries.
select 1 num, 'george' name
union
select 5 num, 'vivian' name;

-- 02: Union and Union all
-- Union takes the two dataset, sort them and select the uniquely new rows 
-- from second dataset and append together as a new dataset.
-- Union all does not sort of account for duplicates that might be added.

-- Book's definition:
-- Union - sorts the combined set and removes duplicates, 
-- whereas union all does not.
-- Union all's final dataset set will always equal the sum of the number of rows
-- of the set being combined.

-- 03: Union all - does not sort or remove duplicates
select 'IND' type_cd, cust_id, lname name
from individual
    union all
select 'BUS' type_cd, cust_id, name
from business
    union all
    /* Prove to you that it does not remove duplicates */
select 'BUS' type_cd, cust_id, name
from business;

/* Output:
+---------+---------+------------------------+
| type_cd | cust_id | name                   |
+---------+---------+------------------------+
| IND     |       1 | Hadley                 |
| IND     |       2 | Tingley                |
| IND     |       3 | Tucker                 |
| IND     |       4 | Hayward                |
| IND     |       5 | Frasier                |
| IND     |       6 | Spencer                |
| IND     |       7 | Young                  |
| IND     |       8 | Blake                  |
| IND     |       9 | Farley                 |
| BUS     |      10 | Chilton Engineering    |
| BUS     |      11 | Northeast Cooling Inc. |
| BUS     |      12 | Superior Auto Body     |
| BUS     |      13 | AAA Insurance Inc.     |
| BUS     |      10 | Chilton Engineering    |
| BUS     |      11 | Northeast Cooling Inc. |
| BUS     |      12 | Superior Auto Body     |
| BUS     |      13 | AAA Insurance Inc.     |
+---------+---------+------------------------+
*/

 -- 04: Combine table and exclude duplicate rows
select emp_id
from employee
where assigned_branch_id = 2
    and (title = 'Teller' or title = 'Head Teller')
union
select distinct open_emp_id
from account
where open_branch_id = 2;





















-- To combine two data sets, you need to have something that is similiar to 
-- such a primary key and foreign key.