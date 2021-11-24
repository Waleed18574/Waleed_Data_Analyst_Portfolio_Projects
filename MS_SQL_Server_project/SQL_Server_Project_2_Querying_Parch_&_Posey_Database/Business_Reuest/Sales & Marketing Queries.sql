USE [Parch_&_Posey]
GO


/*
What are ALL the accounts associated with ALL orders*/
SELECT 
	o.*
	,a.*
FROM 
	orders AS o
 INNER JOIN 
	accounts AS a
  ON 
	a.id = o.account_id
GO



/*
Provide a table for all web_events associated with account name of Walmart. There should be 
three columns. Be sure to include the primary_poc, time of the event, and the channel for each 
event. Additionally, you might choose to add a fourth column to assure only Walmart events were 
chosen.*/
SELECT 
	a.primary_poc
	,we.occurred_at
	,we.channel
	,a.name
FROM 
	accounts AS a
 INNER JOIN 
	web_events AS we
  ON 
	a.id = we.account_id
WHERE 
	a.name = 'Walmart'
GO


/*
 Provide the name for each region for every order, as well as the account name and the average
 order unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 
 columns: region name, account name, and order average unit price. */
 SELECT
	r.name AS Region
	, a.name AS Account
	, FORMAT(ROUND(o.total_amt_usd/o.total,2),'C','en-us') AS [Order AVG Unit Price]
 FROM 
	orders AS o
  INNER JOIN 
	accounts AS a
   ON o.account_id = a.id
  INNER JOIN 
	sales_reprensntatives AS sr
   ON 
	sr.id = a.sales_person_id
  INNER JOIN region AS r
   ON r.id = sr.region_id
WHERE 
	o.total != 0
GO



/*
Provide the name for each region for every order, as well as the account name and the order average
unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if 
the standard order quantity exceeds 100. Your final table should have 3 columns: region name, 
account name, and order average unit price.*/
SELECT 
	r.name AS Region
	, a.name AS Account
	, FORMAT(ROUND(o.total_amt_usd/o.total,2),'C','en-us') AS [Order AVG Unit Price]
FROM 
	orders AS o
 INNER JOIN 
	accounts AS a
  ON 
	o.account_id = a.id
 INNER JOIN 
	sales_reprensntatives AS sr
  ON 
	a.sales_person_id = sr.id
 INNER JOIN 
	region AS r
  ON 
	sr.region_id = r.id
WHERE 
	o.total > 100
GO



/*
Provide the name for each region for every order, as well as the account name and the order 
average unit price they paid (total_amt_usd/total) for the order. However, you should only 
provide the results if the standard order quantity exceeds 100 and the poster order quantity 
exceeds 50. Your final table should have 3 columns: region name, account name, and order aevrage
unit price. Sort for the smallest unit price first.
*/
SELECT 
	r.name AS Region
	, a.name AS Account
	, FORMAT(ROUND(o.total_amt_usd/o.total,2),'C','en-us') AS [Order AVG Unit Price]
FROM 
	orders AS o
 INNER JOIN 
	accounts AS a
  ON 
	o.account_id = a.id
 INNER JOIN 
	sales_reprensntatives AS sr
  ON 
	a.sales_person_id = sr.id
 INNER JOIN 
	region AS r
  ON 
	sr.region_id = r.id
WHERE 
	o.standard_qty > 100 AND o.poster_amt_usd > 50
GO


/*
What are the different channels used by account id 1001? Your final table should have only 2 
columns: account name and the different channels.*/
SELECT 
	DISTINCT a.name AS Account
	,we.channel AS Channel
FROM 
	accounts AS a
 INNER JOIN 
	web_events AS we
  ON 
	a.id = we.account_id
WHERE 
	a.id = 1001
GO



/*
When was the earliest order ever placed?*/
SELECT 
	*  
FROM 
	orders
WHERE 
	occurred_at = (SELECT 
						MIN(occurred_at) 
				   FROM 
						orders)
GO



/*
Find the total number of times each type of channel from the web_events was used. Your final 
table should have two columns - the channel and the number of times the channel was used.
*/
SELECT 
	channel AS Channel, 
	COUNT(*)
FROM 
	web_events
GROUP BY 
	channel
GO



/*
What was the primary contact associated with the earliest web_event?*/
SELECT 
	TOP(1)a.primary_poc
