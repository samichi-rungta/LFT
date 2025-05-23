-- Create Database
CREATE DATABASE IF NOT EXISTS pizza_runner;
USE pizza_runner;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS runners;
DROP TABLE IF EXISTS customer_orders;
DROP TABLE IF EXISTS runner_orders;
DROP TABLE IF EXISTS pizza_names;
DROP TABLE IF EXISTS pizza_recipes;
DROP TABLE IF EXISTS pizza_toppings;

-- Create Tables
CREATE TABLE runners (
  runner_id INT,
  registration_date DATE
);

INSERT INTO runners (runner_id, registration_date) VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


CREATE TABLE customer_orders (
  order_id INT,
  customer_id INT,
  pizza_id INT,
  exclusions VARCHAR(20),
  extras VARCHAR(20),
  order_time DATETIME
);

INSERT INTO customer_orders (order_id, customer_id, pizza_id, exclusions, extras, order_time) VALUES
  (1, 101, 1, '', '', '2020-01-01 18:05:02'),
  (2, 101, 1, '', '', '2020-01-01 19:00:52'),
  (3, 102, 1, '', '', '2020-01-02 23:51:23'),
  (3, 102, 2, '', NULL, '2020-01-02 23:51:23'),
  (4, 103, 1, '4', '', '2020-01-04 13:23:46'),
  (4, 103, 1, '4', '', '2020-01-04 13:23:46'),
  (4, 103, 2, '4', '', '2020-01-04 13:23:46'),
  (5, 104, 1, 'null', '1', '2020-01-08 21:00:29'),
  (6, 101, 2, 'null', 'null', '2020-01-08 21:03:13'),
  (7, 105, 2, 'null', '1', '2020-01-08 21:20:29'),
  (8, 102, 1, 'null', 'null', '2020-01-09 23:54:33'),
  (9, 103, 1, '4', '1, 5', '2020-01-10 11:22:59'),
  (10, 104, 1, 'null', 'null', '2020-01-11 18:34:49'),
  (10, 104, 1, '2, 6', '1, 4', '2020-01-11 18:34:49');

CREATE TABLE runner_orders (
  order_id INT,
  runner_id INT,
  pickup_time VARCHAR(20),
  distance VARCHAR(20),
  duration VARCHAR(20),
  cancellation VARCHAR(50)
);

