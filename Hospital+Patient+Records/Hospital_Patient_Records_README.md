# Hospital Patient Records Analysis 

## Overview
This project analyzes hospital patient records to uncover trends in admission, readmission, stay-in hours, visit cost, and insurance coverage.
## Objective
- How many patients have been admitted or readmitted over time?
- How long are patients staying in the hospital on average?
- How much is the average cost per visit?
- How many procedures are covered by insurance?
## Tools Used
- SQL Server
- Power BI
- Excel
## Process
### 1. Data Collection
- This dataset is from the Maven Analytics data playground.
- It includes tables such as Encounters, Organizations, Patients, Payers, and Procedures.
### 2. Data Cleaning
- I detected and removed duplicates with a CTE, window function, and delete statement.
- Some of the patients' first and last names have improper letters. I analyzed their names to determine the correct letters.
- I renamed the columns, such as description, reason code, and reason description, to match the table name.
- In the Encounter table, the stop column has letters, so I removed them with a substring function. After that, I standardized that column into a date-time column. I merged the patients' first and last name columns for the Patients table into a full name column.
### 3. Visualization and Key Findings

#### a. Patients Admitted and Readmitted
- In 2014, problem encounters, drug rehabilitation, and admission to hospice were the reasons why 25 patients went into admissions. These patients encountered problems such as malignant disorders, malignant tumors, and overlapping malignant.
- In 2020, COVID-19, chronic heart failure, and malignant disorder were the reasons why 30 patients came to the hospital. The trend for that year increased to 13% higher because 48% of COVID-19 patients.
- Four patients returned to the hospital because they encountered problems. The majority of these reasons are unknown. The readmission years are 2011, 2013, 2018, and 2019.

#### b. Average Stay
- The average hospital stay for Inpatients is 79 hours. The stay-in hours exceeded for years, such as 2017, 2018, 2020, and 2021.
- 2017 is higher because of the periodic evaluation. The percentage of patients who remained for 2 months is 73%. 
In 2018, another patient with a periodic evaluation stayed there for almost a year, increasing the percentage to 92%.
- 2020 had an average stay-in hours of 82.57 because 74% of patients contracted COVID-19. Their remaining time for isolation is 56%, and those in the intensive care unit stayed about 18%.
- The 2021 average stay-in hours are 5.7% higher than 2020's. Its average increased to 6.3% because the percentage of COVID-19 patients staying at the hospital has increased. The percentage of patients with COVID-19 who are in isolation has risen from 56% to 62%.

#### c. Hospital Costs per Visit
- The average cost per visit is $6,270.
- Inpatients have the highest average cost per visit, which is $9,330. COVID-19 costs $126,000 for the intensive care unit and $19,000 for isolation. The average increases more because they encounter problems such as malignant disorders and injuries. The average price for these problems ranges from $10,000 to $26,000
- Outpatients have an average of $2.02k because most of them encounter lung cancer issues. These issues are suspicion of lung cancer, non-small cell lung cancer, and non-small cell lung carcinoma.
- Emergency patients spend an average of $7,460 because they encountered a stroke, which costs $161,000. The other two visits were for myocardial infarction and stroke, which cost $66,000 and $25,000, respectively.
#### d. Procedures Covered by Insurance
- 4756 insurance covered procedures, and Medicare is a popular insurance. 
- List of patients with Medicare that covered procedures (ambulatory: 28.74%, Outpatient: 26.35%, wellness: 23%, emergency: 14.72%, Inpatient: 5.55%, urgent care: 1.64%)
- Ambulatory vs. emergency: The average insurance coverage for emergency patients is $75,100, while for ambulatory patients, it is $45,780. The emergency average is higher because the top 5 procedure coverages are more significant than 0.2m, and three are $933.36k higher than the other two. The three procedures are bone misapplication, echocardiography, and percutaneous mechanical thrombectomy. The ambulatory average is lower because its top 5 procedure coverages are within 0.2m. However, colonoscopy has an average amount of 0.91m, which is more significant than the procedures. 
Inpatients vs. Outpatients: The outpatient average is $113.07k, and the inpatient average is $88.44k. The Inpatient's top 5 procedures are higher than the Outpatient's top 5 procedures. The Inpatient's average is lower due to the oxygen administration coverage being 0.13n, which is consistent with the range covered by other insurance. The Outpatient's average is higher because the coverage ranges between 0.39m and 0.24m. 
- Urgent care vs. wellness: Wellness's average coverage is higher than urgent care's. Urgent care has three procedures, while wellness has more than that amount.