FROM 
	accounts a
 INNER JOIN 
	web_events we
  ON 
	we.account_id = a.id
ORDER BY 
	we.occurred_at ASC
GO
 --OR
SELECT TOP(1)a.primary_poc
FROM 
	web_events we
 INNER JOIN  
	accounts a
  ON 
	we.account_id = a.id
WHERE 
	we.occurred_at = (SELECT 
						MIN(occurred_at) 
					  FROM 
						web_events)
GO



/*
What was the smallest order placed by each account in terms of total usd. Provide only two 
columns - the account name and the total usd. Order from smallest dollar amounts to largest.*/
SELECT 
	a.name AS Account
		,MIN(o.total_amt_usd) AS [Smallest Revenue]
FROM 
	accounts AS a
 INNER JOIN 
	orders AS o
  ON 
	o.account_id = a.id
GROUP BY 
	a.name
ORDER BY 
	[Smallest Revenue] ASC
GO



/*
For each account, determine the average quantity of each type of paper they purchased across 
their orders . Your result should have four columns - one for the account name and one for the 
average spent on each of the paper types.*/
SELECT 
	a.name AS Account

	,ROUND(AVG(o.standard_qty*1.0),0) AS [AVG Standard Quantity]
	,ROUND(AVG(o.gloss_qty*1.0),0) AS [Average Gloss Quantity]
	,ROUND(AVG(o.poster_qty*1.0),0) AS [Average Poster Quantity]
FROM 
	accounts AS a
 INNER JOIN 
	orders AS o
  ON 
	a.id = o.account_id
GROUP BY 
	a.name
GO



/*
Determine the number of times a particular channel was used in the web_events table for each 
region. Your final table should have three columns - the region name, the channel, and the number
of occurrences. Order your table with the highest number of occurrences first.*/
SELECT 
	r.name
	,we.channel
	,COUNT(*) AS [Number of Events]
FROM 
	region AS r
 INNER JOIN 
	sales_reprensntatives AS sr
  ON 
	sr.region_id = r.id
 INNER JOIN 
	accounts AS a
  ON 
	a.sales_person_id = sr.id
 INNER JOIN 
	web_events AS we
  ON 
	we.account_id = a.id
GROUP BY 
	r.name, we.channel
ORDER BY 
	[Number of Events] DESC
GO



/*
How many accounts have more than 20 orders?*/
WITH T1 AS 
(
		SELECT 
			a.id AS [Account ID]
			,a.name AS [Account Name]
			,COUNT(*) AS [Number of Accounts]
		FROM 
			accounts AS a
		 INNER JOIN 
			orders AS o
		  ON 
			a.id = o.account_id
		GROUP BY 
			a.id, a.name
		HAVING 
			COUNT(*) > 20
)

SELECT 
	COUNT(*) 
FROM 
	T1
GO



/*
Which account has the most orders?*/
SELECT 
	TOP(1)a.id AS [Account ID]
	,a.name AS [Account Name]
	,COUNT(*) AS [Number of Orders]
FROM 
	accounts AS a
 INNER JOIN 
	orders AS o
  ON 
	o.account_id = a.id
GROUP BY 
	a.id, a.name
ORDER BY
	[Number of Orders] DESC
GO


/*
How many accounts spent more than 30,000 usd total across all orders?*/
WITH T1 AS
(
		SELECT 
			a.id AS [Account ID]
			,a.name AS [Account Name]
			,SUM(o.total_amt_usd) AS [Total Revenue]
		FROM 
			accounts AS a
		 INNER JOIN 
			orders AS o
		  ON 
			a.id = o.account_id
		GROUP BY 
			a.id, 
			a.name
		HAVING 
			SUM(o.total_amt_usd) > 30000
 )
 SELECT 
	COUNT(*)
 FROM 
	T1
 GO



/*How many accounts spent less than 1,000 usd total across all orders?*/
WITH T1 AS
(
		SELECT 
			a.id AS [Account ID]
			,a.name AS [Account Name]
			,SUM(o.total_amt_usd) AS [Total Revenue]
		FROM 
			accounts AS a
		 INNER JOIN 
			orders AS o
		  ON 
			a.id = o.account_id
		GROUP BY 
			a.id, a.name
		HAVING 
			SUM(o.total_amt_usd) < 1000
 )
 SELECT 
	COUNT(*)
 FROM 
	T1
 GO




