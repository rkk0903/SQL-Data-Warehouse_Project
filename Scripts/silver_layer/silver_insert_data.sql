/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/



CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '-------------------------------------';

-- Loading silver.crm_cust_info
SET @start_time = GETDATE();
PRINT'>> Truncating Table : SILVER.crm_cust_info'
TRUNCATE TABLE SILVER.crm_cust_info;
PRINT '>> Inserting Data Into : SILVER.crm_cust_info'
INSERT INTO SILVER.crm_cust_info(
  cst_id,
  cst_key,
  cst_firstname,
  cst_lastname,
  cst_marital_status,
  cst_gndr,
  cst_create_date
  ) 
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,  --- Remove Unwanted space (Trim)
TRIM(cst_lastname) AS cst_lastname,    --- Remove Unwanted space (Trim)
CASE UPPER(TRIM(cst_marital_status)) 
     WHEN  'M' THEN 'Married'
     WHEN  'S' THEN 'Single'
     ELSE 'N\A'          --- Handling Missing Values
END cst_marital_status,  --- Normalize marital status values to understand data 
CASE 
     WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
     WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
     ELSE 'N\A'          --- Handling Missing Values
END cst_gndr,            --- Normalize marital status values to understand data
  cst_create_date
FROM(
   SELECT 
   *,
   ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date desc) AS flag_last
FROM BRONZE.crm_cust_info WHERE cst_id IS NOT NULL
) T 
WHERE flag_last = 1 ;    --- Select the most recent records per customer ( Find Duplicate)
SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';


SET @start_time = GETDATE();
PRINT'>> Truncating Table : SILVER.crm_prd_info'
TRUNCATE TABLE SILVER.crm_prd_info;
PRINT '>> Inserting Data Into : SILVER.crm_prd_info'
INSERT INTO SILVER.crm_prd_info(
prd_id,
prd_key,
cat_id,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)
SELECT
prd_id,
SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,    --- Extract category ID
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS Cat_id, --- Extract Product key
prd_nm,
ISNULL(prd_cost,0) AS prd_cost,
CASE UPPER(TRIM(prd_line))
           WHEN 'R' THEN 'Road'
           WHEN 'S' THEN 'other Sales'
           WHEN 'M' THEN 'Mountain'
           WHEN 'T' THEN 'Touring'
           ELSE 'N\A'
END AS prd_line,         --- Map product line codes to descriptive values
prd_start_dt,
DATEADD(DAY,-1,LEAD(prd_start_dt) 
OVER (PARTITION BY prd_key ORDER BY prd_start_dt))
AS prd_end_dt            --- Calulate end date as one day before the next start date
FROM BRONZE.crm_prd_info;   
SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';  



SET @start_time = GETDATE();
PRINT'>> Truncating Table : SILVER.crm_sales_details'
TRUNCATE TABLE SILVER.crm_sales_details;
PRINT '>> Inserting Data Into :SILVER.crm_sales_details'
INSERT INTO SILVER.crm_sales_details(
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
)
SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
  CASE
      WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
      ELSE CONVERT(DATE,CAST( sls_order_dt AS VARCHAR(50)),112) 
END AS sls_order_dt,
CASE
      WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
      ELSE  CONVERT(DATE,CAST( sls_ship_dt AS VARCHAR(50)),112)
END AS sls_ship_dt,
CASE
      WHEN sls_due_dt = 0 OR LEN( sls_due_dt) != 8 THEN NULL
      ELSE CONVERT(DATE,CAST( sls_due_dt AS VARCHAR(50)),112)     
END AS sls_due_dt,
CASE 
    WHEN sls_sales IS NULL OR  sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
    THEN sls_quantity * ABS(sls_price)
    ELSE sls_sales
    END AS sls_sales,          --- Recalulate sales if original value is missing or incorrect
sls_quantity,
CASE 
    WHEN sls_price IS NULL OR   sls_price <= 0 
       THEN sls_sales / NULLIF(sls_quantity,0)
     ELSE  sls_price         --- Derive price if original value is invalid
   END AS sls_price
FROM BRONZE.crm_sales_details;
SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';



PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';

SET @start_time = GETDATE();
 PRINT'>> Truncating Table : SILVER.erp_CUST_AZ12'
TRUNCATE TABLE SILVER.erp_CUST_AZ12;
PRINT '>> Inserting Data Into : SILVER.erp_CUST_AZ12'
 INSERT INTO SILVER.erp_CUST_AZ12(
 CID,
 BDATE,
 GEN)
SELECT
   CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID,4, LEN(CID))   --- Remove 'NAS' prefix if present
ELSE CID
END CID,
CASE 
     WHEN BDATE > GETDATE() OR BDATE <'1924-01-01' THEN NULL
     ELSE BDATE
  END BDATE,                         --- Set future birthdate to Null 
 CASE  
     WHEN UPPER(TRIM(GEN)) IN ('F','FEMALE')   THEN 'Female'
     WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
     ELSE 'N\A'
     END GEN                          --- Normalize gender values and handle unknown cases
FROM BRONZE.erp_CUST_AZ12;
SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';




SET @start_time = GETDATE();
PRINT'>> Truncating Table : SILVER.erp_LOC_A101'
TRUNCATE TABLE SILVER.erp_LOC_A101;
PRINT '>> Inserting Data Into : SILVER.erp_LOC_A101'
INSERT INTO SILVER.erp_LOC_A101(
CUST_ID,
COUNTRY
)
SELECT
 REPLACE(CUST_ID,'-','') AS CUST_ID,    --- Remove Unwanted sign 
 CASE 
     WHEN TRIM (COUNTRY) IN ('US', 'USA')          THEN 'United States'
     WHEN TRIM (COUNTRY)  = 'DE'                   THEN 'Germany'
     WHEN TRIM (COUNTRY)   = ''  OR COUNTRY IS NULL THEN  'N\A'       --- Normalize AND Handling null values or empty cell
     ELSE TRIM (COUNTRY)
   END AS COUNTRY
 FROM BRONZE.erp_LOC_A101;
 SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';



SET @start_time = GETDATE();
PRINT'>> Truncating Table : SILVER.erp_PX_CAT_G1V2'
TRUNCATE TABLE SILVER.erp_PX_CAT_G1V2;
PRINT '>> Inserting Data Into : SILVER.erp_PX_CAT_G1V2' 
INSERT INTO SILVER.erp_PX_CAT_G1V2(
ID,
CAT,
SUBCAT,
MAINTENANCE)
SELECT 
ID,
CAT,
SUBCAT,
MAINTENANCE
FROM BRONZE.erp_PX_CAT_G1V2;
SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END

 
 
