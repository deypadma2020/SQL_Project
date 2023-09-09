create database if not exists pizza_runner;

use pizza_runner;

DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  runner_id INTEGER,
  registration_date DATE
);
INSERT INTO runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');

----------------------------------------------------------------------------------
DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  order_id INTEGER,
  customer_id INTEGER,
  pizza_id INTEGER,
  exclusions VARCHAR(4),
  extras VARCHAR(4),
  order_time TIMESTAMP
);

INSERT INTO customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');

-----------------------------------------------------------------------------------------
DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  order_id INTEGER,
  runner_id INTEGER,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23)
);

INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');

-----------------------------------------------------------------------------------------
DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  pizza_id INTEGER,
  pizza_name TEXT
);
INSERT INTO pizza_names
  (pizza_id, pizza_name)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');

-----------------------------------------------------------------------------------------
DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  pizza_id INTEGER,
  toppings TEXT
);
INSERT INTO pizza_recipes
  (pizza_id, toppings)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');

-----------------------------------------------------------------------------------------
DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  topping_id INTEGER,
  topping_name TEXT
);
INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
-----------------------------------------------------------------------------------------
# extracting all the data present into 'runners' table
select * from runners;

# extracting all the data present into 'customer_orders' table
select * from customer_orders;

# extracting all the data present into 'runner_orders' table
select * from runner_orders;

# extracting all the data present into 'pizza_names' table
select * from pizza_names;

# extracting all the data present into 'pizza_recipes' table
select * from pizza_recipes;

# extracting all the data present into 'pizza_toppings' table
select * from pizza_toppings;

################################################# A. Pizza Metrics ################################################

/*
1. How many pizzas were ordered?
*/
select count(co.order_id) as "No. of Pizza Orders" 
from customer_orders as co;

-----------------------------------------------------------------------------------------
/*
2. How many unique customer orders were made?
*/
select count(distinct co.order_id) as "No. of Unique Customer Orders"
from customer_orders as co;

-----------------------------------------------------------------------------------------
/*
3. How many successful orders were delivered by each runner?
*/
with runner_orders_temp as(
					select ro.order_id, ro.runner_id, 
					case
						when ro.distance like 'null' then 0
						else cast(regexp_replace(ro.distance, '[a-z]+', '') as float)
					end as distance 
					from runner_orders as ro
						)
select rot.runner_id as "Runner", count(rot.order_id) as "Successful Orders"
from runner_orders_temp as rot
where rot.distance > 0
group by rot.runner_id
order by count(rot.order_id) desc;

----------------------------------------------------------------------------------------
/*
4. How many of each type of pizza was delivered?
*/
with runner_orders_temp as(
					select ro.order_id, ro.runner_id, 
					case
						when ro.distance like 'null' then 0
						else cast(regexp_replace(ro.distance, '[a-z]+', '') as float)
					end as distance 
					from runner_orders as ro
						)
select pn.pizza_name as "Pizza Name", count(co.pizza_id) as "Count of Delivery"
from customer_orders as co
inner join pizza_names as pn on co.pizza_id = pn.pizza_id
inner join runner_orders_temp as rot on co.order_id = rot.order_id
where rot.distance > 0
group by pn.pizza_name
order by count(co.pizza_id) desc;

---------------------------------------------------------------------------------------
/*
5. How many Vegetarian and Meatlovers were ordered by each customer?
*/
select co.customer_id as "Customer ID", pn.pizza_name as "Pizza Name", count(co.customer_id) as "No. of Pizza Ordered"
from customer_orders as co
inner join pizza_names as pn on co.pizza_id = pn.pizza_id
group by co.customer_id, pn.pizza_name
order by count(co.customer_id) desc;

---------------------------------------------------------------------------------------
/*
6. What was the maximum number of pizzas delivered in a single order?
*/
with runner_orders_temp as(
					select ro.order_id, ro.runner_id, 
					case
						when ro.distance like 'null' then 0
						else cast(regexp_replace(ro.distance, '[a-z]+', '') as float)
					end as distance 
					from runner_orders as ro
						),
pizza_delivery_count as(
						select rot.order_id, count(co.order_id) as max_delivery, rank() over(order by count(co.order_id) desc) as ranking 
                        from runner_orders_temp as rot 
                        inner join customer_orders as co on rot.order_id = co.order_id
                        where rot.distance > 0
                        group by rot.order_id 
                        )
select pdc.order_id as "Order ID", pdc.max_delivery as "Max No. of of Pizza Delivered" 
from pizza_delivery_count as pdc 
where pdc.ranking = 1
group by pdc.order_id;

--------------------------------------------------------------------------------------
/*
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
*/
-- approach 1:
with customer_orders_temp as(
							select co.order_id, co.customer_id, co.pizza_id, 
							case 
								when co.exclusions = '' or co.exclusions like 'null' or co.exclusions is null then 0
								else co.exclusions
							end as exclusions,
							case
								when co.extras = '' or co.extras like 'null' or co.extras is null then 0
								else co.extras
							end as extras, co.order_time
							from customer_orders as co
							)
