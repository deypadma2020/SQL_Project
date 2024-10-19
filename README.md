# SQL Case Studies: -

# (A) Here, I have analyzed the data and provided a solution using MySQL queries based on the case studies organized by Steel Data and Matthew Steel.

# Steve's Car Showroom

Scenario:

Steve runs a top-end car showroom but his data analyst has just quit and left him without his crucial insights.
Can you analyse the following data to provide him with all the answers he requires?

------------------------------------------------------------------------------------------------------------------------------

# Esports Tournament

Scenario:

The top eSports competitors from across the globe have gathered to battle it out
Can you analyse the following data to find out all about the tournament?

-------------------------------------------------------------------------------------------------------------------------------

# Customer Insights

Scenario:

You are a Customer Insights Analyst for 'The General Store'
Can you analyse the following tables to find out crucial information about your customers to provide to your marketing team?

--------------------------------------------------------------------------------------------------------------------------------

# Finance Analysis

Scenario:

You are a Finance Analyst working for 'The Big Bank'
You have been tasked with finding out about your customers and their banking behaviour. Examine the accounts they hold and the type of transactions they make to develop greater insight into your customers.

----------------------------------------------------------------------------------------------------------------------------------

# Pub pricing analysis

Scenario:

You are a Pricing Analyst working for a pub chain called 'Pubs "R" Us'
You have been tasked with analysing the drinks prices and sales to gain a greater insight into how the pubs in your chain are performing.

-----------------------------------------------------------------------------------------------------------------------------------

# Marketing Analysis

Scenario:

You are a Marketing Analyst
The 'Sustainable Clothing Co.' have been running several marketing campaigns and have asked you to provide your insight into whether they have been successful or not. Analyse the following data and answer the questions to form your answer.

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

# (B) Here, I have analyzed the data and provided a solution using MySQL queries based on the case studies organized by Danny Ma.

# Danny's Dinner

![1](https://github.com/user-attachments/assets/c94bb078-7b39-431d-bf06-6b022bd00ec9)

Introduction:

Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.

Problem Statement:

Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!

Danny has shared 3 key datasets for this case study:

sales,
menu,
members.

------------------------------------------------------------------------------------------------

# Pizza Runner

![2](https://github.com/user-attachments/assets/51ae7e47-4ffb-446c-8dee-cb94a5a7f958)

Introduction:

Did you know that over 115 million kilograms of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

Problem Statement:

Because Danny had a few years of experience as a data scientist - he was very aware that data collection was going to be critical for his business’ growth.

He has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

This case study has LOTS of questions - they are broken up by area of focus including:

    - Pizza Metrics
    - Runner and Customer Experience
    - Ingredient Optimisation
    - Pricing and Ratings
    - Bonus DML Challenges (DML = Data Manipulation Language)

------------------------------------------------------------------------------------------------

# Foodie-fi

![3](https://github.com/user-attachments/assets/c5f90e58-7b7b-43cb-a100-10f94a63210c)

Introduction:

Subscription based businesses are super popular and Danny realised that there was a large gap in the market - he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. This case study focuses on using subscription style digital data to answer important business questions.

Problem Statement:

Problem Statement: In a rapidly growing market of subscription-based services, Foodie-Fi, a niche streaming platform offering exclusive food-related content, aims to leverage data to guide its business decisions. The challenge lies in analyzing and utilizing subscription-style digital data to address key questions such as customer retention, subscription growth, content preferences, and the impact of pricing models on revenue. By adopting a data-driven approach, Foodie-Fi seeks to optimize its offerings, improve customer experience, and sustain competitive advantage in the streaming industry.

This case study has LOTS of questions - they are broken up by area of focus including:

    - Customer Journey
    - Data Analysis Questions
    - Challenge Payment Question
    - Outside The Box Questions
---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

# (C) Here, I have analyzed the data and provided a solution using MySQL queries based on the case studies organized by Data In Motion.

# Tiny Shop Sales(Customer Order Analysis)

![Tiny-Shop-Sales-624x624](https://github.com/user-attachments/assets/9fc08aeb-e4c7-4d6c-9dfb-5c51646fc424)

Introduction:

In this case study, we are analyzing the sales data of a retail company. The database consists of four primary tables: customers, products, orders, and order_items. These tables store detailed information about customers, the products they purchase, their orders, and the specific items within those orders. Our goal is to extract meaningful insights and answer specific business questions using SQL queries. The data spans across multiple orders made by customers over time, involving various products with different prices.

Problem Statement:

Within this corporate framework, we encounter several key challenges. 

    - Identify the product with the highest price. 
    - Determine the customer who has made the most orders.
    - Calculate the total revenue per product. 
    - Find the day with the highest revenue.
    - Identify the first order for each customer.
    - Identify the top 3 customers who have ordered the most distinct products.
    - Find the least purchased product in terms of quantity.
    - Calculate the median order total.
    - Classify each order based on its total value.
    - Identify customers who have ordered the product with the highest price.
    
By addressing these key business questions, the retail company can gain valuable insights into product performance, customer behavior, and sales trends, enabling more informed strategic decisions and improved business outcomes.

------------------------------------------------------------------------------------------------

# Human Resources

![Human-Resources-Analysis-624x624](https://github.com/user-attachments/assets/e7062cd6-b40d-4029-b178-798796a8fa8f)

Introduction:

In a dynamic corporate environment, managing departments, employees, and projects efficiently is essential for organizational success. The provided SQL schema represents a typical company structure with departments managed by dedicated individuals, employees engaged in various roles, and projects driving departmental objectives. Leveraging this data, we aim to address pertinent challenges to enhance operational effectiveness and employee management.

Problem Statement:

Within this corporate framework, we encounter several key challenges. 

    - Firstly, identifying the longest ongoing project in each department is crucial for resource allocation and project prioritization. 
    - Secondly, delineating employees who are not managers facilitates targeted management strategies and career progression plans. 
    - Thirdly, pinpointing employees hired after project commencement within their department assists in assessing recruitment efficiency and project alignment. 
    - Additionally, ranking employees based on hire dates enables fair performance evaluations and career trajectory planning. 
    - Lastly, computing the duration between consecutive employee hires within departments sheds light on workforce dynamics and succession planning opportunities. 
    
Through comprehensive analysis and strategic insights derived from SQL queries, we aim to address these challenges effectively, fostering organizational excellence and employee satisfaction.

------------------------------------------------------------------------------------------------
