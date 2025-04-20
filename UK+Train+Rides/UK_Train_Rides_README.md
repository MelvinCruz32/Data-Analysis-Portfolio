# UK Train Rides Analysis

## Overview
This project analyzes UK train rides to uncover trends for popular routes, peak travel times, ticket revenue, and on-time performance.

## Objective
To explore and visualize UK train data, to understand:
- What are the popular routes?
- What are the peak travel times?
- How is the revenue from ticket types and classes?
- How is the on-time performance?

## Tools used
- Power Queery
- Excel
## Process

### 1. Data Collection
- This data set is from Maven Analytics, specifically at the data playground.
- Data includes columns such as transaction ID, date of purchase, time of purchase, purchase type, payment method, railcard, ticket class, ticket type, price, departure station, arrival destination, date of journey, departure time, arrival time, actual arrival time, journey status, reason for delay, and refund request.

### 2. Data Cleaning
- Removed duplicate data from columns such as payment method, purchase location, railcard, ticket class, ticket type, price, routes, date of journey, journey time, journey status, reason for delay, and refund request
- Filled empty rows on the reason for delay column with "No Delays"
- Merged columns, such as purchase date with purchase time, departure routes with arrival routes, and departure time with arrival time
### 3. Visualization & Key Findings
1. Popular Routes: 
* Manchester Piccadilly - Liverpool Lime Street topped the tree map with 3,854 ticket purchases. 
* The top 5 routes, London Paddington to Reading, made higher ticket sales than the other routes. This route contributed 9.79% to the overall revenue.
<img width="377" alt="Screenshot 2025-04-20 at 12 13 17 PM" src="https://github.com/user-attachments/assets/9897a915-c3a0-42e7-9780-08559d53078e" />

<img width="418" alt="Screenshot 2025-04-20 at 10 50 12 AM" src="https://github.com/user-attachments/assets/e141dd56-76cd-4ee4-9d2b-c8b3b988a1b2" />

2. Peak Travel Times:
Peak travel hours are 6:30 a.m.—7:00 a.m., 4-5:30 p.m., and 6:20 p.m.- 8 p.m. 
Tuesday is the busiest day of the week, especially in the morning. The other days are less busy than Tuesday.
<img width="639" alt="Screenshot 2025-04-20 at 10 55 18 AM" src="https://github.com/user-attachments/assets/868da734-9fb9-426b-858a-edb91dd64f0a" />

3. Revenue Trends by Ticket Types and Classes:
- First class provides 23.4%, while the standard ticket class contributes 76.5% towards the revenue
- Advanced tickets from both classes surpassed peak-off and anytime tickets. These tickets contributed 43.6% to the overall revenue.

4. On-Time Performance & Contributing Factors:
- 88.2% of trains arrive on time; none of the passengers requested a refund.
- Delays and cancellations cause refund requests. In January, technical issues resulted in a refund request of $2905 due to delays. Signal failure caused journey cancellations, which accounted for a $7,550 refund request.
- In March, technical issues and signal failures increased by 33.5%. These causes need improvement to enhance the punctuality rate.
