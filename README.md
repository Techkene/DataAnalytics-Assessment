# Customer Account & Transaction Analysis

This project addresses four key business questions using SQL. The queries are designed to extract insights from customer accounts, transactions, and plan data across savings and investment products.

---

## Per-Question Explanations

### Question 1: High-Value Customers with Multiple Products

**Goal**: Identify customers who have both savings and investment plans and rank them by total deposits.

**Approach**:
- Join `users_customuser`, `savings_savingsaccount`, and `plans_plan` tables.
- Use `COUNT(DISTINCT CASE...)` to determine the number of savings and investment products per customer.
- Filter to include only confirmed deposits (`confirmed_amount > 0`).
- Convert `confirmed_amount` from kobo to Naira using `SUM(confirmed_amount) / 100`.

**Output**:
- `owner_id`
- Full name
- `savings_count`
- `investment_count`
- `total_deposits` in Naira

---

### Question 2: Transaction Frequency Segmentation

**Goal**: Segment customers based on how frequently they transact monthly.

**Approach**:
- Use a CTE to calculate monthly transaction counts per customer.
- Calculate the average number of transactions per month.
- Categorize customers into:
  - **High Frequency**: ≥10/month
  - **Medium Frequency**: 3–9/month
  - **Low Frequency**: ≤2/month
- Use `CASE` statements to apply labels based on averages.

**Output**:
- `frequency_category`
- `customer_count`
- `avg_transactions_per_month`

---

### Question 3: Flag Inactive Accounts

**Goal**: Identify all savings or investment accounts with no inflow transactions in the past 1 year.

**Approach**:
- Join `plans_plan` with `savings_savingsaccount`, focusing on confirmed transactions.
- Use `MAX(s.created_on)` to identify the latest transaction date.
- Calculate inactivity in days with `DATEDIFF(CURDATE(), MAX(s.created_on))`.
- Use `HAVING` clause to filter out accounts with more than 365 days of inactivity or no transactions at all.

**Output**:
- `plan_id`
- `owner_id`
- Plan `type` (Savings or Investment)
- `last_transaction_date`
- `inactivity_days`

---

### Question 4: Customer Lifetime Value (CLV) Estimation

**Goal**: Estimate CLV using account tenure and average transaction behavior.

**Approach**:
- Join `users_customuser` with `savings_savingsaccount`.
- Calculate tenure in months using `TIMESTAMPDIFF`.
- Count all confirmed transactions per customer.
- Calculate CLV using:

```sql
CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
```

---

## ⚠️ Challenges & Resolutions

### 1. Understanding Plan Types
- **Challenge**: How to differentiate between savings and investment plans.
- **Solution**: Used `is_regular_savings` for savings and `is_a_fund` for investment from the `plans_plan` table based on the hint provided.

### 2. Lack of a Data Dictionary
- **Challenge**: Spent significant time trying to understand the meaning of different columns and their relationships.
- **Solution**: Relied on column names, patterns, and hints to make informed assumptions. I wish there had been a proper data dictionary or someone available to explain the schema better.

### 3. Currency Conversion
- **Challenge**: All monetary amounts were stored in **kobo**, which could be misleading at first glance.
- **Solution**: Converted values to **Naira** by dividing by 100 in all relevant calculations.

### 4. Inactivity Logic
- **Challenge**: Needed to detect both accounts with **no transactions** and those that had been **inactive for over a year**.
- **Solution**: Used `MAX(s.created_on)` to get the last transaction date, and applied a `HAVING` clause to filter accounts beyond 365 days of inactivity or with null transactions.

### 5. Division by Zero in CLV
- **Challenge**: Customers with 0-month tenure (new signups) could cause division by zero errors in the CLV formula.
- **Solution**: Used `NULLIF(..., 0)` to avoid crashing the query and return `NULL` instead.


---

##  Summary

This SQL analysis provides data-driven insights that support:

- ✅ Identifying and prioritizing high-value cross-product customers  
- ✅ Segmenting users by engagement levels  
- ✅ Re-engagement of dormant accounts  
- ✅ Forecasting customer lifetime value for strategic marketing decisions