/* Which account has spent the most?*/
SELECT 
	TOP(1) a.name AS [Account Name]
	,SUM(o.total_amt_usd) AS [Total Revenue]
FROM 
	accounts AS a
 INNER JOIN 
	orders AS o
  ON 
	o.account_id = a.id
GROUP BY 
	a.name
ORDER BY 
	[Total Revenue] DESC
GO



/* Which accounts used facebook as a channel to contact customers more than 6 times?*/
SELECT 
	a.id AS [Account ID]
	,a.name AS [Account Name]
	,we.channel AS Channel
	,COUNT(*) AS [Number of Events]
FROM 
	accounts as A
 INNER JOIN 
	web_events AS we
  ON 
	a.id = we.account_id
WHERE 
	we.channel = N'facebook'
GROUP BY 
	a.id, a.name, we.channel
HAVING 
	COUNT(*) > 6
ORDER BY 
	[Number of Events] DESC
GO



/*Which account used facebook most as a channel?*/
SELECT 
	TOP(1) a.id AS [Account ID]
	,a.name AS [Account Name]
	,we.channel AS Channel
	,COUNT(*) AS [Number of Events]
FROM 
	accounts as A
 INNER JOIN 
	web_events AS we
  ON 
	a.id = we.account_id
WHERE 
	we.channel = N'facebook'
GROUP BY
	a.id, a.name, we.channel
HAVING 
	COUNT(*) > 6
ORDER BY 
	[Number of Events] DESC
GO



/*Which channel was most frequently used by most accounts?*/
SELECT 
	TOP(18) a.id AS [Account ID]
	,a.name AS [Account Name]
	,we.channel AS Chanel
	,COUNT(*) AS [Number of Use]
FROM 
	accounts AS a
 INNER JOIN 
	web_events AS we
  ON 
	a.id =we.account_id
GROUP BY 
	a.id, a.name, we.channel
ORDER BY 
	[Number of Use] DESC
-- 'direct' is the most used Channl

-- Alternatively

SELECT 
	TOP(1) channel AS Channel
	,COUNT(*) AS [Number of Use]
FROM 
	web_events
GROUP BY 
	channel
ORDER BY 
	[Number of USe] DESC
GO




/*Provide a table to show for each order, the account ID, total amount of the order, and the level of the order - 
 ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or less than $3000.*/
 SELECT 
	account_id AS [Account ID]	
	,total_amt_usd AS [Revenue]
	,CASE
		WHEN total_amt_usd > 3000
			THEN 'Large'
		ELSE 
			'Small'
	END AS [Order Level]
FROM 
	orders
GO



/*Provide a table to show the number of orders in each of three categories, based on the total number of items in each 
order. The three categories are: 'At Least 2000', 'Between 1500 and 2000' and 'Less than 1500'.*/
with T1 AS
(
SELECT
	id,
	CASE
		WHEN total >= 2000
			THEN 'At Least 2000'
		WHEN total >= 1500
			THEN 'Between 1500 and 2000'
	ELSE
		'Less than 1500'
	END AS [Order Category]
FROM 
	orders
)

SELECT [Order Category], COUNT(*) AS [Order Count]
FROM T1
 INNER JOIN orders o
  ON T1.ID = O.id
GROUP BY [Order Category]
GO



/*We would like to understand 3 different branches of customers based on the amount associated with their purchases. 
The top branch includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second 
branch is between 200,000 and 100,000 usd. The lowest branch is anyone under 100,000 usd. Provide a table that includes 
the level associated with each account. You should provide the account name, the total sales of all orders for the 
customer, and the level. Order with the top spending customers listed first.*/
SELECT 
	a.name AS [Account]
	,SUM(total_amt_usd) AS [Total Revenue]
	,CASE
		WHEN SUM(total_amt_usd) > 200000
			THEN 'Top'
		WHEN SUM(total_amt_usd) > 100000
			THEN 'Middle'
		ELSE
			'Low'
	 END AS [Customer Level]
FROM
	orders AS o
 INNER JOIN
	accounts AS a
  ON 
	o.account_id = a.id
GROUP BY 
	a.name
ORDER BY 
	[Total Revenue] DESC
GO



