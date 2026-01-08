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

/*
Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than 38.7880 and less than 137.2345. Truncate your answer to 4 decimal places.
*/
select truncate(sum(lat_n), 4) as sum_lat_n
from station
where lat_n>38.7880 and lat_n<137.2345;

---

/*
Query the greatest value of the Northern Latitudes (LAT_N) from STATION that is less than 137.2345. Truncate your answer to 4 decimal places.
*/
select truncate(max(lat_n), 4) as max_lat_n
from station
where lat_n<137.2345;

---

/*
Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in STATION that is less than 137.2345. Round your answer to 4 decimal places.
*/
with max_lat as(
    select max(lat_n) as max_lat_n
    from station
    where lat_n < 137.2345
)
select round(long_w, 4) as long_w
from station as s 
inner join max_lat as ml on s.lat_n = ml.max_lat_n;

---

/*
Query the smallest Northern Latitude (LAT_N) from STATION that is greater than 38.7780. Round your answer to 4 decimal places.
*/
select round(min(lat_n), 4) as small_lat_n
from station
where lat_n > 38.7780;

---

/*
Query the Western Longitude (LONG_W)where the smallest Northern Latitude (LAT_N) in STATION is greater than 38.7780. Round your answer to 4 decimal places.
*/
with min_lat_n as(
    select min(lat_n) as small_lat_n
    from station
    where lat_n > 38.7780
)
select round(s.long_w, 4) as long_w
from station s
inner join min_lat_n as ml on s.lat_n = ml.small_lat_n;

---

/*
Consider two points on a 2D plane:

P1(a, b):
- a is the minimum value of northern latitude (lat_n) from the station table
- b is the minimum value of western longitude (long_w) from the station table

P2(c, d):
- c is the maximum value of northern latitude (lat_n) from the station table
- d is the maximum value of western longitude (long_w) from the station table

Write a query to calculate the Manhattan distance between points P1 and P2 using the formula:
|a - c| + |b - d|

Round the final result to 4 decimal places.
*/
select
    round(
        abs(min(lat_n) - max(lat_n)) +
        abs(min(long_w) - max(long_w))
        , 4
    ) as manhattan_distance
from station;

---

/*
Consider two points on a 2D plane:

P1(a, c):
- a is the minimum value of northern latitude (lat_n) from the station table
- c is the minimum value of western longitude (long_w) from the station table

P2(b, d):
- b is the maximum value of northern latitude (lat_n) from the station table
- d is the maximum value of western longitude (long_w) from the station table

Write a query to calculate the Euclidean distance between points P1 and P2 using the formula:
sqrt((a - b)^2 + (c - d)^2)

Format the final result to display 4 decimal places.
*/
select
    round(
        sqrt(
            power(max(lat_n) - min(lat_n), 2) +
            power(max(long_w) - min(long_w), 2)
        ),
        4
    ) as euclidean_distance
from station;

---

