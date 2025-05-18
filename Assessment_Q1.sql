SELECT
	u.id AS owner_id,
	CONCAT(u.first_name, " ", u.last_name) AS name,
    COUNT(DISTINCT 
		CASE 
		WHEN p.is_regular_savings = 1 THEN s.id END) AS savings_count,
    COUNT(DISTINCT 
		CASE 
        WHEN p.is_a_fund = 1 THEN s.id END) AS investment_count,
        ROUND((SUM(s.confirmed_amount) / 100), 2) AS total_deposits -- converts to naira
FROM users_customuser u
JOIN savings_savingsaccount s
ON u.id = s.owner_id
JOIN plans_plan p
ON p.id = s.plan_id
WHERE s.confirmed_amount > 0
GROUP BY u.id, CONCAT(u.first_name, " ", u.last_name)
ORDER BY total_deposits DESC;