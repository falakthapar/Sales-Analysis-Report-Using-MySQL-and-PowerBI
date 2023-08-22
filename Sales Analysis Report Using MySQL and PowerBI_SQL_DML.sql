--  Data Analysis Using SQL

-- 1. To see all tables in sales database.

SELECT * FROM customers;

SELECT * FROM date;

SELECT * FROM markets; 

# In markets table we have markets which are from other countries so we will not need them.

SELECT * FROM products;

SELECT * FROM transactions;

# Here, In transactions table we have some transactions which are not in INR so we will need to convert them to INR.

-- 2. To see total number of transactions 

SELECT count(*) as Transactions_Count FROM  transactions;

-- 3. To see number of transactions and sum of sales from different markets

SELECT 
    market_code,
    markets_name,
    SUM(sales_amount) AS Total_Sales,
    COUNT(*) AS transaction_count
FROM
    transactions T
        JOIN
    markets M ON T.market_code = M.markets_code
GROUP BY market_code , markets_name
ORDER BY Total_Sales DESC;

-- 4.To get all the transactions from particular market
/* I have created a stored procedure to get insights for differnt markets */ 

Delimiter //
create procedure Transactions_From_Market( Name varchar(30))
Begin
	select * FROM transactions T JOIN markets M ON T.market_code = M.markets_code where markets_name = Name;
End//
Delimiter ; 

call Transactions_From_Market('Chennai');

-- 5. To see transactions which do not have INR as currency

SELECT 
    *
FROM
    transactions
WHERE
    currency NOT LIKE '%INR%'; 

# Here we would not like to hamper the original data so we will create a veiw and then we can make changes.alter

CREATE VIEW transactions_view AS
    SELECT * FROM transactions;

UPDATE transactions_view 
SET 
    sales_amount = sales_amount * 88
WHERE
    currency LIKE '%USD';

-- 6. To see transations in 2020 joined by dates table

SELECT 
    *
FROM
    transactions T
        JOIN
    date D ON T.order_date = D.date
WHERE
    year = 2020;


-- 7. Checking revenue for different years to see revenue pattern.

SELECT *
	,Total_sales - sales_last_year AS change_in_sales
FROM (
	SELECT sales_year
		,Total_sales
		,lag(Total_sales) OVER () AS sales_last_year
	FROM (
		SELECT year AS sales_year
			,sum(sales_amount) AS Total_sales
		FROM transactions T
		INNER JOIN DATE D ON T.order_date = D.DATE
		GROUP BY year
		) T1
	) T2;

# here, we can see that sales increased in 2018 but then decreased on 2019 and 2020. 

-- 8. Checking for sales in Chennai in year 2020.

SELECT 
    SUM(sales_amount) AS Sales_2020_Chennai
FROM
    transactions T
        JOIN
    markets M ON T.market_code = M.markets_code
        JOIN
    date D ON T.order_date = D.date
WHERE
    year = 2020 AND markets_name = 'Chennai';




