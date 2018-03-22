/* Complete query and save as stored procedure */ 
/* Probelm : #1  */ 
CREATE PROCEDURE Sp_01 
AS 
  BEGIN 
      SELECT a.emp_first_name, 
             a.emp_last_name, 
             a.emp_address1, 
             a.emp_address2, 
             b.country_name, 
             c.city_name, 
             a.emp_mobile, 
             d.desig_name 
      FROM   employee_details a 
             LEFT OUTER JOIN country b 
                          ON a.emp_country_id = b.country_id 
             LEFT OUTER JOIN city c 
                          ON a.emp_city_id = c.city_id 
             LEFT OUTER JOIN designation d 
                          ON a.desig_id = d.desig_id 
  END 

go 



/* Probelm : #2  */CREATE PROCEDURE Sp_02 
AS 
  BEGIN 
    SELECT   a.state_name, 
             b.country_name 
    FROM     state a 
    JOIN     country b 
    ON       a.country_id = b.country_id 
    ORDER BY a.state_name ASC 
  END 
GO

  /* Probelm : #3  */CREATE PROCEDURE Sp_03 
AS 
  BEGIN 
    SELECT TOP 3 
             * 
    FROM     country 
    ORDER BY country_name ASC; 
   
  END 
  /* Probelm : #4  */CREATE PROCEDURE Sp_4 
AS 
  BEGIN 
    SELECT * 
    FROM   employee_details 
    WHERE  LEFT(emp_first_name,1) = 'A' 
  ENDgo 
/* Probelm : #5  */CREATE PROCEDURE Sp_5 
AS 
  BEGIN 
    SELECT * 
    FROM   employee_details 
    WHERE  RIGHT(emp_first_name,1) = 'a' 
  ENDgo 
/* Probelm : #6  */CREATE PROCEDURE Sp_6 
AS 
  BEGIN 
    SELECT * 
    FROM   employee_details 
    WHERE  emp_active = 1 
  END 
  /* Probelm : #7  */CREATE PROCEDURE Sp_7 
AS 
  BEGIN 
    SELECT emp_first_name  AS 'First Name' , 
           emp_last_name   AS 'Last Name', 
           emp_middle_name AS 'Middle Name' 
    FROM   employee_details 
  END 
  /* Probelm : #8 
Use the print function  */CREATE PROCEDURE Sp_8 
AS 
  BEGIN 
    DECLARE @count1 INT; 
    SELECT @count1 = Count(*) 
    FROM   employee_details; 
     
    PRINT @count1 
  END 
  /* Probelm : #9  */CREATE PROCEDURE Sp_9 
AS 
  BEGIN 
    DECLARE @count2 INT; 
    SELECT @count2 = Count(emp_middle_name) 
    FROM   employee_details 
    WHERE  emp_middle_name != 'Null' 
    PRINT @count2 
  END 
  /* Probelm : #10  */CREATE PROCEDURE Sp_10 
AS 
  BEGIN 
    SELECT emp_first_name, 
           emp_last_name, 
           Emp_Middle_Name = 
           CASE emp_middle_name 
                  WHEN 'Null' THEN 'Not Applicable' 
                  ELSE emp_middle_name 
           END 
    FROM   employee_details; 
   
  END 
  /* Probelm : #11  */CREATE PROCEDURE Sp_11 
AS 
  BEGIN 
    SELECT emp_id, 
           emp_address1, 
           emp_address2, 
           emp_country_id, 
           emp_state_id, 
           emp_city_id, 
           emp_zip, 
           emp_mobile, 
           emp_gender, 
           desig_id, 
           emp_dob, 
           emp_joindate, 
           emp_active, 
           NAME = 
           CASE emp_middle_name 
                  WHEN 'Null' THEN emp_first_name + ' ' + emp_last_name 
                  ELSE emp_first_name             + ' ' + emp_middle_name + ' ' +emp_last_name 
           END 
    FROM   employee_details 
  END 
  /* Probelm : #12  */CREATE PROCEDURE Sp_12 
AS 
  BEGIN 
    SELECT   employee_details.* 
    FROM     employee_details 
    JOIN     country 
    ON       employee_details.emp_country_id = country.country_id 
    ORDER BY country.country_name 
  END 
  /* Probelm : #13  */CREATE PROCEDURE Sp_13 
AS 
  BEGIN 
    SELECT   * 
    FROM     employee_details 
    WHERE    emp_id IN 
             ( 
                    SELECT TOP 10 
                           emp_id 
                    FROM   employee_details ) 
    ORDER BY emp_first_name ASC 
  END 
  /* Probelm : #14  */CREATE PROCEDURE Sp_14 
