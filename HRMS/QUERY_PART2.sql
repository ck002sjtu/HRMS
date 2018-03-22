-- QUERY 03
CREATE PROCEDURE sp_Employee_Detail_Modify
(@Flag INT)
AS
BEGIN
	IF (@Flag = 1)
	BEGIN 
		--insert value
	END
	ELSE IF (@Flag = 2)
	BEGIN
		-- UPDATE VALUE
	END
	ELSE IF(@Flag = 3)
	BEGIN 
		-- DELETE VALUE
	END
END
GO

-- QUERY 04 06 
DROP PROCEDURE sp_Employee_Detail_Transaction
GO 

CREATE PROCEDURE sp_Employee_Detail_Transaction
	@Emp_First_Name  NVARCHAR(50),
	@Emp_Middle_Name NVARCHAR(50),
	@Emp_Last_Name   NVARCHAR(50),
	@Emp_Address1    NVARCHAR(100),
	@Emp_Address2    NVARCHAR(100),
	@Emp_Country_Id  NUMERIC(10) ,
	@Emp_State_Id    NUMERIC(10) ,
	@Emp_City_Id     NUMERIC(10) ,
	@Emp_Zip         NUMERIC(5)  ,
	@Emp_Mobile      NUMERIC(10) ,
	@EMP_Gender      BIT         ,
	@Desig_Id        NUMERIC(10) ,
	@Emp_DOB         DATETIME    ,
	@Emp_JoinDate    DATETIME    ,
	@Emp_Active      BIT         ,
	@Emp_Doc_Name NVARCHAR(30)   ,
	@Emp_Doc_Desc NVARCHAR(150)
