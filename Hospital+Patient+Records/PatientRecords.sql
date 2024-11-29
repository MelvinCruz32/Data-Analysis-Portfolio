CREATE DATABASE PatientRecords;

-- CLEANING ENCOUNTERS TABLE
SELECT *
FROM PatientRecords..encounters$;

SELECT DESCRIPTION, TRIM(DESCRIPTION) AS 'Description without Extra Space'
FROM PatientRecords..encounters$;

UPDATE PatientRecords..encounters$
SET START = REPLACE(START, 'T', ' ');

UPDATE PatientRecords..encounters$
SET START = REPLACE(START, 'Z', '');

UPDATE PatientRecords..encounters$
SET STOP = REPLACE(STOP, 'T', ' ');

UPDATE PatientRecords..encounters$
SET STOP = REPLACE(STOP, 'Z', ' ');

EXEC sp_rename 'dbo.encounters$.REASONCODE', 'REASON_CODE', 'COLUMN';

EXEC sp_rename 'dbo.encounters$.REASONDESCRIPTION', 'REASON_DESCRIPTION', 'COLUMN';

EXEC sp_rename 'dbo.encounters$.START', 'START_DATE', 'COLUMN';

EXEC sp_rename 'dbo.encounters$.STOP', 'STOP_DATE', 'COLUMN';

EXEC sp_rename 'dbo.encounters$.ENCOUNTERCLASS', 'ENCOUNTER_CLASS', 'COLUMN';

ALTER TABLE PatientRecords..encounters$
ALTER COLUMN START_DATE datetime;

ALTER TABLE PatientRecords..encounters$
ALTER COLUMN STOP_DATE datetime;

SELECT ISNULL(REASON_CODE, 0)
FROM PatientRecords..encounters$;

SELECT ISNULL(REASON_DESCRIPTION, 'No Reason Description')
FROM PatientRecords..encounters$;

UPDATE PatientRecords..encounters$
SET REASON_CODE = ISNULL(REASON_CODE, 0);

UPDATE PatientRecords..encounters$
SET REASON_DESCRIPTION = ISNULL(REASON_DESCRIPTION, 'No Reason Description');

WITH EncountDup as (
SELECT *, ROW_NUMBER() OVER(PARTITION BY PATIENT, PAYER, ENCOUNTER_CLASS, CODE, DESCRIPTION, BASE_ENCOUNTER_COST, REASON_CODE, REASON_DESCRIPTION ORDER BY PATIENT) AS ROW_NUMBER
FROM PatientRecords..encounters$)
DELETE FROM EncountDup
WHERE ROW_NUMBER > 1;

WITH EncountDup2 as (
SELECT *, ROW_NUMBER() OVER(PARTITION BY PATIENT, PAYER, ENCOUNTER_CLASS,CODE, DESCRIPTION, BASE_ENCOUNTER_COST, REASON_CODE, REASON_DESCRIPTION ORDER BY PATIENT) AS ROW_NUMBER
FROM PatientRecords..encounters$)
SELECT * 
FROM EncountDup2
WHERE ENCOUNTER_CLASS = 'inpatient' and PATIENT = '18e7819f-5407-9d84-de9f-27a4d5526695';

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

WITH Admission AS (
SELECT e.Id, e.START_DATE, e.STOP_DATE, p.FULL_NAME, e.PAYER, e.CODE, e.DESCRIPTION, ROW_NUMBER() OVER(PARTITION BY FULL_NAME ORDER BY FULL_NAME) AS row_num
FROM PatientRecords..encounters$ e
left join PatientRecords..patients$ p on
e.PATIENT = p.Id
WHERE e.ENCOUNTER_CLASS = 'inpatient')
INSERT INTO PatientRecords..PatientsAdmitted$
SELECT * FROM Admission
WHERE row_num = 1 OR FULL_NAME in('Jenni Emard', 'Shellie Lind', 'Maurice Hermiston', 'Rivka Schumm', 'Linsey Thiel', 'Phylis Block', 'Micha Doyle', 
'Vannesa Bode', 'Ike Becker', 'Spring Crooks', 'Estrella Homenick', 'Wendell Hessel', 'Gerardo Valenzuela', 'Miguel Manzanares', 'Estrella Homenick')

Wendell Hessel
Gerardo Valenzuela
Miguel Manzanares
Emelia West
Estrella Homenick

SELECT *
FROM PatientRecords..PatientsAdmitted$
ORDER BY FULL_NAME;

DELETE FROM PatientRecords..PatientsAdmitted$
WHERE FULL_NAME = 'Micha Doyle' AND YEAR(START_DATE) = '2019';

DELETE FROM PatientRecords..PatientsAdmitted$
WHERE FULL_NAME = 'Jenni Emard' AND YEAR(START_DATE) = '2018';

