/*
Problem: Population Count in Cities

You are given a table named CITY with the following structure:

CITY
- id           : NUMBER
- name         : VARCHAR2(17)
- countrycode  : VARCHAR2(3)
- district     : VARCHAR2(20)
- population   : NUMBER

Task:
Write a query to count the number of cities in the CITY table
that have a population greater than 100,000.

Output:
- Return a single integer representing the count of such cities.
*/
select count(*)
from city
where population > 100000;

---

/*
Query the total population of all cities in CITY where District is California.
*/
select sum(population) as total_population
from city
where district = "California";

---

/*
Query the average population of all cities in CITY where District is California.
*/
select round(avg(population), 3) as avg_population
from city
where district = "California";

---

/*
Query the average population for all cities in CITY, rounded down to the nearest integer.
*/
select round(avg(population), 0) as avg_population
from city;

---

/*
Query the sum of the populations for all Japanese cities in CITY. The COUNTRYCODE for Japan is JPN.
*/
select sum(population) as sum_of_population
from city
where countrycode = "JPN";

---

/*
Query the difference between the maximum and minimum populations in CITY.
*/
select max(population) - min(population) diff_population
from city;

---

/*
Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table, but did not realize her keyboard's 0 key was broken until after completing the calculation. She wants your help finding the difference between her miscalculation (using salaries with any zeros removed), and the actual average salary.

Write a query calculating the amount of error (i.e.: actual - miscalculated average monthly salaries), and round it up to the next integer.
*/
select ceil(avg(salary) - avg(replace(salary, '0', ''))) as error_amount
from employees;

---
