# Financial Risk and Loan Approval Analysis: Identifying Factors Driving Loan Defaults


====== TOOLS AND LANGUAGES USED =====
- Languages: SQL
- Tools: PowerBI, MySQL


====== OBJECTIVE ======
* The goal of this project is to analyze banking data to assess the risk associated with lending to customers. By examining historical loan data and customer information, the analysis aims to identify factors that contribute to loan default risk and provide insights to support informed lending decisions.


====== WORKFLOW OVERVIEW ======
The project began by gathering the Loan.csv dataset and reviewing its structure (20000 rows × 36 columns). After exploring data types and quality, the ApplicationDate field was converted from text to a proper date format to support time-based analysis. Once the data was standardized, exploratory analysis was performed to understand patterns across customer profiles, loan terms, and default behavior. These observations guided the creation of engineered features and transformations that improved risk segmentation. SQL was used to clean, prepare, and aggregate the data, and the processed output was imported into Power BI. The dashboard was built to highlight key indicators of loan risk and visualize relationships discovered during analysis. Findings were then summarized into insights and conclusions to support lending decisions.


===== DATA OVERVIEW =====

| Dataset Name |   Description       | Rows    | Columns | Source   |
|--------------|---------------------|---------|---------|----------|
| Loan.csv     | client banking data | 20,000  | 36      | Kaggle   |


===== DATA CLEANING/PREPROCESSING =====
* The dataset required basic cleaning and type conversion for analysis.

```sql
-- CREATE and USE database --
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
```

SUMMARY:
* Converted ApplicationDate from text to SQL DATE type.
* Verified column types for numeric and categorical fields.
* Dataset was now ready for aggregation and visualization.


===== EXPLORATORY DATA ANALYSIS (EDA) =====
* SQL queries were used to explore approval patterns and summarize key metrics:

```sql
-- Get total applications from dataset
SELECT COUNT(*)
FROM customer_loans;

-- Analyzing the average metrics of approved vs denied applicants from 2018-2024, grouped by year
SELECT 
DATE_FORMAT(ApplicationDate, '%Y') AS Year,
CASE 
	WHEN LoanApproved = 0 then 'Declined'
	ELSE 'Approved'
END as ApprovalStatus,
COUNT(*) AS TotalApplicants,
ROUND(AVG(Age), 0) AS AverageAge,
ROUND(AVG(AnnualIncome), 2) AS AverageIncome,
ROUND(AVG(TotalAssets), 2) AS AverageAssets,
ROUND(AVG(TotalLiabilities), 2) AS AverageLiabilities,
ROUND(AVG(SavingsAccountBalance), 2) AS AverageSavings,
ROUND(AVG(JobTenure), 2) as AverageJobTenure,
ROUND(AVG(TotalDebtToIncomeRatio), 2) AS AverageDebtIncomeRatio
FROM customer_loans
WHERE ApplicationDate < "2025-01-01"
GROUP BY LoanApproved, Year;
```

SUMMARY: 
* Approved applicants generally have higher average income and assets.
* Declined applicants have higher debt-to-income ratios and tend to be younger.
* Longer job tenure slightly correlates with higher approval rates.
* Declined applicants consistently outnumber approved applicants year-over-year.


===== FEATURE ENGINEERING/TRANSFORMATION =====
* Created Income Bins for visualizing income distribution in Power BI.
* Aggregated data by ApprovalStatus for comparison charts.
* Derived approval rate metrics using Power BI cards and percentage calculations.


===== ANALYSIS/MODELING =====
No predictive modeling was applied; the focus was on descriptive analysis and visualization.

Key financial risk factors analyzed:
* Debt-to-Income Ratio - key risk factor
* Average Income - strong predictor of approval
* Job Tenure - indicates stability/employment history

* Optional context factor: Age


===== VISUALIZATIONS =====
![Risk Analysis](risk_analysis.png)

* Clustered Column/Bar Charts: Approved vs Declined for TotalApplicants, AverageJobTenure, AverageDebtIncomeRatio
* Histogram with Income Bins: Visualizes income distribution for Approved vs Declined applicants
* Pie Chart: Approval and declined percentages.
* Card Visual: Total Applicants
* Line Charts: Trends over time for income and approval rates.
* List Slicer: Filters metrics by year (2018–2024).


===== KEY INSIGHTS =====

Drivers of financial risk:
* Higher Debt-to-Income Ratio → higher likelihood of being declined
* Lower Average Income → higher decline rate
* Shorter Job Tenure → slightly higher decline probability
* Younger applicants tend to be declined more often

Application Summary:
* Total applications analyzed: 3,000
* Approved vs Declined ratio: Approved - 23.46%, Declined - 76.54%
* Income distribution shows higher approval rates in upper income brackets.
* Debt-to-income ratio distribution clearly separates high-risk (declined) applicants from low-risk (approved) applicants.



===== CONCLUSION =====
The analysis highlights that income and debt-to-income ratio are the strongest predictors of loan approval. Job tenure and age provide additional context but are less influential. Power BI visualizations allow stakeholders to quickly assess approval patterns, identify high-risk applicants, and make informed lending decisions.
    -> Future work could include building predictive models using machine learning to estimate the probability of approval or default for new applicants.