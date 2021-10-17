USE master
GO

DROP DATABASE IF EXISTS [Business_Requests]
GO

CREATE DATABASE [Business_Requests]
GO

USE [Business_Requests]
GO



CREATE TABLE tbl_business_requests(
							   id SMALLINT
							   ,date DATE
							   ,department VARCHAR(30)
							   ,question_id TINYINT
							   ,question VARCHAR(1000)
							   ,answer VARCHAR(2000) null
							   )


BULK INSERT TBL_BUSINESS_REQUESTS
 FROM 'C:\Users\ADMIN\Desktop\CSV Files\Documentation Files\01- Business Request Database-HR_Business_Requests.csv'
 WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
	 )
 GO

 BULK INSERT TBL_BUSINESS_REQUESTS
 FROM 'C:\Users\ADMIN\Desktop\CSV Files\Documentation Files\02- Business Requests Database-Finance_Business_Requests.csv'
 WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
	 )
 GO


  BULK INSERT TBL_BUSINESS_REQUESTS
 FROM 'C:\Users\ADMIN\Desktop\CSV Files\Documentation Files\03- Business Requests Database-Sales_&_Marketing_Business_Requests.csv'
 WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
	 )
 GO



 SELECT * FROM TBL_BUSINESS_REQUESTS
 GO


