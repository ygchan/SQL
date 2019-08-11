-- This is a running list of the concept and functions encountered in the book
-- Learning SQL, 2nd Edition 

/* 
   http://shop.oreilly.com/product/9780596520847.do
   Learning SQL, 2nd Edition
   Master SQL Fundamentals

   By Alan Beaulieu
   Publisher: O'Reilly Media
   Release Date: April 2009

   Pages: 338
*/

-- Chapter 7: Data Generation, Conversion and Manipulation
--    For strings:
--    length()
--    locate()
--    show warnings
--    concat()
--    position()
--    like '%substring%' in select context
--    ssn regex '.{3}-.{2}-.{4}' is_ss_no_format
--    insert()

--    For numbers:
--    ceil(), floor()
--    round(), round(var, precision)
--    truncate(var, precision)
--    sign()
--    abs()

--    For temporal data:
--    cast(),           ex: cast('2019-08-12' as date)
--    str_to_date(),    ex: str_to_date('September 17, 2008', '%M %d, %Y')
--    current_date(),
--    current_time(), 
--    current_timestamp()
--    date_add()
--    last_day()
--    dayname()
--    extract(),       ex: extract(year from '2018-05-01')
--    datediff(),      ex: datediff(current_date(), '1999-01-01')
--    cast(),          ex: cast('1234' as unsigned integer)

-- Chapter 8: Grouping and Aggregates
--    Group By
--    count(*) vs. count(value)
--    having count(*)
--    max, min, avg, count
--    impolicit vs. explicit groups
--    count(distinct membno)
--    using expression in Aggregates
--    single column grouping
--    multiple columns grouping
--    rollups          ex: group by a, b with rollup