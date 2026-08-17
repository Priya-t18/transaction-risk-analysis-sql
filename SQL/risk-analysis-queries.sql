--SQL
--Transaction Risk Analysis
--1. High-Value Transactions
SELECT user_id, country,
round (avg (amount),0) as avg_amt,
round (max (amount),0) as max_amt,
round (max (amount)/((SUM(amount)- MAX(amount)) / (COUNT(*) - 1)), 0) as risk_ratio
FROM creditcard01
group by user_id, country
HAVING COUNT(*) > 2
order by risk_ratio DESC;

--2. High-Frequency Transactions
SELECT user_id,
country,
substr(timestamp, 1, 13) as txn_hour,
count(*) as transaction_count,
round(sum(amount),0) as total_amount
FROM creditcard01
group by user_id, country, txn_hour
HAVING COUNT(*) > 1
order by transaction_count DESC;

--3. Threshold Avoidance
SELECT user_id,
       country,
round (avg(amount),0) as avg_amt,
round (max(amount),0) as max_amt,
count(*) as trans_count
FROM creditcard01
WHERE amount BETWEEN 3000 AND 3999
GROUP by user_id, country
HAVING count(*) > 2
ORDER by trans_count DESC;

--4. Geographic Inconsistency
SELECT user_id,
COUNT(DISTINCT country) AS country_count,
COUNT(DISTINCT ip_address) AS ip_count
FROM creditcard01
GROUP BY user_id
HAVING country_count > 2
   OR ip_count > 5
ORDER BY country_count DESC, ip_count DESC;

--5. Behavioral Deviation
SELECT user_id, country,
round( Avg(amount), 0) AS avg_amt,
round( max(amount), 0) As highest_amt,
round(max(amount)/Avg(amount),2) as deviation_ratio
FROM creditcard01
GROUP by user_id, country
HAVING deviation_ratio > 2
ORDER by deviation_ratio DESC;
