WITH monthly_transactions AS (
    SELECT
        s.owner_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS yr_month,
        COUNT(*) AS monthly_transaction_count
    FROM savings_savingsaccount s
    WHERE s.confirmed_amount > 0  -- only confirmed transactions
    GROUP BY s.owner_id, DATE_FORMAT(s.transaction_date, '%Y-%m')
),
avg_transaction_per_customer AS (
    SELECT
        owner_id,
        AVG(monthly_transaction_count) AS avg_transaction_per_month
    FROM monthly_transactions
    GROUP BY owner_id
),
categorized_customers AS (
    SELECT
        owner_id,
        avg_transaction_per_month,
        CASE
            WHEN avg_transaction_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transaction_per_month >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM avg_transaction_per_customer
)

SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transaction_per_month), 1) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
