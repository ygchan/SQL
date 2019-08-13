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

-- The next example consider how many rows are encountered.
-- 05. Use a simple case expression to count the number of each customers
-- and returns either 'None', '1', '2', or 3+
select c.cust_id, c.fed_id, c.cust_id,
  case (select count(*) from account a
    where a.cust_id = c.cust_id)
    when 0 then 'Non'
    when 1 then '1'
    when 2 then '2'
    else '3+'
  end num_accounts
from customer c;

/* Output:
+---------+-------------+---------+--------------+
| cust_id | fed_id      | cust_id | num_accounts |
+---------+-------------+---------+--------------+
|       1 | 111-11-1111 |       1 | 3+           |
|       2 | 222-22-2222 |       2 | 2            |
|       3 | 333-33-3333 |       3 | 2            |
|       4 | 444-44-4444 |       4 | 3+           |
|       5 | 555-55-5555 |       5 | 1            |
|       6 | 666-66-6666 |       6 | 2            |
|       7 | 777-77-7777 |       7 | 1            |
|       8 | 888-88-8888 |       8 | 2            |
|       9 | 999-99-9999 |       9 | 3+           |
|      10 | 04-1111111  |      10 | 2            |
|      11 | 04-2222222  |      11 | 1            |
|      12 | 04-3333333  |      12 | 1            |
|      13 | 04-4444444  |      13 | 1            |
+---------+-------------+---------+--------------+
13 rows in set (0.01 sec)
*/

-- 06. You should always wrap your denominators in a conditional logics
-- This is to safe guard division by zero errors.

-- First let's build the subquery that calculate the avaiable total balance
select a.product_cd, sum(a.avail_balance) tot_balance
from account a
group by a.product_cd;

/* Output:
+------------+-------------+
| product_cd | tot_balance |
+------------+-------------+
| BUS        |     9345.55 |
| CD         |    19500.00 |
| CHK        |    73008.01 |
| MM         |    17045.14 |
| SAV        |     1855.76 |
| SBL        |    50000.00 |
+------------+-------------+
6 rows in set (0.01 sec)
*/

select a.cust_id, a.product_cd, 
  a.avail_balance / (
    case
      when prod_tots.tot_balance = 0 then 1
      else prod_tots.tot_balance
    end
  ) percent_of_total
from account a inner join
  (
    select a.product_cd, sum(a.avail_balance) tot_balance
    from account a
    group by a.product_cd
  ) prod_tots on (a.product_cd = prod_tots.product_cd);

/* Output:
+---------+------------+------------------+
| cust_id | product_cd | percent_of_total |
+---------+------------+------------------+
|      10 | BUS        |         0.000000 |
|      11 | BUS        |         1.000000 |
|       1 | CD         |         0.153846 |
|       6 | CD         |         0.512821 |
|       7 | CD         |         0.256410 |
|       9 | CD         |         0.076923 |
|       1 | CHK        |         0.014488 |
|       2 | CHK        |         0.030928 |
|       3 | CHK        |         0.014488 |
|       4 | CHK        |         0.007316 |
|       5 | CHK        |         0.030654 |
|       6 | CHK        |         0.001676 |
|       8 | CHK        |         0.047764 |
|       9 | CHK        |         0.001721 |
|      10 | CHK        |         0.322911 |
|      12 | CHK        |         0.528052 |
|       3 | MM         |         0.129802 |
|       4 | MM         |         0.321915 |
|       9 | MM         |         0.548282 |
|       1 | SAV        |         0.269431 |
|       2 | SAV        |         0.107773 |
|       4 | SAV        |         0.413723 |
|       8 | SAV        |         0.209073 |
|      13 | SBL        |         1.000000 |
+---------+------------+------------------+
24 rows in set (0.01 sec)
*/

update account
  set last_activity_date = current_timestamp(),
    -- If it is debit, flip the sign
    -- then multiple the transcation amount by sign (+1/-1) and add to
    -- the current pending amount.
    pending_balance = pending_balance + (
      select t.amount *
        case t.txn_type_cd when 'DBT' then -1 else 1 end
      from transcation t
      where t.txn_id = 999
    ), 
    -- If the fund is available in a future time, then it is count as 0
    -- else multiply the transcation amount by the sign (+1/-1) and add to
    -- the current available amount.
    avail_balance = avail_balance + (
      select
        case t.funds_avail_date > current_timestamp() then 0
        else (
          t.amount *
          case t.txn_type_cd when 'DBT' then -1 else 1 end
        )
        end
      from transcation t
      where t.txn_id = 999
    )
  -- Only update records that is associated with this id
  where account.account_id = (
    select t.account_id
    from transaction t
    where t.txn_id = 999
  );

-- 07. Handling Null Values
-- Say you want to display the word unknown instead of Null
select emp_id, fname, lname,
   case
      when title is null then 'Unknown'
      else title
   end title
from employee;

