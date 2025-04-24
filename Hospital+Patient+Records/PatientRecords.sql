CREATE DATABASE PatientRecords;

-- Cleaning the Encounters Table.
SELECT *
FROM PatientRecords..encounters$;

-- Removes extra spaces.
SELECT DESCRIPTION, TRIM(DESCRIPTION) AS 'Description without Extra Space'
FROM PatientRecords..encounters$;

--Removes the letters from the start and stop columns.
UPDATE PatientRecords..encounters$
SET START = REPLACE(START, 'T', ' ');

UPDATE PatientRecords..encounters$
SET START = REPLACE(START, 'Z', '');

UPDATE PatientRecords..encounters$
SET STOP = REPLACE(STOP, 'T', ' ');

UPDATE PatientRecords..encounters$
SET STOP = REPLACE(STOP, 'Z', ' ');

--Renaming columns.
EXEC sp_rename 'dbo.encounters$.REASONCODE', 'REASON_CODE', 'COLUMN';

EXEC sp_rename 'dbo.encounters$.REASONDESCRIPTION', 'REASON_DESCRIPTION', 'COLUMN';

EXEC sp_rename 'dbo.encounters$.START', 'START_DATE', 'COLUMN';

EXEC sp_rename 'dbo.encounters$.STOP', 'STOP_DATE', 'COLUMN';

EXEC sp_rename 'dbo.encounters$.ENCOUNTERCLASS', 'ENCOUNTER_CLASS', 'COLUMN';

--Converting the start and stop date columns into DateTime data types.
ALTER TABLE PatientRecords..encounters$
ALTER COLUMN START_DATE datetime;

ALTER TABLE PatientRecords..encounters$
ALTER COLUMN STOP_DATE datetime;

--Check and fill out empty rows in the reason code and reason description columns.
SELECT ISNULL(REASON_CODE, 0)
FROM PatientRecords..encounters$;

SELECT ISNULL(REASON_DESCRIPTION, 'No Reason Description')
FROM PatientRecords..encounters$;

UPDATE PatientRecords..encounters$
SET REASON_CODE = ISNULL(REASON_CODE, 0);

UPDATE PatientRecords..encounters$
SET REASON_DESCRIPTION = ISNULL(REASON_DESCRIPTION, 'No Reason Description');

--Removing duplicates with a window function. If the row number is greater than 1, there is a duplicate.
WITH EncountDup as (
SELECT *, ROW_NUMBER() OVER(PARTITION BY PATIENT, PAYER, ENCOUNTER_CLASS, CODE, DESCRIPTION, BASE_ENCOUNTER_COST, REASON_CODE, REASON_DESCRIPTION ORDER BY PATIENT) AS ROW_NUMBER
FROM PatientRecords..encounters$)
DELETE FROM EncountDup
WHERE ROW_NUMBER > 1;

--With only one occurrence, there are no duplicates.
WITH EncountDup2 as (
SELECT *, ROW_NUMBER() OVER(PARTITION BY PATIENT, PAYER, ENCOUNTER_CLASS,CODE, DESCRIPTION, BASE_ENCOUNTER_COST, REASON_CODE, REASON_DESCRIPTION ORDER BY PATIENT) AS ROW_NUMBER
FROM PatientRecords..encounters$)
SELECT * 
FROM EncountDup2
WHERE ENCOUNTER_CLASS = 'inpatient' and PATIENT = '18e7819f-5407-9d84-de9f-27a4d5526695';

--Creating two new tables for patients who we admitted and readmitted.
CREATE TABLE PatientRecords..PatientsAdmitted$ ( 
	Id nvarchar(255),
	START_DATE datetime,
	STOP_DATE datetime,
	FULL_NAME nvarchar(255),
	PAYER nvarchar(255),
	CODE float,
	DESCRIPTION nvarchar(255),
	Number_of_Occurances int,
);

CREATE TABLE PatientRecords..PatientsReadmitted$ ( 
	Id nvarchar(255),
	START_DATE datetime,
	STOP_DATE datetime,
	FULL_NAME nvarchar(255),
	PAYER nvarchar(255),
	CODE float,
	DESCRIPTION nvarchar(255),
	Number_of_Occurances int,
);

