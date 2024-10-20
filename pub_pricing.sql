create database if not exists pub_pricing;

use pub_pricing;

drop table if exists pubs;

-- Create the 'pubs' table
CREATE TABLE pubs (
pub_id INT PRIMARY KEY,
pub_name VARCHAR(50),
city VARCHAR(50),
state VARCHAR(50),
country VARCHAR(50)
);
--------------------

drop table if exists beverages;

-- Create the 'beverages' table
CREATE TABLE beverages (
beverage_id INT PRIMARY KEY,
beverage_name VARCHAR(50),
category VARCHAR(50),
alcohol_content FLOAT,
price_per_unit DECIMAL(8, 2)
);
--------------------

drop table if exists sales;

-- Create the 'sales' table
CREATE TABLE sales (
sale_id INT PRIMARY KEY,
pub_id INT,
beverage_id INT,
quantity INT,
transaction_date DATE,
FOREIGN KEY (pub_id) REFERENCES pubs(pub_id),
FOREIGN KEY (beverage_id) REFERENCES beverages(beverage_id)
);
--------------------

drop table if exists ratings;

-- Create the 'ratings' table 
CREATE TABLE ratings ( 
rating_id INT PRIMARY KEY, 
pub_id INT, 
customer_name VARCHAR(50), 
rating FLOAT, 
review TEXT, 
FOREIGN KEY (pub_id) REFERENCES pubs(pub_id) );
--------------------
-- Insert sample data into the 'pubs' table
INSERT INTO pubs (pub_id, pub_name, city, state, country)
VALUES
(1, 'The Red Lion', 'London', 'England', 'United Kingdom'),
(2, 'The Dubliner', 'Dublin', 'Dublin', 'Ireland'),
(3, 'The Cheers Bar', 'Boston', 'Massachusetts', 'United States'),
(4, 'La Cerveceria', 'Barcelona', 'Catalonia', 'Spain');
--------------------
-- Insert sample data into the 'beverages' table
INSERT INTO beverages (beverage_id, beverage_name, category, alcohol_content, price_per_unit)
VALUES
(1, 'Guinness', 'Beer', 4.2, 5.99),
(2, 'Jameson', 'Whiskey', 40.0, 29.99),
(3, 'Mojito', 'Cocktail', 12.0, 8.99),
(4, 'Chardonnay', 'Wine', 13.5, 12.99),
(5, 'IPA', 'Beer', 6.8, 4.99),
(6, 'Tequila', 'Spirit', 38.0, 24.99);
--------------------
INSERT INTO sales (sale_id, pub_id, beverage_id, quantity, transaction_date)
VALUES
(1, 1, 1, 10, '2023-05-01'),
(2, 1, 2, 5, '2023-05-01'),
(3, 2, 1, 8, '2023-05-01'),
(4, 3, 3, 12, '2023-05-02'),
(5, 4, 4, 3, '2023-05-02'),
(6, 4, 6, 6, '2023-05-03'),
(7, 2, 3, 6, '2023-05-03'),
(8, 3, 1, 15, '2023-05-03'),
(9, 3, 4, 7, '2023-05-03'),
(10, 4, 1, 10, '2023-05-04'),
(11, 1, 3, 5, '2023-05-06'),
(12, 2, 2, 3, '2023-05-09'),
(13, 2, 5, 9, '2023-05-09'),
(14, 3, 6, 4, '2023-05-09'),
(15, 4, 3, 7, '2023-05-09'),
(16, 4, 4, 2, '2023-05-09'),
(17, 1, 4, 6, '2023-05-11'),
(18, 1, 6, 8, '2023-05-11'),
(19, 2, 1, 12, '2023-05-12'),
(20, 3, 5, 5, '2023-05-13');
--------------------
-- Insert sample data into the 'ratings' table
INSERT INTO ratings (rating_id, pub_id, customer_name, rating, review)
VALUES
(1, 1, 'John Smith', 4.5, 'Great pub with a wide selection of beers.'),
(2, 1, 'Emma Johnson', 4.8, 'Excellent service and cozy atmosphere.'),
(3, 2, 'Michael Brown', 4.2, 'Authentic atmosphere and great beers.'),
(4, 3, 'Sophia Davis', 4.6, 'The cocktails were amazing! Will definitely come back.'),
(5, 4, 'Oliver Wilson', 4.9, 'The wine selection here is outstanding.'),
(6, 4, 'Isabella Moore', 4.3, 'Had a great time trying different spirits.'),
(7, 1, 'Sophia Davis', 4.7, 'Loved the pub food! Great ambiance.'),
(8, 2, 'Ethan Johnson', 4.5, 'A good place to hang out with friends.'),
(9, 2, 'Olivia Taylor', 4.1, 'The whiskey tasting experience was fantastic.'),
(10, 3, 'William Miller', 4.4, 'Friendly staff and live music on weekends.');
-------------------------------------------------------------------------------
# extracting all the data present into 'pubs' table
select * from pubs;

# extracting all the data present into 'beverages' table
select * from beverages;

# extracting all the data present into 'sales' table
select * from sales;

# extracting all the data present into 'ratings' table
select * from ratings;

