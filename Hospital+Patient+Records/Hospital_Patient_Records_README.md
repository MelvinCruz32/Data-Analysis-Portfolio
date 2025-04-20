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
- Some of the patients’ first and last names have improper letters. I analyzed their names to determine the correct letters.
- I renamed the columns, such as description, reason code, and reason description, to match the table name.
- In the Encounter table, the stop column has letters, so I removed them with a substring function. After that, I standardized that column into a date-time column. I merged the patients’ first and last name columns for the Patients table into a full name column.
### 3. Visualization and Key Findings

#### a.

#### b.

#### c.

#### d.