AS
--SET NOCOUNT ON;
BEGIN 
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE  @Emp_Id  NUMERIC(10);
			SET @Emp_Id =  IDENT_CURRENT( 'dbo.Employee_Details' )  + 1  ; 
			DECLARE  @Emp_Doc_Id  NUMERIC(10);
			SET @Emp_Doc_Id =  IDENT_CURRENT( 'dbo.Employee_Documents' )  + 1  ; 
			SET IDENTITY_INSERT Employee_Details ON;
			INSERT 
			INTO Employee_Details(
				 Emp_Id,
				 Emp_First_Name,
				 Emp_Middle_Name,
				 Emp_Last_Name ,
				 Emp_Address1,
				 Emp_Address2,
				 Emp_Country_Id,
				 Emp_State_Id,
				 Emp_City_Id,
				 Emp_Zip,
				 Emp_Mobile,
				 EMP_Gender,
				 Desig_Id,
				 Emp_DOB,
				 Emp_JoinDate,
				 Emp_Active )
			VALUES (
				 @Emp_Id,
				 @Emp_First_Name  ,
				 @Emp_Middle_Name ,
				 @Emp_Last_Name   ,
	 			 @Emp_Address1    ,
				 @Emp_Address2    ,
 				 @Emp_Country_Id  ,
	   			 @Emp_State_Id    ,
				 @Emp_City_Id     ,
				 @Emp_Zip         ,
				 @Emp_Mobile      ,
				 @EMP_Gender      ,
				 @Desig_Id        ,
				 @Emp_DOB         ,
				 @Emp_JoinDate    ,
				 @Emp_Active      		
			) 
			SET IDENTITY_INSERT Employee_Details OFF;
			SET IDENTITY_INSERT Employee_Documents ON;
			INSERT 
			INTO Employee_Documents(
			Emp_Doc_Id,
			Emp_Id,
			Emp_Doc_Name,
			Emp_Doc_Desc
			)
			VALUES (
			SCOPE_IDENTITY(),
			@Emp_Id,
			@Emp_Doc_Name,
			@Emp_Doc_Desc
			);	
			--SET IDENTITY_INSERT Employee_Details OFF;
		COMMIT TRAN

		--- used for test purposes
		RAISERROR ('Error raised in TRY block.', -- Message text.
            16, -- Severity.
            1 -- State.
            )
	END TRY
	BEGIN CATCH
		Rollback Transaction
		INSERT INTO Error_Log(
				ErrorNum ,
				ErrorMsg ,
				Table_Name ,
				Action_Name,
				CurrentTime
		)
		VALUES (
			ERROR_NUMBER() ,
			ERROR_MESSAGE(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			GETDATE()
			)
		-- PRINT 'SB'
	END CATCH	
END
GO

sp_Employee_Detail_Transaction
	@Emp_First_Name  = 'Ronaldo',
	@Emp_Middle_Name = 'Rome',
	@Emp_Last_Name   = 'Fabrizzio',
	@Emp_Address1    = '75 Calle Suerte',
	@Emp_Address2    = NULL,
	@Emp_Country_Id  = 2,
	@Emp_State_Id    = 7,
	@Emp_City_Id     = 4,
	@Emp_Zip         = 10034,
	@Emp_Mobile      = 1317778395,
	@EMP_Gender      = 1,
	@Desig_Id        = 4,
	@Emp_DOB         = '1978-05-12 00:00:00.000',
	@Emp_JoinDate    = '2012-03-22 00:00:00.000',
	@Emp_Active       = 1,
	@Emp_Doc_Name    = 'DOC1',
	@Emp_Doc_Desc    = 'DOC_DESC1'

GO
SELECT * FROM Employee_Documents

SELECT * FROM Error_Log
-- QUERY 07
CREATE PROCEDURE sp_AddNewColumn_EmployeeD
AS
	ALTER TABLE Employee_Details
		ADD Emp_Bouns DECIMAL(10,2)

sp_AddNewColumn_EmployeeD
GO

-- QUERY 08
IF OBJECT_ID (N'BonusOfEmployee', N'FN') IS NOT NULL  
    DROP FUNCTION BonusOfEmployee;  
GO

CREATE FUNCTION BonusOfEmployee(@Emp_Id NUMERIC(10) )
RETURNS DECIMAL(10,2)
AS
BEGIN
	DECLARE @Bonus DECIMAL(10,2);
	SELECT @Bonus = (0.1 * s.Emp_Salary)
	FROM Employee_Details e
	INNER JOIN SALARY s
	ON e.Emp_Id = s.Emp_Id
	INNER JOIN 
	(	
		SELECT s.Emp_Id, MAX(s.Emp_Salary_Change_Year) AS recent_year
		FROM Salary s
		GROUP BY s.Emp_Id
	) AS derived1
	ON e.Emp_Id = derived1.Emp_Id AND s.Emp_Salary_Change_Year = derived1.recent_year
	WHERE e.Emp_Id = @Emp_Id

	RETURN @Bonus
END;
GO

DECLARE @ret DECIMAL(10,2);
EXEC @ret = dbo.BonusOfEmployee 
    @Emp_Id = 5; 
	PRINT @ret
GO

-- QUERY 09
IF OBJECT_ID (N'ActiveEmployeeInCity') IS NOT NULL  
    DROP FUNCTION ActiveEmployeeInCity;  
GO
CREATE FUNCTION ActiveEmployeeInCity(@City_Name NVARCHAR(50))
RETURNS @retActiveEmployeeInCity TABLE 
(
	Emp_Id NUMERIC(10) UNIQUE NOT NULL,
	Emp_First_Name  NVARCHAR(50) NOT NULL ,
	--Emp_Middle_Name NVARCHAR(50) ,
	Emp_Last_Name   NVARCHAR(50) NOT NULL,
	--Emp_Address1    NVARCHAR(100)NOT NULL,
	--Emp_Address2    NVARCHAR(100),
	--Emp_Country_Id  NUMERIC(10) NOT NULL,
	--Emp_State_Id    NUMERIC(10) NOT NULL,
	--Emp_City_Id     NUMERIC(10) NOT NULL,
	--Emp_Zip         NUMERIC(5)  NOT NULL,
	--Emp_Mobile      NUMERIC(10) NOT NULL,
	--EMP_Gender      BIT         NOT NULL,
	--Desig_Id        NUMERIC(10) NOT NULL,
	--Emp_DOB         DATETIME    NOT NULL,
	--Emp_JoinDate    DATETIME    NOT NULL,
	--Emp_Active      BIT         NOT NULL,
	--Emp_Bouns       DECIMAL(10,2),
	Emp_CityName      NVARCHAR(50) 
)
AS 
BEGIN
	INSERT @retActiveEmployeeInCity 
	SELECT e.Emp_Id,e.Emp_First_Name, e.Emp_Last_Name, c.City_Name
	FROM Employee_Details e
	INNER JOIN City c
	ON e.Emp_City_Id = c.City_Id
	WHERE c.City_Name = @City_Name
	
	RETURN 
END
GO

SELECT * 
FROM dbo.ActiveEmployeeInCity( 'Berat') 
GO

-- QUERY 10
IF OBJECT_ID (N'sp_Insert_Bonus_Amount') IS NOT NULL  
    DROP PROCEDURE sp_Insert_Bonus_Amount;  
GO
CREATE PROCEDURE sp_Insert_Bonus_Amount @City_Name NVARCHAR(50)
AS
	With Bonus_Amount_CTE ( bonus,Emp_Id)
	AS 
	(
		SELECT dbo.BonusOfEmployee(e.Emp_Id) AS bonus, e.Emp_Id
		FROM Employee_Details e
		WHERE e.Emp_Id IN 
			(
			SELECT Emp_Id
			FROM dbo.ActiveEmployeeInCity( @City_Name)
			)
	)	
	UPDATE Employee_Details
	SET Emp_Bouns = derivetb1.bonus
	FROM 
	(
		SELECT b.Emp_Id,bonus 
		FROM Bonus_Amount_CTE b
	) derivetb1
	WHERE Employee_Details.Emp_Id = derivetb1.Emp_Id

/*
	INSERT INTO  Employee_Details (Emp_Bouns)
		SELECT bonus 
		FROM Bonus_Amount_CTE b
		WHERE Employee_Details.Emp_Id = b.Emp_Id
*/
GO

sp_Insert_Bonus_Amount 'Berat'

--UPDATE Employee_Details SET Emp_Bouns = null
SELECT * FROM Employee_Details
SELECT Emp_First_Name,
	   Emp_Bouns,
	   City_Name
 FROM Employee_Details
 INNER JOIN City
 ON Emp_City_Id = City_Id

 GO

-- QUERY 11
-- Write a procedure to return the sum of current salaries of all the active employees using cursor.
IF OBJECT_ID (N'Get_Current_Salary') IS NOT NULL  
    DROP FUNCTION Get_Current_Salary;  
GO
CREATE FUNCTION dbo.Get_Current_Salary(@Emp_Id NUMERIC(10))
RETURNS @retCurrent_Salary TABLE 
(
	retCurrent_Salary DECIMAL(10,2)
)
AS
BEGIN
	DECLARE @Current_Salary NUMERIC(10);
	SELECT @Current_Salary = s.Emp_Salary
	FROM Employee_Details e
	INNER JOIN 
	Salary s
	ON e.Emp_Id = s.Emp_Id
	INNER JOIN 
		(
		SELECT Emp_Id, MAX(Emp_Salary_Change_Year) as RecentYear
		FROM Salary s
		WHERE s.Emp_Id = @Emp_Id
		GROUP BY s.Emp_Id
		) Derived_tb
	ON e.Emp_Id = Derived_tb.Emp_Id and s.Emp_Salary_Change_Year = Derived_tb.RecentYear
	INSERT @retCurrent_Salary
	SELECT @Current_Salary
	RETURN
END
GO

SELECT * 
FROM dbo.Get_Current_Salary (1)
GO

IF OBJECT_ID (N'sp_Sum_Current_Salaries') IS NOT NULL  
    DROP PROCEDURE sp_Sum_Current_Salaries;  
GO
CREATE PROCEDURE sp_Sum_Current_Salaries
AS
	DECLARE @Emp_Id_TEMP NUMERIC(10);
	DECLARE @Current_Salary NUMERIC(10,2);
	SET @Current_Salary =  0.0;

	DECLARE Sum_Salaries_Cursor CURSOR FOR
	SELECT Emp_Id FROM Employee_Details 
	WHERE Emp_Active = 1

	OPEN Sum_Salaries_Cursor 
	FETCH NEXT FROM Sum_Salaries_Cursor INTO @Emp_Id_TEMP
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		IF (SELECT retCurrent_Salary FROM dbo.Get_Current_Salary (@Emp_Id_TEMP)) IS NOT NULL
			BEGIN 
			SELECT @Current_Salary += 
				(SELECT retCurrent_Salary FROM dbo.Get_Current_Salary (@Emp_Id_TEMP))
			END ;
		FETCH NEXT FROM Sum_Salaries_Cursor INTO @Emp_Id_TEMP
		 
	END

	CLOSE Sum_Salaries_Cursor
	DEALLOCATE Sum_Salaries_Cursor
	SELECT @Current_Salary AS Current_Salary
	--SELECT @Emp_Id_TEMP AS sb
	RETURN 

GO

sp_Sum_Current_Salaries

select * from Employee_Details

GO

-- QUERY 12
-- 12.	Use CTE in a stored procedure return the First Name, Last Name and Current Salary of all the employee¡¯s.

WITH Get_Current_SalaryAndBio_CTE ( FirstName, LastName , CurrentSalary)
AS 
(
	SELECT Emp_First_Name,Emp_Last_Name, 
	(
	SELECT * FROM dbo.Get_Current_Salary (Emp_Id)
	) AS Current_Salary
	FROM Employee_Details
)
SELECT * 
FROM Get_Current_SalaryAndBio_CTE
GO

-- QUERY 13
--13.	List the Employee Name(Last Name, First Name),Address, Designation, Country name, state name, city name, Join Date, Current Salary using the following:
-- a. Table Variable
-- b. Temp Table
-- c. Table Parameter (try to execute using sp)

-- a. Table Variable
DECLARE @Employee_Info_TV TABLE
(
	Employee_Name NVARCHAR(150),
	Emp_Address   NVARCHAR(150),
	Desig_Name    NVARCHAR(50),
	Country_Name  NVARCHAR(50),
	State_Name    NVARCHAR(50),
	City_Name     NVARCHAR(50),
	Join_Date     DATETIME,
	Current_Salary NUMERIC(10,2)
) 

INSERT INTO @Employee_Info_TV
	SELECT (e.Emp_First_Name+' '+e.Emp_Last_Name) AS Employee_Name,
		   (e.Emp_Address1 + ' ' + e.Emp_Address2) AS Emp_Address,
		   d.Desig_Name,
		   COUNTRY.Country_Name,
		   State.State_Name,
		   City.City_Name,
		   e.Emp_JoinDate,
		   (SELECT * FROM dbo.Get_Current_Salary(e.Emp_Id)) AS Current_Salary
	FROM Employee_Details e
	LEFT OUTER JOIN Designation d
	ON e.Desig_Id = d.Desig_Id
	LEFT OUTER JOIN Country 
	ON e.Emp_Country_Id = COUNTRY.Country_Id
	LEFT OUTER JOIN State 
	ON e.Emp_State_Id = State.State_Id
	LEFT OUTER JOIN City
	ON e.Emp_City_Id = CITY.City_Id
	
SELECT * FROM @Employee_Info_TV
GO
-- b. Temp Table
IF OBJECT_ID (N'#Employee_Info_TT') IS NOT NULL  
    DROP TABLE #Employee_Info_TT;  
GO
CREATE TABLE dbo.#Employee_Info_TT
(
	Employee_Name NVARCHAR(150),
	Emp_Address   NVARCHAR(150),
	Desig_Name    NVARCHAR(50),
	Country_Name  NVARCHAR(50),
	State_Name    NVARCHAR(50),
	City_Name     NVARCHAR(50),
	Join_Date     DATETIME,
	Current_Salary NUMERIC(10,2)
)
GO
INSERT INTO #Employee_Info_TT
	SELECT (e.Emp_First_Name+' '+e.Emp_Last_Name) AS Employee_Name,
		   (e.Emp_Address1 + ' ' + e.Emp_Address2) AS Emp_Address,
		   d.Desig_Name,
		   COUNTRY.Country_Name,
		   State.State_Name,
		   City.City_Name,
		   e.Emp_JoinDate,
		   (SELECT * FROM dbo.Get_Current_Salary(e.Emp_Id)) AS Current_Salary
	FROM Employee_Details e
	LEFT OUTER JOIN Designation d
	ON e.Desig_Id = d.Desig_Id
	LEFT OUTER JOIN Country 
	ON e.Emp_Country_Id = COUNTRY.Country_Id
	LEFT OUTER JOIN State 
	ON e.Emp_State_Id = State.State_Id
	LEFT OUTER JOIN City
	ON e.Emp_City_Id = CITY.City_Id
	
SELECT * FROM #Employee_Info_TT
GO

-- c. Table Parameter
CREATE TYPE dbo.Employee_Info_TYPE AS TABLE 
(
	Employee_Name NVARCHAR(150),
	Emp_Address   NVARCHAR(150),
	Desig_Name    NVARCHAR(50),
	Country_Name  NVARCHAR(50),
	State_Name    NVARCHAR(50),
	City_Name     NVARCHAR(50),
	Join_Date     DATETIME,
	Current_Salary NUMERIC(10,2)
)
GO
CREATE PROCEDURE usp_Employee_Info_TP
	(@Employee_Info_TP  Employee_Info_TYPE READONLY)
	AS
	SELECT * 
	FROM @Employee_Info_TP
GO

DECLARE @usp_Employee_Info_TP AS Employee_Info_TYPE;
INSERT INTO @usp_Employee_Info_TP
	SELECT (e.Emp_First_Name+' '+e.Emp_Last_Name) AS Employee_Name,
		   (e.Emp_Address1 + ' ' + e.Emp_Address2) AS Emp_Address,
		   d.Desig_Name,
		   COUNTRY.Country_Name,
		   State.State_Name,
		   City.City_Name,
		   e.Emp_JoinDate,
		   (SELECT * FROM dbo.Get_Current_Salary(e.Emp_Id)) AS Current_Salary
	FROM Employee_Details e
	LEFT OUTER JOIN Designation d
	ON e.Desig_Id = d.Desig_Id
	LEFT OUTER JOIN Country 
	ON e.Emp_Country_Id = COUNTRY.Country_Id
	LEFT OUTER JOIN State 
	ON e.Emp_State_Id = State.State_Id
	LEFT OUTER JOIN City
	ON e.Emp_City_Id = CITY.City_Id

EXEC usp_Employee_Info_TP @usp_Employee_Info_TP;  
GO  

-- QUERY 14
-- 14.Use case when clause in SP to assign level of employee¡¯s based on the salary as follows: 
--    Level1 if salary>95000,Level2 if 50000<salary<95000 and Level3 if salary<50000.

SELECT e.Emp_Id, 
	(
		CASE 
		WHEN (SELECT * FROM dbo.Get_Current_Salary(e.Emp_Id)) > 95000 THEN 'LEVEL1'
		WHEN (SELECT * FROM dbo.Get_Current_Salary(e.Emp_Id)) > 50000 THEN 'LEVEL2'
		ELSE 'LEVEL3'
		END
	) AS Employee_Level
FROM Employee_Details e

GO
-- QUERY 15
/*15.	Create a dynamic SQL procedure for searching all employees from employee details table.
Search Parameters (The user may input none or one or multiple values into the parameters you set up in the stored procedure):
First name, Last name, Middle name, Designation name, Country name, Start DOB, End DOB, start DOJ, End DOJ.
Result:
First name, Middle name, Last name, Country, State, City, Designation, DOB, DOJ, Gender  
*/
CREATE PROCEDURE spSearchEmployeeDetails
@FirstName  NVARCHAR(100) = NULL,
@MiddleName NVARCHAR(100) = NULL,
@LastName   NVARCHAR(100) = NULL,
@Gender     BIT           = NULL,
@Country    NVARCHAR(100) = NULL,
@State      NVARCHAR(100) = NULL,
@City       NVARCHAR(100) = NULL,
@Designation NVARCHAR(100) = NULL,
@DOB        DATETIME      = NULL,
@DOJ        DATETIME      = NULL
AS 

SELECT E.Emp_JoinDate
FROM Employee_Details E
BEGIN
	Declare @sql nvarchar(max)
	SET @sql = 'SELECT * FROM Employee_Details e LEFT OUTER JOIN Country ON e.Emp_Country_Id = COUNTRY.Country_Id LEFT OUTER JOIN State ON e.Emp_State_Id = State.State_Id LEFT OUTER JOIN CITY ON e.Emp_City_Id = City.City_Id LEFT OUTER JOIN Designation d ON e.Desig_Id = d.Desig_Id where 1 = 1'
	IF @FirstName IS NOT NULL
		SET @sql = @sql + ' and e.Emp_First_Name = @FirstName'
	IF @MiddleName IS NOT NULL
		SET @sql = @sql + ' and e.Emp_Middle_Name = @MiddleName'
	IF @LastName IS NOT NULL
		SET @sql = @sql + ' and e.Emp_Last_Name = @LastName'
	IF @Gender IS NOT NULL
		SET @sql = @sql + ' and e.EMP_Gender = @Gender'
	IF @Country IS NOT NULL
		SET @sql = @sql + ' and COUNTRY.Country_Name = @Country'
	IF @State IS NOT NULL
		SET @sql = @sql + ' and STATE.State_Name = @State'
	IF @City IS NOT NULL
		SET @sql = @sql + ' and CITY.City_Name = @City'
	IF @Designation IS NOT NULL
		SET @sql = @sql + ' and d.Desig_Name = @Designation'
	IF @DOB IS NOT NULL
		SET @sql = @sql + ' and e.Emp_DOB = @DOB'
	IF @DOJ IS NOT NULL
		SET @sql = @sql + ' and e.Emp_JoinDate = @DOJ'
	EXECUTE sp_executesql @SQL 		
		N'@FirstName nvarchar(max), 
		@MiddleName nvarchar(max),
		@LastName nvarchar(max),
		@Gender nvarchar(max),
		@Country nvarchar(max),
		@Emp_DOB DATETIME,
		@Emp_JoinDate DATETIME',
END
GO


-- QUERY 16
--  16.	Select the employees who have the third highest current salary.
WITH Employee_CTE AS
(
SELECT Emp_First_Name, (SELECT * FROM dbo.Get_Current_Salary(Emp_Id)) AS Current_Salary, ROW_NUMBER()OVER(ORDER BY (SELECT * FROM dbo.Get_Current_Salary(Emp_Id)) DESC) AS ROWNUMBER
FROM Employee_Details 
)
SELECT * 
FROM Employee_CTE
WHERE ROWNUMBER = 3

GO



