## PIZZA Business Analytics – Term Project 1-ECBS 5146 SQL and Different Shapes of Data

This dataset was chosen from Kaggle, as most down-to-life and free sample of data for running a pizza restaurant. I am interested in transforming the raw data for proper business analysis and manipulating it further to prepare mock overview of what a new pizza business owner may expect in terms of sales volume during afternoon, popularity of certain types of pizza depending on the season and whether there is high demand for large vegetarian pizzas to plan accordingly for stocking up produce. 
Operational layer
The operational layer consists of 4 tables in csv.
Loading data and initial ideas
Example Data Import


## EER Diagram 


## Analytics plan
I broke down this project into the following phases: 
1.	Loading the raw data, view and define issues for analysis; 
2.	Create ETL pipeline to produce a denormalised data warehouse
3.	Create ETL pipeline to create data marts for the three research questions below: 
Research questions:
1. What are the sales (in total price and quantity) during the daytime?
2. Whether there is higher consumption on mushroom pizza depending on season?
3. If veggie pizzas are mostly ordered in L size (size vs. category)? 

## Analytical layer
Fact: order_id
Dimension1: time
Dimension2: pizza name
Dimension3: pizza category
Dimension4: quantity
Dimension5: size
Dimension6: price
Dimension7: mushroom (y/n)
Dimension8: season



## Concluding remarks 
