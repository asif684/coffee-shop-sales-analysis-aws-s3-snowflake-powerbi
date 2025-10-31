# ☕ Coffee Shop Sales Analytics Dashboard using AWS S3, Snowflake & Power BI

## 🔍 Project Overview
This project presents an **end-to-end data analytics pipeline** designed for a **Coffee Shop Sales Dashboard**, integrating **AWS S3 (data storage)**, **Snowflake (data warehousing)**, and **Power BI (data visualization)**.  

The dataset, hosted in **AWS S3**, was imported into **Snowflake** for cleaning, transformation, and KPI computation. The processed data was then connected to **Power BI** to create an interactive dashboard providing insights into sales performance, order trends, and product category analytics.  
The dashboard also leverages **Power BI Tooltips** to provide detailed contextual insights when hovering over visuals.

---

## 🧱 Tech Stack
- **Data Source:** AWS S3  
- **Data Warehouse:** Snowflake  
- **Visualization Tool:** Power BI  
- **Query Language:** SQL  
- **Data Cleaning & Transformation:** Snowflake SQL operations  

---
---

## Dashboard 
![image alt](https://github.com/asif684/coffee-shop-sales-analysis-aws-s3-snowflake-powerbi/blob/189afea370f136b80dbf5baa03ddeefff9e7e0a9/dashboard1.png)
![image alt](https://github.com/asif684/coffee-shop-sales-analysis-aws-s3-snowflake-powerbi/blob/189afea370f136b80dbf5baa03ddeefff9e7e0a9/Tooltip-calender-chart.png)
![image alt](https://github.com/asif684/coffee-shop-sales-analysis-aws-s3-snowflake-powerbi/blob/189afea370f136b80dbf5baa03ddeefff9e7e0a9/Tooltip-day%20%26%20Hour%20chart.png)

---

## ⚙️ Implementation Steps

### 1️⃣ Snowflake Setup
- Performed a **data walkthrough** of raw coffee shop sales data stored in AWS S3.  
- Created a **Snowflake database and schema** to manage data efficiently.  
- Imported raw CSV data from **AWS S3** using the `COPY INTO` command.  
- Cleaned and transformed data using SQL:
  - Removed **duplicates**, **null values**, and **inconsistent records**.  
  - Changed data types and formatted date columns using `STR_TO_DATE`.  
- Executed SQL queries to calculate business KPIs such as sales, orders, and quantity sold.  
- Stored transformed tables and created **SQL documentation** for reproducibility.  

---

## 🧩 SQL Concepts & Functionalities Learned

| Category | SQL Concepts |
|-----------|---------------|
| **Data Conversion & Aggregation** | `STR_TO_DATE`, `ROUND`, `SUM`, `COUNT`, `AVG`, `MAX`, `MIN` |
| **Date & Time Functions** | `MONTH`, `DAY`, `DAYOFWEEK`, `HOUR` |
| **Table Operations** | `ALTER TABLE`, `UPDATE`, `CHANGE COLUMN` |
| **Conditional Logic & Filtering** | `CASE`, `WHERE`, `GROUP BY`, `ORDER BY`, `LIMIT` |
| **Advanced SQL** | `LAG`, `WINDOW FUNCTIONS`, `JOINS`, `SUBQUERIES`, `ALIAS` |

---

## 🎯 Problem Statement
The **Coffee Shop Sales Dashboard** aims to analyze sales trends, order volumes, and product performance over time.  
Business users should be able to monitor month-on-month growth, identify top-selling items, and understand customer purchasing patterns by day, time, and location.

---

## 📊 KPI Requirements

### 🧾 1. Total Sales Analysis
- Calculate total coffee shop sales per month.  
- Measure **Month-on-Month (MoM)** sales growth or decline.  
- Compute the difference between the current and previous month’s sales.  

### 📦 2. Total Orders Analysis
- Count the total number of orders each month.  
- Determine **MoM change** in orders.  
- Calculate the order difference between consecutive months.  

### ☕ 3. Total Quantity Sold Analysis
- Calculate the total number of items sold per month.  
- Evaluate **MoM variations** in quantity sold.  
- Determine month-to-month differences in total quantity.  

---

## 📈 Power BI Dashboard Components

### 1️⃣ Calendar Heat Map
- Displays **daily sales volume** with color-coded intensity.  
- Supports **month selection** through slicers.  
- Hover tooltips show **Sales, Orders, Quantity** for each day.  

### 2️⃣ Weekday vs Weekend Sales Analysis
- Segments data by weekdays and weekends.  
- Highlights variations in **customer behavior** across time periods.  

### 3️⃣ Sales by Store Location
- Map visualization showing performance across **multiple coffee shop branches**.  
- Includes **Month-over-Month (MoM)** sales metrics and trend indicators.  

### 4️⃣ Daily Sales with Average Line
- Combination chart (bar + line) to visualize daily sales trends.  
- **Average line** acts as a benchmark for performance tracking.  
- Bars above/below average are color-coded for clarity.  

### 5️⃣ Sales by Product Category
- Analyzes coffee shop categories (e.g., Beverages, Pastries, Sandwiches).  
- Highlights top categories driving revenue growth.  

### 6️⃣ Top 10 Products by Sales
- Displays top 10 best-selling items (e.g., Latte, Cappuccino, Espresso).  
- Enables quick identification of high-demand products.  

### 7️⃣ Sales by Days & Hours (Heat Map)
- Visualizes sales activity by **day of the week** and **hour of the day**.  
- Reveals peak hours (e.g., morning coffee rush, evening snacks).  
- Interactive tooltips with key performance metrics.  

---

## 🎨 Power BI Tooltip Integration

Tooltips were implemented throughout the dashboard to enhance **interactivity and detail visibility**.  

### ✨ Tooltip Features
- 📍 **Dynamic Tooltips:** Automatically update based on slicer selections.  
- 💡 **Hover Insights:** Show detailed metrics — *Sales, Orders, Quantity* — when hovering over visuals.  
- 📊 **Custom Tooltip Pages:**  
  - Created separate tooltip pages (Product Insights, Store Insights, Time Analysis).  
  - Enabled tooltip pages in *Page Information → Tooltip = ON*.  
- ⚡ **Visual Assignment:** Assigned each tooltip to its respective chart via *Format → Tooltip → Report Page*.  

### ✅ Benefits
- Provides **deeper insight** without cluttering main visuals.  
- Encourages **data exploration** and storytelling.  
- Offers **contextual metrics** for every visualization element.  

---

## 💡 Key Insights
- **Peak Sales Hours:** Morning (8–11 AM) and evening (4–7 PM).  
- **Weekend Effect:** Sales spike during weekends compared to weekdays.  
- **Product Performance:** Coffee beverages dominate sales, while bakery items perform well in the mornings.  
- **Store Trends:** Urban locations outperform suburban outlets by 25%.  
- **Revenue Share:** Top 10 products contribute over **60% of total sales**.  

---

## 🧠 Skills Gained
- **Cloud Integration:** AWS S3 → Snowflake → Power BI  
- **Advanced SQL Querying:** Aggregations, Joins, Window Functions  
- **Data Cleaning & Transformation** using Snowflake SQL  
- **Power BI Dashboard Design & DAX Implementation**  
- **Interactive Visualization Techniques (Tooltips, Slicers, KPIs)**  
- **Business Analytics & Insight Generation**  

---

## 📁 Project Structure


```
coffee-shop-sales-analysis-aws-s3-snowflake-powerbi/
│
├── data/          # Sample CSV files stored in AWS S3
├── sql/           # Snowflake SQL scripts for cleaning & KPIs
├── dashboard/     # Power BI (.pbix) file
├── images/        # Dashboard screenshots
├── README.md      # Project documentation
└── LICENSE        # MIT License
```

---

## 🚀 Future Enhancements
- Automate data ingestion with **Snowpipe**.  
- Deploy dashboard on **Power BI Service** for live updates.  
- Integrate **AWS Lambda** for scheduled data refresh.  
- Add **predictive analytics** for future sales forecasting.  

---

## 👨‍💻 Author
**Mohammed Asif Ameen Baig**  
🎓 B.Tech in Robotics & Automation Engineering  
💼 Data Science | AI/ML | Cloud Analytics | Power BI  
📧 mohammedasifameenbaig684@gmail.com  
🌐 [GitHub: asif684](https://github.com/asif684)  
🔗 [LinkedIn](https://www.linkedin.com/in/mohammed-asif-ameen-baig/)

---

## 🪄 License
This project is licensed under the **MIT License** — free to use, modify, and share with proper credit.

---