/*We would now like to perform a similar calculation to the previous, but we want to obtain the total amount spent by 
customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers
listed first.*/
SELECT 
	a.name AS [Account]
	,SUM(total_amt_usd) AS [Total Revenue]
	,CASE
		WHEN SUM(total_amt_usd) > 200000
			THEN 'Top'
		WHEN SUM(total_amt_usd) > 100000
			THEN 'Middle'
		ELSE
			'Low'
	 END AS [Customer Level]
FROM
	orders AS o
 INNER JOIN
	accounts AS a
  ON 
	o.account_id = a.id
WHERE
	occurred_at > '2015-12-31' 
GROUP BY 
	a.name
ORDER BY 
	[Total Revenue] DESC
GO

/*Provide the average number of events for each day for each channel. */
WITH T1 AS
(
		SELECT 
			CAST(occurred_at As DATE) AS [day]
			,channel AS Channel
			,COUNT(*) AS Events
		FROM 
			web_events
		GROUP BY 
			CAST(occurred_at As DATE), channel
)
SELECT 
	channel AS Channel
	,AVG(Events) AS [Average Daily Events]
FROM 
	T1
GROUP BY
	channel
ORDER BY [Average Daily Events] DESC
GO

/*For the region with the largest sales total_amt_usd, how many total orders were placed?*/
SELECT 
	r.name AS Region
	,COUNT(o.total) AS [Total Orders]
FROM
	orders AS o
 INNER JOIN
	accounts AS a
  ON 
	o.account_id = a.id
 INNER JOIN
	sales_reprensntatives AS sr
  ON
	a.sales_person_id = sr.id
 INNER JOIN
	region AS r
  ON r.id = sr.region_id
GROUP BY 
	r.name
HAVING 
	SUM(o.total_amt_usd) = (
							SELECT 
								MAX([Total Revenue])
							FROM
									(SELECT 
										r.name AS Region
										,SUM(o.total_amt_usd) AS [Total Revenue]
									 FROM 
										orders AS O
									  INNER JOIN
										accounts AS a
									   ON o.account_id = a.id
									  INNER JOIN
										sales_reprensntatives AS sr
									   ON sr.id = a.sales_person_id
									  INNER JOIN
										region AS r
									   ON r.id = sr.region_id
									 GROUP BY r.name) AS T1
									 )
GO


/*How many accounts had more total purchases than the account name which has bought the most standard_qty paper 
throughout their lifetime as a customer?*/
SELECT 
	COUNT(*) AS [Number of Account]
FROM
	(
	SELECT 
		a.name AS Account
	FROM
		orders AS o
		INNER JOIN 
		accounts AS a
		ON a.id = o.account_id
	GROUP BY
		a.name
	HAVING SUM(o.total) > (
							SELECT 
								Total
							FROM 
								(	SELECT 
										TOP(1)
										a.name AS Account
										,SUM(o.standard_qty) AS [Total Standard Quantity]
										,SUM(o.total) AS Total
									FROM
										accounts AS a
										INNER JOIN
										orders AS o
										ON
										a.id = o.account_id
									GROUP BY
										a.name ) AS T1
							)
		) T2
GO


/*For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many 
web_events did they have for each channel?*/
SELECT
	a.name AS Account
	,we.channel AS Channel
	,COUNT(*) AS [Number of Web-Events]
FROM
	accounts AS a
 INNER JOIN
	web_events AS we
  ON
	a.id = we.account_id
	AND
	a.id = (
			SELECT
				[Account ID]
			FROM (
					SELECT 
						TOP(1)
						a.id AS [Account ID]
						,a.name AS Account
						,SUM(o.total_amt_usd) AS [Total Spent]
					FROM
						orders AS o
					 INNER JOIN
						accounts AS a
					  ON a.id = o.account_id
					GROUP BY
						a.id,a.name
					ORDER BY [Total Spent] DESC
					) T1
			)
GROUP BY
	a.name, we.channel
ORDER BY 
	[Number of Web-Events] DESC
GO


/*Provide a record for the  revenue, previous date revenue, difference from the previous date revenue for
the top 10 most spending accounts*/
SELECT
	account_id
	,occurred_at
	,total_amt_usd AS [Revenue]
	,LAG(total_amt_usd) OVER (ORDER BY occurred_at)  AS [Previous Revenue]
	,ROUND(total_amt_usd-LAG(total_amt_usd) OVER (ORDER BY occurred_at),2) AS  [Difference from Previous Revenue]
FROM	
	orders
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
GO