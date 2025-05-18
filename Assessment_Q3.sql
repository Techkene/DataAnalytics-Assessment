SELECT
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Unknown'
    END AS type,
    MAX(s.created_on) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(s.created_on)) AS inactivity_days
FROM plans_plan p
LEFT JOIN savings_savingsaccount s
    ON p.id = s.plan_id AND s.confirmed_amount > 0
GROUP BY p.id, p.owner_id, type
HAVING MAX(s.created_on) IS NULL OR DATEDIFF(CURDATE(), MAX(s.created_on)) > 365
ORDER BY inactivity_days DESC;