DELETE FROM PatientRecords..PatientsAdmitted$
WHERE FULL_NAME = 'Rivka Schumm' AND YEAR(START_DATE) = '2016';

DELETE FROM PatientRecords..PatientsAdmitted$
WHERE FULL_NAME = 'Rivka Schumm' AND YEAR(START_DATE) = '2020';

SELECT *
FROM PatientRecords..PatientsAdmitted$
WHERE FULL_NAME = 'Phylis Block'
ORDER BY YEAR(START_DATE), MONTH(START_DATE), DAY(START_DATE);

WITH Readmitted AS (
SELECT e.Id, e.START_DATE, e.STOP_DATE, p.FULL_NAME, e.PAYER, e.CODE, e.DESCRIPTION, COUNT(p.FULL_NAME) OVER(PARTITION BY FULL_NAME ORDER BY FULL_NAME) AS num_of_occ
FROM PatientRecords..encounters$ e
left join PatientRecords..patients$ p on
e.PATIENT = p.Id
WHERE e.ENCOUNTER_CLASS = 'inpatient')
INSERT INTO PatientRecords..PatientsReadmitted$
SELECT * FROM Readmitted
WHERE FULL_NAME in ('Valencia Schuster', 'Chi Mante', 'Jenni Emard', 'Micha Doyle', 'Rivka Schumm');

SELECT *
FROM PatientRecords..PatientsReadmitted$;

DELETE FROM PatientRecords..PatientsReadmitted$
WHERE FULL_NAME = 'Micha Doyle' AND YEAR(START_DATE) <> '2019'

DELETE FROM PatientRecords..PatientsReadmitted$
WHERE FULL_NAME = 'Jenni Emard' AND YEAR(START_DATE) = '2013';

DELETE FROM PatientRecords..PatientsReadmitted$
WHERE FULL_NAME = 'Rivka Schumm' AND YEAR(START_DATE) <> '2016' AND YEAR(START_DATE) <> '2020';

SELECT *
FROM PatientRecords..PatientsReadmitted$
ORDER BY YEAR(START_DATE), MONTH(START_DATE), FULL_NAME;

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
ORDER BY FULL_NAME;

SELECT *
FROM PatientRecords..PatientsReadmitted$
ORDER BY YEAR(START_DATE);

-- CLEANING PROCEDURES TABLE
SELECT *
FROM PatientRecords..procedures$;

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

UPDATE PatientRecords..procedures$
SET STOP = CONVERT(datetime, STOP);

WITH ProcudureDup AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY PATIENT, ENCOUNTER, DESCRIPTION ORDER BY PATIENT) AS ROW_NUMBER
FROM PatientRecords..procedures$)
DELETE FROM ProcudureDup
WHERE ROW_NUMBER > 1;

WITH ProcudureDup2 AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY PATIENT, ENCOUNTER, DESCRIPTION ORDER BY PATIENT) AS ROW_NUMBER
FROM PatientRecords..procedures$)
SELECT * 
FROM ProcudureDup2;

UPDATE PatientRecords..encounters$
SET DESCRIPTION = TRIM(DESCRIPTION);

EXEC sp_rename 'dbo.procedures$.DESCRIPTION', 'PROCEDURE_DESCRIPTION', 'COLUMN';

EXEC sp_rename 'dbo.procedures$.BASE_COST', 'PROCEDURE_BASE_COST', 'COLUMN';

EXEC sp_rename 'dbo.procedures$.REASONCODE', 'PROCEDURE_REASONCODE', 'COLUMN';

EXEC sp_rename 'dbo.procedures$.REASONDESCRIPTION', 'PROCEDURE_REASON_DESCRIPTION', 'COLUMN';

UPDATE PatientRecords..procedures$
SET PROCEDURE_REASONCODE = ISNULL(PROCEDURE_REASONCODE, 0);

UPDATE PatientRecords..procedures$
SET PROCEDURE_REASON_DESCRIPTION = ISNULL(PROCEDURE_REASON_DESCRIPTION, 'No Procedure Reason');

--CLEANING PATIENTS TABLE
SELECT *
FROM PatientRecords..patients$;

UPDATE PatientRecords..patients$
SET FIRST = REPLACE(FIRST, '√≥', 'a');

UPDATE PatientRecords..patients$
SET LAST = REPLACE(LAST, '√©', 'e');

UPDATE PatientRecords..patients$
SET FIRST = REPLACE(FIRST, '√©', 'e');

UPDATE PatientRecords..patients$
SET LAST = REPLACE(LAST, '√©', 'e');

UPDATE PatientRecords..patients$
SET FIRST = REPLACE(FIRST, '√', 'i');

