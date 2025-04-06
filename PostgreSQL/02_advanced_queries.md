# Advanced PostgreSQL Queries

## Table of Contents
1. [Subqueries](#subqueries)
2. [Common Table Expressions (CTEs)](#common-table-expressions)
3. [Window Functions](#window-functions)
4. [Advanced JOIN Techniques](#advanced-join-techniques)
5. [Performance Optimization](#performance-optimization)

## Subqueries

Subqueries allow you to nest queries within queries:

```sql
-- Basic subquery
SELECT * FROM table1 
WHERE column1 > (SELECT AVG(column1) FROM table1);

-- Correlated subquery
SELECT * FROM table1 t1 
WHERE column1 > (
    SELECT AVG(column1) 
    FROM table1 t2 
    WHERE t2.category = t1.category
);

-- Subquery in FROM clause
SELECT * FROM (
    SELECT column1, COUNT(*) as count 
    FROM table1 
    GROUP BY column1
) AS subquery 
WHERE count > 5;
```

## Common Table Expressions (CTEs)

CTEs provide a way to write more readable and maintainable queries:

```sql
-- Basic CTE
WITH cte_name AS (
    SELECT column1, column2 
    FROM table1 
    WHERE column1 > 100
)
SELECT * FROM cte_name;

-- Recursive CTE
WITH RECURSIVE numbers AS (
    SELECT 1 as n
    UNION ALL
    SELECT n + 1 
    FROM numbers 
    WHERE n < 10
)
SELECT * FROM numbers;

-- Multiple CTEs
WITH 
cte1 AS (
    SELECT * FROM table1
),
cte2 AS (
    SELECT * FROM table2
)
SELECT cte1.*, cte2.* 
FROM cte1 
JOIN cte2 ON cte1.id = cte2.id;
```

## Window Functions

Window functions perform calculations across a set of table rows:

```sql
-- ROW_NUMBER()
SELECT 
    column1,
    ROW_NUMBER() OVER (ORDER BY column1) as row_num
FROM table1;

-- RANK() and DENSE_RANK()
SELECT 
    column1,
    RANK() OVER (ORDER BY column1) as rank,
    DENSE_RANK() OVER (ORDER BY column1) as dense_rank
FROM table1;

-- PARTITION BY
SELECT 
    column1,
    column2,
    AVG(column3) OVER (PARTITION BY column1) as avg_by_group
FROM table1;

-- LAG and LEAD
SELECT 
    column1,
    LAG(column1) OVER (ORDER BY column1) as previous_value,
    LEAD(column1) OVER (ORDER BY column1) as next_value
FROM table1;
```

## Advanced JOIN Techniques

Complex join operations for sophisticated data retrieval:

```sql
-- Self JOIN
SELECT 
    e1.employee_name,
    e2.employee_name as manager_name
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.id;

-- CROSS JOIN with conditions
SELECT * 
FROM table1 
CROSS JOIN table2 
WHERE table1.column1 = table2.column1;

-- NATURAL JOIN
SELECT * FROM table1 NATURAL JOIN table2;

-- Multiple JOINs with different conditions
SELECT 
    t1.column1,
    t2.column2,
    t3.column3
FROM table1 t1
JOIN table2 t2 ON t1.id = t2.id
LEFT JOIN table3 t3 ON t2.id = t3.id
WHERE t1.column1 > 100;
```

## Performance Optimization

Advanced techniques for query optimization:

```sql
-- Using EXISTS instead of IN
SELECT * FROM table1 t1
WHERE EXISTS (
    SELECT 1 FROM table2 t2 
    WHERE t2.id = t1.id
);

-- Using UNION ALL instead of UNION when duplicates are acceptable
SELECT column1 FROM table1
UNION ALL
SELECT column1 FROM table2;

-- Using materialized views
CREATE MATERIALIZED VIEW mv_name AS
SELECT * FROM table1
WHERE column1 > 100;

-- Using partial indexes
CREATE INDEX idx_name ON table1 (column1)
WHERE column1 > 100;
```

## Best Practices for Advanced Queries

1. Use CTEs for complex queries to improve readability
2. Consider using window functions instead of subqueries when possible
3. Be careful with recursive CTEs to avoid infinite loops
4. Use appropriate indexes for complex joins
5. Consider query execution plans when optimizing
6. Use EXPLAIN ANALYZE to understand query performance
7. Break down complex queries into smaller, manageable parts
8. Use appropriate data types and constraints
9. Consider using materialized views for frequently accessed data
10. Regular maintenance of indexes and statistics 