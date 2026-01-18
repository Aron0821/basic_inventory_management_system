# Inventory Management Database (SQL Server)

## 📦 Project Overview

This project is a SQL Server–based Inventory Management System designed to manage products, suppliers, inventory stock levels, and transactions (sales and purchases).

It demonstrates:
- Database design with relationships
- Constraints and data integrity
- Inventory tracking logic
- Sales and purchase reporting using SQL queries

---

## 🛠️ Technologies Used

- Database: Microsoft SQL Server
- Language: SQL (T-SQL)
- Tool: SQL Server Management Studio (SSMS)

---

## 🗄️ Database Tables

### 1. Products
Stores product details.

| Column | Data Type | Description |
|------|----------|-------------|
| product_id | INT (PK, IDENTITY) | Unique product ID |
| product_name | VARCHAR(255) | Product name |
| price | DECIMAL(10,2) | Product price |
| category | VARCHAR(100) | Product category |

---

### 2. Suppliers
Stores supplier information.

| Column | Data Type | Description |
|------|----------|-------------|
| supplier_id | INT (PK, IDENTITY) | Unique supplier ID |
| supplier_name | VARCHAR(255) | Supplier name |
| contact_email | VARCHAR(255) | Email address |
| phone_number | VARCHAR(15) | Phone number |

---

### 3. Inventory
Tracks product stock levels.

| Column | Data Type | Description |
|------|----------|-------------|
| inventory_id | INT (PK, IDENTITY) | Inventory ID |
| product_id | INT (FK) | Product reference |
| quantity | INT | Available stock |
| supplier_id | INT (FK) | Supplier reference |
| last_updated | DATE | Last updated date |

---

### 4. Transactions
Stores sales and purchase records.

| Column | Data Type | Description |
|------|----------|-------------|
| transaction_id | INT (PK, IDENTITY) | Transaction ID |
| product_id | INT (FK) | Product reference |
| transaction_type | VARCHAR(10) | sale / purchase |
| transaction_date | DATE | Transaction date |
| quantity | INT | Quantity |

**Constraint:**  
`transaction_type` must be either `'sale'` or `'purchase'`.

---

## 🔗 Table Relationships

- Products → Inventory (One-to-Many)
- Suppliers → Inventory (One-to-Many)
- Products → Transactions (One-to-Many)

Foreign keys are used to maintain data integrity.

---

## 📊 Sample Queries & Features

### View Current Inventory
```sql
SELECT p.product_name, i.quantity
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id;
```

### Update Stock After Sale
```sql
UPDATE Inventory
SET quantity = quantity - 3
WHERE product_id = 2;
```

### Update Stock After Purchase
```sql
UPDATE Inventory
SET quantity = quantity + 10
WHERE product_id = 1;
```

### Low Stock Products
```sql
SELECT p.product_name, i.quantity
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
WHERE i.quantity < 5;
```

### Sales Report by Date Range
```sql
SELECT p.product_name, SUM(t.quantity) AS total_sold
FROM Transactions t
JOIN Products p ON t.product_id = p.product_id
WHERE t.transaction_type = 'sale'
  AND t.transaction_date BETWEEN '2026-01-12' AND '2026-10-31'
GROUP BY p.product_name;
```

### Total Revenue Calculation
```sql
SELECT SUM(t.quantity * p.price) AS total_revenue
FROM Transactions t
JOIN Products p ON t.product_id = p.product_id
WHERE t.transaction_type = 'sale';
```

### Top-Selling Product
```sql
WITH TopProduct AS (
    SELECT p.product_name, SUM(t.quantity) AS total_sold
    FROM Transactions t
    JOIN Products p ON t.product_id = p.product_id
    WHERE t.transaction_type = 'sale'
    GROUP BY p.product_name
)
SELECT *
FROM TopProduct
WHERE total_sold = (SELECT MAX(total_sold) FROM TopProduct);
```

---

## 🧪 Sample Data

The database includes:
- 20 products
- 10 suppliers
- Inventory stock records
- Sales and purchase transactions

This allows easy testing and reporting.

---

## 🚀 How to Run

1. Open SQL Server Management Studio (SSMS)
2. Create a new query window
3. Paste and execute the SQL script
4. Verify data using:
```sql
SELECT * FROM Products;
SELECT * FROM Inventory;
SELECT * FROM Transactions;
```

---

## 📌 Use Cases

- Inventory management system
- SQL practice project
- Academic assignment
- Business reporting
- Data visualization (Tableau / Power BI)

---

## 🔮 Future Improvements

- Triggers for automatic stock updates
- Stored procedures for transactions
- Reorder level alerts
- Index optimization
- Role-based access

---

## 👤 Author

Aron Shakha
