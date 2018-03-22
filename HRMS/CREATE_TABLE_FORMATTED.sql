/* create all the tables */
CREATE TABLE Country(
	Country_Id NUMERIC(10) IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Country_Name NVARCHAR(50) UNIQUE NOT NULL,
);

CREATE TABLE State(
	State_Id   NUMERIC(10) IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Country_Id NUMERIC(10)  NOT NULL,
	State_Name NVARCHAR(50) NOT NULL
);

CREATE TABLE City(
	City_Id  NUMERIC(10) IDENTITY(1,1) PRIMARY KEY NOT NULL,
	State_Id NUMERIC(10) NOT NULL,
	City_Name NVARCHAR(50) NOT NULL,
	FOREIGN KEY (State_Id) REFERENCES State(State_Id)
);

CREATE TABLE Designation(
	Desig_Id NUMERIC(10) IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Desig_Name NVARCHAR(50) UNIQUE NOT NULL,
	Desig_Description NVARChar(300) NOT NULL 
);

CREATE TABLE Employee_Details(
	Emp_Id NUMERIC(10) IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Emp_First_Name  NVARCHAR(50) NOT NULL ,
	Emp_Middle_Name NVARCHAR(50) ,
	Emp_Last_Name   NVARCHAR(50) NOT NULL,
	Emp_Address1    NVARCHAR(100)NOT NULL,
	Emp_Address2    NVARCHAR(100),
	Emp_Country_Id  NUMERIC(10) NOT NULL,
	Emp_State_Id    NUMERIC(10) NOT NULL,
	Emp_City_Id     NUMERIC(10) NOT NULL,
	Emp_Zip         NUMERIC(5)  NOT NULL,
	Emp_Mobile      NUMERIC(10) NOT NULL,
	EMP_Gender      BIT         NOT NULL,
	Desig_Id        NUMERIC(10) NOT NULL,
	Emp_DOB         DATETIME    NOT NULL,
	Emp_JoinDate    DATETIME    NOT NULL,
	Emp_Active      BIT         NOT NULL,
	CONSTRAINT FK_ED_Country_Id  FOREIGN KEY (Emp_Country_Id) REFERENCES Country(Country_Id),
	CONSTRAINT FK_ED_State_Id    FOREIGN KEY (Emp_State_Id) REFERENCES State(State_Id),
	CONSTRAINT FK_ED_City_Id     FOREIGN KEY (Emp_City_Id) REFERENCES City(City_Id)
);

CREATE TABLE Salary(
	Salary_Id NUMERIC(10) IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Emp_Id    NUMERIC(10) NOT NULL,
	Emp_Salary_Change_Year DATETIME NOT NULL,
	Emp_Salary DECIMAL(10,2) NOT NULL,
	CONSTRAINT FK_Emp_Id FOREIGN KEY (Emp_Id) REFERENCES Employee_Details(Emp_Id)
);

CREATE TABLE Employee_Documents(
	Emp_Doc_Id NUMERIC(10) IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Emp_Id     NUMERIC(10) NOT NULL,
	Emp_Doc_Name NVARCHAR(30) NOT NULL,
	Emp_Doc_Desc NVARCHAR(150)
	CONSTRAINT FK_ED_Emp_Id FOREIGN KEY (Emp_Id) REFERENCES Employee_Details(Emp_Id)
);

GO 

-- QUERY 01
CREATE TABLE DB_Actions 
  ( 
     Id          NUMERIC(10) IDENTITY(1, 1) PRIMARY KEY, 
     Table_Name  VARCHAR(20), 
     Action_Name VARCHAR(10), 
     User_Name   VARCHAR(50), 
     Done_On     DATETIME, 
     Record_Id   NUMERIC(5) 
  ); 

GO

-- QUERY 02
CREATE TRIGGER audit_trigger 
ON employee_details 
after INSERT, UPDATE, DELETE 
AS 
  BEGIN 
      DECLARE @Table_Name VARCHAR(20); 

      SET @Table_Name = 'Employee_Details'; 

      DECLARE @Action AS VARCHAR(10); 

      SET @Action = ( CASE 
                        WHEN EXISTS(SELECT * 
                                    FROM   inserted) 
                             AND EXISTS(SELECT * 
                                        FROM   deleted) THEN 'U' 
                        -- Set Action to Updated. 
                        WHEN EXISTS(SELECT * 
                                    FROM   inserted) THEN 'I' 
                        -- Set Action to Insert. 
                        WHEN EXISTS(SELECT * 
                                    FROM   deleted) THEN 'D' 
                      -- Set Action to Deleted. 
                      END ); 

      INSERT INTO db_actions 
                  (table_name, 
                   action_name, 
                   user_name, 
                   done_on, 
                   record_id) 
      SELECT @Table_Name, 
             @Action, 
             CURRENT_USER, 
             Getdate(), 
             e.emp_id 
      FROM   employee_details e 
  END 

GO

-- QUERY 05
CREATE TABLE  Error_Log
(
	Error_Id NUMERIC(18) IDENTITY(1,1) PRIMARY KEY,
	ErrorNum NUMERIC(18) ,
	ErrorMsg NVARCHAR(MAX),
	Table_Name NVARCHAR(MAX),
	Action_Name NVARCHAR(MAX),
	CurrentTime DATETIME
)






