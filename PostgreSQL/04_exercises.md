# PostgreSQL Practice Exercises

## Table of Contents
1. [Basic Queries](#basic-queries)
2. [Joins and Subqueries](#joins-and-subqueries)
3. [Aggregation and Grouping](#aggregation-and-grouping)
4. [Window Functions](#window-functions)
5. [Data Manipulation](#data-manipulation)

## Basic Queries

### Exercise 1: Simple SELECT
**Problem:** Write a query to select all employees who work in the 'IT' department and have a salary greater than 50000.

**Solution:**
```sql
SELECT 
    employee_id,
    first_name,
    last_name,
    salary
FROM employees
WHERE department = 'IT'
AND salary > 50000;
```

### Exercise 2: String Operations
**Problem:** Find all customers whose email addresses contain 'gmail.com' and their names start with 'A'.

**Solution:**
```sql
SELECT 
    customer_id,
    first_name,
    last_name,
    email
FROM customers
WHERE email LIKE '%@gmail.com'
AND first_name LIKE 'A%';
```

## Joins and Subqueries

### Exercise 3: Multiple Table Join
**Problem:** Create a report showing employee names, their department names, and their manager's name.

**Solution:**
```sql
SELECT 
    e.first_name || ' ' || e.last_name as employee_name,
    d.department_name,
    m.first_name || ' ' || m.last_name as manager_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
LEFT JOIN employees m ON e.manager_id = m.employee_id;
```

### Exercise 4: Subquery with Aggregation
**Problem:** Find all products that have a price higher than the average price of all products in their category.

**Solution:**
```sql
SELECT 
    product_id,
    product_name,
    price,
    category
FROM products p
WHERE price > (
    SELECT AVG(price)
    FROM products
    WHERE category = p.category
);
```

## Aggregation and Grouping

### Exercise 5: Complex Grouping
**Problem:** Calculate the total sales amount and number of orders for each customer, but only for customers who have made more than 5 orders.

**Solution:**
```sql
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name as customer_name,
    COUNT(o.order_id) as number_of_orders,
    SUM(o.total_amount) as total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > 5
ORDER BY total_spent DESC;
```

### Exercise 6: Multiple Aggregations
**Problem:** For each department, calculate:
- Total number of employees
- Average salary
- Highest salary
- Lowest salary
- Salary range (highest - lowest)

**Solution:**
```sql
SELECT 
    d.department_name,
    COUNT(e.employee_id) as employee_count,
    ROUND(AVG(e.salary), 2) as avg_salary,
    MAX(e.salary) as max_salary,
    MIN(e.salary) as min_salary,
    MAX(e.salary) - MIN(e.salary) as salary_range
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY avg_salary DESC;
```

## Window Functions

### Exercise 7: Ranking
**Problem:** Rank employees within each department by their salary, showing their rank and dense rank.

**Solution:**
```sql
SELECT 
    e.first_name || ' ' || e.last_name as employee_name,
    d.department_name,
    e.salary,
    RANK() OVER (PARTITION BY d.department_id ORDER BY e.salary DESC) as salary_rank,
    DENSE_RANK() OVER (PARTITION BY d.department_id ORDER BY e.salary DESC) as salary_dense_rank
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_name, e.salary DESC;
```

### Exercise 8: Moving Average
**Problem:** Calculate the 3-month moving average of sales for each product.

**Solution:**
```sql
SELECT 
    p.product_name,
    s.sale_date,
    s.amount,
    AVG(s.amount) OVER (
        PARTITION BY p.product_id
        ORDER BY s.sale_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as three_month_moving_avg
FROM sales s
JOIN products p ON s.product_id = p.product_id
ORDER BY p.product_name, s.sale_date;
```

## Data Manipulation

### Exercise 9: Data Update
**Problem:** Update employee salaries by giving a 10% raise to employees who have been with the company for more than 5 years.

**Solution:**
```sql
UPDATE employees
SET salary = salary * 1.1
WHERE hire_date < CURRENT_DATE - INTERVAL '5 years';
```

### Exercise 10: Data Cleanup
**Problem:** Remove duplicate customer records keeping only the most recent entry for each email address.

**Solution:**
```sql
DELETE FROM customers a USING (
    SELECT MIN(customer_id) as keep_id, email
    FROM customers
    GROUP BY email
    HAVING COUNT(*) > 1
) b
WHERE a.email = b.email 
AND a.customer_id <> b.keep_id;
```

## Additional Practice Problems

1. Create a query that shows the percentage of total sales each product category contributes
2. Find employees who earn more than their department's average salary
3. Calculate the running total of sales for each day
4. Create a report showing the top 3 selling products in each category
5. Find customers who haven't made a purchase in the last 6 months

## Tips for Solving Exercises

1. Break down complex problems into smaller parts
2. Use CTEs to make complex queries more readable
3. Test your queries with a small dataset first
4. Consider performance implications of your solutions
5. Use appropriate indexes to optimize query performance
6. Document your solutions with comments
7. Consider edge cases and NULL values
8. Use appropriate data types for calculations
9. Consider using views for frequently used complex queries
10. Always verify your results with test data 