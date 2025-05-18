/*
1. High-Value Customers with Multiple Products
Scenario: The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).
Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.
Tables:
users_customuser
savings_savingsaccount
plans_plan

Expected result should have these columns
owner_id
name
savings_count
investment_count
total_deposits
*/

SELECT
	u.id AS owner_id,
	CONCAT(u.first_name, " ", u.last_name) AS name,
    COUNT(DISTINCT 
		CASE 
		WHEN p.is_regular_savings = 1 THEN s.savings_id END) AS savings_count,
    COUNT(DISTINCT 
		CASE 
        WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
        SUM(s.confirmed_amount) AS total_deposits
FROM users_customuser u
JOIN savings_savingsaccount s
ON u.id = s.owner_id
JOIN plans_plan p
ON p.id = s.plan_id
WHERE s.confirmed_amount > 0
GROUP BY u.id, CONCAT(u.first_name, " ", u.last_name)
ORDER BY total_deposits DESC
LIMIT 1;
    
    
    


