-- ========================================
-- Project: Sales & Profit Analysis
-- Author: Praveen Balakrishnamurthy
-- Date: [April 28, 2025]
-- Dataset: Sample Superstore 
-- SQL Engine: SQLite
-- ========================================

-- ========================================
-- TABLE OF CONTENTS
-- ========================================
-- 1. Sales & Profit Analysis
--    a. Total Sales and Total Profit
--    b. Sales and Profit by Category
--    c. Sales and Profit by Sub-Category
--    d. Sales and Profit by Region
--    e. Sales and Profit by State (Top 5 States)
--
-- 2. Trends Over Time
--    a. Monthly Sales Trend
--    b. Yearly Profit Trend
--    c. Quarterly Sales Trend
--
-- 3. Customer Behavior
--    a. Top 10 Customers by Sales
--    b. Customer Count by Segment
--    c. Number of Orders and Average Order Value per Segment
--    d. Profitability by Segment
--
-- 4. Product Insights
--    a. Top 10 Products by Quantity Sold
--    b. Bottom 5 Products by Profit Margin
--    c. Profit Margin & Avg Discount by Sub-Category
--
-- 5. Shipping & Operations
--    a. Order Count by Shipping Mode
--    b. Average Shipping Delay by Mode
--    c. Sales and Profit by Shipping Mode
--
-- 6. Discounts & Profitability
--    a. Orders with High Discount and Loss
-- ========================================

--===========================================
--1) SALES & PROFIT ANALYSIS
--===========================================

-- a. Total Sales and Total Profit
SELECT
	ROUND(SUM(Sales),2) AS "Total_Sales", 
	ROUND(SUM(Profit),2) AS "Total_Profit",
	ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) as Profit_Margin_Percentage
FROM Sample s;

-- b. Sales and Profit by Category
SELECT 
	Category, 
	ROUND(SUM(Sales),2) AS Sales, 
	ROUND(SUM(Profit),2) AS Profit
FROM Sample s
GROUP BY Category;

-- c. Sales and Profit by Sub-Category
SELECT 
	"Sub-Category", 
	ROUND(SUM(Sales),2) AS Sales, 
	ROUND(SUM(Profit),2) AS Profit
FROM Sample s
GROUP BY "Sub-Category";

-- d. Sales and Profit by Region
SELECT 
	Region, 
	ROUND(SUM(Sales),2) AS Sales, 
	ROUND(SUM(Profit),2) AS Profit
FROM Sample s
GROUP BY Region;

-- e. Sales and Profit by Top 5 States
SELECT 
	State, 
	ROUND(SUM(Sales),2) AS Sales, 
	ROUND(SUM(Profit),2) AS Profit
FROM Sample s
GROUP BY State 
ORDER BY SUM(Sales) DESC, SUM(profit) DESC
LIMIT 5; 


--===========================================
--2) TRENDS OVER TIME
--===========================================

-- a. Monthly Sales Trend
SELECT 
	STRFTIME('%Y-%m', "Order Date") AS Order_Month,
	ROUND(SUM(Sales),2) AS Total_Sales
FROM Sample s 
GROUP BY Order_Month
ORDER BY Order_Month;

-- b. Yearly Profit Trend
SELECT 
	STRFTIME('%Y', "Order Date") AS Order_Year,
	ROUND(SUM(Profit),2) AS Total_Profit,
	ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percentage
From Sample s
GROUP BY Order_Year 
ORDER BY Order_Year;

-- c. Quarterly Sales Trend
SELECT STRFTIME('%Y', "Order date") || '-Q' ||
CASE 
	WHEN STRFTIME('%m', "Order Date") BETWEEN '01' AND '03' THEN '1'
	WHEN STRFTIME('%m', "Order Date") BETWEEN '04' AND '06' THEN '2'
	WHEN STRFTIME('%m', "Order Date") BETWEEN '07' AND '09' THEN '3'
	WHEN STRFTIME('%m', "Order Date") BETWEEN '10' AND '12' THEN '4'	
END AS Order_Quarter,
ROUND(SUM(Sales),2) AS Total_Sales
FROM Sample s 
GROUP BY Order_Quarter
ORDER BY Order_Quarter;


--===========================================
--3) CUSTOMER BEHAVIOR
--===========================================

--a. Top 10 Customers by Sales
SELECT 
	"Customer ID",
	"Customer Name",
	ROUND(SUM(Sales),2) AS Total_Sales
FROM Sample s
GROUP BY "Customer Name"
ORDER BY Total_Sales DESC 
LIMIT 10;

--b. Customer Count by Segment
SELECT
	Segment,
	COUNT(DISTINCT "Customer ID") AS Customer_count
FROM Sample s 
GROUP BY Segment; 

--c. Number of Orders and Average Order Value per Segment
SELECT
	Segment,
	COUNT(DISTINCT "Order ID") AS Orders,
	ROUND(SUM(Sales) / COUNT(DISTINCT "Order ID"),2) AS Average_order_value
FROM Sample s
GROUP BY Segment; 

--d. Profitability by Segment
SELECT 
	Segment,
	ROUND(SUM(Sales), 2) AS Sales,
	ROUND(SUM(Profit),2) as Profit,
	ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) as Profit_Margin_Percentage
From Sample s
GROUP BY Segment
ORDER BY Profit DESC;

--===========================================
--4) PRODUCT INSIGHTS
--===========================================

--a. Top 10 Products by Quantity Sold
SELECT 
	"Product ID",
	"Product Name",
	SUM(Quantity) AS Quantity_Sold
FROM Sample s
GROUP BY "Product ID" 
ORDER BY Quantity_Sold DESC
LIMIT 10;

--b. Bottom 5 Products by Profit Margin
SELECT 
	"Product ID",
	"Product Name",
	ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent
FROM Sample s
GROUP BY "Product ID" 
ORDER BY Profit_Margin_Percent ASC
LIMIT 5;

--c. Profit Margin & Avg Discount by Sub-Category
SELECT 
	"Sub-Category",
	ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin,
	ROUND(AVG(Discount) * 100, 2) AS Avg_Discount_Percentage
FROM Sample s
GROUP BY "Sub-Category"; 

--===========================================
-- 5) SHIPPING & OPERATIONS
--===========================================

--a. Order Count by Shipping Mode
SELECT 
	"Ship Mode",
	COUNT(DISTINCT "Order ID") AS Orders
FROM Sample s
GROUP BY "Ship Mode";

--b. Average Shipping Delay by Mode
SELECT 
	"Ship Mode",
	ROUND(AVG(JULIANDAY("Ship Date") - JULIANDAY("Order Date")),2) as Avg_Shipping_Delay_Days
FROM Sample s
GROUP BY "Ship Mode";

--c. Sales and Profit by Shipping Mode
SELECT 
	"Ship Mode",
	ROUND(SUM(Sales),2) as Total_Sales,
	ROUND(SUM(Profit),2) as Total_Profit
From Sample s
GROUP BY "Ship Mode";

--===========================================
--6) DISCOUNTS & PROFITABILITY
--===========================================

--a. Orders with High Discount and Loss
SELECT 
	"Order ID", 
	Discount,
	Profit
FROM Sample s
WHERE Discount > 0.3 AND Profit < 0
ORDER BY Profit ASC;





