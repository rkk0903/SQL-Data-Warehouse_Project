/*===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================



CREATE VIEW gold.dim_customers AS
SELECT  
ROW_NUMBER () OVER (ORDER BY ci.cst_id) AS Customer_key,
ci.cst_id AS Customer_id,
ci.cst_key AS Customer_number,
ci.cst_firstname AS First_name,
ci.cst_lastname AS Last_name,
la.Country,
ci.cst_marital_status AS Marital_status,
CASE 
    WHEN ci.cst_gndr != 'N\A ' THEN ci.cst_gndr
    ELSE COALESCE(ca.gen,'N\A')
    END Gender,
ca.bdate AS Birth_date,
ci.cst_create_date as Create_date
FROM SILVER.crm_cust_info ci
LEFT JOIN SILVER.erp_CUST_AZ12 ca
ON ci.cst_key = ca.cid
LEFT JOIN SILVER.erp_LOC_A101 la
ON ci.cst_key = la.CUST_ID;



CREATE VIEW gold.dim_products AS
SELECT
ROW_NUMBER () OVER (ORDER BY pn.prd_start_dt ,pn.prd_key) AS Product_key,
pn.prd_id AS Product_id,
pn.prd_key AS Product_number,
pn.prd_nm AS Product_name,
pn.cat_id AS Category_id,
CASE 
     WHEN prd_id IN (542,543,544,545,546,547,548)  THEN 'Components'
     ELSE pc.cat
     END AS category,
CASE 
     WHEN pn.prd_id IN (542,543,544)  THEN 'Mountain Bikes'
     WHEN pn.prd_id IN (545,546,547)  THEN 'Road Bikes'
     WHEN pn.prd_id IN (548) THEN 'Touring Bikes'
     ELSE PC.subcat
     END AS Subcategory,
CASE 
    WHEN pn.prd_id IN (542,543,544,545,546,547,548) THEN 'YES'
    ELSE pc.maintenance
    END Maintenance,
pn.prd_cost AS Cost,
pn.prd_line AS Product_line,
pn.prd_start_dt AS Start_date
FROM SILVER.crm_prd_info pn
LEFT JOIN SILVER.erp_PX_CAT_G1V2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL;



CREATE VIEW gold.Fact_sales AS
SELECT
sd.sls_ord_num AS Order_number,
pr.Product_key,
cu.Customer_key,
sd.sls_order_dt AS Order_date,
sd.sls_ship_dt AS Shipping_date,
sd.sls_due_dt AS Due_date,
sd.sls_sales AS Sales_amount,
sd.sls_quantity AS Quantity,
sd.sls_price AS Price
FROM SILVER.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON  sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.Customer_id
