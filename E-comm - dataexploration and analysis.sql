use ecomm;
SELECT * FROM customer_churn;
										-- Data Exploration and Analysis
-- Retrieve the count of churned and active customers from the dataset.
	SELECT ChurnStatus,count(*) Customer_count FROM customer_churn GROUP BY ChurnStatus;
    
-- Display the average tenure and total cashback amount of customers who churned.
	SELECT Round(AVG(Tenure)) Avg_tenure,sum(CashbackAmount) Total_caskback FROM customer_churn WHERE ChurnStatus='churned';

-- Determine the percentage of churned customers who complained.
	SELECT ComplaintReceived,CONCAT(ROUND(COUNT(*)/(SELECT COUNT(*) FROM customer_churn)*100,2),'%') Churn_percentage 
    FROM customer_churn  WHERE ChurnStatus='churned' GROUP BY ComplaintReceived;

-- Find the gender distribution of customers who complained.
	SELECT Gender,count(*) FROM customer_churn WHERE ComplaintReceived='Yes' GROUP BY Gender;
    -- SELECT Gender,count(*) FROM customer_churn GROUP BY Gender;
    
-- Identify the city tier with the highest number of churned customers whose preferred order category is Laptop & Accessory.
	SELECT CityTier,COUNT(*) count_of_churned_customer FROM customer_churn 
    WHERE ChurnStatus= 'churned' and PreferredOrderCat='Laptop & Accessory'
    GROUP BY CityTier 
    ORDER BY count(*)DESC LIMIT 1 ;
        
-- Identify the most preferred payment mode among active customers.
	SELECT PreferredPaymentMode FROM customer_churn WHERE ChurnStatus= 'Active' 
    GROUP BY PreferredPaymentMode
    ORDER BY count(*) DESC LIMIT 1;
   
-- total order amount hike from last year for customers who are single and prefer mobile phones for ordering.
	SELECT SUM(OrderAmountHikeFromlastYear) Total_hikeamount FROM customer_churn
    WHERE MaritalStatus='Single' AND PreferredLoginDevice= 'Mobile Phone';
    
-- Find the average number of devices registered among customers who used UPI as their preferred payment mode.
	SELECT ROUND(AVG(NumberOfDeviceRegistered)) FROM customer_churn WHERE PreferredPaymentMode='UPI';
    
--  Determine the city tier with the highest number of customers.
	SELECT CityTier,COUNT(*) Highestnocust FROM customer_churn 
    GROUP BY CityTier
    ORDER BY COUNT(*) DESC LIMIT 1;
    
-- Identify the gender that utilized the highest number of coupons.
	SELECT Gender,SUM(CouponUsed) Couponused FROM customer_churn  
    GROUP BY Gender ORDER BY COUNT(*) DESC LIMIT 1;

-- List the number of customers and the maximum hours spent on the app in each preferred order category.
	SELECT PreferredOrderCat, COUNT(*) Customers, MAX(HoursSpentOnApp) Maximumhourspent FROM customer_churn  
    GROUP BY  PreferredOrderCat ORDER BY Customers DESC;
    
-- Calculate the total order count for customers who prefer using credit cards and have the maximum satisfaction score.
	SELECT SUM(OrderCount) Total_Order_Count FROM customer_churn 
    WHERE PreferredPaymentMode='credit card' AND 
    SatisfactionScore=(SELECT MAX(SatisfactionScore) FROM customer_churn);
   
-- How many customers are there who spent only one hour on the app and days since their last order was more than 5?
	SELECT COUNT(*) Customer_count FROM customer_churn WHERE HoursSpentOnApp=1 AND DaySinceLastOrder>5 ;
    
-- What is the average satisfaction score of customers who have complained?
	SELECT ROUND(AVG(SatisfactionScore)) Average_satisfactionscore FROM customer_churn WHERE ComplaintReceived='Yes';
    
-- List the preferred order category among customers who used more than 5 coupons.
	SELECT PreferredOrderCat,COUNT(*)Count_Customer FROM customer_churn 
    WHERE CouponUsed>5 GROUP BY PreferredOrderCat ORDER BY COUNT(*) DESC;
    
-- List the top 3 preferred order categories with the highest average cashback amount.
	SELECT PreferredOrderCat,ROUND(AVG(CashbackAmount)) AVG_Cashback FROM customer_churn 
    GROUP BY PreferredOrderCat
    ORDER BY AVG_Cashback DESC LIMIT 3;

-- *Find the preferred payment modes of customers whose average tenure is 10 months and have placed more than 500 orders.
	SELECT PreferredPaymentMode,COUNT(*) FROM customer_churn 
	WHERE OrderCount>5 and Tenure=(SELECT ROUND(AVG(Tenure))FROM customer_churn)
    GROUP BY PreferredPaymentMode;
    
    SELECT PreferredPaymentMode,SUM(OrderCount) OrderCount FROM customer_churn 
	WHERE OrderCount>5 and Tenure=(SELECT ROUND(AVG(Tenure))FROM customer_churn)
    GROUP BY PreferredPaymentMode;
   
-- Categorize customers based on their distance from the warehouse to home such as 'Very Close Distance' for distances <=5km, 'Close Distance' for <=10km,
-- 'Moderate Distance' for <=15km, and 'Far Distance' for >15km. Then, display the churn status breakdown for each distance category.
	SELECT CASE
		WHEN WarehouseToHome<=5 THEN 'Very Close Distance'
        WHEN WarehouseToHome<=10 THEN 'Close Distance'
        WHEN WarehouseToHome<=15 THEN 'Moderate Distance'
        ELSE 'Far Distance'
	END AS Distance,
    count(*) churned_customer FROM customer_churn WHERE ChurnStatus='Churned'
    GROUP BY Distance ORDER BY churned_customer DESC;
    
-- List the customer’s order details who are married, live in City Tier-1, and their order counts are more than the average 
-- number of orders placed by all customers.
	SELECT Gender,PreferredPaymentMode,HoursSpentOnApp,OrderCount,DaySinceLastOrder FROM customer_churn 
    WHERE CityTier=1 AND MaritalStatus='Married' 
    HAVING OrderCount>(SELECT ROUND(AVG(OrderCount)) FROM customer_churn) 
    ORDER BY Gender,PreferredPaymentMode;
	
