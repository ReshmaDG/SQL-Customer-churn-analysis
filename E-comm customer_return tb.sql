USE ecomm;

CREATE TABLE customer_returns(
ReturnID INT PRIMARY KEY,
CustomerID INT,
ReturnDate DATE,
RefundAmount INT,
FOREIGN KEY(CustomerID) REFERENCES customer_churn(CustomerID) );

INSERT INTO customer_returns VALUES
(1001,50022,'2023-01-01',2130),
(1002,50316,'2023-01-23',2000),
(1003,51099,'2023-02-14',2290),
(1004,52321,'2023-03-08',2510),
(1005,52928,'2023-03-20',3000),
(1006,53749,'2023-04-17',1740),
(1007,54206,'2023-04-21',3250),
(1008,54838,'2023-04-30',1990);

SELECT * FROM customer_returns;

-- Display the return details along with the customer details of those who have churned and have made complaints.
	SELECT * FROM customer_returns R 
    LEFT JOIN customer_churn C ON C.CustomerID=R.CustomerID 
    WHERE ChurnStatus= 'Churned' AND ComplaintReceived= 'Yes';