AS 
  BEGIN 
    SELECT * 
    FROM   employee_details 
    JOIN   city 
    ON     employee_details.emp_city_id = city.city_id 
    WHERE  city.city_name IN ('Dallas', 
                              'Algiers') 
  END 
  /* Probelm : #15  */CREATE PROCEDURE Sp_15 
AS 
  BEGIN 
    SELECT * 
    FROM   employee_details 
    JOIN   city 
    ON     employee_details.emp_city_id = city.city_id 
    WHERE  LEFT(emp_first_name,1) > 'A' 
    AND    LEFT(emp_first_name,1) < 'D' 
  END 
  /* Probelm : #16  */CREATE PROCEDURE Sp_16 
AS 
  BEGIN 
    SELECT          a.emp_first_name, 
                    a.emp_last_name, 
                    a.emp_middle_name, 
                    b.country_name , 
                    c.desig_name, 
                    a.emp_dob 
    FROM            employee_details a 
    LEFT OUTER JOIN country b 
    ON              a.emp_country_id = b.country_id 
    LEFT OUTER JOIN designation c 
    ON              a.desig_id = c.desig_id 
    WHERE           Datepart(year,a.emp_dob) = 1984 
    AND             Datepart(dayofyear,a.emp_dob) >= 33 
    OR              Datepart(year,a.emp_dob) = 1985 
    OR              Datepart(year,a.emp_dob) = 1986 
    AND             Datepart(dayofyear,a.emp_dob) <= 34 
  END 
  /* Probelm : #17 */CREATE PROCEDURE Sp_17 
AS 
  BEGIN 
    SELECT          a.emp_first_name, 
                    a.emp_last_name, 
                    a.emp_middle_name, 
                    b.country_name, 
                    d.desig_name, 
                    tmp.emp_salary 
    FROM            employee_details a 
    LEFT OUTER JOIN country b 
    ON              a.emp_country_id = B.country_id 
    LEFT OUTER JOIN designation d 
    ON              a.desig_id = d.desig_id 
    INNER JOIN 
                    ( 
                               SELECT     c.emp_id, 
                                          emp_salary 
                               FROM       salary c 
                               INNER JOIN 
                                          ( 
                                                   SELECT   emp_id, 
                                                            Max(emp_salary) AS max_salary 
                                                   FROM     salary 
                                                   GROUP BY emp_id ) tmp2 
                               ON         c.emp_id = tmp2.emp_id 
                               AND        c.emp_salary = tmp2.max_salary ) tmp 
    ON              a.emp_id = tmp.emp_id 
  END 
  /* Probelm : #18  */
CREATE PROCEDURE Sp_18 
AS 
BEGIN 
SELECT	a.Emp_First_Name,
		a.Emp_Last_Name,
		a.Emp_Middle_Name,
		b.Country_Name,
		tmp.current_salary
FROM		    Employee_Details a
LEFT OUTER JOIN Country b
ON			    a.Emp_Country_Id = b.Country_Id
LEFT OUTER JOIN Designation c
ON				a.Desig_Id       = c.Desig_Id
INNER JOIN
	(
		SELECT d.Emp_Id,d.Emp_Salary AS current_salary
		FROM SALARY d
		INNER JOIN 
			(
				SELECT Emp_Id,MAX(Emp_Salary_Change_Year) AS recent_time 
				FROM Salary
				GROUP BY Emp_Id
			) tmp2
		ON d.Emp_Id = tmp2.Emp_Id AND d.Emp_Salary_Change_Year = tmp2.recent_time
	) tmp
ON a.Emp_Id = tmp.Emp_Id
END
G0


  /* Probelm : #19  */CREATE PROCEDURE Sp_19 
AS 
  BEGIN 
    SELECT     a.emp_first_name, 
               a.emp_middle_name, 
               a.emp_last_name, 
               b.country_name, 
               c.desig_name, 
               tmp2.emp_salary 
    FROM       employee_details a 
    INNER JOIN country b 
    ON         a.emp_country_id = b.country_id 
    INNER JOIN designation c 
    ON         a.desig_id = C.desig_id 
    INNER JOIN 
               ( 
                          SELECT     s.emp_id, 
                                     s.emp_salary 
                          FROM       salary s 
                          INNER JOIN 
                                     ( 
                                              SELECT   emp_id, 
                                                       Max(emp_salary) max_salary 
                                              FROM     salary 
                                              GROUP BY emp_id ) tmp1 
                          ON         s.emp_id = tmp1.emp_id 
                          AND        s.emp_salary = tmp1.max_salary 
                          WHERE      s.emp_salary > 50000 
                          AND        s.emp_salary < 100000 ) tmp2 
    ON         a.emp_id = tmp2.emp_id 
  ENDgoSp_19 