SELECT *
FROM PatientRecords..encounters$;

--Insert records of admitted patients with a CTE and left join. The left join queries the Encounters and Patients tables, including those marked as inpatient.
WITH Admission AS (
SELECT e.Id, e.START_DATE, e.STOP_DATE, p.FULL_NAME, e.PAYER, e.CODE, e.DESCRIPTION, ROW_NUMBER() OVER(PARTITION BY FULL_NAME ORDER BY FULL_NAME) AS row_num
FROM PatientRecords..encounters$ e
left join PatientRecords..patients$ p on
e.PATIENT = p.Id
WHERE e.ENCOUNTER_CLASS = 'inpatient')
INSERT INTO PatientRecords..PatientsAdmitted$
SELECT * FROM Admission
WHERE row_num = 1 OR FULL_NAME in('Jenni Emard', 'Shellie Lind', 'Maurice Hermiston', 'Rivka Schumm', 'Linsey Thiel', 'Phylis Block', 'Micha Doyle', 
'Vannesa Bode', 'Ike Becker', 'Spring Crooks', 'Estrella Homenick', 'Wendell Hessel', 'Gerardo Valenzuela', 'Miguel Manzanares', 'Estrella Homenick', 'Chi Mante', 'Jenni Emard')

Wendell Hessel
Gerardo Valenzuela
Miguel Manzanares
Emelia West
Estrella Homenick

SELECT START_DATE, STOP_DATE, FULL_NAME, DESCRIPTION
FROM PatientRecords..PatientsAdmitted$
WHERE Number_of_Occurances > 1
ORDER BY YEAR(START_DATE), MONTH(START_DATE), DAY(START_DATE), FULL_NAME;

--List of records to remove by name
Phylis Block for 2013
Rivka Schumm
--Removing the records that count as readmittance. These records contain the ones that inpatients return within 30 days.
WHERE FULL_NAME = 'Micha Doyle' AND YEAR(START_DATE) = '2019';

DELETE FROM PatientRecords..PatientsAdmitted$
WHERE FULL_NAME = 'Jenni Emard' AND YEAR(START_DATE) = '2018';

DELETE FROM PatientRecords..PatientsAdmitted$
WHERE FULL_NAME = 'Rivka Schumm' AND YEAR(START_DATE) = '2016';

DELETE FROM PatientRecords..PatientsAdmitted$
WHERE FULL_NAME = 'Phylis Block' AND YEAR(START_DATE) = '2013';

SELECT *
FROM PatientRecords..PatientsAdmitted$
WHERE Number_of_Occurances > 1
ORDER BY YEAR(START_DATE), MONTH(START_DATE), DAY(START_DATE), FULL_NAME;

SELECT * 
FROM PatientRecords..PatientsReadmitted$;
--Using a CTE and left join to insert records into the readmittance table. This query includes inpatients who return within 30 days after discharge.
WITH Readmitted AS (
SELECT e.Id, e.START_DATE, e.STOP_DATE, p.FULL_NAME, e.PAYER, e.CODE, e.DESCRIPTION, COUNT(p.FULL_NAME) OVER(PARTITION BY FULL_NAME ORDER BY FULL_NAME) AS num_of_occ
FROM PatientRecords..encounters$ e
left join PatientRecords..patients$ p on
e.PATIENT = p.Id
WHERE e.ENCOUNTER_CLASS = 'inpatient')
INSERT INTO PatientRecords..PatientsReadmitted$
SELECT * FROM Readmitted
WHERE FULL_NAME in ('Valencia Schuster', 'Micha Doyle', 'Rivka Schumm', 'Phylis Block');

SELECT *
FROM PatientRecords..PatientsReadmitted$;

--Delete records that doesn't count as readmittance
DELETE FROM PatientRecords..PatientsReadmitted$
WHERE FULL_NAME = 'Micha Doyle' AND YEAR(START_DATE) <> '2019'

DELETE FROM PatientRecords..PatientsReadmitted$
WHERE FULL_NAME = 'Jenni Emard' AND YEAR(START_DATE) = '2013';

DELETE FROM PatientRecords..PatientsReadmitted$
WHERE FULL_NAME = 'Rivka Schumm' AND YEAR(START_DATE) <> '2016';

