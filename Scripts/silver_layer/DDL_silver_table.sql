/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/


IF OBJECT_ID('SILVER.crm_cust_info','U') IS NOT NULL
    DROP TABLE SILVER.crm_cust_info;
GO
CREATE TABLE  SILVER.crm_cust_info(
cst_id INT,
cst_key	NVARCHAR(100),
cst_firstname VARCHAR(100),
cst_lastname VARCHAR(100),
cst_marital_status VARCHAR(100),
cst_gndr VARCHAR(100),
cst_create_date DATE ,
Dwh_create_date DATETIME2 DEFAULT GETDATE());
GO


IF OBJECT_ID('SILVER.crm_prd_info','U') IS NOT NULL
    DROP TABLE SILVER.crm_prd_info;
GO
CREATE TABLE  SILVER.crm_prd_info(
prd_id INT,
prd_key	NVARCHAR(100),
cat_id VARCHAR(100),
prd_nm	NVARCHAR(100),
prd_cost INT,
prd_line VARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE, 
Dwh_create_date DATETIME2 DEFAULT GETDATE());
GO


IF OBJECT_ID('SILVER.crm_sales_details','U') IS NOT NULL
    DROP TABLE SILVER.crm_sales_details;
GO
CREATE TABLE  SILVER.crm_sales_details (
sls_ord_num	NVARCHAR(100),
sls_prd_key	NVARCHAR(100),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt	DATE, 
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,	
sls_price INT,
Dwh_create_date DATETIME2 DEFAULT GETDATE());
GO    
    

  --      ERP TABLES      --- 
    
IF OBJECT_ID('SILVER.erp_CUST_AZ12','U') IS NOT NULL
    DROP TABLE SILVER.erp_CUST_AZ12;
GO    
CREATE TABLE  SILVER.erp_CUST_AZ12(
CID	NVARCHAR(100),
BDATE DATE,
GEN VARCHAR(50),
Dwh_create_date DATETIME2 DEFAULT GETDATE());
GO


IF OBJECT_ID('SILVER.erp_LOC_A101','U') IS NOT NULL
    DROP TABLE SILVER.erp_LOC_A101;
GO    
CREATE TABLE  SILVER.erp_LOC_A101(
CUST_ID	NVARCHAR(100),
COUNTRY VARCHAR(100),
Dwh_create_date DATETIME2 DEFAULT GETDATE());
GO



IF OBJECT_ID('SILVER.erp_PX_CAT_G1V2','U') IS NOT NULL
    DROP TABLE SILVER.erp_PX_CAT_G1V2;
GO    
CREATE TABLE  SILVER.erp_PX_CAT_G1V2(
ID VARCHAR(100),
CAT	VARCHAR(100),
SUBCAT VARCHAR(100),
MAINTENANCE VARCHAR(100),
Dwh_create_date DATETIME2 DEFAULT GETDATE());
GO

