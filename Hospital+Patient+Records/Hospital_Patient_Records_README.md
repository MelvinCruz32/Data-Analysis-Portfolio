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
- In 2021, the average stay was 87.58 hours. The average increased  because COVID-19 patients stayed in the intensive care unit for a week. These patients in isolation stayed for ten days.
![Patients_Stay_In](https://github.com/user-attachments/assets/56fb68a8-dfbb-4b0e-b77b-54fc86294168)

#### c. Hospital Costs per Visit
- The average cost per visit is $6,270.
- Inpatients have the highest average cost per visit, at $9,330. COVID-19 cases cost an average of $126,000 for intensive care and $19,000 for isolation. These high costs were due to complications such as malignant disorders and injuries. The average price for these conditions ranged from $10,000 to $26,000.
  ![Patients_Visiting_2](https://github.com/user-attachments/assets/d1cabfd9-5ae8-405e-96a9-84a0c5320670)

- Outpatients have an average cost per visit of $2,020, primarily due to lung cancer-related cases. These include suspected lung cancer, non-small cell lung cancer, and non-small cell lung carcinoma.
  ![Patients_Visiting_3](https://github.com/user-attachments/assets/d2d3c003-03b3-433c-be6b-4400a885ecf4)

- Emergency patients had an average visit cost of $7,460, primarily due to stroke cases, which cost up to $161,000. Other costly visits included myocardial infarction and additional stroke cases, which cost $66,000 and $25,000.
  ![Patients_Visiting](https://github.com/user-attachments/assets/3096785f-02ec-430b-ac53-5a14b84a0f63)

#### d. Procedures Covered by Insurance
- 4,756 insurance-covered procedures, and Medicare is a popular insurance.
- The average insurance coverage for emergency procedures is $75,100, compared to $45,780 for ambulatory care. Emergency averages are higher because the top five procedures each exceed $200,000, with three of them costing approximately $933,360 more than the other two. These high-cost procedures include bone misapplication, echocardiography, and percutaneous mechanical thrombectomy. In contrast, the top five ambulatory procedures are below $200,000, although colonoscopy coverage stands out with an average of $910,000.
  ![Medical_Insurance_2](https://github.com/user-attachments/assets/e2fe2990-b46f-487e-8ba3-dfd01fc80511)
![Medical_Insurance_3](https://github.com/user-attachments/assets/bc9feb84-68d4-4e0f-a778-fb5c4fd3ffdd)

- Inpatients vs. Outpatients: The average insurance coverage for outpatient procedures is $113,070, while for inpatients it is $88,440. Although the top five inpatient procedures are more expensive, the overall average decreased due to the lower cost of oxygen administration, which is approximately $130,000, consistent with typical insurance coverage ranges. Outpatient coverage is higher overall because its top procedures range from $240,000 to $390,000.
  ![Medical_Insurance_4](https://github.com/user-attachments/assets/26843a97-c6bd-452f-ab93-add1173ecff9)
![Medical_Insurance_5](https://github.com/user-attachments/assets/b6e69ca3-a6f5-45e9-bf93-d56d605f862b)

- Urgent care vs. wellness: The average insurance coverage for wellness procedures is higher than that of urgent care. Urgent care includes three covered procedures, while wellness encompasses a greater number.