DELETE FROM PatientRecords..PatientsReadmitted$
WHERE FULL_NAME = 'Phylis Block' AND YEAR(START_DATE) <> '2013';

DELETE FROM PatientRecords..PatientsReadmitted$
WHERE FULL_NAME = 'Jenni Emard';

SELECT *
FROM PatientRecords..PatientsReadmitted$
ORDER BY YEAR(START_DATE), MONTH(START_DATE), FULL_NAME;

SELECT *
FROM PatientRecords..PatientsAdmitted$
WHERE Number_of_Occurances > 1
ORDER BY YEAR(START_DATE), FULL_NAME;

Ike Becker
Spring Crooks
Micha Doyle
Phylis Block

Wendell Hessel
Gerardo Valenzuela
Miguel Manzanares
Emelia West
Estrella Homenick

SELECT *
FROM PatientRecords..PatientsAdmitted$
WHERE Number_of_Occurances > 1
ORDER BY YEAR(START_DATE), FULL_NAME;

SELECT *
FROM PatientRecords..PatientsReadmitted$
ORDER BY YEAR(START_DATE);

--Cleaning the Procudes Table
SELECT *
FROM PatientRecords..procedures$;

--Eliminating unnecessary letters to clean the start and stop date columns.
UPDATE PatientRecords..procedures$
SET START = REPLACE(START, 'T', ' ');

UPDATE PatientRecords..procedures$
SET START = REPLACE(START, 'Z', ' ');

UPDATE PatientRecords..procedures$
SET START = CONVERT(datetime, START);

UPDATE PatientRecords..procedures$
SET STOP = REPLACE(STOP, 'T', ' ');

UPDATE PatientRecords..procedures$
SET STOP = REPLACE(STOP, 'Z', ' ');

--Convert the stop column into a DateTime column.
UPDATE PatientRecords..procedures$
SET STOP = CONVERT(datetime, STOP);

--Removing duplicates using a CTE and window function.
WITH ProcudureDup AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY PATIENT, ENCOUNTER, DESCRIPTION ORDER BY PATIENT) AS ROW_NUMBER
FROM PatientRecords..procedures$)
DELETE FROM ProcudureDup
WHERE ROW_NUMBER > 1;

--Ensuring that there are no duplicates.
WITH ProcudureDup2 AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY PATIENT, ENCOUNTER, DESCRIPTION ORDER BY PATIENT) AS ROW_NUMBER
FROM PatientRecords..procedures$)
SELECT * 
FROM ProcudureDup2;

UPDATE PatientRecords..encounters$
SET DESCRIPTION = TRIM(DESCRIPTION);

--Renaming columns such as description, base cost, reason code, and reason description.
EXEC sp_rename 'dbo.procedures$.DESCRIPTION', 'PROCEDURE_DESCRIPTION', 'COLUMN';

EXEC sp_rename 'dbo.procedures$.BASE_COST', 'PROCEDURE_BASE_COST', 'COLUMN';

EXEC sp_rename 'dbo.procedures$.REASONCODE', 'PROCEDURE_REASONCODE', 'COLUMN';

EXEC sp_rename 'dbo.procedures$.REASONDESCRIPTION', 'PROCEDURE_REASON_DESCRIPTION', 'COLUMN';

--Fill in the blank rows in the procedure reason code and reason description.
UPDATE PatientRecords..procedures$
SET PROCEDURE_REASONCODE = ISNULL(PROCEDURE_REASONCODE, 0);

UPDATE PatientRecords..procedures$
SET PROCEDURE_REASON_DESCRIPTION = ISNULL(PROCEDURE_REASON_DESCRIPTION, 'No Procedure Reason');

--Cleaning the Patients Table
SELECT *
FROM PatientRecords..patients$;

--Replacing incorrect letters with the correct ones.
UPDATE PatientRecords..patients$
SET FIRST = REPLACE(FIRST, 'Ã³', 'a');

UPDATE PatientRecords..patients$
SET LAST = REPLACE(LAST, 'Ã©', 'e');

UPDATE PatientRecords..patients$
SET FIRST = REPLACE(FIRST, 'Ã©', 'e');

