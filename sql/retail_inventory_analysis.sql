create database retail_inventory_db;
USE retail_inventory_db;


CREATE TABLE retail_inventory (
    id INT AUTO_INCREMENT PRIMARY KEY,

    date DATE NOT NULL,
    store_id VARCHAR(10),
    product_id VARCHAR(10),
    category VARCHAR(50),
    region VARCHAR(20),

    inventory_level INT,
    units_sold INT,
    units_ordered INT,

    demand_forecast DECIMAL(10,2),
    price DECIMAL(10,2),
    discount INT,

    weather_condition VARCHAR(20),
    holiday INT,

    competitor_pricing DECIMAL(10,2),
    seasonality VARCHAR(20),

    year INT,
    month INT,
    years_month VARCHAR(10),

    reorder_point DECIMAL(10,2),
    inventory_status VARCHAR(20),

    revenue DECIMAL(12,2)
);

-- 1. Basic Data Understanding --

SELECT * FROM retail_inventory LIMIT 5;

-- Total Records
 
SELECT COUNT(*) AS total_rows
FROM retail_inventory;

-- Date Range 

SELECT 
    MIN(date) AS start_date,
    MAX(date) AS end_date
FROM retail_inventory;

-- 2. Sales Performance Analyis --

-- Total Revenue

SELECT 
    ROUND(SUM(revenue), 2) AS total_revenue
FROM retail_inventory;

-- Revenue by Category

SELECT 
    category,
    ROUND(SUM(revenue), 2) AS category_revenue
FROM retail_inventory
GROUP BY category
ORDER BY category_revenue DESC;

-- Revenue by Region

SELECT 
    region,
    ROUND(SUM(revenue), 2) AS region_revenue
FROM retail_inventory
GROUP BY region
ORDER BY region_revenue DESC;


-- 3. Timme-Based Analysis --

-- Monthly Revenue Trend 

SELECT 
    year,
    month,
    ROUND(SUM(revenue), 2) AS monthly_revenue
FROM retail_inventory
GROUP BY year, month
ORDER BY year, month;

-- Yearly Revenue Comparsion

SELECT 
    year,
    ROUND(SUM(revenue), 2) AS yearly_revenue
FROM retail_inventory
GROUP BY year
ORDER BY year;


-- 4. Inventory Health Analysis [Key Business Insight] --

-- Inventory Status Distribution

SELECT 
    inventory_status,
    COUNT(*) AS total_records
FROM retail_inventory
GROUP BY inventory_status;

-- Overstock & Understock by Category

SELECT 
    category,
    inventory_status,
    COUNT(*) AS count_records
FROM retail_inventory
WHERE inventory_status IN ('Overstock', 'Understock')
GROUP BY category, inventory_status
ORDER BY category;


-- 5. Demand VS Supply Analysis --

-- Units Sold vs Units Ordered

SELECT
    ROUND(SUM(units_sold), 0) AS total_units_sold,
    ROUND(SUM(units_ordered), 0) AS total_units_ordered
FROM retail_inventory;

-- Products with High Demand But Low Inventory

SELECT
    product_id,
    category,
    SUM(units_sold) AS total_sold,
    AVG(inventory_level) AS avg_inventory
FROM retail_inventory
GROUP BY product_id, category
HAVING total_sold > avg_inventory
ORDER BY total_sold DESC;


-- 6. Recorder Point & Optimization -- 

-- Items Frequently Under Recorder Point 

SELECT
    category,
    COUNT(*) AS understock_count
FROM retail_inventory
WHERE inventory_level < reorder_point
GROUP BY category
ORDER BY understock_count DESC;


-- 7. Pricing & Discount Impact --

-- Average Price & Discount by Category

SELECT
    category,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(discount), 2) AS avg_discount
FROM retail_inventory
GROUP BY category;

-- Discount Impact on Sales 

SELECT
    discount,
    ROUND(SUM(revenue), 2) AS revenue
FROM retail_inventory
GROUP BY discount
ORDER BY discount;


-- 8. External Factors Impact -- 

-- Sales by Weather Condition

SELECT
    weather_condition,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM retail_inventory
GROUP BY weather_condition
ORDER BY total_revenue DESC;

-- Sales During Hoildays / Promotions 

SELECT
    holiday,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM retail_inventory
GROUP BY holiday;

-- 9. Store-Level Performance --

-- Top Performing Stores

SELECT
    store_id,
    ROUND(SUM(revenue), 2) AS store_revenue
FROM retail_inventory
GROUP BY store_id
ORDER BY store_revenue DESC
LIMIT 10;