select cot.customer_id as "Customer ID",
        sum(
			case 
				when cot.exclusions > 0 or cot.extras > 0 or (cot.exclusions > 0 and cot.extras > 0) then 1 
                else 0 
			end) as "Had at least 1 Change",
        sum(
			case 
				when cot.exclusions = 0 and cot.extras = 0 then 1 
                else 0 
			end) as "Had No Change"
from customer_orders_temp as cot
inner join runner_orders as ro on cot.order_id = ro.order_id
where ro.duration > 0
group by cot.customer_id
order by cot.customer_id;

-- approach 2:
with customer_orders_temp as(
							select co.order_id, co.customer_id, co.pizza_id, 
							case 
								when co.exclusions = '' or co.exclusions like 'null' or co.exclusions is null then 0
								else co.exclusions
							end as exclusions,
							case
								when co.extras = '' or co.extras like 'null' or co.extras is null then 0
								else co.extras
							end as extras, co.order_time
							from customer_orders as co
							),
changes_status as(
						select cot.order_id, cot.customer_id, 
						case 
							when cot.exclusions = 0 and cot.extras = 0 then "no change"
							when cot.exclusions > 0 and cot.extras = 0 then "at least 1 change"
							when cot.exclusions = 0 and cot.extras > 0 then "at least 1 change"
							when cot.exclusions > 0 and cot.extras > 0 then "at least 1 change"
						end as changes_status
						from customer_orders_temp as cot 
                        inner join runner_orders as ro on cot.order_id = ro.order_id 
                        where ro.duration > 0
                        order by cot.customer_id
                        )
select cs.customer_id as "Customer ID", cs.changes_status as "Status", count(cs.changes_status) as "No. of Pizza"
from changes_status as cs
group by cs.customer_id, cs.changes_status 
order by cs.customer_id;

--------------------------------------------------------------------------------------
/*
8. How many pizzas were delivered that had both exclusions and extras?
*/
with customer_orders_temp as(
							select co.order_id, co.customer_id, co.pizza_id, 
							case 
								when co.exclusions = '' or co.exclusions like 'null' or co.exclusions is null then 0
								else co.exclusions
							end as exclusions,
							case
								when co.extras = '' or co.extras like 'null' or co.extras is null then 0
								else co.extras
							end as extras, co.order_time
							from customer_orders as co
							),
runner_orders_temp as(
					select ro.order_id, ro.runner_id, 
					case
						when ro.duration like 'null' then 0
						else cast(regexp_replace(ro.duration, '[a-z]+', '') as float)
					end as duration 
					from runner_orders as ro
						)
select sum(
			case 
				when cot.exclusions > 0 and cot.extras > 0 then 1 
                else 0 
			end) as "Had_Both_Exclusions_and_Extras"
from customer_orders_temp as cot
inner join runner_orders_temp as rot on cot.order_id = rot.order_id
where rot.duration > 0;

--------------------------------------------------------------------------------------
/*
9. What was the total volume of pizzas ordered for each hour of the day?
*/
select date(co.order_time) as "Date", concat(extract(hour from co.order_time), 'h') as "Hour of the Day", count(co.order_id) as "Volume of Pizza Ordered" 
from customer_orders as co
group by day(co.order_time), extract(hour from co.order_time)
order by count(co.order_id) desc;

--------------------------------------------------------------------------------------
/*
10. What was the volume of orders for each day of the week?
*/
select date(co.order_time) as "Date", dayname(co.order_time) as "Day Name", count(co.order_id) as "Volume of Pizza Ordered" 
from customer_orders as co
group by dayname(co.order_time)
order by count(co.order_id) desc;

################################################# B. Runner and Customer Experience ################################################

/*
1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
*/
with recursive week_no_list as(
							select 1 as n
							union all
							select 1 + n 
							from week_no_list
							where n < 5), 
week_selection as(
				select r.runner_id, 
				case 
					when r.registration_date between '2021-01-01' and '2021-01-07' then '1'
					when r.registration_date between '2021-01-08' and '2021-01-14' then '2'
					when r.registration_date between '2021-01-15' and '2021-01-21' then '3'
					when r.registration_date between '2021-01-22' and '2021-01-28' then '4'
					when r.registration_date between '2021-01-29' and '2021-01-31' then '5'
				end as week_no
				from runners as r),
runner_count as(
				select ws.week_no, 
				count(ws.runner_id) as registrations_count
				from week_selection as ws
				group by ws.week_no)
select n as "Week No.", coalesce(registrations_count, 0) as "No. of Runner Signed Up" 
from week_no_list as wnl
left join runner_count as rc on wnl.n = rc.week_no;

--------------------------------------------------------------------------------------
/*
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
*/
with runner_orders_temp as(
							select ro.runner_id, ro.order_id, 
							case
								when ro.duration like 'null' then 0
								else cast(regexp_replace(ro.duration, '[a-z]+', '') as float)
							end as duration
							from runner_orders as ro
						)
