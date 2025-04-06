# PostgreSQL Sample Database

<div align="center">
  <img src="https://www.postgresql.org/media/img/about/press/elephant.png" alt="PostgreSQL Logo" width="80" height="80">
</div>

<div align="center">
  <img src="https://raw.githubusercontent.com/dewwts/Additional_r/main/pixelmath.png" alt="Pixelmath Logo" width="120" height="40">
  <p><em>By Pixelmath Education</em></p>
</div>

This is a sample database designed for practicing PostgreSQL queries. It contains a simple e-commerce and HR system with the following tables:

## Database Structure

### Tables
1. **departments** - Company departments
   - department_id (PK)
   - department_name
   - location

2. **employees** - Employee information
   - employee_id (PK)
   - first_name
   - last_name
   - email
   - hire_date
   - salary
   - department_id (FK)
   - manager_id (FK to employees)

3. **categories** - Product categories with hierarchical structure
   - category_id (PK)
   - name
   - parent_id (FK to categories)

4. **products** - Product information
   - product_id (PK)
   - product_name
   - price
   - category_id (FK)
   - description

5. **customers** - Customer information
   - customer_id (PK)
   - first_name
   - last_name
   - email
   - phone
   - address
   - created_at

6. **sales** - Sales transactions
   - sale_id (PK)
   - customer_id (FK)
   - product_id (FK)
   - sale_date
   - amount
   - quantity

### Views
1. **employee_details** - Combined employee information with department and manager
2. **sales_summary** - Detailed sales information with product and customer details

## How to Use

1. Create a new database in PostgreSQL:
```sql
CREATE DATABASE postgresql_learning;
```

2. Connect to the database:
```sql
\c postgresql_learning
```

3. Run the sample_database.sql script:
```sql
\i path/to/sample_database.sql
```

## Sample Queries

### Basic Queries
```sql
-- List all employees
SELECT * FROM employees;

-- Find employees in IT department
SELECT * FROM employees WHERE department_id = 1;

-- List products with prices over $500
SELECT * FROM products WHERE price > 500;
```

### Joins
```sql
-- Employee details with department
SELECT 
    e.first_name, 
    e.last_name, 
    d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;
```

### Aggregations
```sql
-- Sales by product
SELECT 
    p.product_name,
    SUM(s.amount) as total_sales,
    COUNT(*) as number_of_sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name;
```

### Window Functions
```sql
-- Rank products by sales
SELECT 
    p.product_name,
    SUM(s.amount) as total_sales,
    RANK() OVER (ORDER BY SUM(s.amount) DESC) as sales_rank
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name;
```

## Data Relationships

- Employees belong to departments
- Employees can have managers (self-referential)
- Products belong to categories
- Categories can have parent categories (self-referential)
- Sales connect customers with products

## Notes

- The database includes sample data for all tables
- Indexes are created for better query performance
- Views are provided for common queries
- All foreign keys are properly set up
- The data represents a small company with 5 departments and 8 employees
- Sales data covers the year 2023
- Product categories include Electronics, Clothing, and Books 