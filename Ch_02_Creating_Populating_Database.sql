-- How to sign-on with user account and select database
-- mysql -u Study -p bank

-- 01: How to get the current time
select now();

-- 02: How to get the current time (Oracle DB)
select now 
from dual;

-- The following examples will only uses character, date and numeric data types
-- Charcter data
--    char(20)    /* Fixed length */
--    Fixed length strings are right padded with spaces
--    varchar(20) /* Variable Length */
--    Variable length strings can go up to 64KB, 65,000 characters or sign-on

-- Numeric data
--    boolean, 0 to indicate false and 1 to indicate true
--    pimary key, system generated number from 1 and increment up to some value
--    whole number, 0, 1, 2, 3, etc
--    decimal number, up to 8 decimal points

-- float (32 bit) and double precision (64 bit) 

-- Temporal data such as date/time
-- Date      yyyy-mm-dd
-- Datetime  yyyy-mm-dd hh:mi:ss
-- Timestamp yyyy-mm-dd hh:mi:ss
-- Year      yyyy
-- Time      hhh:mi:ss

-- 03: Build SQL schema statement
create table person
(
	person_id smallint unsigned,
	fname varchar(20),
	lname varchar(20),
	-- gender char(1),
	-- enforce the check of gender
	gender enum('M', 'F'),
	birth_date date,
	street varchar(30),
	city varchar(20),
	state varchar(20),
	country varchar(20),
	postal_code varchar(20),
	constraint pk_person primary key (person_id)
);

-- 04: Checking your table actually there
desc person;

-- 05: Build another SQL schema statement
create table favorite_food
(
	person_id smallint unsigned,
	food varchar(20),
	constraint pk_favourite_food primary key (person_id, food),
	constraint fk_fav_food_person_id foreign key (person_id) 
		-- Shoud run on the same line in terminal!
		references person (person_id)
);

-- 06: Change the definition with alter table, and setting it to auto increment
alter table person modify person_id smallint unsigned auto_increment;

-- 07: Insert data
insert into 
	person (person_id, fname, lname, gender, birth_date)
	values (null, 'George', 'Chan', 'M', '1972-05-27');

-- 08: Look at the data
select person_id, fname, lname, birth_date
	from person
	where person_id = 1;

/* Output:
+-----------+--------+-------+------------+
| person_id | fname  | lname | birth_date |
+-----------+--------+-------+------------+
|         1 | George | Chan  | 1972-05-27 |
+-----------+--------+-------+------------+
*/

-- 09: Look at the data by fname = 'George'
select person_id, fname, lname, birth_date
	from person
	where fname = 'George';

-- 10: Insert some more data
insert into favorite_food (person_id, food)
	values (1, 'pizza');

insert into favorite_food (person_id, food)
	values (1, 'cookies');

insert into favorite_food (person_id, food)
	values (1, 'pasta');

-- 11: Look at all George's favorite food
select food
	from favorite_food
	where person_id = 1
	order by food;

/* Output:
+---------+
| food    |
+---------+
| cookies |
| pasta   |
| pizza   |
+---------+
*/
