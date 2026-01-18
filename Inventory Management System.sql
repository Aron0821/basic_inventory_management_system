CREATE DATABASE InventoryDB;
USE InventoryDB;

-- Create the Products table
CREATE TABLE Products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(100)
);

-- Create the Suppliers table
CREATE TABLE Suppliers (
    supplier_id INT IDENTITY(1,1) PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255),
    phone_number VARCHAR(15)
);

-- Create the Inventory table
CREATE TABLE Inventory (
    inventory_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT,
    quantity INT DEFAULT 0,
    supplier_id INT,
    last_updated DATE DEFAULT GETDATE(),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- Create the Transactions table
CREATE TABLE Transactions (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    transaction_type VARCHAR(10) NOT NULL,
    transaction_date DATE DEFAULT GETDATE(),
    quantity INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    CHECK (transaction_type IN ('sale', 'purchase'))
);

INSERT INTO Products (product_name, price, category) VALUES
('Laptop', 1200.00, 'Electronics'),
('Desk Chair', 150.00, 'Furniture'),
('Notebook', 2.50, 'Stationery'),
('Mouse', 25.00, 'Electronics'),
('Keyboard', 45.00, 'Electronics'),
('Monitor 24"', 180.00, 'Electronics'),
('Office Desk', 250.00, 'Furniture'),
('Pen Pack', 5.00, 'Stationery'),
('Printer', 200.00, 'Electronics'),
('USB Drive 64GB', 15.00, 'Electronics'),
('Headphones', 35.00, 'Electronics'),
('Smartphone', 650.00, 'Electronics'),
('Backpack', 40.00, 'Accessories'),
('Desk Lamp', 20.00, 'Furniture'),
('Paper Ream', 8.00, 'Stationery'),
('Whiteboard', 60.00, 'Furniture'),
('Stapler', 10.00, 'Stationery'),
('Webcam', 50.00, 'Electronics'),
('Router', 80.00, 'Electronics'),
('Coffee Mug', 7.00, 'Accessories');

INSERT INTO Suppliers (supplier_name, contact_email, phone_number) VALUES
('Tech Supplies Co.', 'contact@techsupplies.com', '1234567890'),
('Office Furniture Inc.', 'support@officefurniture.com', '0987654321'),
('Stationery World', 'hello@stationeryworld.com', '1112223334'),
('ElectroMart', 'sales@electromart.com', '2223334445'),
('Smart Devices Ltd.', 'info@smartdevices.com', '3334445556'),
('Furniture Hub', 'contact@furniturehub.com', '4445556667'),
('Paper Supplies Ltd.', 'orders@papersupplies.com', '5556667778'),
('Gadget World', 'support@gadgetworld.com', '6667778889'),
('Office Essentials', 'info@officeessentials.com', '7778889990'),
('Accessory Depot', 'sales@accessorydepot.com', '8889990001');

INSERT INTO Inventory (product_id, quantity, supplier_id, last_updated) VALUES
(1, 50, 1, GETDATE()),
(2, 40, 2, GETDATE()),
(3, 100, 3, GETDATE()),
(4, 70, 4, GETDATE()),
(5, 60, 4, GETDATE()),
(6, 30, 4, GETDATE()),
(7, 25, 6, GETDATE()),
(8, 200, 3, GETDATE()),
(9, 15, 4, GETDATE()),
(10, 90, 8, GETDATE()),
(11, 55, 9, GETDATE()),
(12, 35, 5, GETDATE()),
(13, 80, 10, GETDATE()),
(14, 60, 6, GETDATE()),
(15, 150, 7, GETDATE());

INSERT INTO Transactions (product_id, transaction_type, transaction_date, quantity) VALUES
(1, 'purchase', GETDATE(), 30),
(2, 'purchase', GETDATE(), 25),
(3, 'purchase', GETDATE(), 80),
(4, 'purchase', GETDATE(), 50),
(5, 'purchase', GETDATE(), 40),
(1, 'sale', GETDATE(), 10),
(2, 'sale', GETDATE(), 5),
(3, 'sale', GETDATE(), 20),
(4, 'sale', GETDATE(), 15),
(5, 'sale', GETDATE(), 8);

-- View current stock quantities
SELECT p.product_name, i.quantity
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id;

-- Decrease stock after a sale
UPDATE Inventory
SET quantity = quantity - 3
WHERE product_id = 2;

-- Increase stock after a purchase
UPDATE Inventory
SET quantity = quantity + 10
WHERE product_id = 1;

-- View transaction history for a specific product
SELECT t.transaction_type, t.quantity, t.transaction_date
FROM Transactions t
JOIN Products p ON t.product_id = p.product_id
WHERE p.product_id = 1;

-- View products with low stock
SELECT p.product_name, i.quantity
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
WHERE i.quantity < 5;

-- Generate sales report for a specific date range
SELECT p.product_name, SUM(t.quantity) AS total_sold
FROM Transactions t
JOIN Products p ON t.product_id = p.product_id
WHERE t.transaction_type = 'sale'
  AND t.transaction_date BETWEEN '2026-01-12' AND '2026-10-31'
GROUP BY p.product_name;

-- Identify products that need reorder
SELECT p.product_name, i.quantity
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
WHERE i.quantity < 5;

-- Insert new product into Products table
INSERT INTO Products (product_name, category, price)
VALUES ('Monitor', 'Electronics', 150.00);

-- Insert initial stock for new product
INSERT INTO Inventory (product_id, quantity)
VALUES ((SELECT product_id FROM Products WHERE product_name = 'Monitor'), 20);

-- Delete product and its related records
DELETE FROM Transactions WHERE product_id = 3;
DELETE FROM Inventory WHERE product_id = 3;
DELETE FROM Products WHERE product_id = 3;

-- View products in Electronics category
SELECT product_name, price
FROM Products
WHERE category = 'Electronics';

-- View inventory value per product
SELECT p.product_name, i.quantity, p.price,
       (i.quantity * p.price) AS total_value
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id;

-- Find products with no sales or no recent sales
SELECT p.product_name
FROM Products p
LEFT JOIN Transactions t ON p.product_id = t.product_id
  AND t.transaction_type = 'sale'
WHERE t.transaction_date IS NULL
   OR t.transaction_date < '2026-01-18';

-- Calculate total revenue for a date range
SELECT SUM(t.quantity * p.price) AS total_revenue
FROM Transactions t
JOIN Products p ON t.product_id = p.product_id
WHERE t.transaction_type = 'sale'
  AND t.transaction_date BETWEEN '2026-01-17' AND '2026-10-31';

-- Find top-selling product in a date range
WITH TopProduct AS (
    SELECT p.product_name, SUM(t.quantity) AS total_sold
    FROM Transactions t
    JOIN Products p ON t.product_id = p.product_id
    WHERE t.transaction_type = 'sale'
      AND t.transaction_date BETWEEN '2026-01-17' AND '2026-10-31'
    GROUP BY p.product_name
)
SELECT *
FROM TopProduct
WHERE total_sold = (SELECT MAX(total_sold) FROM TopProduct);

-- View purchase transactions for a product
SELECT t.transaction_date, t.quantity
FROM Transactions t
WHERE t.product_id = 2
  AND t.transaction_type = 'purchase';

-- View today�s sales per product
SELECT p.product_name, SUM(t.quantity) AS total_sold_today
FROM Transactions t
JOIN Products p ON t.product_id = p.product_id
WHERE t.transaction_type = 'sale'
  AND CAST(t.transaction_date AS DATE) = CAST(GETDATE() AS DATE)
GROUP BY p.product_name
ORDER BY total_sold_today DESC;

-- View inventory for specific products
SELECT p.product_name, i.quantity
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
WHERE p.product_id IN (1, 2);

-- View purchase transactions with product names
SELECT t.transaction_date, p.product_name, t.quantity
FROM Transactions t
JOIN Products p ON t.product_id = p.product_id
WHERE t.transaction_type = 'purchase';

-- View out-of-stock products
SELECT p.product_name
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
WHERE i.quantity = 0;
