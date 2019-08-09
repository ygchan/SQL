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

-- Equality Conditions, 'column = expression'
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