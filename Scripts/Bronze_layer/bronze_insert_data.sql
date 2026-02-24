/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/


CREATE OR ALTER PROCEDURE BRONZE.load_bronze AS
BEGIN
   DECLARE @Start_Time DATETIME ,@End_Time DATETIME,@batch_start_time DATETIME, @batch_end_time DATETIME;   
   BEGIN TRY
      PRINT'===================================================================================================';
      PRINT'Loading Bronze Layer';
      PRINT'===================================================================================================';

      PRINT'---------------------------------------------------------------------------------------------------';
      PRINT'Loading CRM Tables';
      PRINT'---------------------------------------------------------------------------------------------------';

      SET @Start_Time = GETDATE();
      PRINT'>> Truncating Table: BRONZE.crm_cust_info';
      TRUNCATE TABLE BRONZE.crm_cust_info;

      PRINT'>> Inserting Data Into: BRONZE.crm_cust_info';
      BULK INSERT BRONZE.crm_cust_info FROM'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_crm/cust_info.csv'
        WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK);
        SET @End_Time = GETDATE();
        PRINT'>> load Duration:' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR) + 'Seconds';
        PRINT'>>--------------------';


     SET @Start_Time = GETDATE();
     PRINT'>> Truncating Table: BRONZE.crm_prd_info';
     TRUNCATE TABLE BRONZE.crm_prd_info;

     PRINT'>> Inserting Data Into: BRONZE.crm_prd_info';
     BULK INSERT BRONZE.crm_prd_info FROM'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_crm/prd_info.csv'
       WITH(
       FIRSTROW = 2,
       FIELDTERMINATOR = ',',
       TABLOCK
       );
       SET @End_Time = GETDATE();
       PRINT'>> load Duration:' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR) + 'Seconds';
       PRINT'>>----------------------';


     SET @Start_Time = GETDATE();
     PRINT'>> Truncating Table: BRONZE.crm_sales_details';
     TRUNCATE TABLE BRONZE.crm_sales_details;

     PRINT'>> Inserting Data Into: BRONZE.crm_sales_details';
     BULK INSERT BRONZE.crm_sales_details FROM'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_crm/sales_details.csv'
        WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
        ); 
        SET @End_Time = GETDATE();
        PRINT'>> load Duration:' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR) + 'Seconds';  
        PRINT'>>-----------------------';
 
 
 -- INSERT DATA OF ERP
PRINT'---------------------------------------------------------------------------------------------------';
PRINT'Loading ERP Tables';
PRINT'---------------------------------------------------------------------------------------------------';

     SET @Start_Time = GETDATE();
     PRINT'>> Truncating Table: BRONZE.erp_CUST_AZ12';
       TRUNCATE TABLE BRONZE.erp_CUST_AZ12;

     PRINT'>> Inserting Data Into: BRONZE.erp_CUST_AZ12';
     BULK INSERT BRONZE.erp_CUST_AZ12 FROM'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_erp/CUST_AZ12.csv'
       WITH(
       FIRSTROW = 2,
       FIELDTERMINATOR = ',',
       TABLOCK
       );
       SET @End_Time = GETDATE();
       PRINT'>> load Duration:' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR) + 'Seconds';
       PRINT'>>------------------------';


     SET @Start_Time = GETDATE();
     PRINT'>> Truncating Table: BRONZE.erp_LOC_A101';
     TRUNCATE TABLE BRONZE.erp_LOC_A101;

     PRINT'>> Inserting Data Into: BRONZE.erp_LOC_A101';
     BULK INSERT BRONZE.erp_LOC_A101 FROM'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_erp/LOC_A101.csv'
       WITH(
       FIRSTROW = 2,
       FIELDTERMINATOR = ',',
       TABLOCK
       );
       SET @End_Time = GETDATE();
       PRINT'>> load Duration:' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR) + 'Seconds';
       PRINT'>>------------------------';


     SET @Start_Time = GETDATE();
     PRINT'>> Truncating Table: BRONZE.erp_PX_CAT_G1V12';
     TRUNCATE TABLE BRONZE.erp_PX_CAT_G1V2;

     PRINT'>> Inserting Data Into: BRONZE.erp_PX_CAT_G1V2';
     BULK INSERT BRONZE.erp_PX_CAT_G1V2 FROM'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_erp/PX_CAT_G1V2.csv'
       WITH(
       FIRSTROW = 2,
       FIELDTERMINATOR = ',',
       TABLOCK
);
     SET @End_Time = GETDATE();
     PRINT'>> load Duration:' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR) + 'Seconds';
     PRINT'>>-------------------------';
     SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
END TRY 
BEGIN CATCH 
    PRINT '=================================================================' 
    PRINT '====     ERROR OCCURED DURING LOADING BRONZE LAYER    ==========='
    PRINT '====     ERROR MESSAGE' + ERROR_MESSAGE();
    PRINT '====     ERROR MESSAGE' + CAST (ERROR_NUMBER() AS NVARCHAR);
    PRINT '====     ERROR MESSAGE' + CAST (ERROR_STATE() AS NVARCHAR);
    PRINT '================================================================='
END CATCH
END

