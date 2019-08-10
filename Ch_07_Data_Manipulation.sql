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

-- 03: How to escape a singe quote?
update string_tbl
   set text_fld = 'This string did''t work, but it does now!';