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
Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table, 
but did not realize her keyboard's 0 key was broken until after completing the calculation. 
She wants your help finding the difference between her miscalculation (using salaries with any zeros removed), and the actual average salary.

Write a query calculating the amount of error (i.e.: actual - miscalculated average monthly salaries), and round it up to the next integer.
*/
select ceil(avg(salary) - avg(replace(salary, '0', ''))) as error_amount
from employees;

---

/*
We define an employee's total earnings to be their monthly salary*months worked, 
and the maximum total earnings to be the maximum total earnings for any employee in the Employee table. 
Write a query to find the maximum total earnings for all employees as well as the total number of employees who have maximum total earnings. 
Then print these values as 2 space-separated integers.
*/
with earnings as (
    select
        months * salary as total_earnings,
        max(months * salary) over () as global_max
    from employee
)
select
    total_earnings as max_total_earnings,
    count(*) as employee_count
from earnings
where total_earnings = global_max
group by total_earnings;

---

/*
Query the following two values from the STATION table:

    1. The sum of all values in LAT_N rounded to a scale of 2 decimal places.
    2. The sum of all values in LONG_W rounded to a scale of 2 decimal places.
*/
select
    round(sum(lat_n), 2) as sum_lat_n,
    round(sum(long_w), 2) as sum_long_w
from station;

---