/* Probelm : #20  */CREATE PROCEDURE Sp_20 
AS 
  BEGIN 
    SELECT Substring(emp_first_name,1,3) AS FIRST 
    FROM   employee_details 
  ENDgoSp_20 
/* Probelm : #21  */CREATE PROCEDURE Sp_21 
AS 
  BEGIN 
    SELECT Replace(emp_first_name,'A','$') 
    FROM   employee_details 
  ENDgoSp_21 
/* Probelm : #22  */CREATE PROCEDURE Sp_22 
AS 
  BEGIN 
    SELECT emp_first_name, 
           Year(emp_joindate)  AS [Year], 
           Month(emp_joindate) AS [Month], 
           Day(emp_joindate)   AS [Day] 
    FROM   employee_details 
  ENDgoSp_22 
/* Probelm : #23  */CREATE PROCEDURE sp_23 
AS 
  BEGIN 
    SELECT * 
    FROM   employee_details 
    WHERE  Year(emp_joindate) = 2014goSp_23 
/* Probelm : #24 */CREATE PROCEDURE Sp_24 
AS 
  BEGIN 
    SELECT * 
    FROM   employee_details 
    WHERE  emp_joindate < '2014-01-01' 
  ENDgoSp_24 
/* Probelm : #25  */CREATE PROCEDURE Sp_25 
AS 
  BEGIN 
    SELECT          b.desig_name, 
                    Sum(c.emp_salary) AS Total_Salary 
    FROM            employee_details a 
    LEFT OUTER JOIN designation b 
    ON              a.desig_id = b.desig_id 
    LEFT OUTER JOIN salary c 
    ON              a.emp_id = c.emp_id 
    GROUP BY        b.desig_name 
  ENDgoSp_25 
/* Probelm : #26 */CREATE PROCEDURE Sp_26 
AS 
  BEGIN 
    SELECT          b.desig_name, 
                    Count(a.emp_id) 
    FROM            employee_details a 
    LEFT OUTER JOIN designation b 
    ON              a.desig_id = b.desig_id 
    GROUP BY        b.desig_name 
  ENDgoSp26 
/* Probelm : #27  */CREATE PROCEDURE Sp_27 
AS 
  BEGIN 
    SELECT          b.desig_name, 
                    Avg(c.emp_salary) AS avg_salary 
    FROM            employee_details a 
    LEFT OUTER JOIN designation b 
    ON              a.desig_id = b.desig_id 
    LEFT OUTER JOIN salary c 
    ON              a.emp_id = c.emp_id 
    GROUP BY        b.desig_name 
    ORDER BY        avg_salary ASC 
  ENDgoSp_27 
/* Probelm : #28  */CREATE PROCEDURE Sp_28 
AS 
  BEGIN 
    SELECT   Year(emp_joindate)  AS Joined_Year, 
             Month(emp_joindate) AS Joined_Month, 
             Count(emp_id)       AS Number_Emp 
    FROM     employee_details 
    GROUP BY Year(emp_joindate), 
             Month(emp_joindate) 
  ENDgoSp_28 
/* Probelm : #29  */CREATE PROCEDURE Sp_29 
AS 
  BEGIN 
    SELECT          a.* 
    FROM            employee_details a 
    LEFT OUTER JOIN salary b 
    ON              a.emp_id = b.emp_id 
    WHERE           a.emp_id NOT IN (b.emp_id ) 
  ENDgoSp_29 
/* Probelm : #30  */CREATE PROCEDURE Sp_30 
AS 
  BEGIN 
    SELECT          a.emp_first_name, ( 
                    CASE 
                                    WHEN ( 
                                                                    Sum(b.emp_salary) IS NULL) THEN 0
                                    ELSE Sum(b.emp_salary) 
                    END ) AS sum_salary 
    FROM            employee_details a 
    LEFT OUTER JOIN salary b 
    ON              a.emp_id = b.emp_id 
    GROUP BY        a.emp_first_name 
  ENDgoSp_30 
/* Probelm : #31 */CREATE PROCEDURE sp_31 
AS 
  BEGIN 
    SELECT          a.emp_id, ( 
                    CASE 
                                    WHEN ( 
                                                                    a.emp_id = 1) THEN (0.1 * b.emp_salary)
                                    WHEN ( 
                                                                    a.emp_id = 2) THEN (0.2 * b.emp_salary)
                                    WHEN ( 
                                                                    b.emp_salary IS NULL) THEN 0
                                    ELSE 0.3 * b.emp_salary 
                    END ) AS new_salary 
    FROM            employee_details a 
    LEFT OUTER JOIN salary b 
    ON              a.emp_id = b.emp_id emdgoSp_31 
/* Probelm : #32  */CREATE PROCEDURE Sp_32 
AS 
  BEGIN 
    SELECT emp_first_name, 
           emp_last_name, 
           Datediff(day,emp_joindate,Getdate()) AS Days_worked 
    FROM   employee_details 
  ENDgoSp_32 
