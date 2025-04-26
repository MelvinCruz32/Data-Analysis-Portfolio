# Hospital Patient Records Analysis 

## I originally completed this project in November 2024. In April 2025, I revisited the code to improve readability by adding comments, editing the program, and updating documentation.

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
- This dataset is from the Maven Analytics data playground (https://mavenanalytics.io/data-playground?page=2&pageSize=5).
- It includes tables such as Encounters, Organizations, Patients, Payers, and Procedures.
### 2. Data Cleaning
- I detected and removed duplicates with a CTE, window function, and delete statement.
- Some of the patients' first and last names have improper letters. I analyzed their names to determine the correct letters.
- I renamed the columns, such as description, reason code, and reason description, to match the table name.
- In the Encounter table, the stop column has letters, so I removed them with a substring function. After that, I standardized that column into a date-time column. I merged the patients' first and last name columns for the Patients table into a full name column.
### 3. Visualization and Key Findings

#### a. Patients Admitted and Readmitted
- In 2014, 25 patients were admitted because of problem encounters, drug rehabilitation, and hospice admission. These patients encountered problems such as malignant disorders, malignant tumors, and overlapping malignant conditions.
![Admitted and Readmitted](https://github.com/user-attachments/assets/b056c76d-4507-4f3a-af70-2ba50f847083)

- In 2020, 30 patients came to the hospital because of COVID-19, chronic heart failure, and malignant disorder. Admissions for that year increased because 48% of COVID-19 patients went to the hospital.
![Admitted and Readmitted 2](https://github.com/user-attachments/assets/2783b08c-d49f-47f6-8b42-e428770aef86)

- Four patients were readmitted because they encountered problems. The majority of these reasons are unknown. The readmission years are 2011, 2013, 2018, and 2019.
![Admitted and Readmitted 3](https://github.com/user-attachments/assets/aca6b447-a437-4a27-b192-61b57d10f9e7)

#### b. Average Stay
- The average inpatient stay is 79 hours. Inpatients stayed for at least 79 hours in 2017, 2018, 2020, and 2021. In other years, most inpatients stayed for less than 79 hours.
- In 2017, the average inpatient stay was 84 hours due to one patient who stayed for two months for a periodic reevaluation and management.
- In 2018, the average stay was 319.71 hours due to another patient who stayed for a year for a periodic evaluation.
- In 2020, the average inpatient stay was 82.57 hours, influenced by COVID-19 cases. These patients remained in isolation for an average of 5.75 days and in the intensive care unit for 8.3 days.
- In 2021, the average stay was 87.58 hours. The average increased  because COVID-19 patients stayed in the intensive care unit for a week. These patients stayed in isolation for ten days.
![Patients_Stay_In](https://github.com/user-attachments/assets/56fb68a8-dfbb-4b0e-b77b-54fc86294168)

#### c. Hospital Costs per Visit
- The average cost per visit is $6,270.
- Inpatients have the highest average cost per visit. It is $9,330 because COVID-19 costs $126,000 for the intensive care unit and $19,000 for isolation. The average increases more because they encounter problems such as malignant disorders and injuries. The average price for these problems ranges from $10,000 to $26,000
  ![Patients_Visiting_2](https://github.com/user-attachments/assets/d1cabfd9-5ae8-405e-96a9-84a0c5320670)

- Outpatients have an average of $2.02k because most of them encounter lung cancer issues. These issues are suspicion of lung cancer, non-small cell lung cancer, and non-small lung carcinoma.
  ![Patients_Visiting_3](https://github.com/user-attachments/assets/d2d3c003-03b3-433c-be6b-4400a885ecf4)

- Emergency patients spend an average of $7,460 because they encountered a stroke, which costs $161,000. The other two visits were for myocardial infarction and stroke, which cost between $66,000 and $25,000.
  ![Patients_Visiting](https://github.com/user-attachments/assets/3096785f-02ec-430b-ac53-5a14b84a0f63)

#### d. Procedures Covered by Insurance
- 4,756 insurance-covered procedures, and Medicare is a popular insurance.
  ![Medical_Insurance_1](https://github.com/user-attachments/assets/a6039a0e-d12c-4012-86f5-8c4a527f986b)

- Ambulatory vs emergency: The average insurance coverage for emergency patients is $75,100, while for ambulatory patients, it is $45,780. This average is higher because the top 5 procedure coverages are more significant than 0.2m, and three are $933.36k higher than the other two. The three procedures are bone misapplication, echocardiography, and percutaneous mechanical thrombectomy. The ambulatory average is lower than the emergency average because the ambulatory’s top 5 procedure coverages are within 0.2m. However, colonoscopy is more significant because it has an average length of 91 million.
  ![Medical_Insurance_2](https://github.com/user-attachments/assets/e2fe2990-b46f-487e-8ba3-dfd01fc80511)
![Medical_Insurance_3](https://github.com/user-attachments/assets/bc9feb84-68d4-4e0f-a778-fb5c4fd3ffdd)

- Inpatients vs Outpatients: The outpatient’s average is 113,007, and the inpatient’s average is $88,440. Most of the Inpatient’s top 5 procedures are higher than the outpatient’s top 5 procedures. However, the inpatient average is lower because the coverage for oxygen administration is $13 million, and others are covered within that range. The outpatient average among the top 5 procedures is higher because the coverage ranges between $39 million and $24 million. The coverage is different because the outpatient coverage was not lower than the inpatient coverage.
  ![Medical_Insurance_4](https://github.com/user-attachments/assets/26843a97-c6bd-452f-ab93-add1173ecff9)
![Medical_Insurance_5](https://github.com/user-attachments/assets/b6e69ca3-a6f5-45e9-bf93-d56d605f862b)

- Urgent care vs. wellness: Wellness’s average coverage is higher than urgent care’s average. Urgent care has three procedures, while wellness has more procedures.
![Medical_Insurance_5](https://github.com/user-attachments/assets/c0dd54e1-3e46-4311-93ad-d6c423768bfd)
![Medical_Insurance_6](https://github.com/user-attachments/assets/353f26e1-2de0-445e-ba33-86ec3ca1aecb)


