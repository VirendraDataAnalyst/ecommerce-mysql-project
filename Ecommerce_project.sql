CREATE DATABASE ecommerce_db;
USE ecommerce_db;

SELECT count(*) from orders;
SELECT count(*) from products_data;
SELECT count(*) from users;

#1.Total Sales
SELECT SUM(total_amount) AS total_sales FROM orders;

#2.Top Selling Products
SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products_data p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

#3.Monthly Sales
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(oi.quantity * p.price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products_data p ON oi.product_id = p.product_id
GROUP BY month;

#4.Top Customers
SELECT u.name, 
    SUM(oi.quantity * p.price) AS total_spent
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products_data p ON oi.product_id = p.product_id
GROUP BY u.name
ORDER BY total_spent DESC;

#5.Highest revenue product
SELECT p.product_name, 
    SUM(oi.quantity * p.price) AS revenue
FROM order_items oi
JOIN products_data p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 1;

#6.Average order value
SELECT 
    SUM(oi.quantity * p.price) / COUNT(DISTINCT o.order_id) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products_data p ON oi.product_id = p.product_id;

#7.Total quantity sold per product
SELECT p.product_name, SUM(oi.quantity) AS total_qty
FROM order_items oi
JOIN products_data p ON oi.product_id = p.product_id
GROUP BY p.product_name;

#8.Orders per day
SELECT DATE(order_date) AS order_day, COUNT(*) AS total_orders
FROM orders
GROUP BY order_day;

#9.Users with highest spending city-wise
SELECT city, MAX(total_spent) AS highest_spending
FROM (
    SELECT 
        u.city, 
        u.user_id, 
        SUM(oi.quantity * p.price) AS total_spent
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products_data p ON oi.product_id = p.product_id
    GROUP BY u.city, u.user_id
) t
GROUP BY city;

#10.Orders with more than 3 items
SELECT order_id, SUM(quantity) AS total_items
FROM order_items
GROUP BY order_id
HAVING total_items > 3;

#11.Most reviewed products
SELECT p.product_name, COUNT(r.review_id) AS total_reviews
FROM reviews r
JOIN products_data p ON r.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_reviews DESC;

#12.Most popular category
SELECT p.category, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products_data p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sold DESC
LIMIT 1;

#13.Customer Orders Procedure
DELIMITER //

CREATE PROCEDURE GetCustomerOrders(IN cust_id INT)
BEGIN
    SELECT *
    FROM orders
    WHERE user_id = cust_id;
END //

DELIMITER ;
CALL GetCustomerOrders(5);

SELECT * FROM orders LIMIT 10;


