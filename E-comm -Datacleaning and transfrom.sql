USE ecomm;
SELECT * FROM customer_churn;
SELECT COUNT(*) CUST_COUNT FROM customer_churn;

											-- DATA CLEANING
-- Handling Missing Values and Outliers
-- Impute the MEAN value for the columns:WarehouseToHome, HourSpendOnApp, OrderAmountHikeFromlastYear,DaySinceLastOrder

SET SQL_SAFE_UPDATES=0;

SET @avg_WarehouseToHome=(SELECT ROUND(AVG(WarehouseToHome)) FROM customer_churn);
SELECT @avg_WarehouseToHome;

SET @avg_HourSpendOnApp=(SELECT ROUND(AVG(HourSpendOnApp)) FROM customer_churn);
SELECT @avg_HourSpendOnApp;

SET @avg_OrderAmntHikeFromlastYr=(SELECT ROUND(AVG(OrderAmountHikeFromlastYear)) FROM customer_churn);
SELECT @avg_OrderAmntHikeFromlastYr;

SET @avg_DaySinceLastOrder=(SELECT ROUND(AVG(DaySinceLastOrder)) FROM customer_churn);
SELECT @avg_DaySinceLastOrder;

	UPDATE customer_churn SET WarehouseToHome=@avg_WarehouseToHome
    WHERE WarehouseToHome IS NULL;
	UPDATE customer_churn SET HourSpendOnApp=@avg_HourSpendOnApp
    WHERE HourSpendOnApp IS NULL;
    UPDATE customer_churn SET OrderAmountHikeFromlastYear=@avg_OrderAmntHikeFromlastYr
    WHERE OrderAmountHikeFromlastYear IS NULL;
    UPDATE customer_churn SET DaySinceLastOrder=@avg_DaySinceLastOrder
    WHERE DaySinceLastOrder IS NULL;
    
SELECT AVG(WarehouseToHome) FROM customer_churn;
SELECT AVG(HourSpendOnApp) FROM customer_churn;
SELECT AVG(OrderAmountHikeFromlastYear) FROM customer_churn;
SELECT AVG(DaySinceLastOrder) FROM customer_churn;

SELECT DaySinceLastOrder,WarehouseToHome,HourSpendOnApp,OrderAmountHikeFromlastYear FROM customer_churn;

--  Impute mode for the following columns: Tenure, CouponUsed, OrderCount.

SET @mode_tunure=(SELECT Tenure FROM customer_churn GROUP BY Tenure ORDER BY count(*) DESC LIMIT 1);
SELECT @mode_tunure;
SET @mode_coupenused=(SELECT CouponUsed FROM customer_churn GROUP BY CouponUsed ORDER BY count(*) DESC LIMIT 1);
SELECT @mode_coupenused;
SET @mode_ordercount=(SELECT OrderCount FROM customer_churn GROUP BY OrderCount ORDER BY count(*) DESC LIMIT 1);
SELECT @mode_ordercount;

	UPDATE customer_churn SET Tenure=@mode_tunure
    WHERE Tenure IS NULL;
    UPDATE customer_churn SET CouponUsed=@mode_coupenused
    WHERE CouponUsed IS NULL;
    UPDATE customer_churn SET OrderCount=@mode_ordercount
    WHERE OrderCount IS NULL;

-- UPDATE customer_churn SET Tenure=(SELECT Tenure FROM customer_churn GROUP BY Tenure ORDER BY count(*) DESC LIMIT 1)
--     WHERE Tenure IS NULL;

SELECT Tenure,CouponUsed,OrderCount FROM customer_churn;

--  Handle outliers in the 'WarehouseToHome' column by deleting rows where the values are greater than 100.

SELECT WarehouseToHome,COUNT(*) FROM customer_churn GROUP BY WarehouseToHome ORDER BY WarehouseToHome DESC;

	DELETE FROM customer_churn WHERE WarehouseToHome>100;
    
-- Dealing with Inconsistencies 
-- Replace occurrences of “Phone” in the 'PreferredLoginDevice' column and “Mobile” in the 'PreferedOrderCat' column with “Mobile Phone”.

	UPDATE customer_churn 
    SET PreferredLoginDevice="Mobile Phone" WHERE PreferredLoginDevice="Phone";
    UPDATE customer_churn 
    SET PreferedOrderCat=IF(PreferedOrderCat="Mobile","Mobile Phone",PreferedOrderCat);
    
SELECT PreferredLoginDevice,PreferedOrderCat FROM customer_churn;
SELECT PreferedOrderCat,COUNT(*)FROM customer_churn GROUP BY PreferedOrderCat ORDER BY PreferedOrderCat;
SELECT PreferredLoginDevice,COUNT(*)FROM customer_churn GROUP BY PreferredLoginDevice ORDER BY PreferredLoginDevice;

-- Standardize payment mode values: Replace "COD" with "Cash on Delivery" and "CC" with "Credit Card" in the PreferredPaymentMode column.

	UPDATE customer_churn
    SET PreferredPaymentMode=CASE
		WHEN PreferredPaymentMode='COD' THEN 'Cash on Delivery'
        WHEN PreferredPaymentMode='CC' THEN 'Credit Card'
        ELSE PreferredPaymentMode
    END;
    
SELECT PreferredPaymentMode FROM customer_churn GROUP BY PreferredPaymentMode;

										-- Data Transformation
-- Column Renaming
-- Rename the column "PreferedOrderCat" to "PreferredOrderCat"
	
    ALTER TABLE customer_churn
    RENAME COLUMN PreferedOrderCat TO PreferredOrderCat;
    
--  Rename the column "HourSpendOnApp" to "HoursSpentOnApp"

	ALTER TABLE customer_churn
    RENAME COLUMN HourSpendOnApp TO HoursSpentOnApp;
    
-- Creating New Columns
-- Create a new column named ‘ComplaintReceived’ with values "Yes" if the corresponding value in the ‘Complain’ is 1, and "No" otherwise
-- Create a new column named 'ChurnStatus'. Set its value to “Churned” if the corresponding value in the 'Churn' column is 1, else assign “Active”

	ALTER TABLE customer_churn
    ADD COLUMN ComplaintReceived ENUM('Yes','No'),
    ADD COLUMN ChurnStatus ENUM('Churned','Active');
    
    UPDATE customer_churn
    SET ComplaintReceived=IF(Complain=1,'Yes','No'),
		ChurnStatus=IF(Churn=1,'Churned','Active');
        
SELECT ComplaintReceived,ChurnStatus FROM customer_churn;

-- Column Dropping
-- Drop the columns "Churn" and "Complain" from the table.

	ALTER TABLE customer_churn
    DROP COLUMN Churn,
    DROP COLUMN Complain;

SELECT * FROM customer_churn;

