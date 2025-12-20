/*
Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. 
Output one of the following statements for each record in the table: 
- Equilateral: It's a triangle with 3 sides of equal length. 
- Isosceles: It's a triangle with 2 sides of equal length. 
- Scalene: It's a triangle with 3 sides of differing lengths. 
- Not A Triangle: The given values of A, B, and C don't form a triangle.
*/
select 
case 
    when ((a + b) > c and (a + c) > b and (c + b) > a) and (a = b and b = c) then "Equilateral"
    when ((a + b) > c and (a + c) > b and (c + b) > a) and (a=b or b=c or c=a) then "Isosceles"
    when ((a + b) > c and (a + c) > b and (c + b) > a) and (a<>b and b<>c and c<>a) then "Scalene" 
    else "Not A Triangle"
end as type_of_triangle
from triangles;

---

/*
Problem: Occupations
- You are given a table named OCCUPATIONS with the following structure:
  Name        STRING
  Occupation  STRING

- The Occupation column will contain only one of the following values:
Doctor, Professor, Singer, or Actor.
Task:
- Generate the following two result sets:
1) Query an alphabetically ordered list of all names in the OCCUPATIONS table.
    Each name should be immediately followed by the first letter of the occupation in parentheses.
        - Example format: Name(FirstLetterOfOccupation)

2) Query the number of occurrences of each occupation in the OCCUPATIONS table.
    Output the result in the following format:
    There are a total of [occupation_count] [occupation]s.

Sorting rules for the second query:
- Sort by occupation_count in ascending order.
- If counts are the same, sort alphabetically by occupation name.

Note:
- There will be at least two entries for each occupation type.
*/

-- 1.
select concat(name, "(", left(occupation, 1), ")")
from occupations
order by name;

-- 2.
select concat(
           "There are a total of ",
           count(*),
           " ",
           lower(occupation),
           "s."
       )
from occupations
group by occupation
order by count(*), occupation;

---

/*
Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. 
The output should consist of four columns (Doctor, Professor, Singer, and Actor) in that specific order, with their respective names listed alphabetically under each column.

Note: Print NULL when there are no more names corresponding to an occupation.
*/
with ranked as (
    select name, occupation,
    row_number() over (partition by occupation order by name) as rn
    from occupations
)
select
max(case when occupation = 'Doctor' then name end) as Doctor,
max(case when occupation = 'Professor' then name end) as Professor,
max(case when occupation = 'Singer' then name end) as Singer,
max(case when occupation = 'Actor' then name end) as Actor
from ranked
group by rn
order by rn;

---

/*
You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, and P is the parent of N.
Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:

Root: If node is root node.
Leaf: If node is leaf node.
Inner: If node is neither root nor leaf node.
*/
select
    n,
    case
        when p is null then 'Root'
        when n not in (select distinct p from bst where p is not null) then 'Leaf'
        else 'Inner'
    end as node_type
from bst
order by n;

-- select b1.n,
-- case
--     when b1.p is null then 'Root'
--     when count(b2.n) = 0 then 'Leaf'
--     else 'Inner'
-- end as node_type
-- from bst b1
-- left join bst b2 on b1.n = b2.p
-- group by b1.n, b1.p
-- order by b1.n;

---
