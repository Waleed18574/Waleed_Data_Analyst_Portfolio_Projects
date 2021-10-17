/*
Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at,
account name, order total, and order total_amt_usd.*/
SELECT 
	we.occurred_at AS [Accoured at]
	, a.name as Name
	, o.total AS [Total Quantity]
	, o.total_amt_usd AS [Total Revenue]
FROM 
	orders AS o
 INNER JOIN 
	accounts AS a
  ON 
	o.account_id = a.id
 INNER JOIN 
	web_events AS we
  ON 
	a.id = we.account_id
GO

/*What are the average quantity & total revenue for each paper type 
(standard, gloss, poster)*/
SELECT 
	AVG(standard_qty) AS Average_Standard_Quantity
	, AVG(standard_amt_usd) AS Average_Standard_Revenue
	, AVG(gloss_qty) AS Average_Gloss_Quantity
	, AVG(gloss_amt_usd) AS Average_Gloss_Revenue
	, AVG(poster_amt_usd) AS Average_Poster_Quantity
	, AVG(poster_amt_usd) AS Average_Poster_Revenue
FROM 
	orders;
GO

/*What is median of (total_amt_usd) values*/

DECLARE @MED BIGINT = (SELECT COUNT(*) FROM orders)

SELECT 
	AVG(1.0*total_amt_usd)
FROM (
	SELECT 
		total_amt_usd 
	FROM	
		orders
	ORDER BY
		total_amt_usd
	OFFSET (@MED - 1)/2 ROWS
	FETCH NEXT (1 + (1-@MED %2)) ROWS ONLY
	) T1
GO

/*
For each account, determine the average amount spent per order on each paper type. Your 
result should have four columns - one for the account name and one for the average amount spent 
on each paper type.*/
SELECT 
	a.name AS Account
	,ROUND(AVG(o.standard_amt_usd),2) AS [AVG Standard Revenue]
	,ROUND(AVG(o.gloss_amt_usd),2) AS [Average Gloss Revenue]
	,ROUND(AVG(o.poster_amt_usd),2) AS [Average Poster Revenue]
FROM 
	accounts AS a
 INNER JOIN 
	orders AS o
  ON 
	a.id = o.account_id
GROUP BY 
	a.name
GO

/*Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented 
by the dataset?*/
-- I checked if the moonths represented evenly in the data
SELECT
	DATEPART(year,occurred_at) AS [Year]
	,DATEPART(month,occurred_at) AS [Month]
	, SUM(total_amt_usd) AS [Total Revenue]
FROM 
	orders
GROUP BY DATEPART(year,occurred_at),DATEPART(month,occurred_at)
ORDER BY
	[Year],[Month]
	
-- Since the data contain only 1 month for each 2013 and 2017, I removed these year from the query 

SELECT
	TOP(1) DATEPART(month,occurred_at) AS [Month]
	,SUM(total_amt_usd) AS [Total Revenue]
FROM 
	orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 
	DATEPART(month,occurred_at)
ORDER BY
	[Total Revenue] DESC
GO

/* Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly 
represented by the dataset?*/
-- Since the data contain only 1 month for each 2013 and 2017, I remove these years from the query for more accuracy
SELECT
	TOP(1) DATEPART(year,occurred_at) AS [YEAR]
	,COUNT(*) AS [Total Orders]
FROM 
	orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 
	DATEPART(year,occurred_at)
ORDER BY
	[Total Orders] DESC
GO

/*In which month of which year did Walmart spend the most on gloss paper in terms of dollars?*/ 
SELECT
	TOP(1)DATEPART(month, o.occurred_at) AS [Month]
	,DATEPART(year, o.occurred_at) AS [Year]
	,SUM(o.gloss_amt_usd) AS [Gloss Type Reevnue]
FROM
	orders AS o
 INNER JOIN
	accounts AS a
  ON a.id = o.account_id
WHERE
	a.name = 'Walmart'
GROUP BY DATEPART(month, o.occurred_at), DATEPART(year, o.occurred_at)
ORDER BY  [Gloss Type Reevnue] DESC
GO

/*What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total 
spending accounts?*/
SELECT FORMAT(AVG([Total Spent]),'C','en-us') AS [Average Amount Spent]
FROM (
		SELECT 
			TOP(10)
			a.id AS [Account ID]
			,a.name AS Account
			,SUM(o.total_amt_usd) AS [Total Spent]
		FROM
			orders AS o
		 INNER JOIN
			accounts AS a
		  ON a.id = o.account_id
		GROUP BY
			a.id, a.name
		ORDER BY [Total Spent] DESC
		) AS T1
GO

/* What is the lifetime average amount spent in terms of total_amt_usd, including only the 
companies that spent more per order, on average, than the average of all orders.*/
SELECT FORMAT(AVG([Average Spent]),'C','en-us') AS [Average Amount Spent]
FROM	(
		SELECT 
			o.account_id AS [Account ID]
			,AVG(o.total_amt_usd) AS [Average Spent]
		FROM
			orders AS o
		GROUP BY
			o.account_id
		HAVING AVG(o.total_amt_usd) >(
										SELECT 
											AVG(o.total_amt_usd) AS [Average Spent]
										FROM orders AS o
										)
			) AS T1
GO

/*Provide the revenue and the running totals for the revenues of the three paper types 
partitioned by account number and  ordered by time, month and year of occurance*/
SELECT	
	account_id AS [Account ID]
	,occurred_at
	,DATENAME(month, occurred_at) + '-' +  CAST(YEAR(occurred_at) AS VARCHAR) AS [DATE]
	,standard_amt_usd AS [Standard Revenue]
	,SUM(standard_amt_usd) OVER(PARTITION BY account_id ORDER BY occurred_at) AS [Running Standard Revenue]
	,poster_amt_usd AS [Poster Revenue]
	,SUM(poster_qty) OVER(PARTITION BY account_id ORDER BY occurred_at) AS [Running Poster Revenue]
	,gloss_amt_usd AS [Gloss Revenue]
	,SUM(gloss_qty) OVER(PARTITION BY account_id ORDER BY occurred_at) AS [Running Gloss Revenue]
FROM orders
WHERE account_id IN (
					SELECT account_id
					FROM (SELECT
								TOP(10)
								account_id
								, SUM(total_amt_usd) AS [Total Spent]
							FROM
								orders
							GROUP BY
								account_id
							ORDER BY
								[Total Spent] DESC
						  ) AS T1

					)
ORDER BY YEAR(occurred_at), MONTH(occurred_at)
GO

