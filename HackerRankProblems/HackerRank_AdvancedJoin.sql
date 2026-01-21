/*
You are given a table named projects with the following columns:

projects:
- task_id (integer): the unique id of the task
- start_date (date): the start date of the task
- end_date (date): the end date of the task

It is guaranteed that for each row, the difference between end_date and start_date is exactly 1 day.

If the end_date of one task is consecutive to the start_date of another task, then those tasks
belong to the same project.

Write a query to identify all distinct projects and print:
- the project start date
- the project end date

Rules:
- A project consists of one or more consecutive tasks.
- Calculate the total duration of each project as (project_end_date - project_start_date).
- Sort the results by the project duration in ascending order.
- If more than one project has the same duration, sort them by the project start date in ascending order.
*/
SET NOCOUNT ON;
with ordered_tasks as (
    select task_id, start_date, end_date,
    lag(end_date) over (order by start_date) as prev_end_date
    from projects
),
project_flags as (
    select task_id, start_date, end_date,
    case
        when prev_end_date = start_date then 0
        else 1
    end as is_new_project
    from ordered_tasks
),
project_groups as (
    select task_id, start_date, end_date,
    sum(is_new_project) over (order by start_date) as project_id
    from project_flags
),
project_ranges as (
    select min(start_date) as project_start_date, max(end_date) as project_end_date,
    datediff(day, min(start_date), max(end_date)) as duration_days
    from project_groups
    group by project_id
)
select project_start_date, project_end_date
from project_ranges
order by duration_days asc, project_start_date asc;

go

---

/*
You are given three tables: students, friends, and packages.

students:
- id (integer): the unique id of the student
- name (string): the name of the student

friends:
- id (integer): the id of the student
- friend_id (integer): the id of the student's only best friend

packages:
- id (integer): the id of the student
- salary (float): the offered salary in thousands of dollars per month

Write a query to print the names of students whose best friends were offered
a higher salary than they were.

Rules:
- Compare each student’s salary with their best friend’s salary.
- Include only those students whose best friend’s salary is greater than their own.
- Order the result by the best friend’s salary in ascending order.
*/
SET NOCOUNT ON;
with salary_map as (
    select f.id as student_id, f.friend_id,
    p1.salary as student_salary,
    p2.salary as friend_salary
    from friends f
    inner join packages p1 on f.id = p1.id
    inner join packages p2 on f.friend_id = p2.id
),
filtered as (
    select s.name, sm.friend_salary
    from salary_map sm
    inner join students s on sm.student_id = s.id
    where sm.friend_salary > sm.student_salary
)
select name
from filtered
order by friend_salary asc;

go

---

/*
You are given a table named functions with the following columns:

functions:
- x (integer)
- y (integer)

Two pairs (x1, y1) and (x2, y2) are said to be symmetric if:
- x1 = y2
- x2 = y1

Write a query to find and print all such symmetric pairs.

Rules:
- Each symmetric pair should be listed only once.
- Display only the rows where x <= y.
- Sort the output in ascending order by the value of x.
*/
SET NOCOUNT ON;
with cte as (
    select x, y,
    count(*) over (partition by x, y) as cnt
    from functions
),
symmetric as (
    select f1.x, f1.y
    from cte f1
    inner join cte f2 on f1.x = f2.y and f1.y = f2.x
    where (f1.x < f1.y) or (f1.x = f1.y and f1.cnt > 1)
)
select distinct x, y
from symmetric
order by x;

go

---

/*
Samantha interviews candidates from multiple colleges using coding contests.

Each contest is created by a hacker and may be used to screen candidates from more than one college.
However, each college conducts only one screening contest.

You are given the following tables:

1. contests
   - contest_id: id of the contest
   - hacker_id: id of the hacker who created the contest
   - name: name of the hacker

2. colleges
   - college_id: id of the college
   - contest_id: id of the contest used by the college

3. challenges
   - challenge_id: id of the challenge
   - college_id: id of the college where the challenge was given

4. view_stats
   - challenge_id: id of the challenge
   - total_views: total number of views for the challenge
   - total_unique_views: total number of unique views for the challenge

5. submission_stats
   - challenge_id: id of the challenge
   - total_submissions: total number of submissions for the challenge
   - total_accepted_submissions: number of accepted submissions for the challenge

Task:
Write a query to display, for each contest:
- contest_id
- hacker_id
- hacker name
- sum of total_submissions
- sum of total_accepted_submissions
- sum of total_views
- sum of total_unique_views

Exclude contests where all four summed values are equal to 0.

The output should be ordered by contest_id.
*/
SET NOCOUNT ON;
/* CTE for aggregated submission statistics */
with Aggregated_Submissions as (
    select challenge_id, 
    sum(total_submissions) as sum_submissions, 
    sum(total_accepted_submissions) as sum_accepted_submissions
    from Submission_Stats
    group by challenge_id
),
/* CTE for aggregated view statistics */
Aggregated_Views as (
    select challenge_id, 
    sum(total_views) as sum_views, 
    sum(total_unique_views) as sum_unique_views
    from View_Stats
    group by challenge_id
)
select con.contest_id, con.hacker_id, con.name, 
sum(asub.sum_submissions), 
sum(asub.sum_accepted_submissions), 
sum(aview.sum_views), 
sum(aview.sum_unique_views)
from Contests as con
inner join Colleges as col on con.contest_id = col.contest_id
inner join Challenges as cha on col.college_id = cha.college_id
left join Aggregated_Submissions as asub on cha.challenge_id = asub.challenge_id
left join Aggregated_Views as aview on cha.challenge_id = aview.challenge_id
group by con.contest_id, con.hacker_id, con.name
having (sum(asub.sum_submissions) + 
        sum(asub.sum_accepted_submissions) + 
        sum(aview.sum_views) + 
        sum(aview.sum_unique_views)) > 0
order by con.contest_id;

go

---