select rot.runner_id as "Runner", round(avg(rot.duration), 2) as "Average Time(minutes)" 
from runner_orders_temp as rot
inner join customer_orders as co on rot.order_id = co.order_id
where rot.duration > 0
group by rot.runner_id;
--------------------------------------------------------------------------------------
/*
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
*/
with runner_orders_temp as(
							select ro.runner_id, ro.order_id, 
                            case 
								when ro.pickup_time = 'null' then null 
								else ro.pickup_time 
							end as pickup_time,
							case
								when ro.duration like 'null' then 0
								else cast(regexp_replace(ro.duration, '[a-z]+', '') as float)
							end as duration
							from runner_orders as ro
						)
select co.order_id as "Order ID", count(co.order_id) as "No. of Pizzas", timestampdiff(minute, co.order_time, rot.pickup_time) as "Preparation Time(mins)" 
from runner_orders_temp as rot
inner join customer_orders as co on rot.order_id = co.order_id
where rot.duration > 0
group by co.order_id
order by co.order_id;

--------------------------------------------------------------------------------------
/*
4. What was the average distance travelled for each customer?
*/
with runner_orders_temp as(
							select ro.order_id, 
							case
								when ro.distance like 'null' then 0
								else cast(regexp_replace(ro.distance, '[a-z]+', '') as float)
							end as distance
							from runner_orders as ro
						),
distance_travelling as(
					select rot.order_id, co.customer_id, sum(rot.distance) as distance
                    from runner_orders_temp as rot
                    inner join customer_orders as co on rot.order_id = co.order_id
                    where rot.distance > 0
                    group by rot.order_id
                    )
select co.customer_id as "Customer ID", round(avg(dt.distance), 2) as "Average Distance" 
from customer_orders as co 
inner join runner_orders_temp as rot on co.order_id = rot.order_id
inner join distance_travelling as dt on co.customer_id = dt.customer_id 
group by co.customer_id 
order by co.customer_id;

--------------------------------------------------------------------------------------
/*
5. What was the difference between the longest and shortest delivery times for all orders?
*/
with runner_orders_temp as(
							select ro.order_id, 
							case
								when ro.duration like 'null' then 0
								else cast(regexp_replace(ro.duration, '[a-z]+', '') as float)
							end as duration
							from runner_orders as ro
						)
select max(rot.duration) as "Longest Delivery Time(mins)", min(rot.duration) as "Shortest Delivery Time(mins)", max(rot.duration) - min(rot.duration) as "Difference btw Longest & Shortest"
from runner_orders_temp as rot
where rot.duration > 0;

--------------------------------------------------------------------------------------
/*
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
*/
with runner_orders_temp as(
							select ro.order_id, 
							case
								when ro.distance like 'null' then 0
								else cast(regexp_replace(ro.distance, '[a-z]+', '') as float)
							end as distance,
							case
								when ro.duration like 'null' then 0
								else cast(regexp_replace(ro.duration, '[a-z]+', '') as float)
							end as duration
							from runner_orders as ro
						)
select ro.runner_id as "Runner", rot.order_id as "Order ID", round(avg(rot.distance/(rot.duration/60)), 1) as "Average Speed(km/h)" 
from runner_orders_temp as rot 
inner join runner_orders as ro on rot.order_id = ro.order_id 
where rot.distance > 0
group by ro.runner_id, rot.order_id
order by ro.runner_id;

--------------------------------------------------------------------------------------
/*
7. What is the successful delivery percentage for each runner?
*/
with runner_orders_temp as(
							select ro.order_id, 
							case
								when ro.distance like 'null' then 0
								else cast(regexp_replace(ro.distance, '[a-z]+', '') as float)
							end as distance,
							case
								when ro.duration like 'null' then 0
								else cast(regexp_replace(ro.duration, '[a-z]+', '') as float)
							end as duration
							from runner_orders as ro
						)
select ro.runner_id as "Runner", 
concat(round(((sum(case 
					when rot.distance = 0 then 0 
					else 1
				  end))/count(rot.order_id))* 100, 0), "%") as "Successful Delivery" 
from runner_orders as ro 
inner join runner_orders_temp as rot on ro.order_id = rot.order_id
group by ro.runner_id 
order by ro.runner_id;

################################################# C. Ingredient Optimisation ################################################

/*
1. What are the standard ingredients for each pizza?
*/
with recursive num_lists as( 
							with number_of_ingredients as(
															select max(char_length(pr.toppings) - char_length(replace(pr.toppings, ',','')) + 1) as no_of_ingredients
															from pizza_recipes as pr)
							select 1 as num
							union all
							select 1 + num as num
							from num_lists, number_of_ingredients
							where num < no_of_ingredients
							),