UPDATE PatientRecords..patients$
SET LAST = REPLACE(LAST, '√', 'i');

UPDATE PatientRecords..patients$
SET LAST = REPLACE(LAST, 'de Jes√∫s414', 'Dejesus414');

UPDATE PatientRecords..patients$
SET LAST = REPLACE(LAST, '√∫√±', 'un');

UPDATE PatientRecords..patients$
SET FIRST = REPLACE(FIRST, '°', 'a');

UPDATE PatientRecords..patients$
SET LAST = REPLACE(LAST, '°', 'a');

UPDATE PatientRecords..patients$
SET LAST = REPLACE(LAST, '°', 'a');

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
SET LAST = 'Chavarri≠a'
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

UPDATE PatientRecords..patients$
SET FIRST = SUBSTRING(FIRST, 1, PATINDEX('%[1-9]%', FIRST)-1);

UPDATE PatientRecords..patients$
SET LAST = SUBSTRING(LAST, 1, PATINDEX('%[1-9]%', LAST)-1);

SELECT ISNULL(MARITAL, 'NA')
FROM PatientRecords..patients$;

UPDATE PatientRecords..patients$
SET MARITAL = ISNULL(MARITAL, 'NA');

SELECT FIRST, LAST, BIRTHDATE, BIRTHPLACE, ADDRESS
FROM PatientRecords..patients$
WHERE FIRST LIKE 'Jose E%';

SELECT *, ROW_NUMBER() OVER(PARTITION BY FIRST, LAST ORDER BY FIRST) AS ROW_NUMBER
FROM PatientRecords..patients$
ORDER BY LAST;

UPDATE PatientRecords..patients$
SET FIRST = CONCAT(FIRST, ' ', LAST);

ALTER TABLE PatientRecords..patients$
DROP COLUMN LAST;

EXEC sp_rename 'dbo.patients$.FIRST', 'FULL_NAME', 'COLUMN';

UPDATE PatientRecords..patients$
SET FULL_NAME = 'Ramiro Dejesus'
WHERE FULL_NAME = 'Ramiro de Jesi∫s';

UPDATE PatientRecords..patients$
SET FULL_NAME = 'Beatriz Villaseior'
WHERE FULL_NAME = 'Beatriz Villasei±or';

UPDATE PatientRecords..patients$
SET FULL_NAME = 'Carlos Fari≠as'
WHERE FULL_NAME = 'Carlos Farias';

SELECT *
FROM PatientRecords..patients$
WHERE FULL_NAME LIKE 'Mercedes%';

Ramiro de Jesi∫s
Mercedes Chavarri≠a
Beatriz Villasei±or
Carlos Fari≠as

-- Cleaning Procedures Table
SELECT *
FROM PatientRecords..procedures$;

UPDATE PatientRecords..procedures$
SET DESCRIPTION = TRIM(DESCRIPTION);

EXEC sp_rename 'dbo.procedures$.PROCEDURE DESCRIPTION', 'PROCEDURE_DESCRIPTION', 'COLUMN';

-- ANALYTICAL PROCESS (Checking how many patients are admitted or readmitted?)

SELECT Year(START_DATE) AS 'YEARS', COUNT(DISTINCT(FULL_NAME)) AS 'Amount_of_Patients_Admitted'
FROM PatientRecords..PatientsAdmitted$
GROUP BY YEAR(START_DATE);

SELECT Year(START_DATE) AS 'YEARS', COUNT(FULL_NAME) AS 'Amount_of_Patients_Admitted'
FROM PatientRecords..PatientsAdmitted$
GROUP BY YEAR(START_DATE);

SELECT *
FROM PatientRecords..PatientsAdmitted$
WHERE YEAR(START_DATE) = '2014';

SELECT *
FROM PatientRecords..PatientsReadmitted$;

SELECT DESCRIPTION, COUNT(DESCRIPTION)
FROM PatientRecords..PatientsAdmitted$
WHERE YEAR(START_DATE) = '2014'
GROUP BY DESCRIPTION
ORDER BY COUNT(DESCRIPTION) DESC;

SELECT YEAR(pa.START_DATE) 'Year', e.DESCRIPTION, e.REASON_DESCRIPTION
FROM PatientRecords..encounters$ e
JOIN PatientRecords..PatientsAdmitted$ pa
on e.Id = pa.Id
WHERE YEAR(pa.START_DATE) = '2014' and e.ENCOUNTER_CLASS = 'Inpatient';

SELECT DESCRIPTION, COUNT(DESCRIPTION)
FROM PatientRecords..PatientsAdmitted$
WHERE YEAR(START_DATE) = '2020'
GROUP BY DESCRIPTION
ORDER BY COUNT(DESCRIPTION) DESC;

