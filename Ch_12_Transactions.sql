-- Transactions
-- While most of the single SQL query can be executed, such as ad-hoc report.
-- In a producion environment, there are a lot of queries running and 
-- interacting with the database at the same time.

-- How are they going to work with each other?

-- 01: What is a multiuser database?
-- DBMS (Database Management System) allows for multiple users, imagine this
-- you are running a report about how much claims for a group of members.
-- And at the sametime the claims are being adjudicated, some members are also
-- being enrolled, some members are paying the bills.

-- Which number should the report use? The answer is depending on how the 
-- server handle "LOCKS".

-- 02: What are the two locking strategies?
--    Write/Read Locks - Database writer must request and receive the
--    a write lock to modify data, and the server only gives out one at a time.
--    Database reader must also request and receive from server a read lock
--    to query the data. Read requests are blocked until write lock is released

--    Database writers must request and receive from the server a write lock
--    to modify data. But readers do not need any type of lock to query data.
--    Instead the server ensures the reader see a consistent view of the data
--    (from the time his/her query started). This is known a verisioning.

--    In my own words: There are two approaches to locking strategies.
--    Read/Write locks, when reader wants to query database, they must request
--    and receive a read lock, which will only be received a write lock is not
--    being used. To prevent multiple people to update/delete/insert/modify
--    at the same time, only 1 write lock is given at anytime. But this does
--    not affect any mult-user query functions. The draw back is, if someone
--    is running a large query, it can be a long time to for the write to 
--    return.

--    The second type of locking strategies is: Versioning - the database
--    ensure a consistent view of the data, from the time the query start to
--    execute. But this can be problemetic if the query takes a long time to
--    run and the data are no longer reflective of real time?

--    Interestingly, MySQL has both approaches available for users depending
--    on the storage engine choice.

-- Lock Granularities
-- Table Lock - Entire Table
-- Page Lock  - Each page is a segment of memory in the range of 2KB-16KB
-- Row Lock   - One Row

-- 03: What is a transactions?
-- If the queries never encounter fatal errors and it always allow many 
-- concurrent user access, and server never shut down. Then no need for this.
-- But because we are in a real world, we need a way to ensure if the execution
-- failed, we can "rollback" ALL changes made.

-- The book gives an interesting example, if you try to transfer $500 from 
-- checking to saving, and it crashed AFTER the withdrawal for any kind of 
-- reason - server shut down, query crashed, write lock not available. You will
-- be understandly very upset.

-- Therefore, after the server confirmed the transcation is sucessful, it 
-- will issue a commit (git??), and if it failed (not complete entire run)
-- it will issue a rollback.

-- Example:
start transcation;

/* With draw $500 */
update account set avail_balance = avail_balance - 500
where account_id = 1234
  and avail_balance > 500;

if /* Exactly one row was updated by previous query */ Then
   /* deposit money into second account */
   update account set avail_balance = avail_balance + 500
   where account_id = 1234;

   if /* Exactly one row was updated by previous query */ Then
      /* everything worked, make the changes permanent */
      commit;
   else
      /* Something went wrong, undo all changes in this transcation */
      rollback;
else
   rollback;
end if;

-- In MS SQL Server (I imagine what the company use?) - They are automatically
-- commited independently of one another.

-- In MS SQL. Once you press the Enter key, the changes made will be permanent.
-- Unless your DBA rollback from a backup.

-- Start a transcation
set implicit_transactions on

-- MySQL disable auto-commit mode via the following
set autocommit = 0

-- Ending a transcation
commit
rollback

-- Test your knowledge!!

-- 12.1 Generate a transcation to transfer $50 from Frank Tucker's money 
-- market account to his checking account. You will need to insert two rows
-- into transaction table and update two rows in the account table

start transaction;

-- Using coorelated subquery to lookup the account ids
select i.cust_id,
   (select a.account_id from account a
    where a.cust_id = i.cust_id
      and a.product_cd = 'MM') mm_id,
   (select a.account_id from account a
    where a.cust_id = i.cust_id
      and a.product_cd = 'chk') chk_id
   -- place these value into variables
   into @cst_id, @@mm_id, @chk_id
   from individual i
   where i.fname = 'Frank' and i.lname = 'Tucker';

-- Using the @ symbol to use them somewhere else
insert into transcation (txn_id, txn_date, account_id,
   txn_type_cd, amount)
values (null, now(), @mm_id, 'CDT', 50);

insert into transcation(txn_id, txn_date, account_id,
   txn_type_cd, amount)
values (null, now(), @chk_id, 'DBT', 50);

update account
set last_activity_date = now(),
   avail_balance = avail_balance - 50
where account_id = @mm_id;

update account
set last_activity_date = now(),
   avail_balance = avail_balance + 50
where account_id = @chk_id;  

commit;