toppings_lists as(
					select pr.pizza_id, pn.pizza_name, trim(substring_index(substring_index(pr.toppings, ',', nl.num) , ',', -1)) as topping_id
					from num_lists as nl
					inner join pizza_recipes as pr on (char_length(pr.toppings)-char_length(replace(pr.toppings, ',','')) + 1) >= nl.num
                    inner join pizza_names as pn on pr.pizza_id = pn.pizza_id
					)
select tl.pizza_name as "Pizza Name", group_concat(pt.topping_name order by pt.topping_id separator ', ') as "Standard Ingredients"
from toppings_lists as tl
inner join pizza_toppings as pt on tl.topping_id = pt.topping_id
group by tl.pizza_name
order by tl.pizza_id, pt.topping_id;

--------------------------------------------------------------------------------------
/*
2. What was the most commonly added extra?
*/
with recursive num_lists as(
							with number_of_ingredients as(
															select max(char_length(co.extras) - char_length(replace(co.extras, ',','')) + 1) as no_of_ingredients
															from customer_orders as co)
							select 1 as num
							union all
							select 1 + num as num
							from num_lists, number_of_ingredients
							where num < no_of_ingredients
							),
toppings_list as(
				select trim(substring_index(substring_index(co.extras, ',', nl.num), ',', -1)) as extras
				from num_lists as nl
				inner join customer_orders as co on (char_length(co.extras) - char_length(replace(co.extras, ',','')) + 1) >= nl.num
					),
extra_count as(
				select tl.extras, count(tl.extras) as count_extras, pt.topping_name
				from toppings_list as tl
				inner join pizza_toppings as pt on tl.extras = pt.topping_id
				group by tl.extras
                ),
added_extra as(
				select ec.topping_name, ec.count_extras, rank() over(order by ec.count_extras desc) as ranking
                from extra_count as ec 
                )
select ae.topping_name as "Most Commonly Added Topings as Extra", ae.count_extras as "No. of Times Added"
from added_extra as ae
where ae.ranking = 1;

--------------------------------------------------------------------------------------
/*
3. What was the most common exclusion?
*/
with recursive num_lists as(
							with number_of_ingredients as(
															select max(char_length(co.exclusions) - char_length(replace(co.exclusions, ',','')) + 1) as no_of_ingredients
															from customer_orders as co)
							select 1 as num
							union all
							select 1 + num as num
							from num_lists, number_of_ingredients
							where num < no_of_ingredients
							),
toppings_list as(
				select trim(substring_index(substring_index(co.exclusions, ',', nl.num), ',', -1)) as exclusions
				from num_lists as nl
				inner join customer_orders as co on (char_length(co.exclusions) - char_length(replace(co.exclusions, ',','')) + 1) >= nl.num
				),
exclusions_count as(
				select tl.exclusions, count(tl.exclusions) as count_exclusions, pt.topping_name
				from toppings_list as tl
				inner join pizza_toppings as pt on tl.exclusions = pt.topping_id
				group by tl.exclusions
                ),
added_exclusions as(
				select ec.topping_name, ec.count_exclusions, rank() over(order by ec.count_exclusions desc) as ranking
                from exclusions_count as ec 
                )
select ae.topping_name as "Most Commonly Removed Toppings as Exclusion", ae.count_exclusions as "No. of Times Removed"
from added_exclusions as ae
where ae.ranking = 1;

--------------------------------------------------------------------------------------
/*
4. Generate an order item for each record in the customers_orders table in the format of one of the following:
			* Meat Lovers
			* Meat Lovers - Exclude Beef
			* Meat Lovers - Extra Bacon
			* Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
*/
with recursive num_lists as( 
							with maximum_ingredients as(
															with customer_orders_temp as(
																						select co.order_id, co.customer_id, co.pizza_id, 
																						case 
																							when co.exclusions like 'null' or co.exclusions like '' then null
																							else co.exclusions
																						end as exclusions,
																						case
																							when co.extras like 'null' or co.extras like '' then null
																							else co.extras
																						end as extras, co.order_time
																						from customer_orders as co
																						),
															number_of_ingredients as(
																						select max(char_length(cot.exclusions) - char_length(replace(cot.exclusions, ',', '')) + 1) as no_of_ingredients
																						from customer_orders_temp as cot
																						union all
																						select max(char_length(cot.extras) - char_length(replace(cot.extras, ',', '')) + 1) as no_of_ingredients
																						from customer_orders_temp as cot
                                                                                        )
															select max(no_of_ingredients) as max_ingredient
															from number_of_ingredients as mi
														)
							select 1 as num
							union all
							select 1 + num as num
							from num_lists, maximum_ingredients
							where num < max_ingredient
							),
customer_orders_temp as(
							select co.order_id, co.customer_id, co.pizza_id, 
							case 
								when co.exclusions like 'null' or co.exclusions like '' then null
								else co.exclusions
							end as exclusions,
							case
								when co.extras like 'null' or co.extras like '' then null
								else co.extras
							end as extras, co.order_time, row_number() over (order by order_id) as rownum
							from customer_orders as co
							), 
