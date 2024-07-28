USE financial_loan;
SELECT * FROM financial_loan;
-- Alter table to change columns to DATE type
ALTER TABLE financial_loan
MODIFY COLUMN issue_date DATE,
MODIFY COLUMN last_credit_pull_date DATE,
MODIFY COLUMN last_payment_date DATE,
MODIFY COLUMN next_payment_date DATE;

ALTER TABLE financial_loan
ADD PRIMARY KEY (id);

-- PRIMARY KPI QUERIES
SELECT * FROM financial_loan;

-- Get the total number of loan applicants 
SELECT COUNT(id) AS Total_Loan_Applications FROM financial_loan;

-- Month to date 
SELECT COUNT(id) AS MTD_Total_Loan_Applications FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Previous month to date
SELECT COUNT(id) AS PMTD_Total_Loan_Applications FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- month on month ==> (MTD-PMTD)/PMTD

-- Total funded amount
SELECT SUM(loan_amount) AS Total_funded_amount FROM financial_loan;

-- month to date Total funded amount
SELECT SUM(loan_amount) AS MTD_Total_funded_amount FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;


-- month to date Total funded amount
SELECT SUM(loan_amount) AS PMTD_Total_funded_amount FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- total amount recieved back from customers
SELECT SUM(total_payment) AS Total_amount_recieved FROM financial_loan;

-- month to date total amount recieved back from customers
SELECT SUM(total_payment) AS MTD_Total_amount_recieved FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Previous month to date total amount recieved back from customers
SELECT SUM(total_payment) AS PMTD_Total_amount_recieved FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Find the average interest rate
SELECT AVG(int_rate)AS Avg_Interest_Rate FROM financial_loan;

-- round the decimal points to 4 decimals to Find the average interest rate
SELECT ROUND(AVG(int_rate),4)*100 AS Avg_Interest_Rate FROM financial_loan;

-- Month to date average interest rate
SELECT ROUND(AVG(int_rate),4)*100 AS Avg_Interest_Rate FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Previous month to date average interest rate
SELECT ROUND(AVG(int_rate),4)*100 AS Avg_Interest_Rate FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Average debt to income ratio
SELECT ROUND(AVG(dti),4)*100 AS Avg_DTI FROM financial_loan;
-- month to date DTI
SELECT ROUND(AVG(dti),4) *100 AS MTD_Avg_DTI FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;
-- previous month
SELECT ROUND(AVG(dti),4) *100 AS MTD_Avg_DTI FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- SECONDARY PRIMARY KEY
-- CATEGORIZE GOOD LOANS AND BAD LOANS
USE financial_loan;
SELECT * FROM financial_loan;

SELECT
	(COUNT(CASE WHEN loan_status ="Fully Paid" OR loan_status="Current" THEN id END) *100)
    /
    COUNT(id) AS Good_loan_percentage 
FROM financial_loan;

-- Good Loan applications
SELECT COUNT(id) AS Good_Loan_Applications FROM financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- Good Loan funded amount
SELECT SUM(loan_amount) AS Good_Loan_Funded_Amount FROM financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- Good Loan payment amount
SELECT SUM(total_payment) AS Good_Loan_Recieved_Amount FROM financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- BAD loans
-- Bad loan percentage
SELECT
	((COUNT(CASE WHEN loan_status ='Charged Off' THEN id END) *100.0))
    /
    COUNT(id) AS Bad_loan_percentage 
FROM financial_loan;

-- total loan applications from bad loans
SELECT COUNT(id) AS Bad_Loan_Applications FROM financial_loan
WHERE Loan_status ='Charged Off';

-- total band loan funded amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_amount FROM financial_loan
WHERE Loan_status ='Charged Off';

-- total bad loan amount recieved
SELECT SUM(total_payment) AS Bad_Loan_Amount_Recieved FROM financial_loan
WHERE Loan_status ='Charged Off';

-- Loan status grid view
SELECT
		loan_status,
        COUNT(id) AS Total_Loan_applications,
        SUM(total_payment) AS Total_Amount_Recieved,
        SUM(loan_amount) AS Total_Funded_Amount,
        AVG(int_rate * 100) AS Interest_Rate,
        AVG(dti * 100) AS DTI
	FROM
		financial_loan
	GROUP BY
		loan_status;

-- month to date
SELECT
	loan_status,
    SUM(total_payment) AS MTD_Total_Amount_Recieved,
    SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM
	financial_loan
WHERE MONTH(issue_date) = 12
GROUP BY loan_status;


SELECT 
    MONTH(STR_TO_DATE(issue_date, '%Y-%m-%d')) AS month_number,
    DATE_FORMAT(STR_TO_DATE(issue_date, '%Y-%m-%d'), '%M') AS month_name,
    COUNT(id) AS total_loan_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_received_amount
FROM financial_loan
GROUP BY month_number, month_name
ORDER BY month_number;

-- State wise analysis of loan applicants
SELECT
	address_state,
    COUNT(id) AS Total_Loan_applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount
FROM financial_loan
GROUP BY address_state
ORDER BY COUNT(id) DESC;

-- Loan term analysis
SELECT
	term,
    COUNT(id) AS Total_Loan_applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount
FROM financial_loan
GROUP BY term
ORDER BY term;

-- Employee length analysis
SELECT
	emp_length,
    COUNT(id) AS Total_Loan_applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount
FROM financial_loan
GROUP BY emp_length
ORDER BY emp_length;

-- purpose
SELECT
	purpose,
    COUNT(id) AS Total_Loan_applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount
FROM financial_loan
GROUP BY purpose
ORDER BY purpose;

-- Home ownership
SELECT
	home_ownership,
    COUNT(id) AS Total_Loan_applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount
FROM financial_loan
GROUP BY home_ownership
ORDER BY home_ownership;

-- home_ownership wrt grade A applicants
SELECT
	home_ownership,
    COUNT(id) AS Total_Loan_applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount
FROM financial_loan
WHERE grade = 'A'
GROUP BY home_ownership
ORDER BY home_ownership;

-- home_ownership wrt grade A applicants in some state
SELECT
	home_ownership,
    COUNT(id) AS Total_Loan_applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount
FROM financial_loan
WHERE grade = 'A' AND address_state = 'CA'
GROUP BY home_ownership
ORDER BY home_ownership;