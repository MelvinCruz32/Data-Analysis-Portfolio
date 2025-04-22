# Hospital Patient Records Analysis 

## Overview
This project analyzes hospital patient records to uncover trends in admissions, readmissions, length of stay, cost per visit, and insurance coverage.
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
- This dataset is from the Maven Analytic's data playground (https://mavenanalytics.io/data-playground?page=2&pageSize=5).
- It includes tables such as Encounters, Organizations, Patients, Payers, and Procedures.
### 2. Data Cleaning
- I detected and removed duplicates with a CTE, window function, and delete statement.
- Some of the patients' first and last names have improper letters. I analyzed their names to determine the correct letters.
- I renamed the columns, such as description, reason code, and reason description, to match the table name.
- In the Encounter table, the stop column has letters, so I removed them with a substring function. After that, I standardized that column into a date-time column. I merged the patients' first and last name columns for the Patients table into a full name column.
### 3. Visualization and Key Findings

#### a. Patients Admitted and Readmitted
- In 2014, 25 patients went into admissions because of problem encounters, drug rehabilitation, and hospice admission. These patients encountered problems such as malignant disorders, malignant tumors, and overlapping malignant conditions.
- In 2020, 30 patients came to the hospital because of COVID-19, chronic heart failure, and malignant disorder. Admissions for that year increased because of 48% of COVID-19 patients.
- Four patients returned to the hospital because they encountered problems. The majority of these reasons are unknown. The readmission years are 2011, 2013, 2018, and 2019.

#### b. Average Stay
- The average stay-in hours for Inpatients are 79 hours. These hours exceeded for years such as 2017, 2018, 2020, and 2021. Besides these years, most inpatients have resided at the hospital for less than 79 hours.
- 2017 had a higher average of 84 hours because an Inpatient stayed for two months. The patient came for a periodic reevaluation and management.
- In 2018, the average stay-in hours was 319.71 hours. Another Inpatient with a periodic evaluation stayed for a year.
- The 2020 average stay-in hour is 82.57 because of COVID-19 patients. Their remaining time for isolation is 5.75 days, and the intensive care unit is 8.3 days.
- The average stay-in hours for 2021 was 87.58 hours. The average increased because COVID-19 patients stayed in the intensive care unit for a week. These patients in isolation stayed for ten days.

#### c. Hospital Costs per Visit
- The average cost per visit is $6,270.
- Inpatients have the highest average cost per visit, which is $9,330. COVID-19 costs $126,000 for the intensive care unit and $19,000 for isolation. The average increased because they encountered problems such as malignant disorders and injuries. The average price for these problems ranges from $10,000 to $26,000
- Outpatients have an average of $2.02k because most of them encounter lung cancer issues. These issues are suspicion of lung cancer, non-small cell lung cancer, and non-small cell lung carcinoma.
- Emergency patients spend an average of $7,460 because they encountered a stroke, which costs $161,000. The other two visits were for myocardial infarction and stroke, which cost $66,000 and $25,000, respectively.
#### d. Procedures Covered by Insurance
- 4756 insurance covered procedures, and Medicare is a popular insurance.
- Ambulatory vs. emergency: The average insurance coverage for emergency is $75,100, while it is $45,780 for ambulatory. The emergency average is higher because the top 5 procedure coverages are more significant than 0.2m, and three are $933.36k higher than the other two. The three procedures are bone misapplication, echocardiography, and percutaneous mechanical thrombectomy. The ambulatory average is lower because its top 5 procedure coverages are within 0.2m. However, colonoscopy coverage is higher than the other procedures because its average is 0.91m.
- Inpatients vs. Outpatients: The Outpatient average is $113.07k, and the Inpatient average is $88.44k. The Inpatient's top 5 procedures are higher than the Outpatient's top 5. The Inpatient's average is lower because the oxygen administration coverage is 0.13m, which is consistent with the range covered by other insurance. The Outpatient average is higher because the coverage ranges between 0.39m and 0.24m.
- Urgent care vs. wellness: Wellness's average coverage is higher than urgent care's. Urgent care has three procedures, while wellness has more than that amount.