toppings_exclusions as(
						select cot.rownum, cot.order_id, cot.customer_id, cot.pizza_id, trim(substring_index(substring_index(cot.exclusions, ',', nl.num), ',', -1)) as exclusions, cot.order_time
						from num_lists as nl
						join customer_orders_temp as cot on char_length(cot.exclusions) - char_length(replace(cot.exclusions, ',', '')) + 1 >= nl.num
                        ),
toppings_extras as(
					select cot.rownum, cot.order_id, cot.customer_id, cot.pizza_id, trim(substring_index(substring_index(cot.extras, ',', nl.num), ',', -1)) as extras, cot.order_time
					from num_lists as nl
					join customer_orders_temp as cot on char_length(cot.extras) - char_length(replace(cot.extras, ',', '')) + 1 >= nl.num
                    ),
exclusions_with_toppings as(
							select te.rownum, te.order_id, te.customer_id, te.pizza_id, pn.pizza_name, group_concat(pt.topping_name order by pt.topping_id separator ', ') as toppings_exclusions, te.order_time 
							from toppings_exclusions as te
							join pizza_toppings as pt on te.exclusions = pt.topping_id
							join pizza_names as pn on te.pizza_id = pn.pizza_id
							group by te.order_id, te.pizza_id, te.rownum
                            ),
extras_with_toppings as(
						select te.rownum, te.order_id, te.customer_id, te.pizza_id, pn.pizza_name, group_concat(pt.topping_name order by pt.topping_id separator ', ') as toppings_extras, te.order_time 
						from toppings_extras as te
						join pizza_toppings as pt on te.extras = pt.topping_id
						join pizza_names as pn on te.pizza_id = pn.pizza_id
						group by te.order_id, te.pizza_id, te.rownum
                        ),
union_all as(
				select excwt.order_id, excwt.customer_id, concat(excwt.pizza_name, ': [Exclude - ', excwt.toppings_exclusions, '], [Extras - ', extwt.toppings_extras, ']') as order_item, excwt.order_time
				from exclusions_with_toppings as excwt
				join extras_with_toppings as extwt on (excwt.order_id = extwt.order_id) and (excwt.pizza_id = extwt.pizza_id) and (excwt.rownum = extwt.rownum)
                
				union all
                
				select excwt.order_id, excwt.customer_id, concat(excwt.pizza_name, ': [Exclude - ', excwt.toppings_exclusions, ']') as order_item, excwt.order_time
				from exclusions_with_toppings as excwt
				left join extras_with_toppings as extwt on (excwt.order_id = extwt.order_id) and (excwt.pizza_id = extwt.pizza_id) and (excwt.rownum = extwt.rownum)
				where extwt.order_id is null
                
				union all
                
				select extwt.order_id, extwt.customer_id, concat(extwt.pizza_name, ': [Extras - ', extwt.toppings_extras, ']') as order_item, extwt.order_time
				from extras_with_toppings as extwt
				left join exclusions_with_toppings as excwt on (excwt.order_id = extwt.order_id) and (excwt.pizza_id=  extwt.pizza_id) and (excwt.rownum = extwt.rownum)
				where excwt.order_id is null
                
				union all
                
				select cot.order_id, cot.customer_id, pn.pizza_name as order_item, cot.order_time
				from customer_orders_temp as cot
				join pizza_names as pn on cot.pizza_id = pn.pizza_id
				where cot.exclusions is null and cot.extras is null 
                order by order_id
				) 
select ua.order_id as "Order ID", ua.customer_id as "Customer ID", ua.order_item as "Ordered Item", ua.order_time as "Order Time"
from union_all as ua 
order by ua.order_id;

--------------------------------------------------------------------------------------
/*
5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the 
customer_orders table and add a 2x in front of any relevant ingredients
		* For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
*/
with recursive num_lists as(
							with number_of_ingredients as(
															select max(char_length(pr.toppings) - char_length(replace(pr.toppings, ',', '')) + 1 ) as no_of_ingredients
                                                            from pizza_recipes as pr
                                                            )
							select 1 as num
							union all
							select 1 + num as num
							from num_lists, number_of_ingredients
							where num < no_of_ingredients
							),
customer_orders_temp as(
							select co.order_id, co.customer_id, co.pizza_id, 
							case 
								when co.exclusions like 'null' or co.exclusions like '' then null
								else co.exclusions
							end as exclusions,
							case
								when co.extras like 'null' or co.extras like '' then null
								else co.extras
							end as extras, co.order_time, row_number() over (order by order_id) as rownum
							from customer_orders as co
							),
cot_with_toppings as(
					select cot.order_id, cot.customer_id, cot.pizza_id, pr.toppings, cot.exclusions, cot.extras, cot.rownum
					from customer_orders_temp as cot
					inner join pizza_recipes as pr on cot.pizza_id = pr.pizza_id
					),
