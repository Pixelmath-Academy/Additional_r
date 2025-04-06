-- Create sample database for PostgreSQL learning
-- This script creates tables and inserts sample data

-- Drop tables if they exist
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS categories;

-- Create departments table
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    location VARCHAR(100)
);

-- Create employees table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    department_id INTEGER REFERENCES departments(department_id),
    manager_id INTEGER REFERENCES employees(employee_id)
);

-- Create categories table
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    parent_id INTEGER REFERENCES categories(category_id)
);

-- Create products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category_id INTEGER REFERENCES categories(category_id),
    description TEXT
);

-- Create customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create sales table
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    product_id INTEGER REFERENCES products(product_id),
    sale_date TIMESTAMP NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    quantity INTEGER NOT NULL
);

-- Insert sample data into departments
INSERT INTO departments (department_name, location) VALUES
('IT', 'New York'),
('Sales', 'Los Angeles'),
('Marketing', 'Chicago'),
('HR', 'Boston'),
('Finance', 'San Francisco');

-- Insert sample data into employees
INSERT INTO employees (first_name, last_name, email, hire_date, salary, department_id, manager_id) VALUES
('John', 'Doe', 'john.doe@example.com', '2020-01-15', 75000, 1, NULL),
('Jane', 'Smith', 'jane.smith@example.com', '2019-03-10', 82000, 2, 1),
('Bob', 'Johnson', 'bob.johnson@example.com', '2021-06-22', 65000, 1, 1),
('Alice', 'Williams', 'alice.williams@example.com', '2018-11-05', 90000, 3, 1),
('Charlie', 'Brown', 'charlie.brown@example.com', '2020-09-18', 70000, 2, 2),
('Diana', 'Miller', 'diana.miller@example.com', '2019-07-30', 78000, 4, 1),
('Edward', 'Davis', 'edward.davis@example.com', '2021-02-14', 62000, 1, 3),
('Fiona', 'Garcia', 'fiona.garcia@example.com', '2018-05-20', 85000, 5, 1);

-- Insert sample data into categories
INSERT INTO categories (name, parent_id) VALUES
('Electronics', NULL),
('Clothing', NULL),
('Books', NULL),
('Smartphones', 1),
('Laptops', 1),
('Men', 2),
('Women', 2),
('Fiction', 3),
('Non-Fiction', 3);

-- Insert sample data into products
INSERT INTO products (product_name, price, category_id, description) VALUES
('iPhone 13', 999.99, 4, 'Latest Apple smartphone'),
('Samsung Galaxy S21', 899.99, 4, 'Android flagship phone'),
('MacBook Pro', 1299.99, 5, 'Apple laptop with M1 chip'),
('Dell XPS 13', 999.99, 5, 'Windows laptop'),
('Men''s T-Shirt', 19.99, 6, 'Cotton t-shirt'),
('Women''s Dress', 49.99, 7, 'Summer dress'),
('The Great Gatsby', 9.99, 8, 'Classic novel'),
('Data Science Handbook', 29.99, 9, 'Technical book');

-- Insert sample data into customers
INSERT INTO customers (first_name, last_name, email, phone, address) VALUES
('Adam', 'Wilson', 'adam.wilson@example.com', '555-123-4567', '123 Main St, New York'),
('Beth', 'Anderson', 'beth.anderson@example.com', '555-234-5678', '456 Oak Ave, Los Angeles'),
('Chris', 'Taylor', 'chris.taylor@example.com', '555-345-6789', '789 Pine Rd, Chicago'),
('Diana', 'Moore', 'diana.moore@example.com', '555-456-7890', '321 Elm St, Boston'),
('Eric', 'Jackson', 'eric.jackson@example.com', '555-567-8901', '654 Maple Dr, San Francisco');

-- Insert sample data into sales
INSERT INTO sales (customer_id, product_id, sale_date, amount, quantity) VALUES
(1, 1, '2023-01-15 10:30:00', 999.99, 1),
(1, 3, '2023-01-15 10:30:00', 1299.99, 1),
(2, 2, '2023-02-20 14:15:00', 899.99, 1),
(3, 4, '2023-03-10 09:45:00', 999.99, 1),
(3, 5, '2023-03-10 09:45:00', 19.99, 2),
(4, 6, '2023-04-05 16:20:00', 49.99, 1),
(5, 7, '2023-05-12 11:10:00', 9.99, 1),
(5, 8, '2023-05-12 11:10:00', 29.99, 1),
(1, 5, '2023-06-18 13:25:00', 19.99, 3),
(2, 6, '2023-07-22 15:40:00', 49.99, 2),
(3, 1, '2023-08-30 10:05:00', 999.99, 1),
(4, 3, '2023-09-14 14:50:00', 1299.99, 1),
(5, 2, '2023-10-25 09:15:00', 899.99, 1),
(1, 4, '2023-11-08 16:30:00', 999.99, 1),
(2, 7, '2023-12-15 11:20:00', 9.99, 2);

-- Create some useful views
CREATE VIEW employee_details AS
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name,
    e.email,
    e.hire_date,
    e.salary,
    d.department_name,
    m.first_name || ' ' || m.last_name AS manager_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
LEFT JOIN employees m ON e.manager_id = m.employee_id;

CREATE VIEW sales_summary AS
SELECT 
    s.sale_date::date AS sale_day,
    p.product_name,
    c.first_name || ' ' || c.last_name AS customer_name,
    s.quantity,
    s.amount,
    cat.name AS category_name
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN customers c ON s.customer_id = c.customer_id
JOIN categories cat ON p.category_id = cat.category_id;

-- Create indexes for better performance
CREATE INDEX idx_employees_department ON employees(department_id);
CREATE INDEX idx_employees_manager ON employees(manager_id);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_sales_customer ON sales(customer_id);
CREATE INDEX idx_sales_product ON sales(product_id);
CREATE INDEX idx_sales_date ON sales(sale_date);

-- Print confirmation message
SELECT 'Sample database created successfully!' AS message; 