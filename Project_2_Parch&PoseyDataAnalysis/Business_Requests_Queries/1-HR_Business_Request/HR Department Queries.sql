USE [Parch_&_Posey]
GO

/*
Provide a table with the region for each sales representative along with their associated 
accounts. Your final table should include three columns: the region name, the sales rep name, 
and the account name. Sort the accounts alphabetically (A-Z) according to account name.*/
SELECT 
	r.name AS Region
	,sr.name AS [Sales Representative]
	,a.name AS Account
FROM 
	region AS r
 INNER JOIN 
	sales_reprensntatives AS sr
  ON 
	r.id = sr.region_id
 INNER JOIN 
	accounts AS a
  ON 
	a.sales_person_id = sr.id
GO

/*Provide a table that provides the region for each sales representative along with their associated 
accounts. This time only for the Midwest region. Your final table should include three columns: 
the region name, the sales rep name, and the account name. Sort the accounts alphabetically 
(A-Z) according to account name.*/
SELECT 
	r.name AS Region
	,sr.name AS [Sales Representative]
	,a.name AS Account
FROM 
	region AS r
 INNER JOIN 
	sales_reprensntatives AS sr
  ON 
	r.id = sr.region_id
 INNER JOIN 
	accounts AS a
  ON 
	sr.id = a.sales_person_id
WHERE 
	r.name = 'Midwest'
ORDER BY 
	Account, [Sales Representative]
GO

/*Provide a table with the region for each sales representative  along with their associated 
accounts. This time only for accounts where the sales rep has a first name starting with S and 
in the Midwest region. Your final table should include three columns: the region name, the sales 
representative name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
*/
SELECT 
	r.name AS Region
	,sr.name AS [Sales Representative]
	,a.name AS Account
FROM 
	region AS r
 INNER JOIN 
	sales_reprensntatives AS sr
  ON 
	r.id = sr.region_id
 INNER JOIN 
	accounts AS a
  ON 
	sr.id = a.sales_person_id
WHERE 
	r.name = 'Midwest' AND sr.name LIKE 'S%'
ORDER BY 
	Account, [Sales Representative]
GO

/*
Provide a table that provides the region for each sales representative along with their associated 
accounts. This time only for accounts where the sales rep has a last name starting with K and in 
the Midwest region. Your final table should include three columns: the region name, the sales 
rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
*/
SELECT 
	r.name AS Region
	,sr.name AS [Sales Representative]
	,a.name AS Account
FROM 
	region AS r
 INNER JOIN 
	sales_reprensntatives AS sr
  ON 
	r.id = sr.region_id
 INNER JOIN 
	accounts AS a
  ON 
	sr.id = a.sales_person_id
WHERE 
	r.name = 'Midwest' AND sr.name LIKE '% K%'
ORDER BY 
	Account, [Sales Representative]
GO

/*
Find the number of sales reps in each region. Your final table should have two columns - the 
region and the number of sales representative. Order from fewest reps to most reps.*/
SELECT 
	r.name AS Region
	,COUNT(*) AS [Number of Sales Representatives]
FROM 
	region AS r
 INNER JOIN 
	sales_reprensntatives AS sr
  ON 
	r.id = sr.region_id
GROUP BY 
	r.name
ORDER BY 
	[Number of Sales Representatives] 
GO

/*Determine the number of times a particular channel was used in the web_events table for each 
sales rep. Your final table should have three columns - the name of the sales rep, the channel, 
and the number of occurrences. Order your table with the highest number of occurrences first.*/
SELECT 
	sr.name AS [Sales Representative]
	,we.channel AS Channel
	,COUNT(*) AS [Number of Events]
FROM 
	sales_reprensntatives AS sr
 INNER JOIN  
	accounts AS a
  ON 
	sr.id = a.sales_person_id
 INNER JOIN 
	web_events AS we
  ON 
	we.account_id = a.id
GROUP BY 
	sr.name, we.channel
ORDER BY 
	[Sales Representative]
GO

/*
Have any sales reps worked on more than one account?*/
SELECT 
	sr.id AS [Sales Representative ID]
	,sr.name AS [Sales Representative]
	,COUNT(*) AS [Number of Accounts]
FROM 
	sales_reprensntatives AS sr
 INNER JOIN 
	accounts AS a
  ON 
	sr.id = a.sales_person_id
GROUP BY 
	sr.id, sr.name
ORDER BY 
	[Number of Accounts] DESC
GO

/*
How many of the sales reps have more than 5 accounts that they manage?*/
WITH T1 AS 
(
		SELECT 
			sr.id AS [Sales Representative ID]
			,sr.name AS [Sales Representative]
			,COUNT(*) AS [Number of Accounts]
		FROM 
			sales_reprensntatives AS sr
		 INNER JOIN 
			accounts AS a
		  ON 
			sr.id = a.sales_person_id
        GROUP BY 
			sr.id, sr.name
		HAVING 
			COUNT(*) > 5
)

SELECT 
	COUNT(*) 
FROM 
	T1
GO

/*We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. 
The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the 
total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria.
Place the top sales people based on dollar amount of sales first in your final table.*/
SELECT 
	sr.name AS [Sales Representative]
	,COUNT(*) AS [Total Order]
	,FORMAT(ROUND(SUM(O.total_amt_usd),0),'C','en-us') AS [Total Revenue]
	,CASE
		WHEN COUNT(*) > 200 OR SUM(O.total_amt_usd) > 750000
			THEN 'Top'
		WHEN COUNT(*) > 150 OR SUM(O.total_amt_usd) > 500000
			THEN 'middle'
		ELSE
			'Not'
	END AS [Sales Rperesentative Level]			
FROM 
	
	orders AS o
 INNER JOIN 
	accounts a
  ON
	o.account_id = a.id
 INNER JOIN 
	sales_reprensntatives AS sr
  ON
	sr.id = a.sales_person_id
GROUP BY sr.name
ORDER BY [Total Revenue] DESC
GO


/*Provide the name of the sales represntative in each region with the largest amount of total_amt_usd sales.*/

SELECT
	T3.[Sales Representative]
	,T3.Region
	,T3.[Total Revenue]
FROM
	(SELECT 
		Region
		,MAX([Total Revenue]) AS [Maximum Total Revenue]
	 FROM	
		(SELECT  
			sr.name AS [Sales Representative]
			,r.name Region
			,SUM(o.total_amt_usd) AS [Total Revenue]
		 FROM
			sales_reprensntatives AS sr
		  INNER JOIN
			accounts AS a
		    ON sr.id = a.sales_person_id
		  INNER JOIN
			orders AS o
		    ON
				a.id = o.account_id
		  INNER JOIN
			region AS r
			ON r.id = sr.region_id
		 GROUP BY 
			sr.name
			,r.name) AS T1
	 GROUP BY 
		Region) AS T2

 INNER JOIN
	(SELECT
		sr.name AS [Sales Representative]
		,r.name Region
		,SUM(o.total_amt_usd) AS [Total Revenue]
	 FROM
		sales_reprensntatives AS sr
	  INNER JOIN
		accounts AS a
	   ON
		sr.id = a.sales_person_id
	  INNER JOIN
		orders AS o
	   ON o.account_id = a.id
	  INNER JOIN
	    region AS r
	   ON r.id = sr.region_id
	 GROUP BY
		sr.name
		,r.name) AS T3
 ON
	T3.Region = T2.Region AND T3.[Total Revenue] = T2.[Maximum Total Revenue]
GO