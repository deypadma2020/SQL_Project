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

/*
write a query to print all prime numbers less than or equal to 1000.

the output should be printed on a single line.
use the ampersand (&) character as the separator between numbers instead of a space.

example:
for prime numbers less than or equal to 10, the output should be:
2&3&5&7
*/
SET NOCOUNT ON;
with numbers as (
    select 2 as n
    union all
    select n + 1 
    from numbers 
    where n < 1000
),
primes as (
    select n1.n
    from numbers n1
    left join numbers n2 on n2.n < n1.n and n1.n % n2.n = 0
    group by n1.n having count(n2.n) = 0
)
select string_agg(n, '&') within group (order by n)
from primes
option (maxrecursion 1000);

go
