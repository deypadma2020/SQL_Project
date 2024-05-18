create database if not exists customer_orders_analysis;

use customer_orders_analysis;

CREATE TABLE customers (
    customer_id integer PRIMARY KEY,
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100)
);

CREATE TABLE products (
    product_id integer PRIMARY KEY,
    product_name varchar(100),
    price decimal
);

CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    customer_id integer,
    order_date date
);

CREATE TABLE order_items (
    order_id integer,
    product_id integer,
    quantity integer
);

INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
(1, 'John', 'Doe', 'johndoe@email.com'),
(2, 'Jane', 'Smith', 'janesmith@email.com'),
(3, 'Bob', 'Johnson', 'bobjohnson@email.com'),
(4, 'Alice', 'Brown', 'alicebrown@email.com'),
(5, 'Charlie', 'Davis', 'charliedavis@email.com'),
(6, 'Eva', 'Fisher', 'evafisher@email.com'),
(7, 'George', 'Harris', 'georgeharris@email.com'),
(8, 'Ivy', 'Jones', 'ivyjones@email.com'),
(9, 'Kevin', 'Miller', 'kevinmiller@email.com'),
(10, 'Lily', 'Nelson', 'lilynelson@email.com'),
(11, 'Oliver', 'Patterson', 'oliverpatterson@email.com'),
(12, 'Quinn', 'Roberts', 'quinnroberts@email.com'),
(13, 'Sophia', 'Thomas', 'sophiathomas@email.com');

INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Product A', 10.00),
(2, 'Product B', 15.00),
(3, 'Product C', 20.00),
(4, 'Product D', 25.00),
(5, 'Product E', 30.00),
(6, 'Product F', 35.00),
(7, 'Product G', 40.00),
(8, 'Product H', 45.00),
(9, 'Product I', 50.00),
(10, 'Product J', 55.00),
(11, 'Product K', 60.00),
(12, 'Product L', 65.00),
(13, 'Product M', 70.00);

INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2023-05-01'),
(2, 2, '2023-05-02'),
(3, 3, '2023-05-03'),
(4, 1, '2023-05-04'),
(5, 2, '2023-05-05'),
(6, 3, '2023-05-06'),
(7, 4, '2023-05-07'),
(8, 5, '2023-05-08'),
(9, 6, '2023-05-09'),
(10, 7, '2023-05-10'),
(11, 8, '2023-05-11'),
(12, 9, '2023-05-12'),
(13, 10, '2023-05-13'),
(14, 11, '2023-05-14'),
(15, 12, '2023-05-15'),
(16, 13, '2023-05-16');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 2, 1),
(2, 3, 3),
(3, 1, 1),
(3, 3, 2),
(4, 2, 4),
(4, 3, 1),
(5, 1, 1),
(5, 3, 2),
(6, 2, 3),
(6, 1, 1),
(7, 4, 1),
(7, 5, 2),
(8, 6, 3),
(8, 7, 1),
(9, 8, 2),
(9, 9, 1),
(10, 10, 3),
(10, 11, 2),
(11, 12, 1),
(11, 13, 3),
(12, 4, 2),
(12, 5, 1),
(13, 6, 3),
(13, 7, 2),
(14, 8, 1),
(14, 9, 2),
(15, 10, 3),
(15, 11, 1),
(16, 12, 2),
(16, 13, 3);

---------------------------------------------------------------------------
select * from  customers;
select * from  products;
select * from  orders;
select * from  order_items;

------------------------------------------------------------------------------------
/*
1. Which product has the highest price? Only return a single row.
*/
with cte as(select 
				p.product_name, p.price,
                row_number() over(order by p.price desc) as price_rank
				from products as p
)
select cte.product_name as 'Product Name', cte.price as 'Price'
from cte
where price_rank = 1;

------------------------------------------------------------------------------------
/*
2. Which customer has made the most orders?
*/
with cte as(select
				o.customer_id, count(o.order_date) as count_of_orders,
                dense_rank() over (order by count(o.order_date) desc) as order_rank
                from orders as o
                group by o.customer_id
)
select concat(c.first_name, ' ', c.last_name) as 'Customer Name', cte.count_of_orders as 'Count Of Oders'
from customers as c
inner join cte on c.customer_id = cte.customer_id
where cte.order_rank = 1;