SELECT YEAR(pa.START_DATE) 'Year', e.DESCRIPTION, e.REASON_DESCRIPTION
FROM PatientRecords..encounters$ e
JOIN PatientRecords..PatientsAdmitted$ pa
on e.Id = pa.Id
WHERE YEAR(pa.START_DATE) = '2020' and e.ENCOUNTER_CLASS = 'Inpatient';

SELECT YEAR(pr.START_DATE) 'Year', e.DESCRIPTION, e.REASON_DESCRIPTION
FROM PatientRecords..encounters$ e
JOIN PatientRecords..PatientsReadmitted$ pr
on e.Id = pr.Id
WHERE e.ENCOUNTER_CLASS = 'Inpatient'
ORDER BY YEAR(pr.START_DATE), MONTH(pr.START_DATE), DAY(pr.START_DATE);

SELECT DESCRIPTION, COUNT(DESCRIPTION)
FROM PatientRecords..PatientsAdmitted$
WHERE YEAR(START_DATE) = '2020'
GROUP BY DESCRIPTION
ORDER BY COUNT(DESCRIPTION) DESC;

-- ANALYTICAL PROCESS (How long are patients staying in the hospital, on avaerage?)
SELECT ENCOUNTER_CLASS, AVG(DATEDIFF(HOUR, START_DATE, STOP_DATE)) AS 'Average_Stay_in_Hours'
FROM PatientRecords..encounters$
WHERE ENCOUNTER_CLASS = 'inpatient'
GROUP BY ENCOUNTER_CLASS;

SELECT YEAR(START_DATE) AS 'Year', AVG(DATEDIFF(HOUR, START_DATE, STOP_DATE)) AS 'Length of Stay in Hours'
FROM PatientRecords..encounters$
WHERE ENCOUNTER_CLASS = 'inpatient'
GROUP BY START_DATE
ORDER BY YEAR(START_DATE);

SELECT ENCOUNTER_CLASS, AVG(DATEDIFF(HOUR, START_DATE, STOP_DATE)) AS 'Average Stay'
FROM PatientRecords..encounters$
WHERE ENCOUNTER_CLASS = 'inpatient'
GROUP BY ENCOUNTER_CLASS;

SELECT YEAR(START_DATE) AS 'Year', DESCRIPTION, REASON_DESCRIPTION, AVG(DATEDIFF(HOUR, START_DATE, STOP_DATE)) AS 'Length of Stay in Hours'
FROM PatientRecords..encounters$
WHERE ENCOUNTER_CLASS = 'inpatient' AND YEAR(START_DATE) IN ('2017', '2018', '2020', '2021')
GROUP BY START_DATE, DESCRIPTION, REASON_DESCRIPTION
ORDER BY YEAR(START_DATE);

-- ANALYTICAL PROCESS (How much is the average cost per visit?)
SELECT ENCOUNTER_CLASS, AVG(TOTAL_CLAIM_COST) AS 'Average per Visit'
FROM PatientRecords..encounters$
WHERE ENCOUNTER_CLASS IN ('Emergency', 'Inpatient', 'Outpatient')
GROUP BY ENCOUNTER_CLASS;

SELECT ENCOUNTER_CLASS, DESCRIPTION, REASON_DESCRIPTION, TOTAL_CLAIM_COST
FROM PatientRecords..encounters$
WHERE ENCOUNTER_CLASS IN ('Emergency', 'Inpatient', 'Outpatient')
ORDER BY ENCOUNTER_CLASS;

-- ANALYTICAL PROCESS (How many procedures are covered by insurance?)
SELECT *
FROM PatientRecords..encounters$ e
LEFT JOIN PatientRecords..procedures$ p
on e.Id = p.ENCOUNTER
WHERE e.PAYER <> 'b1c428d6-4f07-31e0-90f0-68ffa6ff8c76';

SELECT COUNT(*) as 'Number of Procedures covered by Insurance'
FROM PatientRecords..encounters$ e
INNER JOIN PatientRecords..procedures$ p
on e.Id = p.ENCOUNTER
WHERE e.PAYER <> 'b1c428d6-4f07-31e0-90f0-68ffa6ff8c76' AND e.PAYER_COVERAGE > 0;

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

SELECT e.ENCOUNTER_CLASS, SUM(p.PROCEDURE_BASE_COST) AS 'Insurance Coverage Amount'
FROM PatientRecords..procedures$ p
INNER JOIN PatientRecords..encounters$ e on p.ENCOUNTER = e.Id
INNER JOIN PatientRecords..payers$ p2 on e.PAYER = p2.Id
WHERE p2.NAME = 'Medicare' and e.PAYER_COVERAGE > 0
GROUP BY e.ENCOUNTER_CLASS;

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