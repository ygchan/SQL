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

-- Same query but implemented using searched case expression
case 
   when customer.cust_type_cd = 'I' then
   (select concat(i.fname, ' ', i.lname)
    from individual i
    where i.cust_id = customer.cust_id)
   when customer.cust_type_cd = 'B' then
   (select b.name
    from business b
    where b.cust_id = customer.cust_id)
   else 'Unknown Customer' Type
end

-- Case Expression Examples
-- Examples to illustrating the utility of conditional logic in SQL statement

-- 03. Result set transformations
-- Setup: Suppose you want a query that shows the number of accounts opened
-- in 2000 through 2005.

-- Counting the number of accounts opened by year of the open_date
select year(open_date) year, count(*) how_many
from account
where open_date > '1999-12-31'
  and open_date < '2006-01-01'
group by year(open_date);

/* Output:
+------+----------+
| year | how_many |
+------+----------+
| 2000 |        3 |
| 2001 |        4 |
| 2002 |        5 |
| 2003 |        3 |
| 2004 |        9 |
+------+----------+
5 rows in set (0.03 sec)
*/

-- Actual question: Want a query to return a single row of data with six 
-- columns (one for each year in the data range). To transform this result
-- set into a single row.

select 
  /* If the open_date's year = 2000, then give value of 1, an sum all the
     values as you loop through the data */
  sum(case
        when extract(year from open_date) = 2000 then 1
        else 0
      end) year_2000,
  sum(case
        when extract(year from open_date) = 2001 then 1
        else 0
      end) year_2001,
  sum(case
        when extract(year from open_date) = 2002 then 1
        else 0
      end) year_2002,
  sum(case
        when extract(year from open_date) = 2003 then 1
        else 0
      end) year_2003,
  sum(case
        when extract(year from open_date) = 2004 then 1
        else 0
      end) year_2004,
  sum(case
        when extract(year from open_date) = 2005 then 1
        else 0
      end) year_2005
from account;
where open_date between '2000-01-01' and '2005-12-31';

-- This is a new SQL query pattern I haven't seen before. Imagine the following
-- this query read rows one at a time, depending on the account's open_date,
-- it sets the flag 0 or 1 for such year.

-- How about try to write it in two smaller query that is easier to understand?

-- 03A. First write case statement for each year.
-- This will not sum the account, but rather filter and do 1 or 0 determination
select
  /* True is 1, False is 0 */
  case
    when year(open_date) = 2000 then 1
    else 0
  end year_2000,
  case
    when year(open_date) = 2001 then 1
    else 0
  end year_2001,
  case
    when year(open_date) = 2002 then 1
    else 0
  end year_2002,
  case
    when year(open_date) = 2003 then 1
    else 0
  end year_2003,
  case
    when year(open_date) = 2004 then 1
    else 0
  end year_2004,
  case
    when year(open_date) = 2005 then 1
    else 0
  end year_2004
from account
/* SQL between is inclusive */
where open_date between '2000-01-01' and '2005-12-31';

/* Output:
+-----------+-----------+-----------+-----------+-----------+-----------+
| year_2000 | year_2001 | year_2002 | year_2003 | year_2004 | year_2004 |
+-----------+-----------+-----------+-----------+-----------+-----------+
|         1 |         0 |         0 |         0 |         0 |         0 |
|         1 |         0 |         0 |         0 |         0 |         0 |
|         0 |         0 |         0 |         0 |         1 |         0 |
|         0 |         1 |         0 |         0 |         0 |         0 |
|         0 |         1 |         0 |         0 |         0 |         0 |
|         0 |         0 |         1 |         0 |         0 |         0 |
|         0 |         0 |         1 |         0 |         0 |         0 |
|         0 |         0 |         0 |         1 |         0 |         0 |
|         1 |         0 |         0 |         0 |         0 |         0 |
|         0 |         0 |         0 |         0 |         1 |         0 |
|         0 |         0 |         0 |         0 |         1 |         0 |
|         0 |         0 |         1 |         0 |         0 |         0 |
|         0 |         0 |         0 |         0 |         1 |         0 |
|         0 |         0 |         0 |         0 |         1 |         0 |
|         0 |         1 |         0 |         0 |         0 |         0 |
|         0 |         1 |         0 |         0 |         0 |         0 |
|         0 |         0 |         0 |         1 |         0 |         0 |
|         0 |         0 |         0 |         0 |         1 |         0 |
|         0 |         0 |         0 |         0 |         1 |         0 |
|         0 |         0 |         1 |         0 |         0 |         0 |
|         0 |         0 |         1 |         0 |         0 |         0 |
|         0 |         0 |         0 |         0 |         1 |         0 |
|         0 |         0 |         0 |         1 |         0 |         0 |
|         0 |         0 |         0 |         0 |         1 |         0 |
+-----------+-----------+-----------+-----------+-----------+-----------+
24 rows in set (0.00 sec)
*/

-- with this grid presented, just sum the columns.
select
  /* True is 1, False is 0 */
  sum(case
    when year(open_date) = 2000 then 1
    else 0
  end) year_2000,
  sum(case
    when year(open_date) = 2001 then 1
    else 0
  end) year_2001,
  sum(case
    when year(open_date) = 2002 then 1
    else 0
  end) year_2002,
  sum(case
    when year(open_date) = 2003 then 1
    else 0
  end) year_2003,
  sum(case
    when year(open_date) = 2004 then 1
    else 0
  end) year_2004,
  sum(case
    when year(open_date) = 2005 then 1
    else 0
  end) year_2004