------------------------------------------------------------------------------------
/*
3. What’s the total revenue per product?
*/
select p.product_name as 'Product Name', sum(p.price * oi.quantity) as 'Revenue'
from products as p 
inner join order_items as oi on p.product_id = oi.product_id
group by p.product_name
order by sum(p.price * oi.quantity) desc;

------------------------------------------------------------------------------------
/*
4. Find the day with the highest revenue.
*/
with cte as(select
				p.product_name, o.order_date, sum(p.price * oi.quantity) as revenue, 
                rank() over (order by sum(p.price * oi.quantity) desc) as revenue_rank
				from products as p 
				inner join order_items as oi on p.product_id = oi.product_id
                inner join orders as o on oi.order_id = o.order_id
				group by p.product_name, o.order_date
)
select cte.product_name as 'Product Name', cte.order_date as 'Order Date', cte.revenue as 'Revenue'
from cte
where cte.revenue_rank = 1;

------------------------------------------------------------------------------------
/*
5. Find the first order (by date) for each customer.
*/
with cte as(select
				o.customer_id, o.order_date, 
                row_number() over (partition by o.customer_id order by o.order_date desc) as order_date_rank
				from orders as o 
)
select concat(c.first_name, ' ', c.last_name) as 'Customer Name', cte.order_date as 'Order Date'
from customers as c
inner join cte on c.customer_id = cte.customer_id
where cte.order_date_rank = 1;

------------------------------------------------------------------------------------
/*
6. Find the top 3 customers who have ordered the most distinct products
*/
with cte as(select
				c.customer_id,
                count(distinct oi.product_id) as pdt_count,
                rank() over(order by count(distinct oi.product_id) desc)as order_rank
                from order_items as oi
                inner join orders as o on oi.order_id = o.order_id
                inner join customers as c on c.customer_id = o.customer_id
                group by c.customer_id
)
select concat(c.first_name, ' ', c.last_name) as 'Customer Name', cte.pdt_count as 'Distinct Product Count'
from customers as c
inner join cte on c.customer_id = cte.customer_id
where order_rank <= 3
order by cte.pdt_count, concat(c.first_name, ' ', c.last_name) desc
limit 3;

------------------------------------------------------------------------------------
/*
7. Which product has been bought the least in terms of quantity?
*/
with cte as(select
				oi.product_id, sum(oi.quantity) as total_quantity,
                rank() over (order by sum(oi.quantity)) as quantity_rank
                from order_items as oi
                group by oi.product_id
)
select p.product_name as 'Product Name', cte.total_quantity as 'Quantity'
from products as p
inner join cte on p.product_id = cte.product_id
where cte.quantity_rank = 1
order by p.product_name;

------------------------------------------------------------------------------------
/*
8. What is the median order total?
*/
with cte as(select
			oi.order_id, sum(oi.quantity * p.price) as total_order_amount,
            row_number() over (order by sum(oi.quantity * p.price)) as row_num,
            count(*) over () as total_rows
            from order_items as oi
            inner join products as p on oi.product_id = p.product_id
            group by oi.order_id
)
select total_order_amount as 'Median Order Total'
from cte 
where row_num = ceil(total_rows/ 2.0);

------------------------------------------------------------------------------------
/*
9. For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.
*/
select oI.order_id as 'Order ID', sum(oi.quantity * p.price) as 'Order Total', 
case
	when sum(oi.quantity * p.price) > 300 then 'Expensive'
    when sum(oi.quantity * p.price) > 100 then 'Afforrdable'
    else 'Cheap'
end as 'Order Classification'
from products as p
inner join order_items as oi on p.product_id = oi.product_id
group by oi.order_id
order by sum(oi.quantity * p.price) desc;

------------------------------------------------------------------------------------
/*
10. Find customers who have ordered the product with the highest price.
*/
with highest_price as(select
							max(p.price) as max_price
                            from products as p
)
select concat(c.first_name, ' ', c.last_name) as 'Customer Name', p.product_name as 'Product Name', p.price as 'Price Amount'
from customers as c
inner join orders as o on c.customer_id = o.customer_id 
inner join order_items as oi on o.order_id = oi.order_id
inner join products as p on oi.product_id = p.product_id
where p.price = (select max_price from highest_price)
order by concat(c.first_name, ' ', c.last_name);