/* Output:
+--------+----------+-----------+--------------------+
| emp_id | fname    | lname     | title              |
+--------+----------+-----------+--------------------+
|      1 | Michael  | Smith     | President          |
|      2 | Susan    | Barker    | Vice President     |
|      3 | Robert   | Tyler     | Treasurer          |
|      4 | Susan    | Hawthorne | Operations Manager |
|      5 | John     | Gooding   | Loan Manager       |
|      6 | Helen    | Fleming   | Head Teller        |
|      7 | Chris    | Tucker    | Teller             |
|      8 | Sarah    | Parker    | Teller             |
|      9 | Jane     | Grossman  | Teller             |
|     10 | Paula    | Roberts   | Head Teller        |
|     11 | Thomas   | Ziegler   | Teller             |
|     12 | Samantha | Jameson   | Teller             |
|     13 | John     | Blake     | Head Teller        |
|     14 | Cindy    | Mason     | Teller             |
|     15 | Frank    | Portman   | Teller             |
|     16 | Theresa  | Markham   | Head Teller        |
|     17 | Beth     | Fowler    | Teller             |
|     18 | Rick     | Tulman    | Teller             |
+--------+----------+-----------+--------------------+
18 rows in set (0.00 sec)
*/

-- Becareful if you are calculating a value that might be null.
-- Best to check for null and convert to 0. Like this.

select some_calculation +
   case
      when avail_balance is null then 0
      else avail_balance
   end
   + rest of some_calculation
from some_table.

-- Test your knowledge!!

-- 11.1 Try to re-write this query using as few when clauses as possible
select e.emp_id, e.title,
   case 
   when (
      select 1
      from employee emp_title
      where e.emp_id = emp_title.emp_id and title in ('Presdient', 
         'Vice President', 'Treasurer', 'Load Officer')
   ) then 'Management'
   when (
      select 1
      from employee emp_title
      where e.emp_id = emp_title.emp_id and title in ('Operation Manager', 
         'Head Teller', 'Teller')
   ) then 'Operations'
   else 'Unknown'
   end 'Group'
from employee e
order by title;


/* Output:
+--------+------------+
| emp_id | Group      |
+--------+------------+
|      1 | Unknown    |
|      2 | Management |
|      3 | Management |
|      4 | Unknown    |
|      5 | Unknown    |
|      6 | Operations |
|     10 | Operations |
|     13 | Operations |
|     16 | Operations |
|      7 | Operations |
|      8 | Operations |
|      9 | Operations |
|     11 | Operations |
|     12 | Operations |
|     14 | Operations |
|     15 | Operations |
|     17 | Operations |
|     18 | Operations |
+--------+------------+
18 rows in set (0.01 sec)
*/

-- 11.2 Rewrite the following query so that the result set contains a single
-- row with four columns (one for each branch).

select open_branch_id, count(*)
from account
group by open_branch_id;

/* Output:
+----------------+----------+
| open_branch_id | count(*) |
+----------------+----------+
|              1 |        8 |
|              2 |        7 |
|              3 |        3 |
|              4 |        6 |
+----------------+----------+
4 rows in set (0.01 sec)
*/

-- Original attempt:
select distinct
   case 
   when open_branch_id = 1 then (
         select count(*)
         from account
         group by open_branch_id
         having open_branch_id = 1
   ) end branch_1, 
   case 
      when open_branch_id = 2 then (
         select count(*)
         from account
         group by open_branch_id
         having open_branch_id = 2
   ) end branch_2,
   case
   when open_branch_id = 3 then (
         select count(*)
         from account
         group by open_branch_id
         having open_branch_id = 3
   ) end branch_3,
   case
   when open_branch_id = 4 then (
         select count(*)
         from account
         group by open_branch_id
         having open_branch_id = 4
   ) end branch_4
from account;

/* Output:
+----------+----------+----------+----------+
| branch_1 | branch_2 | branch_3 | branch_4 |
+----------+----------+----------+----------+
|        8 |     NULL |     NULL |     NULL |
|     NULL |        7 |     NULL |     NULL |
|     NULL |     NULL |        3 |     NULL |
|     NULL |     NULL |     NULL |        6 |
+----------+----------+----------+----------+
4 rows in set (0.01 sec)
*/

-- Reading the notes:
select distinct
   sum(case 
      when open_branch_id = 1 then (
         select count(*)
         from account
         group by open_branch_id
         having open_branch_id = 1
      ) 
      else 0 end
   ) branch_1, 
   sum(case 
      when open_branch_id = 2 then (
         select count(*)
         from account
         group by open_branch_id
         having open_branch_id = 2
      ) 
      else 0 end
   ) branch_2,
   sum(case
      when open_branch_id = 3 then (
         select count(*)
         from account
         group by open_branch_id
         having open_branch_id = 3
      )  
      else 0 end
   ) branch_3,
   sum(case
      when open_branch_id = 4 then (
         select count(*)
         from account
         group by open_branch_id
         having open_branch_id = 4
      ) 
      else 0 end
   ) branch_4
from account;

/* Output:
+----------+----------+----------+----------+
| branch_1 | branch_2 | branch_3 | branch_4 |
+----------+----------+----------+----------+
|       64 |       49 |        9 |       36 |
+----------+----------+----------+----------+
1 row in set (0.01 sec)
*/

























