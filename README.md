# PIZZA Business Analytics – Term Project 1-ECBS 5146 SQL and Different Shapes of Data

The pizza sales dataset was chosen from [Kaggle](https://www.kaggle.com/datasets/mysarahmadbhat/pizza-place-sales?resource=download), as most down-to-life and free sample of data for running a pizza restaurant. All data comes from the same year 2015. I am interested in transforming the raw data for proper business analysis and manipulating it further to prepare mock overview of what a new pizza business owner may expect in terms of sales quantity and income during daytime, popularity of certain types of pizza depending on the season and whether there is high demand for large vegetarian pizzas to plan accordingly for stocking up produce. 
## Operational layer
The operational layer consists of [4 tables in csv](https://github.com/HannaCEU/Term1/tree/main/Data_pizza). All datasets were imported into MySQL Workbench using table creation code and then CSVs were uploaded. When reproducing these steps, please, put the csv files into a directory which is accepted on your server and adjust the file path for the code below for loading data.

**Table creation code: example**
```
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  `order_id` INT NOT NULL,
  `date` DATE NOT NULL,
  `time` VARCHAR(8) NOT NULL,
  PRIMARY KEY (`order_id`))
```

**Table population code: example**
```
LOAD DATA INFILE 'C:/Users/grazh/Documents/SQL/SQLfiles_pizza/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```
## EER Diagram 
MySQL Workbench was used for designing initial data [EER Diagram](https://raw.githubusercontent.com/HannaCEU/Term1/main/Diagrams/1-pizza_ERR_diagram.png) with created and cross-checked primary and foreign keys and inserting relevant relationships between the dataframes. 

![1-pizza_ERR_diagram](https://user-images.githubusercontent.com/111881776/202871690-d7dc4a14-e386-4037-bb7a-90154a346229.png)

## ETL-Analytical Layer
The stored procedure function was used in MySQL to merge all the datasets together in order to build the following table (analytical layer), representing facts and dimensions.

![3-Analytical layer](https://user-images.githubusercontent.com/111881776/202871791-13085224-1e75-4607-b6ce-fc22bb1e69be.png)

```
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
```
## Analytical plan

![2-Analytical plan](https://user-images.githubusercontent.com/111881776/202871897-aa4b8a15-16ad-425a-8c1a-303adb2bf856.png)

This project consists of the following **phases**: 
1.	Loading the raw data, view and define issues for analysis. 
2.	Create ETL pipeline to produce a denormalised data warehouse.
3.	Create ETL pipeline to create data marts for **the three research questions** below: 

**Research questions:**
1. What are the sales (in total price and quantity) during the daytime?
2. Whether there is higher consumption on mushroom pizza depending on season?
3. If veggie pizzas are mostly ordered in L size (size vs. category)? 

## Data Marts 
Based on the above research questions, the following [queries](https://github.com/HannaCEU/Term1/blob/main/Scripts/3-Views.sql) were created.

**Sample query**
```
DROP VIEW IF EXISTS Sales_time;
CREATE VIEW Sales_time AS
SELECT SUM(quantity) AS total_quantity,
SUM(price) as total_price
FROM dw_pizza where OfficeHours=1;

SELECT * 
FROM Sales_time; 
```
## Concluding remarks 
Based on the queries outcomes we can provide the following conclusions on our initial questions, as well as apply similar logic to other tasks we may have related to this datastore.

1. What are the sales (in total price and quantity) during the daytime? 

**Outcome**: Total price of the pizzas sold in 2015 during office hours was 433,957USD. The total number of pizzas was 27, 007.

2. Whether there is higher consumption on mushroom pizza depending on season?

**Outcome**: There is no significant difference in consumption of mushroom pizza in different seasons with slight increase in warmer seasons. Thus, 2,303 pizzas with mushrooms in its ingredients were sold in Fall, 2,358 in Winter, 2,545 in Summer and 2,523 in Spring.

3. If veggie pizzas are mostly ordered in L size (size vs. category)? 

**Outcome**: No. Vegetarian pizzas were ordered 5,403 times in large sizes and 6,246 times in not large.