toppings_separation as(
					select cotwt.rownum, cotwt.order_id, cotwt.customer_id, cotwt.pizza_id, trim(substring_index(substring_index(cotwt.toppings, ',', nl.num), ',', -1)) as toppings_sep
					from num_lists as nl
					inner join cot_with_toppings as cotwt on char_length(cotwt.toppings) - char_length(replace(cotwt.toppings, ',', '')) + 1 >= nl.num
                    ),
exclusions_separation as(
						select cotwt.rownum, cotwt.order_id, cotwt.customer_id, cotwt.pizza_id, trim(substring_index(substring_index(cotwt.exclusions, ',', nl.num), ',', -1)) as exclusions_sep
						from num_lists as nl
						inner join cot_with_toppings as cotwt on char_length(cotwt.exclusions) - char_length(replace(cotwt.exclusions, ',', '')) + 1 >= nl.num
						where cotwt.exclusions is not null
                        ),
extras_separation as(
					select cotwt.rownum, cotwt.order_id, cotwt.customer_id, cotwt.pizza_id, trim(substring_index(substring_index(cotwt.extras, ',', nl.num), ',', -1)) as extras_sep
					from num_lists as nl
					inner join cot_with_toppings as cotwt on char_length(cotwt.extras) - char_length(replace(cotwt.extras, ',', '')) + 1 >= nl.num
					where cotwt.extras is not null
                    ),
exclusions_with_toppings as(
							select ts.rownum, ts.order_id, ts.customer_id, ts.pizza_id, ts.toppings_sep
							from toppings_separation as ts
							left join exclusions_separation as es on (ts.order_id=es.order_id) and (ts.pizza_id = es.pizza_id) and (ts.toppings_sep = es.exclusions_sep) and (ts.rownum = es.rownum)
							where es.exclusions_sep is null
                            ),
extras_with_toppings as(
						select excwt.rownum, excwt.order_id, excwt.customer_id, excwt.pizza_id, excwt.toppings_sep, es.extras_sep
						from exclusions_with_toppings as excwt
						left join extras_separation as es on (excwt.order_id=es.order_id) and (excwt.pizza_id = es.pizza_id) and (excwt.toppings_sep = es.extras_sep) and (excwt.rownum = es.rownum)
                        ),
topping as(
			select extwt.rownum, extwt.order_id, extwt.customer_id, extwt.pizza_id, extwt.extras_sep, pt.topping_name, row_number() over (order by extwt.order_id, extwt.pizza_id, pt.topping_name) as row_no
			from extras_with_toppings as extwt
			inner join pizza_toppings as pt on extwt.toppings_sep = pt.topping_id
			),
group_by as(
			select t.order_id, t.customer_id, t.pizza_id, 
			group_concat(case 
							when t.extras_sep is null then topping_name
							when t.extras_sep is not null then concat('(2x', t.topping_name, ')')
						end separator ', ') as toppings
			from topping as t
			group by t.rownum, t.order_id, t.pizza_id
			)
select gb.order_id as "Order ID", gb.customer_id as "Customer ID", gb.pizza_id as "Pizza ID", concat(pn.pizza_name, ': ', gb.toppings) as "Ingredients"
from group_by as gb
inner join pizza_names as pn on gb.pizza_id=pn.pizza_id
order by gb.order_id, gb.pizza_id;

--------------------------------------------------------------------------------------
/*
6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
*/
with recursive num_lists as(
							with number_of_ingredients as(
															select max(char_length(pr.toppings) - char_length(replace(pr.toppings, ',', '')) + 1 ) as no_of_ingredients
                                                            from pizza_recipes as pr
                                                            )
							select 1 as num
							union all
							select 1 + num as num
							from num_lists, number_of_ingredients
							where num < no_of_ingredients
							),
customer_orders_temp as(
							select co.order_id, co.customer_id, co.pizza_id, 
							case 
								when co.exclusions like 'null' or co.exclusions like '' then null
								else co.exclusions
							end as exclusions,
							case
								when co.extras like 'null' or co.extras like '' then null
								else co.extras
							end as extras, co.order_time, row_number() over (order by order_id) as rownum
							from customer_orders as co
							),
runner_orders_temp as(
							select ro.order_id, 
							case
								when ro.distance like 'null' then 0
								else cast(regexp_replace(ro.distance, '[a-z]+', '') as float)
							end as distance,
							case
								when ro.duration like 'null' then 0
								else cast(regexp_replace(ro.duration, '[a-z]+', '') as float)
							end as duration
							from runner_orders as ro
						),
cot_with_toppings as(
					select cot.order_id, cot.customer_id, cot.pizza_id, pr.toppings, cot.exclusions, cot.extras, cot.rownum
					from customer_orders_temp as cot
					inner join pizza_recipes as pr on cot.pizza_id = pr.pizza_id
                    left join runner_orders_temp as rot on cot.order_id = rot.order_id
                    where rot.duration > 0
					),
toppings_separation as(
					select cotwt.rownum, cotwt.order_id, cotwt.customer_id, cotwt.pizza_id, trim(substring_index(substring_index(cotwt.toppings, ',', nl.num), ',', -1)) as toppings_sep
					from num_lists as nl
					inner join cot_with_toppings as cotwt on char_length(cotwt.toppings) - char_length(replace(cotwt.toppings, ',', '')) + 1 >= nl.num
                    ),