UPDATE PatientRecords..patients$
SET LAST = REPLACE(LAST, 'Ã©', 'e');

UPDATE PatientRecords..patients$
SET FIRST = REPLACE(FIRST, 'Ã', 'i');

UPDATE PatientRecords..patients$
SET LAST = REPLACE(LAST, 'Ã', 'i');

UPDATE PatientRecords..patients$
SET LAST = REPLACE(LAST, 'de JesÃºs414', 'Dejesus414');

UPDATE PatientRecords..patients$
SET LAST = REPLACE(LAST, 'ÃºÃ±', 'un');

UPDATE PatientRecords..patients$
SET FIRST = REPLACE(FIRST, '¡', 'a');

UPDATE PatientRecords..patients$
SET LAST = REPLACE(LAST, '¡', 'a');

UPDATE PatientRecords..patients$
SET LAST = REPLACE(LAST, '¡', 'a');

UPDATE PatientRecords..patients$
SET FULL_NAME = 'Ramiro Dejesus'
WHERE FULL_NAME = 'Ramiro de Jesiºs';

UPDATE PatientRecords..patients$
SET FULL_NAME = 'Beatriz Villaseior'
WHERE FULL_NAME = 'Beatriz Villasei±or';

UPDATE PatientRecords..patients$
SET FULL_NAME = 'Carlos Fari­as'
WHERE FULL_NAME = 'Carlos Farias';

SELECT FULL_NAME
FROM PatientRecords..patients$
WHERE FULL_NAME LIKE 'Mercedes%';

--Correcting patients' last names.
UPDATE PatientRecords..patients$
SET LAST = 'Enriquez'
WHERE FIRST = 'Beatriz';

UPDATE PatientRecords..patients$
SET LAST = 'Marin'
WHERE FIRST = 'Jose Emilio';

UPDATE PatientRecords..patients$
SET LAST = 'Martinez'
WHERE FIRST = 'Virginia';

UPDATE PatientRecords..patients$
SET LAST = 'Chavarri­a'
WHERE FIRST = 'Mercedes';

UPDATE PatientRecords..patients$
SET LAST = 'Delrio'
WHERE FIRST = 'Juana';

UPDATE PatientRecords..patients$
SET FIRST = 'Maria Teresa'
WHERE LAST = 'Pedroza';

UPDATE PatientRecords..patients$
SET LAST = 'Perez'
WHERE FIRST = 'Norma';

--Removing extra spaces in the birth date column.
SELECT TRIM(BIRTHDATE)
FROM PatientRecords..patients$;

UPDATE PatientRecords..patients$
SET BIRTHPLACE = REPLACE(BIRTHPLACE, '  ', ', ');

UPDATE PatientRecords..patients$
SET BIRTHDATE = CONVERT(datetime, BIRTHDATE);

UPDATE PatientRecords..patients$
SET ZIP = ISNULL(ZIP, 00000);

ALTER TABLE PatientRecords..patients$
DROP COLUMN SUFFIX, MAIDEN, DEATHDATE;

--Removing numbers from the first and last name columns.
UPDATE PatientRecords..patients$
SET FIRST = SUBSTRING(FIRST, 1, PATINDEX('%[1-9]%', FIRST)-1);

UPDATE PatientRecords..patients$
SET LAST = SUBSTRING(LAST, 1, PATINDEX('%[1-9]%', LAST)-1);

--Filling the blank rows in the martial column with “N/A”.

UPDATE PatientRecords..patients$
SET MARITAL = ISNULL(MARITAL, 'N/A');

SELECT FIRST, LAST, BIRTHDATE, BIRTHPLACE, ADDRESS
FROM PatientRecords..patients$
WHERE FIRST LIKE 'Jose E%';

SELECT *, ROW_NUMBER() OVER(PARTITION BY FIRST, LAST ORDER BY FIRST) AS ROW_NUMBER
FROM PatientRecords..patients$
ORDER BY LAST;

--Creating and merging the first and last name columns.
UPDATE PatientRecords..patients$
SET FIRST = CONCAT(FIRST, ' ', LAST);

ALTER TABLE PatientRecords..patients$
DROP COLUMN LAST;

