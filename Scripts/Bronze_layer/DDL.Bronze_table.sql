/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

IF OBJECT_ID('BRONZE.crm_cust_info','U') IS NOT NULL
    DROP TABLE BRONZE.crm_cust_info;
GO
CREATE TABLE  BRONZE.crm_cust_info(
cst_id INT,
cst_key	NVARCHAR(100),
cst_firstname VARCHAR(100),
cst_lastname VARCHAR(100),
cst_marital_status VARCHAR(100),
cst_gndr VARCHAR(100),
cst_create_date DATE );
GO

IF OBJECT_ID('BRONZE.crm_prd_info','U') IS NOT NULL
    DROP TABLE BRONZE.crm_prd_info;
GO
CREATE TABLE  BRONZE.crm_prd_info(
prd_id INT,
prd_key	NVARCHAR(100),
prd_nm	NVARCHAR(100),
prd_cost INT,
prd_line VARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE );
GO

IF OBJECT_ID('BRONZE.crm_sales_details','U') IS NOT NULL
    DROP TABLE BRONZE.crm_sales_details;
GO
CREATE TABLE  BRONZE.crm_sales_details (
sls_ord_num	NVARCHAR(100),
sls_prd_key	NVARCHAR(100),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt	INT, 
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,	
sls_price INT );
GO
    
    
  --      ERP TABLES      --- 
    
IF OBJECT_ID('BRONZE.erp_CUST_AZ12','U') IS NOT NULL
    DROP TABLE BRONZE.erp_CUST_AZ12; 
GO
CREATE TABLE  BRONZE.erp_CUST_AZ12(
CID	NVARCHAR(100),
BDATE DATE,
GEN VARCHAR(50));
GO


IF OBJECT_ID('BRONZE.erp_LOC_A101','U') IS NOT NULL
    DROP TABLE BRONZE.erp_LOC_A101;
GO
CREATE TABLE  BRONZE.erp_LOC_A101(
CUST_ID	NVARCHAR(100),
COUNTRY VARCHAR(100));
GO

  
IF OBJECT_ID('BRONZE.erp_PX_CAT_G1V2','U') IS NOT NULL
    DROP TABLE BRONZE.erp_PX_CAT_G1V2;
GO
CREATE TABLE  BRONZE.erp_PX_CAT_G1V2(
ID VARCHAR(100),
CAT	VARCHAR(100),
SUBCAT VARCHAR(100),
MAINTENANCE VARCHAR(100));