/**/ 
/* Probelm : #33  */CREATE PROCEDURE Sp_33 
AS 
  BEGIN 
    SELECT     a.*, 
               tmp2.emp_salary 
    INTO       max_tbl 
    FROM       employee_details a 
    INNER JOIN 
               ( 
                          SELECT     b.emp_id, 
                                     b.emp_salary 
                          FROM       salary b 
                          INNER JOIN 
                                     ( 
                                              SELECT   emp_id, 
                                                       Max(emp_salary_change_year) Recent_ChangeYear
                                              FROM     salary 
                                              GROUP BY emp_id ) tmp3 
                          ON         b.emp_id = tmp3.emp_id 
                          AND        b.emp_salary_change_year = tmp3.recent_changeyear ) tmp2 
    ON         a.emp_id = tmp2.emp_id 
    SELECT     a.*, 
               tmp2.emp_salary 
    INTO       min_tbl 
    FROM       employee_details a 
    INNER JOIN 
               ( 
                          SELECT     b.emp_id, 
                                     b.emp_salary 
                          FROM       salary b 
                          INNER JOIN 
                                     ( 
                                              SELECT   emp_id, 
                                                       Min(emp_salary_change_year) Recent_ChangeYear
                                              FROM     salary 
                                              GROUP BY emp_id ) tmp3 
                          ON         b.emp_id = tmp3.emp_id 
                          AND        b.emp_salary_change_year = tmp3.recent_changeyear ) tmp2 
    ON         a.emp_id = tmp2.emp_id 
    SELECT TOP 1 
                                                     a.emp_first_name, 
                    (a.emp_salary - b.emp_salary) AS sala 
    FROM            max_tbl a 
    LEFT OUTER JOIN min_tbl b 
    ON              a.emp_id = b.emp_id 
    ORDER BY        sala DESC 
  ENDgoSp_33 
/* Probelm : #34  */CREATE PROCEDURE Sp_34 
AS 
  BEGIN 
    SELECT     a.emp_first_name, 
               a.emp_middle_name, 
               a.emp_last_name, 
               b.country_name, 
               c.desig_name, 
               tmp2.emp_salary 
    INTO       tmp_34 
    FROM       employee_details a 
    INNER JOIN country b 
    ON         a.emp_country_id = b.country_id 
    INNER JOIN designation c 
    ON         a.desig_id = C.desig_id 
    INNER JOIN 
               ( 
                          SELECT     s.emp_id, 
                                     s.emp_salary 
                          FROM       salary s 
                          INNER JOIN 
                                     ( 
                                              SELECT   emp_id, 
                                                       Max(emp_salary) max_salary 
                                              FROM     salary 
                                              GROUP BY emp_id ) tmp1 
                          ON         s.emp_id = tmp1.emp_id 
                          AND        s.emp_salary = tmp1.max_salary 
                          WHERE      s.emp_salary > 50000 
                          AND        s.emp_salary < 100000 ) tmp2 
    ON         a.emp_id = tmp2.emp_id 
    SELECT TOP 1 
             * 
    FROM     ( 
                      SELECT TOP 3 
                               * 
                      FROM     tmp_34 
                      ORDER BY emp_salary DESC ) a 
    ORDER BY a.emp_salary ASC 
    DROP TABLE tmp_34 
  ENDgoSp_34 
/* Probelm : #35  */CREATE FUNCTION dbo.Udf_getavgsalary ( @Emp_Id NUMERIC(10,0) ) 
returns @GETAVGSALARY TABLE 
                            ( 
                                                        emp_name  NVARCHAR(50), 
                                                        avgsalary INT 
                            ) 
                            BEGIN 
INSERT INTO @GetAvgSalary 
            ( 
                        emp_name, 
                        avgsalary 
            ) 
SELECT          a.emp_first_name, 
                tmp.avgsalary 
FROM            employee_details a 
LEFT OUTER JOIN 
                ( 
                           SELECT     c.emp_id, 
                                      c.emp_salary AS AvgSalary 
                           FROM       salary c 
                           INNER JOIN 
                                      ( 
                                               SELECT   emp_id, 
                                                        Avg(emp_salary) AS Avg_Salsry, 
                                                        Max(emp_salary) AS Max_Salary 
                                               FROM     salary 
                                               GROUP BY emp_id ) tmp2 
                           ON         c.emp_id = tmp2.emp_id 
                           AND        c.emp_salary = tmp2.max_salary ) tmp 
ON              tmp.emp_id = a.emp_id 
WHERE           a.emp_id = @Emp_Id 
RETURN 
ENDgoSELECT * 
FROM   dbo.Udf_getavgsalary(2)