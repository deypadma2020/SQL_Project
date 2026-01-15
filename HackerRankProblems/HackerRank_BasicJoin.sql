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

/*
Julia has finished conducting a coding contest and needs help assembling the leaderboard.

You are given the following tables:

hackers:
- hacker_id (integer): the unique id of the hacker
- name (string): the name of the hacker

difficulty:
- difficulty_level (integer): the difficulty level of a challenge
- score (integer): the maximum score achievable for a challenge at that difficulty level

challenges:
- challenge_id (integer): the unique id of the challenge
- hacker_id (integer): the id of the hacker who created the challenge
- difficulty_level (integer): the difficulty level of the challenge

submissions:
- submission_id (integer): the unique id of the submission
- hacker_id (integer): the id of the hacker who made the submission
- challenge_id (integer): the id of the challenge for which the submission was made
- score (integer): the score received for the submission

A hacker is considered to have achieved a full score for a challenge if their submission score
matches the maximum score for that challenge’s difficulty level.

Write a query to print:
- hacker_id
- name

Include only hackers who achieved full scores in more than one challenge.

Sort the output:
- first by the total number of challenges in which the hacker earned a full score, in descending order
- if multiple hackers have the same count, sort them by hacker_id in ascending order
*/
/*
Julia has finished conducting a coding contest and needs help assembling the leaderboard.

You are given the following tables:

hackers:
- hacker_id (integer): the unique id of the hacker
- name (string): the name of the hacker

difficulty:
- difficulty_level (integer): the difficulty level of a challenge
- score (integer): the maximum score achievable for a challenge at that difficulty level

challenges:
- challenge_id (integer): the unique id of the challenge
- hacker_id (integer): the id of the hacker who created the challenge
- difficulty_level (integer): the difficulty level of the challenge

submissions:
- submission_id (integer): the unique id of the submission
- hacker_id (integer): the id of the hacker who made the submission
- challenge_id (integer): the id of the challenge for which the submission was made
- score (integer): the score received for the submission

A hacker is considered to have achieved a full score for a challenge if their submission score
matches the maximum score for that challenge’s difficulty level.

Write a query to print:
- hacker_id
- name

Include only hackers who achieved full scores in more than one challenge.

Sort the output:
- first by the total number of challenges in which the hacker earned a full score, in descending order
- if multiple hackers have the same count, sort them by hacker_id in ascending order
*/
/*
Julia has finished conducting a coding contest and needs help assembling the leaderboard.

You are given the following tables:

hackers:
- hacker_id (integer): the unique id of the hacker
- name (string): the name of the hacker

difficulty:
- difficulty_level (integer): the difficulty level of a challenge
- score (integer): the maximum score achievable for a challenge at that difficulty level

challenges:
- challenge_id (integer): the unique id of the challenge
- hacker_id (integer): the id of the hacker who created the challenge
- difficulty_level (integer): the difficulty level of the challenge

submissions:
- submission_id (integer): the unique id of the submission
- hacker_id (integer): the id of the hacker who made the submission
- challenge_id (integer): the id of the challenge for which the submission was made
- score (integer): the score received for the submission

A hacker is considered to have achieved a full score for a challenge if their submission score
matches the maximum score for that challenge’s difficulty level.

Write a query to print:
- hacker_id
- name

Include only hackers who achieved full scores in more than one challenge.

Sort the output:
- first by the total number of challenges in which the hacker earned a full score, in descending order
- if multiple hackers have the same count, sort them by hacker_id in ascending order
*/
select h.hacker_id, h.name
from hackers h
inner join submissions s on h.hacker_id = s.hacker_id
inner join challenges c on s.challenge_id = c.challenge_id
inner join difficulty d on c.difficulty_level = d.difficulty_level
where s.score = d.score
group by h.hacker_id, h.name having count(distinct s.challenge_id) > 1
order by count(distinct s.challenge_id) desc, h.hacker_id asc;

---

/*
Harry Potter and his friends are at Ollivander's, looking to replace Ron's broken wand.

You are given the following tables containing data about the wands in Ollivander's inventory:

wands:
- id (integer): the unique id of the wand
- code (integer): the code of the wand
- coins_needed (integer): the number of gold galleons required to buy the wand
- power (integer): the power of the wand (higher value indicates a more powerful wand)

wands_property:
- code (integer): the code of the wand
- age (integer): the age of the wand
- is_evil (integer): indicates whether the wand is evil
  - 0 means the wand is not evil
  - 1 means the wand is evil

Each wand code maps to exactly one age.

Write a query to print the following columns for all non-evil wands (is_evil = 0):
- id
- age
- coins_needed
- power

For each combination of power and age, select the wand that requires the minimum number of coins_needed.

Sort the result:
- by power in descending order
- if multiple wands have the same power, by age in descending order
*/
with wand_cost as (
    select
        w.id,
        wp.age,
        w.coins_needed,
        w.`power`,
        min(w.coins_needed) over (
            partition by w.code, w.`power`
        ) as min_coins
    from wands w
    join wands_property wp
        on w.code = wp.code
    where wp.is_evil = 0
)
select
    id,
    age,
    coins_needed,
    `power`
from wand_cost
where coins_needed = min_coins
order by `power` desc, age desc;

---
