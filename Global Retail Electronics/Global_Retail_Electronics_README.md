# Global Retail Electronics

## Overview
This project analyzes the global retail electronics trends such as customer location, products, revenue, order quantity, average delivery days, and average order value.
## Objective
- What types of products does the company sell, and where are customers located?
- Are there any seasonal patterns or trends for order volume or revenue?
- How long is the average delivery time in days? Has that changed over time?
- Is there a difference in average order value (AOV) for online vs. in-store sales?
## Tools Used
- Python
- Tableau
## Process
### 1. Data Collection
- This dataset is from the Maven Analytics data playground (https://mavenanalytics.io/data-playground?page=2&pageSize=5).
- It includes tables such as Sales, Products, Customers, Stores, and Exchange Rates.
### 2. Data Cleaning
- I checked for duplicates, but none of the tables had any.
- I standardized data types for each column in each table.
- I created a "Store Type" column for the sales table. This column indicates if purchases are made in-store or online.
- The sales table's delivery date column had null values, so I used the backfill function to fill in that column.
### 3. Visualization and Key Findings
#### a. Customers' Location and Products
Customers live in North America, Europe, and Australia. The product types they purchase are audio, cameras, camcorders, cell phones, computers, games, toys, home appliances, music, movies, TVs, and videos.
<img width="761" alt="Screenshot 2025-04-23 at 10 09 58 PM" src="https://github.com/user-attachments/assets/d22dc413-ff64-4f89-9a54-20921a9ca2bb" />

#### b. Revenue and Order Quantity
Revenue and order volume trends are seasonal. The busiest months for revenue and order volume are January, February, and December. The total revenue for these months is $22,099,066, with 78,043 products sold to customers. Computers are the most popular products, contributing 35% to the revenue.
<img width="740" alt="Screenshot 2025-04-23 at 10 10 13 PM" src="https://github.com/user-attachments/assets/77dc7c3c-5ed4-4f26-8595-f6849e02acd9" />

#### c. Average Delivery Days
The average delivery days have changed over time. In 2016, they were 8.054. The average delivery days decrease because the number of orders increases. For sales from 2018 to 2020, customers purchased more than 10,000, and the average delivery time was 4 days. These visualizations indicate that the items will be delivered faster if stores receive more orders.
<img width="937" alt="Screenshot 2025-04-23 at 10 10 28 PM" src="https://github.com/user-attachments/assets/37bf471f-ffa3-4e3a-81a1-d00971362129" />

#### d. Average Order Value
The Average Order Value in-store is $892.04, while the average order value in the online store is $866.26. Many in-store customers who spend more are in their 30s, 40s, 70s, and 80s. Clustering analysis indicates that these customers spend between $10,000 and $30,000. The highest average spending is on home appliances, TVs, and video products. Australian customers' spending behavior is 4.1% higher than that of North Americans because they spend at least $2,000 on these products. North American customers have an average spending of between $1,580 and $2,094. I recommend targeting customers in their 30s, 40s, 70s, and 80s who like these products.
<img width="935" alt="Screenshot 2025-04-23 at 10 11 14 PM" src="https://github.com/userattachments/assets/227bd852-fa84-4dc3-909c-1353c6ca6980" />

To view and interact with the visualizations, click on the link below:
https://public.tableau.com/app/profile/melvin.cruz/viz/GlobalRetailElectronics/AverageOrderValueDashboard
