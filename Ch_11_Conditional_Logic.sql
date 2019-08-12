-- Write SQL statement to branch in one direction/another depending on the
-- values of certain columns or expressions.

-- 01: Simple case expression
select c.cust_id, c.fed_id,
   case
      when c.cust_type_cd = 'I'
         then concat(i.fname, ' ', i.lname)
      when c.cust_type_cd = 'B'
         then b.name
      else 'Unknown'
   end name
from customer c
   left join individual i on (c.cust_id = i.cust_id)
   left join business b on (c.cust_id = b.cust_id);

/* Output:
+---------+-------------+------------------------+
| cust_id | fed_id      | name                   |
+---------+-------------+------------------------+
|      10 | 04-1111111  | Chilton Engineering    |
|      11 | 04-2222222  | Northeast Cooling Inc. |
|      12 | 04-3333333  | Superior Auto Body     |
|      13 | 04-4444444  | AAA Insurance Inc.     |
|       1 | 111-11-1111 | James Hadley           |
|       2 | 222-22-2222 | Susan Tingley          |
|       3 | 333-33-3333 | Frank Tucker           |
|       4 | 444-44-4444 | John Hayward           |
|       5 | 555-55-5555 | Charles Frasier        |
|       6 | 666-66-6666 | John Spencer           |
|       7 | 777-77-7777 | Margaret Young         |
|       8 | 888-88-8888 | Louis Blake            |
|       9 | 999-99-9999 | Richard Farley         |
+---------+-------------+------------------------+
13 rows in set (0.00 sec)
*/

-- The case expressions
-- There is also the coalesce() function

-- 02. Searched case expressions
case
   when employee.title = 'Head Teller'
      then 'Head Teller'
   when employee.title = 'Teller' and year(employee.start_date) > 2007
      then 'Teller Trainee'
   when employee.title = 'Teller' and year(employee.start_date) < 2006
      then 'Experienced Teller'
   when employee.title = 'Teller'
      then 'Teller'
   else 'Non Teller'
end name_badge

-- Note the corresponding expression is returned and any remaining where
-- clause are ignored. If none of the when clause conditions evaluate to true.
-- Then the expression in the else clause is returned.

-- Author recommended using searched case expression for all but the simplest
-- logic. That allows you to have more options.

-- Simple case expression:
case customer.cust_type_cd
   when 'I' then
      (select concat(i.fname, ' ', i.lname)
       from individual i
       where i.cust_id = customer.cust_id)
   when 'B' then 
      (select b.name
       from business b
       where b.cust_id = customer.cust_id)
   else 'Unknown Customer Type'
end 