-----------------------------------------------------------------------------------
# 1. How many pubs are located in each country?
select p.country as "Country Name", count(p.pub_id) as "No. of Pub"
from pubs as p
group by p.country
order by count(p.pub_id) desc;

------------------------------------------------------------------------------------
# 2. What is the total sales amount for each pub, including the beverage price and quantity sold?
select p.pub_name as "Pub Name", sum(b.price_per_unit * s.quantity) as "Total Sales Amount"
from sales as s
inner join pubs as p on s.pub_id = p.pub_id
inner join beverages as b on s.beverage_id = b.beverage_id
group by p.pub_name
order by sum(b.price_per_unit * s.quantity) desc;

-------------------------------------------------------------------------------------
# 3. Which pub has the highest average rating?
select p.pub_name as "Pub Name", round(avg(r.rating),2) as "Avg Rating"
from ratings as r
inner join pubs as p on r.pub_id = p.pub_id
group by p.pub_name
order by round(avg(r.rating),2) desc limit 1;

--------------------------------------------------------------------------------------
# 4. What are the top 5 beverages by sales quantity across all pubs?
select b.beverage_name as "Beverage Name", sum(s.quantity) as "Quantity"
from beverages as b
inner join sales as s on b.beverage_id = s.beverage_id
group by b.beverage_name
order by sum(s.quantity) desc limit 5;

--------------------------------------------------------------------------------------
# 5. How many sales transactions occurred on each date?
select s.transaction_date as "Transaction Date", count(s.sale_id) as "Count of Sales Transactions"
from sales as s
group by s.transaction_date
order by count(s.sale_id) desc;

--------------------------------------------------------------------------------------
# 6. Find the name of someone that had cocktails and which pub they had it in.
select r.customer_name as "Customer Name", p.pub_name as "Pub Name" 
from sales as s
inner join ratings as r on s.pub_id = r.pub_id
inner join pubs as p on s.pub_id = p.pub_id
inner join beverages as b on s.beverage_id = b.beverage_id
where b.category like "%cocktail%";

--------------------------------------------------------------------------------------
# 7. What is the average price per unit for each category of beverages, excluding the category 'Spirit'?
select b.category as "Beverage Category", round(avg(b.price_per_unit),2) as "Avg Price Per Unit" 
from beverages as b
where b.category <> 'Spirit'
group by b.category
order by round(avg(b.price_per_unit),2) desc;

----------------------------------------------------------------------------------------
# 8. Which pubs have a rating higher than the average rating of all pubs?
select p.pub_name as "Pub Name", round(avg(r.rating),1) as "Rating (higher than avg Rating)"
from ratings as r 
inner join pubs as p on r.pub_id = p.pub_id
group by p.pub_name having avg(r.rating) > (select avg(r.rating) from ratings as r)
order by avg(r.rating) desc;

----------------------------------------------------------------------------------------
# 9. What is the running total of sales amount for each pub, ordered by the transaction date?
select p.pub_name as "Pub Name", s.transaction_date as "Transaction Date", b.price_per_unit as "Price Per Unit", s.quantity as "Quantity",
sum(b.price_per_unit * s.quantity) over (partition by s.pub_id order by s.transaction_date) as "Total Sales Amount"
from sales as s
inner join pubs as p on s.pub_id = p.pub_id
inner join beverages as b on s.beverage_id = b.beverage_id
order by s.transaction_date ;

----------------------------------------------------------------------------------------
# 10. For each country, what is the average price per unit of beverages in each category, and what is the overall average price per unit of beverages across all categories?
select p.country as "Country", b.category as "Beverage Category", round(avg(b.price_per_unit) over (partition by p.country), 2) as "Average Price/unit by Country", 
round(avg(b.price_per_unit), 2) as "Average Price/unit by Category"
from beverages as b
inner join sales as s on b.beverage_id = s.beverage_id
inner join pubs as p on s.pub_id = p.pub_id
group by p.country, b.category 
order by round(avg(b.price_per_unit), 2), round(avg(b.price_per_unit) over (partition by p.country), 2) desc;

------------------------------------------------------------------------------------------
# 11. For each pub, what is the percentage contribution of each category of beverages to the total sales amount, and what is the pub's overall sales amount?
with individual_pub_sales as (
    select p.pub_name, b.category, sum(s.quantity * b.price_per_unit) as total_sales_amount_by_category
    from sales as s
    inner join pubs as p on s.pub_id = p.pub_id
    inner join beverages as b on s.beverage_id = b.beverage_id
    group by p.pub_name, b.category
), 
	total_pub_sales as (
    select p.pub_name, sum(s.quantity * b.price_per_unit) as total_sales_amount
    from sales as s
    inner join pubs as p on s.pub_id = p.pub_id
    inner join beverages as b on s.beverage_id = b.beverage_id
    group by p.pub_name
)
select ips.pub_name as "Pub Name", ips.category as "Category", round(ips.total_sales_amount_by_category / tps.total_sales_amount * 100, 2) as "Percentage Contribution", 
tps.total_sales_amount as "Pub's Overall Sales Amount"
from individual_pub_sales as ips
inner join total_pub_sales as tps on ips.pub_name = tps.pub_name;
