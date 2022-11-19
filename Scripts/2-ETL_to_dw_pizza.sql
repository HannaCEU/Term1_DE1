-- -------------------------------------------------------------------------------
-- CREATE ETL FOR DATA WAREHOUSE TO MERGE ALL RELEVANT DATA AND COMPUTE RELEVANT FIELDS FOR ANALYSIS
-- -------------------------------------------------------------------------------
use pizza;
-- To drop any earlier attempts at creating the procedure and make sure we use most up to date version
-- Create procedure for a unified table with all relevant data with transformations and computations included, e.g. create office hours, vegetarian category, mushrooms
DROP PROCEDURE IF EXISTS ETL_Data_Warehouse;

DELIMITER //

CREATE PROCEDURE ETL_Data_Warehouse()

BEGIN 

DROP TABLE IF EXISTS dw_pizza;

create table dw_pizza as 

SELECT 
 order_details.order_id 
,date  
,str_to_date(time,"%T") as time
,str_to_date(time,"%T") BETWEEN "08:00:00" AND "17:00:00" as officehours
,order_details.pizza_id 
,quantity 
,pizza_types.pizza_type_id
,name 
,category 
,category = "Veggie" as vegetarian
,ingredients
,ingredients LIKE "%Mushrooms%" as mushroom   
,size
,price

FROM orders
INNER JOIN order_details
ON orders.order_id = order_details.order_id
INNER JOIN pizzas
ON order_details.pizza_id = pizzas.pizza_id
INNER JOIN pizza_types
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY order_id;
END //

DELIMITER ;

CAll ETL_Data_Warehouse();
-- Check the structure of the created table and if computed transformations occured
DESCRIBE dw_pizza;
-- View the entire created table
SELECT * FROM pizza.dw_pizza;

-- ------------------------------------------------------------------------------------
-- ------------------------------- ANALYTICS PLAN -------------------------------------
-- ------------------------------------------------------------------------------------
-- This is the final dataset, which includes all relevant for us information to run the following queries
-- in order to answer our research questions: 
-- 1. What are the sales (in total price and quantity) during the office hours?
-- 2. Whether there is higher consumption of mushroom pizza depending on season?
-- 3. How often veggie pizzas are ordered in large size?