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

/*
Enter your query here.
Please append a semicolon ";" at the end of the query and enter your query in a single line to avoid error.
*/

go

---