exclusions_separation as(
						select cotwt.rownum, cotwt.order_id, cotwt.customer_id, cotwt.pizza_id, trim(substring_index(substring_index(cotwt.exclusions, ',', nl.num), ',', -1)) as exclusions_sep
						from num_lists as nl
						inner join cot_with_toppings as cotwt on char_length(cotwt.exclusions) - char_length(replace(cotwt.exclusions, ',', '')) + 1 >= nl.num
						where cotwt.exclusions is not null
                        ),
extras_separation as(
					select cotwt.rownum, cotwt.order_id, cotwt.customer_id, cotwt.pizza_id, trim(substring_index(substring_index(cotwt.extras, ',', nl.num), ',', -1)) as extras_sep
					from num_lists as nl
					inner join cot_with_toppings as cotwt on char_length(cotwt.extras) - char_length(replace(cotwt.extras, ',', '')) + 1 >= nl.num
					where cotwt.extras is not null
                    ),
exclusions_with_toppings as(
							select ts.rownum, ts.order_id, ts.customer_id, ts.pizza_id, ts.toppings_sep
							from toppings_separation as ts
							left join exclusions_separation as es on (ts.order_id=es.order_id) and (ts.pizza_id = es.pizza_id) and (ts.toppings_sep = es.exclusions_sep) and (ts.rownum = es.rownum)
							where es.exclusions_sep is null
                            ),
extras_with_toppings as(
						select ewt.toppings_sep
						from exclusions_with_toppings as ewt
						union all
						select es.extras_sep 
						from extras_separation as es
						),
topping as(
			select ewt.toppings_sep, pt.topping_name
			from extras_with_toppings as ewt
			inner join pizza_toppings as pt on ewt.toppings_sep = pt.topping_id
			)
select t.topping_name as "Toppings Name", count(t.topping_name) as "Count of Using Times"
from topping as t
group by t.topping_name
order by count(t.topping_name) desc;

################################################# D. Pricing and Ratings ################################################

/*
1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes 
- how much money has Pizza Runner made so far if there are no delivery fees?
*/
with runner_orders_temp as(
					select ro.order_id, ro.runner_id, 
					case
						when ro.duration like 'null' then 0
						else cast(regexp_replace(ro.duration, '[a-z]+', '') as float)
					end as duration 
					from runner_orders as ro
						),
cost_calculation as(
					select rot.runner_id, co.pizza_id, pn.pizza_name, 
                    case 
						when pn.pizza_id = '1' then count(co.order_id) * 12
                        when pn.pizza_id = '2' then count(co.order_id) * 10
					end as cost
                    from customer_orders as co 
                    inner join runner_orders_temp as rot on rot.order_id = co.order_id
                    inner join pizza_names as pn on pn.pizza_id = co.pizza_id
                    where rot.duration > 0
                    group by rot.runner_id, co.pizza_id
                    )
select cc.runner_id as "Runner", concat(sum(cc.cost), '$') as "Money Made by Pizza Runners" 
from cost_calculation as cc 
group by cc.runner_id;

--------------------------------------------------------------------------------------
/*
2. What if there was an additional $1 charge for any pizza extras?
		* Add cheese is $1 extra
*/
with customer_orders_temp as(
							select co.order_id, co.customer_id, co.pizza_id, 
							case 
								when co.exclusions like 'null' or co.exclusions like '' then null
								else co.exclusions
							end as exclusions,
							case
								when co.extras like 'null' or co.extras like '' then null
								else co.extras
							end as extras, co.order_time, row_number() over (order by order_id) as rownum
							from customer_orders as co
							),
runner_orders_temp as(
					select ro.order_id, ro.runner_id, 
					case
						when ro.duration like 'null' then 0
						else cast(regexp_replace(ro.duration, '[a-z]+', '') as float)
					end as duration 
					from runner_orders as ro
						),
cost_calculation as(
					select rot.runner_id, rot.order_id, co.pizza_id, pn.pizza_name, sum(char_length(co.extras)-char_length(replace(co.extras,',',''))+1) as extra_cost,
                    case 
						when pn.pizza_id = '1' then count(co.order_id) * 12
                        when pn.pizza_id = '2' then count(co.order_id) * 10
					end as cost
                    from customer_orders_temp as co 
                    inner join runner_orders_temp as rot on rot.order_id = co.order_id
                    inner join pizza_names as pn on pn.pizza_id = co.pizza_id
                    where rot.duration > 0
                    group by rot.runner_id, rot.order_id, co.pizza_id
                    )
select cc.runner_id as "Runner", concat(sum(cc.cost) + sum(cc.extra_cost), '$') as "Money Made by Pizza Runners"
from cost_calculation as cc 
group by cc.runner_id;