EXEC sp_rename 'dbo.patients$.FIRST', 'FULL_NAME', 'COLUMN';

Ramiro de Jesiºs
Mercedes Chavarri­a
Beatriz Villasei±or
Carlos Fari­as

-- Cleaning the Procedures Table
SELECT *
FROM PatientRecords..procedures$;

UPDATE PatientRecords..procedures$
SET DESCRIPTION = TRIM(DESCRIPTION);

EXEC sp_rename 'dbo.procedures$.PROCEDURE DESCRIPTION', 'PROCEDURE_DESCRIPTION', 'COLUMN';

-- ANALYTICAL PROCESS (Checking how many patients are admitted or readmitted?)

-- Querying the unique values of patients who were admitted or readmitted.
SELECT Year(START_DATE) AS 'YEARS', COUNT(DISTINCT(FULL_NAME)) AS 'Amount_of_Patients_Admitted'
FROM PatientRecords..PatientsAdmitted$
GROUP BY YEAR(START_DATE);

SELECT YEAR(START_DATE) AS 'YEARS', COUNT(DISTINCT(FULL_NAME)) AS 'Amount_of_Patients_Readmitted'
FROM PatientRecords..PatientsReadmitted$
GROUP BY YEAR(START_DATE);

--Identifying patient admission reasons in 2014 and 2020.
SELECT YEAR(pa.START_DATE) 'Year', e.DESCRIPTION, e.REASON_DESCRIPTION
FROM PatientRecords..encounters$ e
JOIN PatientRecords..PatientsAdmitted$ pa
on e.Id = pa.Id
WHERE YEAR(pa.START_DATE) IN ('2014', '2020') AND e.ENCOUNTER_CLASS = 'Inpatient'
ORDER BY Year(pa.START_DATE);

--Determining patient readmittance.
SELECT pr.START_DATE, pr.STOP_DATE, e.DESCRIPTION, e.REASON_DESCRIPTION
FROM PatientRecords..encounters$ e
JOIN PatientRecords..PatientsReadmitted$ pr
on e.Id = pr.Id
WHERE e.ENCOUNTER_CLASS = 'Inpatient'
ORDER BY YEAR(pr.START_DATE), MONTH(pr.START_DATE), DAY(pr.START_DATE);

SELECT *
FROM PatientRecords..PatientsReadmitted$
ORDER BY YEAR(START_DATE);

-- ANALYTICAL PROCESS (How long are patients staying in the hospital, on avaerage?)

--Calculating the average stay-in hours.
SELECT ENCOUNTER_CLASS, AVG(DATEDIFF(HOUR, START_DATE, STOP_DATE)) AS 'Average_Stay_in_Hours'
FROM PatientRecords..encounters$
WHERE ENCOUNTER_CLASS = 'inpatient'
GROUP BY ENCOUNTER_CLASS;

--Fetching stay-in hours from the previous years.
SELECT YEAR(START_DATE) AS 'Year', AVG(DATEDIFF(HOUR, START_DATE, STOP_DATE)) AS 'Length of Stay in Hours'
FROM PatientRecords..encounters$
WHERE ENCOUNTER_CLASS = 'inpatient'
GROUP BY START_DATE
ORDER BY YEAR(START_DATE);

--Gaining insights into the cause of higher average stay-in hours.
SELECT YEAR(START_DATE) AS 'Year', DESCRIPTION, REASON_DESCRIPTION, AVG(DATEDIFF(HOUR, START_DATE, STOP_DATE)) AS 'Average_Stay-In_Hours'
FROM PatientRecords..encounters$
WHERE ENCOUNTER_CLASS = 'inpatient' AND YEAR(START_DATE) IN ('2017', '2018', '2020', '2021')
GROUP BY YEAR(START_DATE), DESCRIPTION, REASON_DESCRIPTION
HAVING AVG(DATEDIFF(HOUR, START_DATE, STOP_DATE)) > 79
ORDER BY YEAR(START_DATE);

