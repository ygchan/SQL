-- Data Generation, Conversion and Manipulation

-- Working with String Data, you will be using one of the following data types
--    + char: Fixed length, blank-padded (allow up to 255)
--    + varchar: variable-length string, (allow up to 64KB)
--    + text: very large variable length strings

-- 01: How to use the various string data
create table string_tbl
(
   char_fld char(30),
   vchar_fld varchar(30),
   text_fld text
);

-- 02: How to populate character columns
insert into string_tbl (char_fld, vchar_fld, text_fld)
   values ('This is a fixed length char',
      'This is a variable length char',
      'This is a very long variable length text');

-- My machine set it to truncate and fit as much as it can.
update string_tbl
   set vchar_fld = 'This is an extremely long variable length message.';

/* Output:
mysql> update string_tbl
    ->    set vchar_fld = 'This is an extremely long variable length message.';
Query OK, 1 row affected, 1 warning (0.02 sec)
Rows matched: 1  Changed: 1  Warnings: 1

mysql> show warnings;
+---------+------+------------------------------------------------+
| Level   | Code | Message                                        |
+---------+------+------------------------------------------------+
| Warning | 1265 | Data truncated for column 'vchar_fld' at row 1 |
+---------+------+------------------------------------------------+
1 row in set (0.00 sec)
*/

-- The best practice is to set a high enough upper limit, and because the 
-- server only allocates enough space to store the string, it is not wasteful
-- to set a high upper limit. This is different from SAS and is great!

-- 03: How to escape a singe quote and retrieve it?
update string_tbl
   set text_fld = 'This string did''t work, but it does now!';

-- When pull data such as notes entered by users, you may want to use 
-- quote function to get all the non-system-generated characters.
select quote(text_fld)
from string_tbl;

/* Output:
+---------------------------------------------+
| quote(text_fld)                             |
+---------------------------------------------+
| 'This string did\'t work, but it does now!' |
+---------------------------------------------+
1 row in set (0.02 sec)
*/

-- String Manipulation
delete from string_tbl;

insert into string_tbl (char_fld, vchar_fld, text_fld)
   values ('This string is 28 characters',
      'This string is 28 characters',
      'This string is 28 characters');

-- 04: Most common function - Length of string
select length(char_fld) char_length,
   length(vchar_fld) varchar_length,
   length(text_fld) text_length
from string_tbl;

/* Output:
+-------------+----------------+-------------+
| char_length | varchar_length | text_length |
+-------------+----------------+-------------+
|          28 |             28 |          28 |
+-------------+----------------+-------------+
1 row in set (0.01 sec)
*/

-- 05: Finding the position of the substring
select position('characters' in vchar_fld),
   /* SQL is 1 based, unlike C++/Python 0 based
      If result is not found, it is 0 */
   position('not here' in vchar_fld)
from string_tbl;

/* Output:
+-------------------------------------+-----------------------------------+
| position('characters' in vchar_fld) | position('not here' in vchar_fld) |
+-------------------------------------+-----------------------------------+
|                                  19 |                                 0 |
+-------------------------------------+-----------------------------------+
1 row in set (0.00 sec)
*/

-- 06: Finding the position with optional starting position
select locate('is', vchar_fld, 5)
from string_tbl;

-- 07: MySQL's string comparison function strcmp()
--    returns -1 if first string comes before second string in sort order.
--    returns 0  if first string and second string are identical
--               strcmp() function are case insensitive.
--    returns 1  if first string comes after second string in sort order.


delete from string_tbl;
insert into string_tbl(vchar_fld) values ('abcd');
insert into string_tbl(vchar_fld) values ('xyz');
insert into string_tbl(vchar_fld) values ('QRSTUV');
insert into string_tbl(vchar_fld) values ('qrstuv');
insert into string_tbl(vchar_fld) values ('12345');

select vchar_fld
from string_tbl
order by vchar_fld;

/* Output:
+-----------+
| vchar_fld |
+-----------+
| 12345     |
| abcd      |
| QRSTUV    |
| qrstuv    |
| xyz       |
+-----------+
5 rows in set (0.00 sec)
*/

select strcmp('12345', '12345') 12345_12345, --  0 (identfical)
   strcmp('abcd', 'xyz') abcd_xyz,           -- -1 (abcd comes before xyz)
   strcmp('abcd', 'qrstuv') abcd_qrstuv,     -- -1 (abcd comes before qrstuv)
   strcmp('qrstuv', 'QRSTUV') qrstuv_QRSTUV, --  0 (case insensitive comparision)
   strcmp('12345', 'xyz') 12345_xyz,         -- -1 (numbers comes before characters)
   strcmp('xyz', 'qrstuv') xyz_qrstuv;       --  1 (xyz comes after qrstuv)

/* Output:
+-------------+----------+-------------+---------------+-----------+------------+
| 12345_12345 | abcd_xyz | abcd_qrstuv | qrstuv_QRSTUV | 12345_xyz | xyz_qrstuv |
+-------------+----------+-------------+---------------+-----------+------------+
|           0 |       -1 |          -1 |             0 |        -1 |          1 |
+-------------+----------+-------------+---------------+-----------+------------+
1 row in set (0.00 sec)
*/

-- 08: Like expression and regexp expression 
-- Other function that compare strings, build expressions that return 0 as false
-- and 1 as true.
select name, name like '%ns' ends_in_ns
from department;

/* Output:
+----------------+------------+
| name           | ends_in_ns |
+----------------+------------+
| Operations     |          1 |
| Loans          |          1 |
| Administration |          0 |
+----------------+------------+
3 rows in set (0.00 sec)
*/

select cust_id, cust_type_cd, fed_id,
   fed_id regexp '.{3}-.{2}-.{4}' is_ss_no_format
from customer;

-- 09: String functions that return strings
delete from string_tbl;

insert into string_tbl (text_fld)
   values ('This string was 29 characters');