--------------------------------------------------------------------------------------
/*
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
how would you design an additional table for this new dataset - 
generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
*/
create temporary table if not exists runner_ratings(
													order_id int,
													runner_id int,
                                                    rating float, 
                                                    primary key(order_id)
													);
insert into runner_ratings (order_id, runner_id, rating)
select ro.order_id, ro.runner_id, null as rating 
from runner_orders as ro 
where ro.duration <> 'null';
update runner_ratings set rating = 
									case
										when order_id = 1 then 5
                                        when order_id = 2 then 3
                                        when order_id = 3 then 4.7
                                        when order_id = 4 then 5
                                        when order_id = 5 then 5
                                        when order_id = 6 then 4
                                        when order_id = 7 then 3.4
                                        when order_id = 8 then 5
                                        when order_id = 9 then 2
                                        when order_id = 10 then 4.9
									end;
select * from runner_ratings;

--------------------------------------------------------------------------------------
/*
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
			* customer_id
			* order_id
			* runner_id
			* rating
			* order_time
			* pickup_time
			* Time between order and pickup
			* Delivery duration
			* Average speed
			* Total number of pizzas
*/
with runner_orders_temp as(
					select ro.order_id, ro.runner_id, 
					case 
						when ro.pickup_time = 'null' then null 
						else ro.pickup_time 
					end as pickup_time,
					case
						when ro.distance like 'null' then 0
						else cast(regexp_replace(ro.distance, '[a-z]+', '') as float)
					end as distance,
					case
						when ro.duration like 'null' then 0
						else cast(regexp_replace(ro.duration, '[a-z]+', '') as float)
					end as duration 
					from runner_orders as ro
						)
select co.customer_id as "Customer ID", rr.order_id as "Order ID", rr.runner_id as "Runner ID", rr.rating as "Rating", co.order_time as "Order Time", rot.pickup_time "Pickup Time", 
timestampdiff(minute, co.order_time, rot.pickup_time) as "Time between order and pickup(min)", rot.duration as "Duration(min)", round(avg(rot.distance/(rot.duration/60)), 1) as "Average Speed(km/h)", 
count(co.pizza_id) as "Total Number of Pizzas"
from runner_ratings as rr 
inner join customer_orders as co on rr.order_id = co.order_id 
inner join runner_orders_temp as rot on co.order_id = rot.order_id
group by rr.order_id
order by rr.order_id;

--------------------------------------------------------------------------------------
/*
5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras 
and each runner is paid $0.30 per kilometre traveled 
- how much money does Pizza Runner have left over after these deliveries?
*/
with runner_orders_temp as(
					select ro.order_id, ro.runner_id, 
					case
						when ro.distance like 'null' then 0
						else cast(regexp_replace(ro.distance, '[a-z]+', '') as float)
					end as distance 
					from runner_orders as ro
						),
cost_calculation as(
					select rot.runner_id, co.pizza_id, pn.pizza_name, 
                    case 
						when pn.pizza_id = '1' then count(co.order_id) * 12
                        when pn.pizza_id = '2' then count(co.order_id) * 10
					end as cost
                    from customer_orders as co 
                    inner join runner_orders_temp as rot on rot.order_id = co.order_id
                    inner join pizza_names as pn on pn.pizza_id = co.pizza_id
                    where rot.duration > 0
                    group by rot.runner_id, co.pizza_id
                    ),
runner_paid as(
				select rot.runner_id, sum(rot.distance * 0.30) as pay_amount
                from runner_orders_temp as rot
                where rot.distance > 0
                group by rot.runner_id
                )
select cc.runner_id as "Runner", concat(sum(cc.cost), '$') as "Money Made by Pizza Runners", concat(rp.pay_amount, '$') as "Runner's Paying Money", 
concat(round(sum(cc.cost) - (rp.pay_amount), 2), '$') as "Runner's Left Over Money"
from cost_calculation as cc
inner join runner_paid as rp on cc.runner_id = rp.runner_id 
group by cc.runner_id;

################################################# E. Bonus Questions ################################################

/*
If Danny wants to expand his range of pizzas - how would this impact the existing data design? 
Write an INSERT statement to demonstrate what would happen 
if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?
*/
# pizza_names
create temporary table if not exists pizza_names_temp(
													pizza_id int,
													pizza_name text, 
                                                    primary key(pizza_id)
													);
insert into pizza_names_temp (pizza_id, pizza_name)
select pn.pizza_id, pn.pizza_name 
from pizza_names as pn;
insert into pizza_names_temp (pizza_id, pizza_name) value 
(3, 'Supreme pizza');

select * from pizza_names_temp;

#pizza_recipes
create temporary table if not exists pizza_recipes_temp(
													pizza_id int,
													toppings text, 
                                                    primary key(pizza_id)
													);
insert into pizza_recipes_temp (pizza_id, toppings)
select pr.pizza_id, pr.toppings 
from pizza_recipes as pr;
insert into pizza_recipes_temp (pizza_id, toppings) value 
(3, '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12');

select * from pizza_recipes_temp;