SELECT YEAR(e.START_DATE) AS 'YEAR', COUNT(DISTINCT(p.FULL_NAME))
FROM PatientRecords..encounters$ e
JOIN PatientRecords..patients$ p
on e.PATIENT = p.Id
WHERE e.ENCOUNTER_CLASS = 'inpatient' AND YEAR(e.START_DATE) = '2020'
GROUP BY YEAR(e.START_DATE)
HAVING AVG(DATEDIFF(HOUR, e.START_DATE, e.STOP_DATE)) > 79;

-- ANALYTICAL PROCESS (How much is the average cost per visit?)

--Calculate the average visiting cost for emergency, inpatient, and outpatient patients.
SELECT ENCOUNTER_CLASS, AVG(TOTAL_CLAIM_COST) AS 'Average per Visit'
FROM PatientRecords..encounters$
WHERE ENCOUNTER_CLASS IN ('Emergency', 'Inpatient', 'Outpatient')
GROUP BY ENCOUNTER_CLASS;

--Computing the average for the reasons these patients visited.
SELECT ENCOUNTER_CLASS, DESCRIPTION, REASON_DESCRIPTION, AVG(TOTAL_CLAIM_COST) AS 'Average_Amount'
FROM PatientRecords..encounters$
WHERE ENCOUNTER_CLASS IN ('Emergency', 'Inpatient', 'Outpatient')
GROUP BY ENCOUNTER_CLASS, DESCRIPTION, REASON_DESCRIPTION
ORDER BY ENCOUNTER_CLASS;

-- ANALYTICAL PROCESS (How many procedures are covered by insurance?)

--Obtaining data for patients with insurance only. The where clause indicates that it does not include patients with no insurance.
SELECT *
FROM PatientRecords..encounters$ e
LEFT JOIN PatientRecords..procedures$ p
on e.Id = p.ENCOUNTER
WHERE e.PAYER <> 'b1c428d6-4f07-31e0-90f0-68ffa6ff8c76';

--Retrieving the number of procedures covered by insurance and its cost is at least $0.
SELECT COUNT(*) as 'Number of Procedures covered by Insurance'
FROM PatientRecords..encounters$ e
INNER JOIN PatientRecords..procedures$ p
on e.Id = p.ENCOUNTER
WHERE e.PAYER <> 'b1c428d6-4f07-31e0-90f0-68ffa6ff8c76' AND e.PAYER_COVERAGE > 0;

--Using the CTE to retrieve the number of insurance that covers procedures and querying the names of insurances.
WITH CTE1 AS (
SELECT e.PAYER, COUNT(e.PAYER) as 'Amount'
FROM PatientRecords..encounters$ e
INNER JOIN PatientRecords..procedures$ p
on e.Id = p.ENCOUNTER
WHERE e.PAYER <> 'b1c428d6-4f07-31e0-90f0-68ffa6ff8c76' and e.PAYER_COVERAGE > 0
GROUP BY e.PAYER) 
SELECT T2.NAME AS 'Insurance Name', T1.Amount
FROM CTE1 T1
JOIN PatientRecords..payers$ T2 
on T1.PAYER = T2.Id;

--Accessing Medicare insurance coverages for each encounter class that underwent a procedure.
SELECT e.ENCOUNTER_CLASS, p.PROCEDURE_DESCRIPTION, p.PROCEDURE_REASON_DESCRIPTION , SUM(e.PAYER_COVERAGE) as 'INSURANCE COVERAGE'
FROM PatientRecords..procedures$ p
INNER JOIN PatientRecords..encounters$ e on p.ENCOUNTER = e.Id
INNER JOIN PatientRecords..payers$ p2 on e.PAYER = p2.Id
WHERE p2.NAME = 'Medicare' AND e.ENCOUNTER_CLASS IN ('ambulatory', 'outpatient', 'wellness', 'emergency', 'inpatient', 'urgentcare')
GROUP BY e.ENCOUNTER_CLASS, p.PROCEDURE_DESCRIPTION, p.PROCEDURE_REASON_DESCRIPTION
HAVING SUM(e.PAYER_COVERAGE) > 0
ORDER BY e.ENCOUNTER_CLASS ASC,[INSURANCE COVERAGE] DESC;

SELECT distinct(REASON_DESCRIPTION)
FROM PatientRecords..encounters$
WHERE ENCOUNTER_CLASS = 'Outpatient';