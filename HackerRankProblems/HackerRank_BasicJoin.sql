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