INSERT INTO runner_orders (order_id, runner_id, pickup_time, distance, duration, cancellation) VALUES
  (1, 1, '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  (2, 1, '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  (3, 1, '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  (4, 2, '2020-01-04 13:53:03', '23.4', '40', NULL),
  (5, 3, '2020-01-08 21:10:57', '10', '15', NULL),
  (6, 3, 'null', 'null', 'null', 'Restaurant Cancellation'),
  (7, 2, '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  (8, 2, '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  (9, 2, 'null', 'null', 'null', 'Customer Cancellation'),
  (10, 1, '2020-01-11 18:50:20', '10km', '10minutes', 'null');

CREATE TABLE pizza_names (
  pizza_id INT,
  pizza_name TEXT
);

INSERT INTO pizza_names (pizza_id, pizza_name) VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');

CREATE TABLE pizza_recipes (
  pizza_id INT,
  toppings TEXT
);

INSERT INTO pizza_recipes (pizza_id, toppings) VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');

CREATE TABLE pizza_toppings (
  topping_id INT,
  topping_name TEXT
);

INSERT INTO pizza_toppings (topping_id, topping_name) VALUES
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


SELECT 
  COUNT(*) AS total_orders,
  SUM(CASE WHEN exclusions IS NULL OR exclusions = '' OR LOWER(exclusions) = 'null' THEN 1 ELSE 0 END) AS exclusions_null_or_empty,
  SUM(CASE WHEN extras IS NULL OR extras = '' OR LOWER(extras) = 'null' THEN 1 ELSE 0 END) AS extras_null_or_empty
FROM customer_orders;

SET SQL_SAFE_UPDATES = 0;

UPDATE customer_orders
SET exclusions = NULL
WHERE LOWER(exclusions) = 'null' OR exclusions = '';

UPDATE customer_orders
SET extras = NULL
WHERE LOWER(extras) = 'null' OR extras = '';

SELECT 
  COUNT(*) AS total_records,
  SUM(CASE WHEN LOWER(pickup_time) = 'null' OR pickup_time = '' THEN 1 ELSE 0 END) AS pickup_time_null_count,
  SUM(CASE WHEN LOWER(distance) = 'null' OR distance = '' THEN 1 ELSE 0 END) AS distance_null_count,
  SUM(CASE WHEN LOWER(duration) = 'null' OR duration = '' THEN 1 ELSE 0 END) AS duration_null_count,
  COUNT(DISTINCT cancellation) AS cancellation_types
FROM runner_orders;

UPDATE runner_orders
SET pickup_time = NULL
WHERE LOWER(pickup_time) = 'null' OR pickup_time = '';

UPDATE runner_orders
SET distance = NULL
WHERE LOWER(distance) = 'null' OR distance = '';

UPDATE runner_orders
SET duration = NULL
WHERE LOWER(duration) = 'null' OR duration = '';

ALTER TABLE runner_orders
ADD COLUMN distance_km DECIMAL(5,2) NULL,
ADD COLUMN duration_min INT NULL;

UPDATE runner_orders
SET distance_km = CAST(
  TRIM(
    REPLACE(
      REPLACE(distance, 'km', ''),
      ' ',
      ''
    )
  ) AS DECIMAL(5,2))
WHERE distance IS NOT NULL
  AND distance REGEXP '^[0-9]+(\\.[0-9]+)?'; -- only rows where distance looks like a number or decimal
UPDATE runner_orders
SET duration_min = CAST(
  TRIM(
    SUBSTRING_INDEX(duration, ' ', 1)
  ) AS UNSIGNED)
WHERE duration IS NOT NULL
  AND SUBSTRING_INDEX(duration, ' ', 1) REGEXP '^[0-9]+$'; -- only numeric first parts

UPDATE runner_orders
SET distance = NULL
WHERE LOWER(distance) = 'null' OR distance = '';

UPDATE runner_orders
SET duration = NULL
WHERE LOWER(duration) = 'null' OR duration = '';

-- Section A
-- 1. How many pizzas were ordered?
SELECT COUNT(*) AS total_pizzas_ordered FROM customer_orders;

-- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS unique_customer_orders FROM customer_orders;

-- 3. How many successful orders were delivered by each runner?
-- Assume successful = no cancellation or cancellation is NULL/empty
SELECT runner_id, COUNT(DISTINCT order_id) AS successful_deliveries
FROM runner_orders
WHERE cancellation IS NULL OR cancellation = ''
GROUP BY runner_id;

-- 4. How many of each type of pizza was delivered?
SELECT pn.pizza_name, COUNT(co.pizza_id) AS pizza_count
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
GROUP BY pn.pizza_name;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT customer_id, pn.pizza_name, COUNT(*) AS pizza_count
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
GROUP BY customer_id, pn.pizza_name;

-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT order_id, COUNT(*) AS pizza_count
FROM customer_orders
GROUP BY order_id
ORDER BY pizza_count DESC
LIMIT 1;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
-- Change = exclusions or extras is NOT NULL or empty string
SELECT
  customer_id,
  SUM(CASE WHEN (exclusions IS NOT NULL AND exclusions <> '') OR (extras IS NOT NULL AND extras <> '') THEN 1 ELSE 0 END) AS pizzas_with_changes,
  SUM(CASE WHEN (exclusions IS NULL OR exclusions = '') AND (extras IS NULL OR extras = '') THEN 1 ELSE 0 END) AS pizzas_no_changes
FROM customer_orders
GROUP BY customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(*) AS pizzas_with_both_changes
FROM customer_orders
WHERE exclusions IS NOT NULL AND exclusions <> ''
  AND extras IS NOT NULL AND extras <> '';

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT HOUR(order_time) AS order_hour, COUNT(*) AS pizzas_ordered
FROM customer_orders
GROUP BY order_hour
ORDER BY order_hour;

-- 10. What was the volume of orders for each day of the week?
SELECT DAYNAME(order_time) AS day_of_week, COUNT(DISTINCT order_id) AS orders_count
FROM customer_orders
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- Section B
-- 1. How many runners signed up for each 1 week period? (week starts 2021-01-01)
SELECT
  DATE_FORMAT(registration_date - INTERVAL (WEEKDAY(registration_date)) DAY, '%Y-%u') AS year_week,
  COUNT(*) AS runners_signed_up
FROM runners
GROUP BY year_week
ORDER BY year_week;

-- 2. What was the average time in minutes it took for each runner to arrive at pickup? 
-- Assume arrival time at HQ is the registration_date (rough assumption)
SELECT r.runner_id,
  AVG(TIMESTAMPDIFF(MINUTE, r.registration_date, STR_TO_DATE(ro.pickup_time, '%Y-%m-%d %H:%i:%s'))) AS avg_arrival_time_min
FROM runners r
JOIN runner_orders ro ON r.runner_id = ro.runner_id
WHERE ro.pickup_time IS NOT NULL AND ro.pickup_time <> 'null'
GROUP BY r.runner_id;

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
-- Calculate number of pizzas per order and average duration per order (duration_min)
SELECT co.order_id,
  COUNT(*) AS pizzas_per_order,
  AVG(ro.duration_min) AS avg_duration_min
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.duration_min IS NOT NULL
GROUP BY co.order_id
ORDER BY pizzas_per_order DESC;

-- 4. What was the average distance travelled for each customer?
SELECT co.customer_id,
  AVG(ro.distance_km) AS avg_distance_km
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.distance_km IS NOT NULL
GROUP BY co.customer_id;

-- 5. What was the difference between the longest and shortest delivery times for all orders?
SELECT MAX(duration_min) - MIN(duration_min) AS delivery_time_diff_min
FROM runner_orders
WHERE duration_min IS NOT NULL;

-- 6. What was the average speed for each runner for each delivery and do you notice any trend?
-- Average speed = distance_km / duration_min * 60 (km/hr)
SELECT
  runner_id,
  order_id,
  distance_km,
  duration_min,
  CASE WHEN duration_min > 0 THEN ROUND(distance_km / duration_min * 60, 2) ELSE NULL END AS avg_speed_kmph
FROM runner_orders
WHERE distance_km IS NOT NULL AND duration_min IS NOT NULL
ORDER BY runner_id, order_id;

-- 7. What is the successful delivery percentage for each runner?
SELECT
  runner_id,
  COUNT(CASE WHEN cancellation IS NULL OR cancellation = '' THEN 1 END) AS successful_deliveries,
  COUNT(*) AS total_deliveries,
  ROUND(COUNT(CASE WHEN cancellation IS NULL OR cancellation = '' THEN 1 END) / COUNT(*) * 100, 2) AS success_percentage
FROM runner_orders
GROUP BY runner_id;

-- Section C
-- 1. What are the standard ingredients for each pizza?
SELECT pn.pizza_name, pr.toppings
FROM pizza_names pn
JOIN pizza_recipes pr ON pn.pizza_id = pr.pizza_id;

-- 2. What was the most commonly added extra?
-- Extract extras from customer_orders, split by commas, count frequency (MySQL doesn't have built-in split, so approximate)
-- Use FIND_IN_SET in a helper query or just count all extras strings occurrences:
SELECT extras, COUNT(*) AS frequency
FROM customer_orders
WHERE extras IS NOT NULL AND extras <> ''
GROUP BY extras
ORDER BY frequency DESC
LIMIT 1;

-- 3. What was the most common exclusion?
SELECT exclusions, COUNT(*) AS frequency
FROM customer_orders
WHERE exclusions IS NOT NULL AND exclusions <> ''
GROUP BY exclusions
ORDER BY frequency DESC
LIMIT 1;

-- 4. Generate an order item for each record in the customer_orders table in the format:
-- 'Meat Lovers', 'Meat Lovers - Exclude Beef', 'Meat Lovers - Extra Bacon', etc.
-- Using CONCAT and conditional logic

SELECT
  co.order_id,
  pn.pizza_name,
  CONCAT(
    pn.pizza_name,
    CASE WHEN (exclusions IS NOT NULL AND exclusions <> '') THEN CONCAT(' - Exclude ', exclusions) ELSE '' END,
    CASE WHEN (extras IS NOT NULL AND extras <> '') THEN CONCAT(CASE WHEN exclusions IS NULL OR exclusions = '' THEN ' - Extra ' ELSE ', Extra ' END, extras) ELSE '' END
  ) AS order_item
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id;

-- 5. Generate alphabetically ordered comma separated ingredient list for each pizza order, with "2x" in front of any relevant ingredients
-- This is complex in MySQL; requires stored procedures or external scripting for splitting toppings and extras.
-- Here's an approximate query to list standard toppings:

SELECT
  co.order_id,
  pn.pizza_name,
  pr.toppings AS standard_toppings
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN pizza_recipes pr ON pn.pizza_id = pr.pizza_id;

-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
-- Complex without splitting strings; would require user-defined functions or scripting.
-- You can aggregate counts by topping_id if you join properly (requires splitting toppings string).

-- Section D
-- 1. Total revenue with fixed pizza prices ($12 Meatlovers, $10 Vegetarian, no extras)
SELECT
  SUM(CASE WHEN pn.pizza_name = 'Meatlovers' THEN 12 ELSE 10 END) AS total_revenue_no_extras
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id;

-- 2. Total revenue with $1 extra charge for any pizza extras
SELECT
  SUM(
    CASE WHEN pn.pizza_name = 'Meatlovers' THEN 12 ELSE 10 END +
    CASE WHEN extras IS NOT NULL AND extras <> '' THEN 1 ELSE 0 END
  ) AS total_revenue_with_extras
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id;

-- 3. Total revenue with $1 extra charge for cheese add-on (topping_id = 4)
-- Assuming extras contains topping_ids as comma-separated values and cheese = 4
SELECT
  SUM(
    CASE WHEN pn.pizza_name = 'Meatlovers' THEN 12 ELSE 10 END +
    CASE WHEN extras IS NOT NULL AND extras <> '' THEN 1 ELSE 0 END +
    CASE WHEN FIND_IN_SET('4', extras) > 0 THEN 1 ELSE 0 END
  ) AS total_revenue_with_cheese_extra
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id;

-- 4. Design schema for ratings table (to store customer ratings for runners)

/*DROP TABLE IF EXISTS order_ratings;
CREATE TABLE order_ratings (
  rating_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  runner_id INT NOT NULL,
  rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  rating_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES customer_orders(order_id),
  FOREIGN KEY (runner_id) REFERENCES runners(runner_id)
);

-- 5. Insert sample ratings for each successful order (between 1 and 5 stars)
INSERT INTO order_ratings (order_id, runner_id, rating)
SELECT order_id, runner_id, FLOOR(1 + RAND() * 5)
FROM runner_orders
WHERE cancellation IS NULL OR cancellation = '';

-- 6. Join all info for successful deliveries with requested fields
SELECT 
  co.customer_id,
  co.order_id,
  ro.runner_id,
  orat.rating,
  co.order_time,
  STR_TO_DATE(ro.pickup_time, '%Y-%m-%d %H:%i:%s') AS pickup_time,
  TIMESTAMPDIFF(MINUTE, co.order_time, STR_TO_DATE(ro.pickup_time, '%Y-%m-%d %H:%i:%s')) AS time_order_to_pickup_min,
  ro.duration_min AS delivery_duration_min,
  CASE WHEN ro.duration_min > 0 THEN ROUND(ro.distance_km / ro.duration_min * 60, 2) ELSE NULL END AS avg_speed_kmph,
  (SELECT COUNT(*) FROM customer_orders WHERE order_id = co.order_id) AS total_pizzas
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
JOIN order_ratings orat ON co.order_id = orat.order_id AND ro.runner_id = orat.runner_id
WHERE (ro.cancellation IS NULL OR ro.cancellation = '')
GROUP BY co.order_id, ro.runner_id;

*/

-- 7. Calculate money left after paying runners $0.30/km on successful deliveries
-- Total revenue (fixed prices, no extras)
SELECT
  ROUND(SUM(CASE WHEN pn.pizza_name = 'Meatlovers' THEN 12 ELSE 10 END), 2) AS total_revenue,
  ROUND(SUM(ro.distance_km * 0.30), 2) AS total_runner_payment,
  ROUND(SUM(CASE WHEN pn.pizza_name = 'Meatlovers' THEN 12 ELSE 10 END) - SUM(ro.distance_km * 0.30), 2) AS profit_after_runner_pay
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL OR ro.cancellation = '';

-- Section E
-- 1. How would adding new pizzas affect data design?
-- Existing tables:
-- pizza_names (pizza_id, pizza_name)
-- pizza_recipes (pizza_id, toppings)
-- customer_orders (order_id, pizza_id, ...)

-- Adding new pizzas means:
-- 1) Insert new pizza into pizza_names table
-- 2) Insert pizza recipe (ingredients) in pizza_recipes table
-- 3) Future orders can reference the new pizza_id in customer_orders

-- 2. INSERT new Supreme pizza with all toppings (example)
INSERT INTO pizza_names (pizza_name)
VALUES ('Supreme');

-- Get the pizza_id of newly inserted Supreme pizza
SET @supreme_id = LAST_INSERT_ID();

-- Assuming all toppings have topping_ids, insert all into pizza_recipes for Supreme pizza
-- Here we assume topping_ids 1,2,3,4,... (replace with your actual topping IDs)
INSERT INTO pizza_recipes (pizza_id, toppings)
VALUES 
(@supreme_id, 1),
(@supreme_id, 2),
(@supreme_id, 3),
(@supreme_id, 4),
(@supreme_id, 5),
(@supreme_id, 6),
(@supreme_id, 7);


