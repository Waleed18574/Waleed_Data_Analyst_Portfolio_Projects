
/* Provide the names, job titles, minimum and maximum salaries for each employee*/
SELECT 
	e.F_NAME + ' ' + e.L_NAME AS [Employee Name]
	,j.JOB_TITLE AS [Job Title]
	,j.MIN_SALARY
	,j.MAX_SALARY
FROM
	EMPLOYEES AS e
 INNER JOIN
	JOB_HISTORY AS jh
  ON
	e.EMP_ID = jh.EMP_ID
 INNER JOIN
	JOBS AS j
  ON jh.JOB_ID = j.JOB_ID
GO


/*Provide the Hierarchical structure of the organization*/
SELECT 
	m.F_NAME + ' ' + m.L_NAME AS [Managed By]
	,e.F_NAME + ' ' + e.L_NAME AS [Employee]
FROM 
	EMPLOYEES AS m
 LEFT JOIN 
	EMPLOYEES AS e
  ON 
	m.MANAGER_ID = E.EMP_ID
GO


/* Provide the average of minimum and maximum salary by department*/
SELECT 
	d.DEP_NAME AS Department
	,FORMAT(AVG(j.MIN_SALARY),'C','en-us') AS [Average of Minimum Salary]
	,FORMAT(AVG(j.MAX_SALARY),'C','en-us') AS [Average of Maximum Salary]
FROM
	DEPARTMENTS AS d
 INNER JOIN
	EMPLOYEES AS e
  ON 
	d.DEP_ID = e.DEP_ID
 INNER JOIN
	JOB_HISTORY as jh
  ON
	e.EMP_ID = jh.EMP_ID
 INNER JOIN
	JOBS as j
  ON jh.JOB_ID = j.JOB_ID
GROUP BY 
	d.DEP_NAME
 GO
 
/*Provide the names of the employees with the largest minimum salary or smallest maximum salary
*/
SELECT
	e.F_NAME +' ' + e.L_NAME AS [Employee Name]
	,MAX(j.MIN_SALARY) AS [Largest Minimum Salary]
	,MIN(j.MAX_SALARY) AS [Smallest Maximum Salary]

FROM
	EMPLOYEES AS e
 INNER JOIN
	JOB_HISTORY AS jh
  ON 
	e.EMP_ID = jh.EMP_ID
 INNER JOIN
	JOBS AS j
  ON
	jh.JOB_ID = J.JOB_ID
WHERE
	j.MIN_SALARY = (SELECT MAX([MIN_SALARY]) FROM JOBS)
	OR
	j.MAX_SALARY = (SELECT MIN([MAX_SALARY]) FROM JOBS)
GROUP BY
	e.F_NAME +' ' + e.L_NAME
GO

