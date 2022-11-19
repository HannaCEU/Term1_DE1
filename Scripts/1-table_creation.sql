-- Loading all the raw data into MySQL Workbench from https://www.kaggle.com/datasets/mysarahmadbhat/pizza-place-sales?resource=download
-- Put the csv files into a directory which is accepted on your server and adjust the file path for the code below for loading data.

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema pizza
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema pizza
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS pizza;
CREATE SCHEMA pizza DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE pizza ;

-- -----------------------------------------------------
-- Create table pizza.orders
-- -----------------------------------------------------
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  `order_id` INT NOT NULL,
  `date` DATE NOT NULL,
  `time` VARCHAR(8) NOT NULL,
  PRIMARY KEY (`order_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- put the files into a directory which is accepted on your server and adjust the file path
-- LOAD DATA INFILE 'C:/Users/grazh/Documents/SQL/SQLfiles_pizza/orders.csv'
-- INTO TABLE orders
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;


-- -----------------------------------------------------
-- Create table pizza_types
-- -----------------------------------------------------
USE pizza; 
DROP TABLE IF EXISTS pizza_types;
CREATE TABLE pizza_types (
  `pizza_type_id` VARCHAR(12) NOT NULL,
  `name` VARCHAR(42) NOT NULL,
  `category` VARCHAR(7) NOT NULL,
  `ingredients` VARCHAR(97) NOT NULL,
  PRIMARY KEY (`pizza_type_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- put the files into a directory which is accepted on your server and adjust the file path
-- LOAD DATA INFILE 'C:/Users/grazh/Documents/SQL/SQLfiles_pizza/pizza_types.csv'
-- INTO TABLE pizza_types
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;
-- -----------------------------------------------------
-- Create table pizzas
-- -----------------------------------------------------
USE pizza;
DROP TABLE IF EXISTS pizzas;
CREATE TABLE pizzas (
  `pizza_id` VARCHAR(14) NOT NULL,
  `pizza_type_id` VARCHAR(12) NOT NULL,
  `size` VARCHAR(3) NOT NULL,
  `price` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`pizza_id`),
  INDEX `pizza_type_id_idx` (`pizza_type_id` ASC),
  CONSTRAINT `pizza_type_id`
    FOREIGN KEY (`pizza_type_id`)
    REFERENCES pizza.pizza_types (`pizza_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- put the files into a directory which is accepted on your server and adjust the file path
-- LOAD DATA INFILE 'C:/Users/grazh/Documents/SQL/SQLfiles_pizza/pizzas.csv'
-- INTO TABLE pizzas
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;
-- -----------------------------------------------------
-- Create table order_details
-- -----------------------------------------------------
use pizza;
DROP TABLE IF EXISTS order_details;
CREATE TABLE order_details(
  `order_details_id` INT NOT NULL,
  `order_id` INT NOT NULL,
  `pizza_id` VARCHAR(14) NOT NULL,
  `quantity` INT NOT NULL,
  PRIMARY KEY (`order_details_id`),
  INDEX `pizza_id_idx` (`pizza_id` ASC),
  CONSTRAINT `order_id`
    FOREIGN KEY (`order_id`)
    REFERENCES pizza.orders (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `pizza_id`
    FOREIGN KEY (`pizza_id`)
    REFERENCES `pizza`.`pizzas` (`pizza_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- put the files into a directory which is accepted on your server and adjust the file path
-- LOAD DATA INFILE 'C:/Users/grazh/Documents/SQL/SQLfiles_pizza/order_details.csv'
-- INTO TABLE order_details
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;
-- ----------------------------------------------------------------------------------------------
-- ---------MORE QUERIES FOR UNDERSTANDING DATA--------------------------------
-- ----------------------------------------------------------------------------------------------
-- Describe data in the created tables--
DESCRIBE orders; 
DESCRIBE pizza_types;
DESCRIBE pizzas; 
DESCRIBE order_details;

SELECT COUNT(DISTINCT (pizza_id)) FROM order_details; -- 91 good coverage
SELECT COUNT(DISTINCT (pizza_id)) FROM pizzas; -- 96 good coverage
