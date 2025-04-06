# Basic PostgreSQL Queries

## Table of Contents
1. [SELECT Statement](#select-statement)
2. [WHERE Clause](#where-clause)
3. [ORDER BY](#order-by)
4. [GROUP BY](#group-by)
5. [JOIN Operations](#join-operations)

## SELECT Statement

The basic SELECT statement is the foundation of querying data in PostgreSQL.

```sql
-- Basic SELECT
SELECT column1, column2 FROM table_name;

-- SELECT all columns
SELECT * FROM table_name;

-- SELECT with aliases
SELECT column1 AS alias1, column2 AS alias2 FROM table_name;
```

## WHERE Clause

Filter data using the WHERE clause:

```sql
-- Basic WHERE
SELECT * FROM table_name WHERE column1 = 'value';

-- Multiple conditions
SELECT * FROM table_name 
WHERE column1 = 'value' 
AND column2 > 100 
OR column3 IS NOT NULL;

-- Using IN
SELECT * FROM table_name WHERE column1 IN ('value1', 'value2', 'value3');

-- Using LIKE
SELECT * FROM table_name WHERE column1 LIKE 'pattern%';
```

## ORDER BY

Sort results using ORDER BY:

```sql
-- Basic ORDER BY
SELECT * FROM table_name ORDER BY column1;

-- ORDER BY multiple columns
SELECT * FROM table_name 
ORDER BY column1 ASC, column2 DESC;

-- ORDER BY with expressions
SELECT *, column1 * column2 AS calculated_column 
FROM table_name 
ORDER BY calculated_column;
```

## GROUP BY

Aggregate data using GROUP BY:

```sql
-- Basic GROUP BY
SELECT column1, COUNT(*) 
FROM table_name 
GROUP BY column1;

-- GROUP BY with multiple columns
SELECT column1, column2, COUNT(*) 
FROM table_name 
GROUP BY column1, column2;

-- GROUP BY with HAVING
SELECT column1, COUNT(*) 
FROM table_name 
GROUP BY column1 
HAVING COUNT(*) > 5;
```

## JOIN Operations

Combine data from multiple tables:

```sql
-- INNER JOIN
SELECT table1.column1, table2.column2 
FROM table1 
INNER JOIN table2 ON table1.id = table2.id;

-- LEFT JOIN
SELECT table1.column1, table2.column2 
FROM table1 
LEFT JOIN table2 ON table1.id = table2.id;

-- RIGHT JOIN
SELECT table1.column1, table2.column2 
FROM table1 
RIGHT JOIN table2 ON table1.id = table2.id;

-- FULL OUTER JOIN
SELECT table1.column1, table2.column2 
FROM table1 
FULL OUTER JOIN table2 ON table1.id = table2.id;
```

## Practice Exercises

1. Write a query to select all columns from a table named 'employees'
2. Find all employees with salary greater than 50000
3. List employees ordered by their hire date
4. Count the number of employees in each department
5. Join the employees table with departments table to show employee names and their department names

## Tips and Best Practices

1. Always use meaningful column aliases
2. Use appropriate data types for columns
3. Index frequently queried columns
4. Use EXISTS instead of IN for better performance with large datasets
5. Avoid using SELECT * in production queries 