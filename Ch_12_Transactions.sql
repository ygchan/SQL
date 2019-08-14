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