create database if not exists Challenge_4;

use Challenge_4;

-- Create the Customers table
CREATE TABLE Customers (
CustomerID INT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);
--------------------
-- Populate the Customers table
INSERT INTO Customers (CustomerID, FirstName, LastName, City, State)
VALUES (1, 'John', 'Doe', 'New York', 'NY'),
(2, 'Jane', 'Doe', 'New York', 'NY'),
(3, 'Bob', 'Smith', 'San Francisco', 'CA'),
(4, 'Alice', 'Johnson', 'San Francisco', 'CA'),
(5, 'Michael', 'Lee', 'Los Angeles', 'CA'),
(6, 'Jennifer', 'Wang', 'Los Angeles', 'CA');
--------------------
-- Create the Branches table
CREATE TABLE Branches (
BranchID INT PRIMARY KEY,
BranchName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);
--------------------
-- Populate the Branches table
INSERT INTO Branches (BranchID, BranchName, City, State)
VALUES (1, 'Main', 'New York', 'NY'),
(2, 'Downtown', 'San Francisco', 'CA'),
(3, 'West LA', 'Los Angeles', 'CA'),
(4, 'East LA', 'Los Angeles', 'CA'),
(5, 'Uptown', 'New York', 'NY'),
(6, 'Financial District', 'San Francisco', 'CA'),
(7, 'Midtown', 'New York', 'NY'),
(8, 'South Bay', 'San Francisco', 'CA'),
(9, 'Downtown', 'Los Angeles', 'CA'),
(10, 'Chinatown', 'New York', 'NY'),
(11, 'Marina', 'San Francisco', 'CA'),
(12, 'Beverly Hills', 'Los Angeles', 'CA'),
(13, 'Brooklyn', 'New York', 'NY'),
(14, 'North Beach', 'San Francisco', 'CA'),
(15, 'Pasadena', 'Los Angeles', 'CA');
--------------------
-- Create the Accounts table
CREATE TABLE Accounts (
AccountID INT PRIMARY KEY,
CustomerID INT NOT NULL,
BranchID INT NOT NULL,
AccountType VARCHAR(50) NOT NULL,
Balance DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);
--------------------
-- Populate the Accounts table
INSERT INTO Accounts (AccountID, CustomerID, BranchID, AccountType, Balance)
VALUES (1, 1, 5, 'Checking', 1000.00),
(2, 1, 5, 'Savings', 5000.00),
(3, 2, 1, 'Checking', 2500.00),
(4, 2, 1, 'Savings', 10000.00),
(5, 3, 2, 'Checking', 7500.00),
(6, 3, 2, 'Savings', 15000.00),
(7, 4, 8, 'Checking', 5000.00),
(8, 4, 8, 'Savings', 20000.00),
(9, 5, 14, 'Checking', 10000.00),
(10, 5, 14, 'Savings', 50000.00),
(11, 6, 2, 'Checking', 5000.00),
(12, 6, 2, 'Savings', 10000.00),
(13, 1, 5, 'Credit Card', -500.00),
(14, 2, 1, 'Credit Card', -1000.00),
(15, 3, 2, 'Credit Card', -2000.00);
--------------------
-- Create the Transactions table
CREATE TABLE Transactions (
TransactionID INT PRIMARY KEY,
AccountID INT NOT NULL,
TransactionDate DATE NOT NULL,
Amount DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
--------------------
-- Populate the Transactions table
INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount)
VALUES (1, 1, '2022-01-01', -500.00),
(2, 1, '2022-01-02', -250.00),
(3, 2, '2022-01-03', 1000.00),
(4, 3, '2022-01-04', -1000.00),
(5, 3, '2022-01-05', 500.00),
(6, 4, '2022-01-06', 1000.00),
(7, 4, '2022-01-07', -500.00),
(8, 5, '2022-01-08', -2500.00),
(9, 6, '2022-01-09', 500.00),
(10, 6, '2022-01-10', -1000.00),
(11, 7, '2022-01-11', -500.00),
(12, 7, '2022-01-12', -250.00),
(13, 8, '2022-01-13', 1000.00),
(14, 8, '2022-01-14', -1000.00),
(15, 9, '2022-01-15', 500.00);

