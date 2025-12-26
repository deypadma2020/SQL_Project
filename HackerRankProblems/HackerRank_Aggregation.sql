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
