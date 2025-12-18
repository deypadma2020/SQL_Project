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
