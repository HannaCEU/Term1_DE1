USE pizza;
-- Calling the final stored procedure to make sure the data is current
CALL ETL_Data_Warehouse();
-- 1. What are the sales (in total price and quantity) during the office hours? 
-- Creating view for total quantity and total price of pizzas sold during office hours
DROP VIEW IF EXISTS Sales_time;
CREATE VIEW Sales_time AS
SELECT SUM(quantity) AS total_quantity,
SUM(price) as total_price
FROM dw_pizza where OfficeHours=1;

SELECT * 
FROM Sales_time; 

-- 2. Whether there is higher consumption on mushroom pizza depending on season?
-- Creating view for mushroom pizza sales and transforming date data for defining season
DROP VIEW IF EXISTS Mushroom_Pizza;
CREATE VIEW Mushroom_Pizza AS
SELECT SUM(quantity),
CASE
WHEN date BETWEEN '2015-03-01' AND '2015-05-30' THEN 'Spring'
WHEN date BETWEEN '2015-06-01' AND '2015-08-31' THEN 'Summer'
WHEN date BETWEEN '2015-09-01' AND '2015-11-30' THEN 'Fall'
ELSE 'Winter'
END as season
FROM dw_pizza WHERE mushroom = 1
group by season
order BY SUM(quantity);

Select *
FROM Mushroom_pizza;

-- Are veggie pizzas mostly ordered in L size (size vs. category)?
-- Creating view for vegetarian pizza sales and transforming size data for it
DROP VIEW IF EXISTS Veggie_Pizza_Size;
CREATE VIEW Veggie_Pizza_Size AS
SELECT SUM(quantity),
CASE
WHEN size LIKE 'L' THEN 'Large'
WHEN size LIKE 'XL' THEN 'XLarge'
WHEN size LIKE 'XXL' THEN 'XXLarge'
ELSE 'Not Large'
END as size_veggie
FROM dw_pizza where vegetarian = 1
group by size_veggie
order BY SUM(quantity);

SELECT *
FROM Veggie_Pizza_Size;




