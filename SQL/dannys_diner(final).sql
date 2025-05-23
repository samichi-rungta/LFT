CREATE DATABASE dannys_diner;
USE dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INT
);

CREATE TABLE menu (
  product_id INT,
  product_name VARCHAR(20),
  price INT
);

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO sales (customer_id, order_date, product_id) VALUES
  ('A', '2021-01-01', 1),
  ('A', '2021-01-01', 2),
  ('A', '2021-01-07', 2),
  ('A', '2021-01-10', 3),
  ('A', '2021-01-11', 3),
  ('A', '2021-01-11', 3),
  ('B', '2021-01-01', 2),
  ('B', '2021-01-02', 2),
  ('B', '2021-01-04', 1),
  ('B', '2021-01-11', 1),
  ('B', '2021-01-16', 3),
  ('B', '2021-02-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-07', 3);

INSERT INTO menu (product_id, product_name, price) VALUES
  (1, 'sushi', 10),
  (2, 'curry', 15),
  (3, 'ramen', 12);

INSERT INTO members (customer_id, join_date) VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

-- 1. What is the total amount each customer spent at the restaurant?
SELECT 
  s.customer_id,
  SUM(m.price) AS total_spent
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;

-- 2. How many days has each customer visited the restaurant?
SELECT 
  customer_id,
  COUNT(DISTINCT order_date) AS visit_days
FROM sales
GROUP BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?
SELECT customer_id, product_name
FROM (
  SELECT 
    s.customer_id,
    m.product_name,
    RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS rnk
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
) AS first_orders
WHERE rnk = 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT 
  m.product_name,
  COUNT(*) AS purchase_count
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY purchase_count DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?
SELECT customer_id, product_name, count
FROM (
  SELECT 
    s.customer_id,
    m.product_name,
    COUNT(*) AS count,
    RANK() OVER (PARTITION BY s.customer_id ORDER BY COUNT(*) DESC) AS rnk
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
  GROUP BY s.customer_id, m.product_name
) AS ranked
WHERE rnk = 1;

-- 6. Which item was purchased first by the customer after they became a member?
SELECT customer_id, product_name, order_date
FROM (
  SELECT 
    s.customer_id,
    s.order_date,
    m.product_name,
    RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS rnk
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
  JOIN members mem ON s.customer_id = mem.customer_id
  WHERE s.order_date >= mem.join_date
) AS ranked
WHERE rnk = 1;

-- 7. Which item was purchased just before the customer became a member?
SELECT customer_id, product_name, order_date
FROM (
  SELECT 
    s.customer_id,
    s.order_date,
    m.product_name,
    RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS rnk
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
  JOIN members mem ON s.customer_id = mem.customer_id
  WHERE s.order_date < mem.join_date
) AS ranked
WHERE rnk = 1;

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT 
  s.customer_id,
  COUNT(*) AS total_items,
  SUM(m.price) AS total_spent
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mem ON s.customer_id = mem.customer_id
WHERE s.order_date < mem.join_date
GROUP BY s.customer_id;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT 
  s.customer_id,
  SUM(
    CASE 
      WHEN m.product_name = 'sushi' THEN m.price * 10 * 2
      ELSE m.price * 10
    END
  ) AS total_points
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SELECT 
  s.customer_id,
  SUM(
    CASE
      WHEN s.order_date BETWEEN mem.join_date AND DATE_ADD(mem.join_date, INTERVAL 6 DAY)
           THEN m.price * 10 * 2
      WHEN m.product_name = 'sushi'
           THEN m.price * 10 * 2
      ELSE m.price * 10
    END
  ) AS total_points
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mem ON s.customer_id = mem.customer_id
WHERE s.order_date <= '2021-01-31'
  AND s.customer_id IN ('A', 'B')
GROUP BY s.customer_id;

-- Create a combined table with customer_id, order_date, product_name, price, and member status
SELECT 
  s.customer_id,
  s.order_date,
  m.product_name,
  m.price,
  CASE 
    WHEN s.order_date >= mem.join_date THEN 'Y'
    ELSE 'N'
  END AS member
FROM sales s
JOIN menu m ON s.product_id = m.product_id
LEFT JOIN members mem ON s.customer_id = mem.customer_id
ORDER BY s.customer_id, s.order_date;

-- Add ranking only for purchases after joining the loyalty program
SELECT 
  s.customer_id,
  s.order_date,
  m.product_name,
  m.price,
  CASE 
    WHEN s.order_date >= mem.join_date THEN 'Y'
    ELSE 'N'
  END AS member,
  CASE 
    WHEN s.order_date >= mem.join_date THEN
      RANK() OVER (
        PARTITION BY s.customer_id 
        ORDER BY s.order_date
      )
    ELSE NULL
  END AS ranking
FROM sales s
JOIN menu m ON s.product_id = m.product_id
LEFT JOIN members mem ON s.customer_id = mem.customer_id
ORDER BY s.customer_id, s.order_date;