from account
/* SQL between is inclusive */
where open_date between '2000-01-01' and '2005-12-31';

/* Output:
+-----------+-----------+-----------+-----------+-----------+-----------+
| year_2000 | year_2001 | year_2002 | year_2003 | year_2004 | year_2004 |
+-----------+-----------+-----------+-----------+-----------+-----------+
|         3 |         4 |         5 |         3 |         9 |         0 |
+-----------+-----------+-----------+-----------+-----------+-----------+
1 row in set (0.00 sec)
*/

-- 04. Selective Aggregation
select concat('Alert! : Account #', a.account_id,
  ' has incorrect balance')
from account a
where (a.avail_balance, a.pending_balance) <>
  (select sum(...), sum(...) from transcation t
   where t.account_id = a.account_id);

-- Keep in mind the following
-- debit (flip the side to negative), credit (positive)
-- If the date in the funds_avail_date column is > current day
-- the transcation should be added to the pending balance total
-- but not to the available balance total.

-- Check if the transcation type is DBT, flip the sign by * -1
case 
  when transcation.txt_typ_cd = 'DBT'
    then transcation.amount * -1
  else transcation.amount
end

-- Adding the logic that only transcation fund available date ready
case
  when transaction.txt_type_cd = 'DBT'
    then transaction.amount * -1
  else transaction.amount
end

-- Unavailable funds, such as checks that have not cleared, will contribute
-- $0 to the sum. Here is the final query with two case expressions in place.

select concat('ALERT! : Account #', a.account_id,
  ' Has Incorrect Balance!')
from account a
where (a.avail_balance, a.pending_balance) <>
 (select
    sum(case
          when t.funds_avail_date > current_timestamp()
            then 0
          when t.txn_type_cd = 'DBT'
            then t.amount * -1
          else t.amount
        end),
    sum(case
          when t.txn_type_cd = 'DBT'
            then t.amount * -1
          else t.amount
        end)
    from transaction t
    where t.account_id = a.account_id);

-- Checking on existence
select c.cust_id, c.fed_id, c.cust_type_cd,
  case
    when exists(select 1 from account a
      where a.cust_id = c.cust_id
        and a.product_cd = 'CHK') then 'Y'
      else 'N'
  end has_checking,
  case
    when exists(select 1 from account a
      where a.cust_id = c.cust_id
        and a.product_cd = 'SAV') then 'Y'
    else 'N'
  end has_saving
from customer c;

/* Output:
+---------+-------------+--------------+--------------+------------+
| cust_id | fed_id      | cust_type_cd | has_checking | has_saving |
+---------+-------------+--------------+--------------+------------+
|       1 | 111-11-1111 | I            | Y            | Y          |
|       2 | 222-22-2222 | I            | Y            | Y          |
|       3 | 333-33-3333 | I            | Y            | N          |
|       4 | 444-44-4444 | I            | Y            | Y          |
|       5 | 555-55-5555 | I            | Y            | N          |
|       6 | 666-66-6666 | I            | Y            | N          |
|       7 | 777-77-7777 | I            | N            | N          |
|       8 | 888-88-8888 | I            | Y            | Y          |
|       9 | 999-99-9999 | I            | Y            | N          |
|      10 | 04-1111111  | B            | Y            | N          |
|      11 | 04-2222222  | B            | N            | N          |
|      12 | 04-3333333  | B            | Y            | N          |
|      13 | 04-4444444  | B            | N            | N          |
+---------+-------------+--------------+--------------+------------+
13 rows in set (0.01 sec)
*/

/* Output:
+--------------------+----------------------------------+------+-----+---------+----------------+
| Field              | Type                             | Null | Key | Default | Extra          |
+--------------------+----------------------------------+------+-----+---------+----------------+
| account_id         | int(10) unsigned                 | NO   | PRI | NULL    | auto_increment |
| product_cd         | varchar(10)                      | NO   | MUL | NULL    |                |
| cust_id            | int(10) unsigned                 | NO   | MUL | NULL    |                |
| open_date          | date                             | NO   |     | NULL    |                |
| close_date         | date                             | YES  |     | NULL    |                |
| last_activity_date | date                             | YES  |     | NULL    |                |
| status             | enum('ACTIVE','CLOSED','FROZEN') | YES  |     | NULL    |                |
| open_branch_id     | smallint(5) unsigned             | YES  | MUL | NULL    |                |
| open_emp_id        | smallint(5) unsigned             | YES  | MUL | NULL    |                |
| avail_balance      | float(10,2)                      | YES  |     | NULL    |                |
| pending_balance    | float(10,2)                      | YES  |     | NULL    |                |
+--------------------+----------------------------------+------+-----+---------+----------------+
*/

-- Practice once more
-- The case statement is a correlated subquery, as it is looping each record 
-- in customer c, it is attempting to join account by customer id.
-- If found found, return 1 (True), else the (else) condition is match, thus 'N'
select c.cust_id, c.fed_id, c.cust_type_cd,
  case
    when exists (
        select 1 from account a
        where a.cust_id = c.cust_id
          and a.product_cd = 'SAV'
    ) then 'Y'
    else 'N'
  end has_checking,
  case
    when exists (
      select 1 from account a
      where a.cust_id = c.cust_id
        and a.product_cd = 'CHK'
    ) then 'Y'
    else 'N'
  end has_saving
from customer c;















