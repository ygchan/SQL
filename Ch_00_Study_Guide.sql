/* Interview / Review Questions */
/* (I)   - Simple question    */
/* (II)  - Standard question  */
/* (III) - Difficult question */

/* Answer all questions as concise as possible */

-- (I): What is an index? (P.228)
-- An Index is a mechanism for finding a specific item within a database.

-- (Long Answer)
-- For most textbooks, there is an index at the end that allows you to 
-- locate a specific word or topic within the book. The index is usually
-- sorted alphabetically, to allow you to move quickly to a particular 
-- letter within the index, find the desired entry and then find the page
-- on which the word or subject maybe be found.

-- (I): How to create an index? Write the code.
alter table my_table_name
add index my_index_name (column_name);

-- (I): How to drop an index? Write the code.
alter table my_table_name
drop index my_index_name (column_name);

-- (I): How to create an multi-column index? Write the code
alter table my_table_name
add index my_index_name (column_one, column_two);