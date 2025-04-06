# Common PostgreSQL Use Cases

## Table of Contents
1. [Data Analysis](#data-analysis)
2. [Reporting Queries](#reporting-queries)
3. [Data Cleaning](#data-cleaning)
4. [Time Series Analysis](#time-series-analysis)
5. [Hierarchical Data](#hierarchical-data)

## Data Analysis

### Basic Statistics
```sql
-- Calculate basic statistics
SELECT 
    COUNT(*) as total_rows,
    AVG(column1) as average,
    MIN(column1) as minimum,
    MAX(column1) as maximum,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY column1) as median
FROM table1;

-- Group statistics
SELECT 
    category,
    COUNT(*) as count,
    AVG(value) as avg_value,
    STDDEV(value) as std_dev
FROM table1
GROUP BY category;
```

### Trend Analysis
```sql
-- Monthly trends
SELECT 
    DATE_TRUNC('month', date_column) as month,
    COUNT(*) as count,
    AVG(value) as avg_value
FROM table1
GROUP BY DATE_TRUNC('month', date_column)
ORDER BY month;

-- Year-over-year comparison
WITH monthly_stats AS (
    SELECT 
        DATE_TRUNC('month', date_column) as month,
        AVG(value) as avg_value
    FROM table1
    GROUP BY DATE_TRUNC('month', date_column)
)
SELECT 
    current.month,
    current.avg_value as current_value,
    previous.avg_value as previous_value,
    ((current.avg_value - previous.avg_value) / previous.avg_value * 100) as percent_change
FROM monthly_stats current
LEFT JOIN monthly_stats previous 
    ON current.month = previous.month + INTERVAL '1 year';
```

## Reporting Queries

### Sales Reports
```sql
-- Daily sales summary
SELECT 
    DATE_TRUNC('day', sale_date) as day,
    SUM(amount) as total_sales,
    COUNT(*) as number_of_transactions,
    AVG(amount) as average_transaction
FROM sales
GROUP BY DATE_TRUNC('day', sale_date)
ORDER BY day;

-- Product performance
SELECT 
    p.product_name,
    COUNT(*) as times_sold,
    SUM(s.amount) as total_revenue,
    AVG(s.amount) as average_price
FROM sales s
JOIN products p ON s.product_id = p.id
GROUP BY p.product_name
ORDER BY total_revenue DESC;
```

### Customer Analysis
```sql
-- Customer purchase history
SELECT 
    c.customer_name,
    COUNT(DISTINCT s.order_id) as number_of_orders,
    SUM(s.amount) as total_spent,
    MAX(s.sale_date) as last_purchase_date
FROM sales s
JOIN customers c ON s.customer_id = c.id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- Customer segmentation
SELECT 
    CASE 
        WHEN total_spent > 1000 THEN 'High Value'
        WHEN total_spent > 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END as customer_segment,
    COUNT(*) as number_of_customers,
    AVG(total_spent) as average_spent
FROM (
    SELECT 
        customer_id,
        SUM(amount) as total_spent
    FROM sales
    GROUP BY customer_id
) customer_totals
GROUP BY customer_segment;
```

## Data Cleaning

### Handling Missing Values
```sql
-- Replace NULL values
SELECT 
    COALESCE(column1, 'default_value') as cleaned_column1,
    COALESCE(column2, 0) as cleaned_column2
FROM table1;

-- Remove duplicate rows
DELETE FROM table1 a USING (
    SELECT MIN(ctid) as ctid, column1, column2
    FROM table1
    GROUP BY column1, column2
    HAVING COUNT(*) > 1
) b
WHERE a.column1 = b.column1 
AND a.column2 = b.column2 
AND a.ctid <> b.ctid;
```

### Data Standardization
```sql
-- Standardize text case
UPDATE table1
SET column1 = UPPER(column1)
WHERE column1 IS NOT NULL;

-- Remove extra spaces
UPDATE table1
SET column1 = TRIM(column1)
WHERE column1 IS NOT NULL;

-- Standardize date format
UPDATE table1
SET date_column = DATE_TRUNC('day', date_column)
WHERE date_column IS NOT NULL;
```

## Time Series Analysis

### Time-based Aggregations
```sql
-- Daily aggregations with missing dates filled
WITH RECURSIVE dates AS (
    SELECT MIN(date_column)::date as date
    FROM table1
    UNION ALL
    SELECT date + 1
    FROM dates
    WHERE date < (SELECT MAX(date_column)::date FROM table1)
)
SELECT 
    d.date,
    COALESCE(COUNT(t.id), 0) as count,
    COALESCE(SUM(t.value), 0) as total_value
FROM dates d
LEFT JOIN table1 t ON d.date = t.date_column::date
GROUP BY d.date
ORDER BY d.date;
```

### Moving Averages
```sql
-- 7-day moving average
SELECT 
    date_column,
    value,
    AVG(value) OVER (
        ORDER BY date_column
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as moving_avg_7d
FROM table1
ORDER BY date_column;
```

## Hierarchical Data

### Employee Hierarchy
```sql
-- Employee org chart
WITH RECURSIVE org_chart AS (
    -- Base case: top-level employees
    SELECT 
        id,
        name,
        manager_id,
        1 as level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive case: subordinates
    SELECT 
        e.id,
        e.name,
        e.manager_id,
        oc.level + 1
    FROM employees e
    JOIN org_chart oc ON e.manager_id = oc.id
)
SELECT 
    id,
    name,
    level,
    LPAD('', level * 2, ' ') as hierarchy_level
FROM org_chart
ORDER BY level, id;
```

### Category Tree
```sql
-- Category hierarchy with path
WITH RECURSIVE category_tree AS (
    -- Base case: root categories
    SELECT 
        id,
        name,
        parent_id,
        name::text as path
    FROM categories
    WHERE parent_id IS NULL
    
    UNION ALL
    
    -- Recursive case: child categories
    SELECT 
        c.id,
        c.name,
        c.parent_id,
        ct.path || ' > ' || c.name
    FROM categories c
    JOIN category_tree ct ON c.parent_id = ct.id
)
SELECT 
    id,
    name,
    path
FROM category_tree
ORDER BY path;
``` 