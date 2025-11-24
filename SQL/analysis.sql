-- EXPLORATORY DATA ANALYSIS --


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