-------------------------------------------------------------------------------------------
# extracting all the data present into 'Customers' table
select * from Customers;

# extracting all the data present into 'Branches' table
select * from Branches;

# extracting all the data present into 'Accounts' table
select * from Accounts;

# extracting all the data present into 'Transactions' table
select * from Transactions;

-----------------------------------------------------------------------------------
# 1. What are the names of all the customers who live in New York?
select concat(c.FirstName, " ", c.LastName) as "Customer Name"
from Customers as c
where c.City = 'New York';

------------------------------------------------------------------------------------
# 2. What is the total number of accounts in the Accounts table?
select count(a.AccountID) as "Number of Accounts" 
from Accounts as a;

------------------------------------------------------------------------------------
# 3. What is the total balance of all checking accounts?
select sum(a.Balance) as "Total Balance"
from Accounts as a
where a.AccountType like "%checking%";

------------------------------------------------------------------------------------
# 4. What is the total balance of all accounts associated with customers who live in Los Angeles?
select sum(a.Balance) as "Total Balance" 
from Accounts as a
inner join Customers as c on a.CustomerID = c.CustomerID
where c.City = 'Los Angeles';

------------------------------------------------------------------------------------
# 5. Which branch has the highest average account balance?
select b.BranchName as "Branch Name", round(avg(a.Balance),2) as "Average Balance" 
from Accounts as a
inner join Branches as b on a.BranchID = b.BranchID
group by b.BranchName
order by avg(a.Balance) desc limit 1;

------------------------------------------------------------------------------------
# 6. Which customer has the highest current balance in their accounts?
select concat(c.FirstName, " ", c.LastName) as "Customer Name", sum(a.Balance) as "Current Balance"
from Accounts as a
inner join Customers as c on a.CustomerID = c.CustomerID
group by concat(c.FirstName, " ", c.LastName)
order by sum(a.Balance) desc limit 1;

-------------------------------------------------------------------------------------
# 7. Which customer has made the most transactions in the Transactions table?
select c.CustomerID, concat(c.FirstName, " ", c.LastName) as "Customer Name", sum(abs(t.Amount)) as "Most Transaction Amount"
from Customers as c
inner join Accounts as a on c.CustomerID = a.CustomerID
inner join Transactions as t on a.AccountID = t.TransactionID
group by concat(c.FirstName, " ", c.LastName)
order by sum(abs(t.Amount)) desc limit 2;

------------------------------------------------------------------------------------
# 8.Which branch has the highest total balance across all of its accounts?
select b.BranchName as "Branch Name", sum(a.Balance) as "Total Balance"
from Accounts as a
inner join Branches as b on a.BranchID = b.BranchID
group by b.BranchName
order by sum(a.Balance) desc limit 1;

-----------------------------------------------------------------------------------
# 9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts?
select concat(c.FirstName, " ", c.LastName) as "Customer Name", sum(a.Balance) as "Total Balance" 
from Accounts as a
inner join Customers as c on a.CustomerID = c.CustomerID
where a.AccountType in ("savings" and "checking")
group by concat(c.FirstName, " ", C.LastName) 
order by sum(a.Balance) desc limit 1;

---------------------------------------------------------------------------------
# 10. Which branch has the highest number of transactions in the Transactions table?
select b.BranchName as "Branch Name", count(t.TransactionID) as "No. of Transactions"
from Branches as b
inner join Accounts as a on b.BranchID = a.BranchID
inner join Transactions as t on a.AccountID = t.AccountID
group by b.BranchName
order by count(t.TransactionID) desc limit 2;