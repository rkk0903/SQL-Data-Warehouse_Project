# SQL Data Warehouse Project

<p align="center">
  <img src="https://img.shields.io/badge/SQL-Data%20Warehouse-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/Architecture-Bronze%20%7C%20Silver%20%7C%20Gold-orange?style=for-the-badge">
  <img src="https://img.shields.io/badge/ETL-Pipeline-success?style=for-the-badge">
</p>

---

## 📌 Project Overview

This project demonstrates a modern SQL Data Warehouse Architecture using a layered approach:

- Bronze Layer → Raw Data Ingestion
- Silver Layer → Data Cleaning & Transformation
- Gold Layer → Business & Analytics Views

The project integrates data from multiple source systems (CRM + ERP) and transforms raw datasets into analytics-ready structures suitable for reporting and BI tools.

---

# 🏗️ Data Warehouse Architecture

```text
        Source Systems
      ┌────────────────┐
      │ CRM Data       │
      │ ERP Data       │
      └──────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Bronze Layer     │
    │ Raw Data Storage │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Silver Layer     │
    │ Cleaned Data     │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Gold Layer       │
    │ Business Views   │
    └──────────────────┘
```

---

# 📂 Project Structure

```bash
SQL-Data-Warehouse-Project/
│
├── Datasets
│   ├── crm_source
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   │
│   ├── erp_source
│   │   ├── CUST_AZ12.csv
│   │   ├── LOC_A101.csv
│   │   └── PX_CAT_G1V2.csv
│
├── Docs
│   ├── data_catalog.md
│   └── naming_convention.md
│
├── Scripts
│   ├── Bronze_layer
│   │   ├── DDL.Bronze_table.sql
│   │   └── bronze_insert_data.sql
│   │
│   ├── silver_layer
│   │   ├── DDL_silver_table.sql
│   │   └── silver_insert_data.sql
│   │
│   ├── Gold_layer
│   │   └── DDL.Create_gold_view.sql
│   │
│   └── Create_database.sql
│
├── Tests
│
├── README.md
└── LICENSE
```

---

# 📊 Source Systems

## 🔹 CRM Source

Contains customer and sales-related datasets.

| File Name | Description |
|---|---|
| `cust_info.csv` | Customer information |
| `prd_info.csv` | Product details |
| `sales_details.csv` | Sales transaction data |

---

## 🔹 ERP Source

Contains enterprise operational datasets.

| File Name | Description |
|---|---|
| `CUST_AZ12.csv` | ERP customer data |
| `LOC_A101.csv` | Location information |
| `PX_CAT_G1V2.csv` | Product category mapping |

---

# ⚙️ Technologies Used

- SQL
- Data Warehousing
- ETL Pipeline
- Data Modelling
- CSV File Processing

### Compatible Databases

- SQL Server
- PostgreSQL
- MySQL
- Snowflake
- Azure SQL

---

# 🚀 ETL Workflow

## Step 1 — Create Database

```sql
Create_database.sql
```

## Step 2 — Create Bronze Tables

```sql
DDL.Bronze_table.sql
```

## Step 3 — Load Bronze Data

```sql
bronze_insert_data.sql
```

## Step 4 — Create Silver Tables

```sql
DDL_silver_table.sql
```

## Step 5 — Load Silver Data

```sql
silver_insert_data.sql
```

## Step 6 — Create Gold Views

```sql
DDL.Create_gold_view.sql
```

---

# 📈 Features

✅ Layered Warehouse Architecture  
✅ CRM + ERP Data Integration  
✅ SQL-Based ETL Pipeline  
✅ Data Cleaning & Standardisation  
✅ Analytical Gold Views  
✅ Organised Project Structure  
✅ Real-World Data Engineering Concepts  

---

# 📖 Documentation

| File | Purpose |
|---|---|
| `data_catalog.md` | Dataset metadata and descriptions |
| `naming_convention.md` | SQL naming standards |

---

# 📌 Use Cases

This project is useful for:

- Data Analyst Portfolio
- SQL Interview Preparation
- Data Engineering Practice
- ETL Learning
- Power BI Backend Development
- Data Warehouse Demonstration

---

# 🔮 Future Enhancements

- Add Stored Procedures
- Add Incremental Loading
- Add Data Validation Tests
- Add Automated Scheduling
- Integrate Power BI Dashboard
- Add Airflow / Azure Data Factory

---

# 🤝 Contributing

Contributions are welcome.

You can contribute by:

- Improving SQL scripts
- Optimising transformations
- Adding validations
- Improving documentation

---

# 📜 License

This project is licensed under the MIT License.

---

# 👨‍💻 Author

### Rahul Kumar

SQL • Data Analytics • ETL • Data Warehousing • Power BI

linkedin : https://www.linkedin.com/in/rahul-kumar-345660303/

---

⭐ If you found this project useful, consider giving it a star on GitHub!
