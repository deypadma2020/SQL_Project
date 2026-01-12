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
