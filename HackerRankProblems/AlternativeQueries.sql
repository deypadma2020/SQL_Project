/*
p(r) represents a pattern drawn by julia using r rows.

the pattern consists of a right-angled triangle made of asterisks (*),
where the first row contains r asterisks separated by spaces,
and each subsequent row contains one fewer asterisk than the previous row.

example:
p(5) is printed as:

* * * * *
* * * *
* * *
* *
*

write a query to print the pattern p(20),
with each row on a new line and asterisks separated by a single space.
*/
SET NOCOUNT ON;
with pattern_cte as (
    -- anchor member: start with 20
    select 20 as n
    union all
    -- recursive member: decrement until 1
    select n - 1
    from pattern_cte
    where n > 1
)
select replicate('* ', n)
from pattern_cte;

go

---

/*
p(r) represents a pattern drawn by julia using r rows.

the pattern forms a right-angled triangle of asterisks (*),
where the first row contains 1 asterisk,
and each subsequent row contains one more asterisk than the previous row.

example:
p(5) is printed as:

*
* *
* * *
* * * *
* * * * *

write a query to print the pattern p(20),
with each row on a new line and asterisks separated by a single space.
*/
SET NOCOUNT ON;
with pattern as (
    select 1 as n
    union all
    select n + 1 
    from pattern 
    where n < 20
)
select replicate('* ', n) 
from pattern;

go

---
