SELECT* FROM savesmart ;
-- I will check the first few rows
SELECT * FROM savesmart LIMIT 10 ;
-- I will confirm how many rows I have
SELECT COUNT(*) AS total_customers FROM savesmart ;
SHOW TABLES ; 
DESCRIBE savesmart;
-- I will now carry out basic data Insights
SELECT COUNT(*) AS total_customers
FROM savesmart;
-- I want to find any  unique country and  distribution of genders
SELECT DISTINCT country FROM savesmart;
SELECT gender, COUNT(*) AS total
FROM savesmart
GROUP BY gender;
-- I want to get the average the savings balance of all users
SELECT AVG(savings_balance) AS avg_balance
FROM savesmart;
-- Now, I want to study the savings behaviour and sort the customers with the highest savings balance
SELECT first_name, last_name, savings_balance
FROM savesmart
ORDER BY savings_balance DESC
LIMIT 30 ;
-- Average savings by gender
SELECT gender, ROUND(AVG(savings_balance), 2) AS avg_balance
FROM savesmart
GROUP BY gender
ORDER BY avg_balance DESC ;
-- Average savings by country
SELECT country, ROUND(AVG(savings_balance), 2) AS avg_balance
FROM savesmart
GROUP BY country
ORDER BY avg_balance DESC;
-- To get the top 10 highest savers overall
SELECT first_name, last_name, country, savings_balance
FROM savesmart
ORDER BY savings_balance DESC
LIMIT 10;
-- To study customer activity and churn on the app
SELECT is_active, COUNT(*) AS total
FROM savesmart
GROUP BY is_active;
SELECT churned, COUNT(*) AS total
FROM savesmart
GROUP BY churned;
-- To get the average balance of churned to know if they have high or low savings
SELECT churned, ROUND(AVG(savings_balance), 2) AS avg_balance
FROM savesmart
GROUP BY churned;
-- Now, I want to get the countries and gender with the highest churn rate
SELECT 
    country,
    SUM(CASE WHEN churned = 'TRUE' THEN 1 ELSE 0 END) AS churned_customers,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churned = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
FROM savesmart
GROUP BY country
ORDER BY churn_rate DESC;
-- Churn by gender
SELECT 
    gender,
    SUM(CASE WHEN churned = 'TRUE' THEN 1 ELSE 0 END) AS churned_customers,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churned = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
FROM savesmart
GROUP BY gender
ORDER BY churn_rate DESC;
-- Now we get the churn by age group
SELECT 
    CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END AS age_group,
    SUM(CASE WHEN churned = 'TRUE' THEN 1 ELSE 0 END) AS churned_customers,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churned = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
FROM savesmart
GROUP BY age_group
ORDER BY churn_rate DESC;
-- CUSTOMERS AT RISK OF CHURNING, based on their low savings balance and activity on the app
SELECT 
    first_name,
    last_name,
    country,
    age,
    savings_balance,
    is_active
FROM savesmart
WHERE is_active = 'FALSE'
  AND savings_balance < 500
  AND churned = 'FALSE';
-- Savings by age 
SELECT 
  CASE
    WHEN age < 18 THEN 'Under 18'
    WHEN age BETWEEN 18 AND 25 THEN '18-25'
    WHEN age BETWEEN 26 AND 35 THEN '26-35'
    WHEN age BETWEEN 36 AND 50 THEN '36-50'
    ELSE '50+'
  END AS age_group,
  ROUND(AVG(savings_balance), 2) AS avg_savings,
  COUNT(*) AS total_customers
FROM savesmart
GROUP BY age_group
ORDER BY avg_savings DESC;

-- Savesmart Customer Insights Dashboard

-- 1️General Customer Summary
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'TRUE' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN churned = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_percent,
    SUM(CASE WHEN is_active = 'TRUE' THEN 1 ELSE 0 END) AS active_customers,
    ROUND(AVG(savings_balance), 2) AS avg_savings_balance,
    ROUND(SUM(savings_balance), 2) AS total_savings_balance
FROM savesmart;

-- 2️Churn Rate by Gender
SELECT 
    gender,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'TRUE' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN churned = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM savesmart
GROUP BY gender
ORDER BY churn_rate_percent DESC;

-- 3️Churn Rate by Age Group
SELECT 
    CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END AS age_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'TRUE' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN churned = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM savesmart
GROUP BY age_group
ORDER BY churn_rate_percent DESC;

-- 4️Churn and Active Status by Country
SELECT 
    country,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN is_active = 'TRUE' THEN 1 ELSE 0 END) AS active_customers,
    SUM(CASE WHEN churned = 'TRUE' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN churned = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_percent,
    ROUND(AVG(savings_balance), 2) AS avg_savings_balance
FROM savesmart
GROUP BY country
ORDER BY churn_rate_percent DESC;

-- 5️Savings Balance by Churn Status
SELECT 
    churned,
    ROUND(AVG(savings_balance), 2) AS avg_savings_balance,
    MIN(savings_balance) AS min_savings,
    MAX(savings_balance) AS max_savings,
    COUNT(*) AS total_customers
FROM savesmart
GROUP BY churned;

-- 6️Customers Potentially at Risk
SELECT 
    first_name,
    last_name,
    country,
    age,
    savings_balance,
    is_active
FROM savesmart
WHERE is_active = 'FALSE'
  AND savings_balance < 500
  AND churned = 'FALSE'
ORDER BY savings_balance ASC;

-- To check if there is there’s a pattern between low balance, inactivity, and churn.
SELECT 
    is_active,
    CASE 
        WHEN savings_balance < 500 THEN 'Low Balance'
        WHEN savings_balance BETWEEN 500 AND 2000 THEN 'Medium Balance'
        ELSE 'High Balance'
    END AS balance_group,
    SUM(CASE WHEN churned = 'TRUE' THEN 1 ELSE 0 END) AS churned_customers,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churned = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM savesmart
GROUP BY is_active, balance_group
ORDER BY churn_rate_percent DESC;
-- Result: there is a pattern, those with the lowest balance have the highest churn rate

SELECT 
    country,
    SUM(CASE WHEN is_active = 'FALSE' AND churned = 'FALSE' AND savings_balance < 500 THEN 1 ELSE 0 END) AS at_risk_customers,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN is_active = 'FALSE' AND churned = 'FALSE' AND savings_balance < 500 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS risk_rate
FROM savesmart
GROUP BY country
ORDER BY risk_rate DESC;
-- Nigeria and Frace have the highest churn RATE
