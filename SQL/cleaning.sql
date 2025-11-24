-- CLEANING AND PREPROCESSING ---


-- CREATE and USE database
CREATE DATABASE beg_fin_risk_analysis;
USE beg_fin_risk_analysis;
-- Check if data is imported
SHOW tables;

-- CHANGING APPLICATIONDATE FROM TEXT TO DATE TYPE --
-- Turn off safe mode to allow updates without a WHERE clause key
SET SQL_SAFE_UPDATES = 0;

-- Update the ApplicationDate column by converting payment_date to a date format
UPDATE beg_fin_risk_analysis.customer_loans
SET ApplicationDate = STR_TO_DATE(ApplicationDate, '%m/%d/%Y')
WHERE ApplicationDate LIKE '%/%/%';

-- Convert ApplicationDate column to DATE type
ALTER TABLE beg_fin_risk_analysis.customer_loans
MODIFY ApplicationDate DATE;

-- Turn SafeMode back on
SET SQL_SAFE_UPDATES = 1;
DESCRIBE customer_loans;
