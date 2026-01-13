/*
Given the CITY and COUNTRY tables, query the sum of the populations of all cities where the CONTINENT is 'Asia'.

Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
*/
select sum(ci.population) as total_population
from city as ci
inner join country as co on ci.countrycode = co.code
where co.continent = "Asia";

---

/*
Given the CITY and COUNTRY tables, query the names of all cities where the CONTINENT is 'Africa'.

Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
*/
select ci.name
from city ci
inner join country co on ci.countrycode = co.code 
where co.continent = "Africa";

---

/*
Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) rounded down to the nearest integer.

Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
*/
select co.continent, floor(avg(ci.population)) as avg_population
from country co
inner join city ci on co.code = ci.countrycode
group by co.continent;

---

/*
You are given two tables: students and grades.

The students table contains the following columns:
- id (integer)
- name (string)
- marks (integer)

The grades table contains the following columns:
- grade
- min_mark
- max_mark

Each student is assigned a grade based on their marks falling between min_mark and max_mark (inclusive).

Write a query to generate a report with the following columns:
- name
- grade
- marks

Requirements:
- If a student receives a grade lower than 8, display "NULL" as the name.
- If a student receives a grade of 8 or higher, display the student's actual name.
- Sort the results by grade in descending order.
- For students with the same grade:
  - If the grade is 8 or higher, sort by name alphabetically.
  - If the grade is lower than 8, sort by marks in ascending order.
*/
select
case
    when g.grade < 8 then 'NULL'
    else s.name
end as name,
g.grade, s.marks
from students s
inner join grades g on s.marks between g.min_mark and g.max_mark
order by g.grade desc,
case
    when g.grade >= 8 then s.name
    else null
end asc,
case
    when g.grade < 8 then s.marks
    else null
end asc;

---
