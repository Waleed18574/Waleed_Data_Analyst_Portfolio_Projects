-- Specifying HR Dtabase to be used
/*
USE master
GO
DROP DATABASE IF EXISTS [HR DB]
GO
CREATE DATABASE [HR DB]
GO
*/

-- Specifying the database to be used
USE [HR DB]
GO

-- Droping the tables if they exist
DROP TABLE IF EXISTS dbo.JOB_HISTORY
DROP TABLE IF EXISTS dbo.EMPLOYEES
DROP TABLE IF EXISTS dbo.DEPARTMENTS
DROP TABLE IF EXISTS dbo.JOBS
DROP TABLE IF EXISTS dbo.LOCATIONS
GO


 CREATE TABLE JOBS (
                    JOB_ID                  CHAR(5) NOT NULL
                    ,JOB_TITLE                   VARCHAR(30)
                    ,MIN_SALARY                DECIMAL(10,2)
                    ,MAX_SALARY                DECIMAL(10,2)
                    ,CONSTRAINT  J_PK    PRIMARY KEY(JOB_ID)
					)
GO

 CREATE TABLE LOCATIONS (
						LOC_ID                  CHAR(5) NOT NULL
						,LOC_DESC                    VARCHAR(30)
						,CONSTRAINT LOC_PK   PRIMARY KEY(LOC_ID)
					    )
GO


CREATE TABLE DEPARTMENTS (
						DEP_ID                 CHAR(3) NOT NULL 
						,DEP_NAME                   VARCHAR(30)
						,MANAGER_ID                     CHAR(5)
						,LOC_ID                         CHAR(5)
						,CONSTRAINT DEP_PK  PRIMARY KEY(DEP_ID)
						,CONSTRAINT DEP_FK  FOREIGN KEY(LOC_ID) 
							REFERENCES        LOCATIONS(LOC_ID)
							ON DELETE CASCADE
							ON UPDATE CASCADE
						 )
GO

CREATE TABLE EMPLOYEES (
                        EMP_ID                 CHAR(5) NOT NULL
                        ,F_NAME            VARCHAR(15) NOT NULL
                        ,L_NAME            VARCHAR(15) NOT NULL
                        ,SSN                            CHAR(9)
                        ,B_DATE                            DATE
                        ,GENDER                            CHAR
                        ,ADDRESS                     VARCHAR(30)
                        ,SALARY                    DECIMAL(10,2)
                        ,MANAGER_ID                      CHAR(5)
                        ,DEP_ID                 CHAR(3) NOT NULL
                        ,CONSTRAINT EMP_PK  PRIMARY KEY (EMP_ID)
						,CONSTRAINT EMP_FK1  FOREIGN KEY(DEP_ID)
							REFERENCES      DEPARTMENTS (DEP_ID)
							ON DELETE CASCADE
							ON UPDATE CASCADE
						)
GO

  CREATE TABLE JOB_HISTORY (
                            EMP_ID                      CHAR(5) NOT NULL 
                            ,START_DATE                             DATE
                            ,JOB_ID                     CHAR(5) NOT NULL
							,CONSTRAINT JH_FK1       FOREIGN KEY(EMP_ID)
								REFERENCES             EMPLOYEES(EMP_ID)
								ON DELETE CASCADE
								ON UPDATE CASCADE 
							,CONSTRAINT JH_FK2       FOREIGN KEY(JOB_ID)
								REFERENCES                  JOBS(JOB_ID)
								ON DELETE CASCADE
								ON UPDATE CASCADE
							,CONSTRAINT JH_PK PRIMARY KEY(EMP_ID,JOB_ID)
							)
GO
----------------------------------------------------------------------------------------
------------------------------------Populating Tables-----------------------------------
----------------------------------------------------------------------------------------


 BULK INSERT JOBS
 FROM 'C:\Users\ADMIN\Desktop\CSV Files\Jobs.csv'
 WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
	 )
 GO

   BULK INSERT LOCATIONS
 FROM 'C:\Users\ADMIN\Desktop\CSV Files\Locations.csv'
 WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
	 )
GO

  BULK INSERT DEPARTMENTS
 FROM 'C:\Users\ADMIN\Desktop\CSV Files\Departments.csv'
 WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
	 )
GO

 BULK INSERT EMPLOYEES
 FROM 'C:\Users\ADMIN\Desktop\CSV Files\Employees.csv'
 WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
	 )
GO

  BULK INSERT JOB_HISTORY
 FROM 'C:\Users\ADMIN\Desktop\CSV Files\JobHistory.csv'
 WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
	 )
GO