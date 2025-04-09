-- Active: 1738044664712@@localhost@3306@bscs2
use BSCS2;
Create Table Department(DeptNo int primary key , DName varchar (50), Loc varchar(50));
desc Department;
 Create table Employee(EmpNo  varchar(50) primary key, EName varchar(50), Job varchar(50), Salary int, DeptNo int, foreign key(DeptNo) references Department(DeptNo));
 Drop TABLE employee;
 Create table Employee(EmpNo  varchar(50) primary key, EName varchar(50), Job varchar(50), Salary int, DeptNo int, foreign key(DeptNo) references Department(DeptNo));
 desc Employee;
 insert into department values(10,'SALES','KAMPALA'),
                              (40,'MARKETING','ENTEBBE'),
                              (30,'ACCOUNTING','MUKONO');
select* from department;
 insert into Employee values ('E001','Null','Clerk',40000,30),
                             ('E002','Agaba','Manager',16000,30),
                             ('E003','Mary','SalesLady',20000,10),
                             ('E004','Timo','Clerk',40000,30),
                             ('E005','Simon','Manager',60000,40),
                             ('E006','Mark','Manager',45000,10),
                             ('E007','Solomon','Teacher',30000,30);
 select * from employee;
 show DATABASEs;
 use bscs2;
-- Lists all tables in the database
SHOW TABLES;
-- b) Enforce the entity and referential integrity rule on the above created tables.
ALTER TABLE employee 
ADD CONSTRAINT fk_department FOREIGN KEY (DeptNo) REFERENCES Department(DeptNo);

-- c) Evoke the relational schema of the employee and dept relation. 
SELECT E.EmpNo, E.EName, E.Job, E.Salary, D.DName, D.Loc FROM Employee E
JOIN Department D ON E.DeptNo = D.DeptNo;   

-- d) Create a View labelled view_d, to retrieve all details of employees that belong to Dno 30, 
CREATE VIEW view_d AS
SELECT E.EmpNo, E.EName, E.Job, E.Salary, D.DName, D.Loc
FROM Employee E
JOIN Department D ON E.DeptNo = D.DeptNo
WHERE E.DeptNo = 30;
 select* from view_d;

-- e) Create a view labelled view_e, to compute the number of employees for each job
CREATE VIEW view_e AS
SELECT Job, COUNT(*) AS NumberOfEmployees
FROM Employee
GROUP BY Job;
select* from view_e;
-- f)Create a view labelled view_f, to retrieve the employees whose name starts with letter "T
CREATE VIEW view_f AS
SELECT E.EmpNo, E.EName, E.Job, E.Salary, D.DName, D.Loc FROM Employee E JOIN Department D ON E.DeptNo = D.DeptNo WHERE E.EName LIKE 'T%';
select* from view_f;

-- g) Create a view labelled view_g, to retrieve the unique jobs in the employee table descending order.
CREATE VIEW view_g AS SELECT DISTINCT Job FROM Employee ORDER BY Job DESC;
select* from view_g;

-- h) create a view labelled view_h, to retrieve the total amount spent on each job.
CREATE VIEW view_h AS SELECT Job, SUM(Salary) AS TotalAmountSpent FROM Employee GROUP BY Job;
select* from view_h;

-- i) Create a view labelled view_i, is should fulfill the principle of having close in sql.
 CREATE VIEW view_i AS SELECT E.EmpNo, E.EName, E.Job, E.Salary, D.DName, D.Loc, AVG(Salary) OVER(PARTITION BY Job)
 AS AverageSalary FROM Employee E JOIN Department D ON E.DeptNo = D.DeptNo;
 select* from view_i;
 -- j) Create a view labelled view_j, tit shoud find average and total salaries collected per job.
 CREATE VIEW view_j AS SELECT Job, AVG(Salary) AS AverageSalary, SUM(Salary) AS TotalSalary
 FROM Employee
 GROUP BY Job;
 select* from view_j;

-- k) Add a new column to the department table, the column name should be Location.
 ALTER TABLE Department ADD Location VARCHAR(50);
 DESC Department;
-- l) Change the size of the column DName in the Department table to accommodate 50 characters.
 ALTER TABLE Department MODIFY DName VARCHAR(50);
 DESC Department;  

-- m) Retrieve the different base-tables and views from the bscs2 database.
 SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'bscs2'; 
Show FULL TABLES WHERE Table_type = 'BASE TABLE' OR Table_type = 'VIEW';


-- n) Create a view labelled view_n, it should assign department names based on the deptno. 
 CREATE VIEW view_n AS SELECT E.EmpNo, E.EName, E.Job, E.Salary, D.DName, D.Loc, CASE WHEN D.`DeptNo`
 IN (10, 30, 40) THEN CONCAT(D.DName,'Dept') ELSE 'N/A' END AS DepartmentName
 FROM Employee E JOIN Department D ON E.DeptNo = D.DeptNo;
 select* from view_n;

-- o) Create a view labelled view_o, it should compute salaries based on the conditions below:

 CREATE VIEW view_o AS SELECT E.EmpNo, E.EName, E.Job, E.Salary, D.DName, D.Loc, CASE WHEN D.`DeptNo`
 IN (10) THEN Salary * 1.08 ELSE CASE WHEN D.`DeptNo`
 IN (30) THEN Salary * 0.88 ELSE CASE WHEN D.`DeptNo`
 IN (40) THEN Salary * 1.10 ELSE Salary END END END AS UpdatedSalary
 FROM Employee E JOIN Department D ON E.DeptNo = D.DeptNo;
 select* from view_o;

-- p) Initiate transaction management for the condition n-q.
 START TRANSACTION;
 UPDATE Employee SET Salary = Salary * 1.08 WHERE DeptNo = 10;
 UPDATE Employee SET Salary = Salary * 0.88 WHERE DeptNo = 30;
 UPDATE Employee SET Salary = Salary * 1.10 WHERE DeptNo = 40;
 COMMIT;

--  q) Modify the details of empno=E004 to become (salary =80000, job-cleaner)
 UPDATE Employee SET Salary = 80000, Job = 'Cleaner' WHERE EmpNo = 'E004';
 -- r) Eliminate the record of employee ID E002.
 DELETE FROM Employee WHERE EmpNo = 'E002';

-- s) View the structure of the employee table.
 DESC Employee;

-- t) Push back the transactions that were executed from q-s.
 ROLLBACK;
 select* from employee;
--  The rollback command is executed and it take back the transaction history
show DATABASES;
use bscs2;
select* from department;
CREATE table Project(
    projID
    int primary key AUTO_INCREMENT,
    ProjName VARCHAR(100) NOT NULL,
    DeptNo int,
    Foreign Key (DeptNo) REFERENCES Department(DeptNo)
);
DROP TABLE Project;
CREATE table Project(
    ProjID
    int primary key AUTO_INCREMENT,
    ProjName VARCHAR(100) NOT NULL,
    DeptNo int,
    Foreign Key (DeptNo) REFERENCES Department(DeptNo),
    EmpNo varchar(50),
    Foreign Key (EmpNo) REFERENCES employee(EmpNo)
);
desc project;

--add two columns in the table project AssignedDate and roleand insert the availed values.
ALTER TABLE project ADD COLUMN AssignedDate DATE;
ALTER TABLE project ADD COLUMN Role varchar(50);
DESC project;
insert into project(ProjName,DeptNo,EmpNo) values ('sales boost', 10, 'E001'),
                                                   ('marketing expansion', 40, 'E005'),
                                                   ('accounting automation', 30, 'E007'),
                                                   ('sales strategy',10, 'E006');
select* from project;

-- A)Rerieve employee and their department details.
SELECT E.EmpNo, E.EName, E.Job, E.Salary, D.DName, D.Loc FROM Employee E
JOIN Department D ON E.DeptNo = D.DeptNo;

-- B) Retrieve the project and their Department details.

SELECT P.projID, P.ProjName, D.DName, D.loc FROM project P 
JOIN department D ON P.DeptNo = D.DeptNo;

-- C) Retrieve All Employees, their departments, and Projects.
select E.EmpNo, E.EName,E.Job, E.Salary,D.DName as Department, P.ProjName as Project
FROM employee E
JOIN department D ON E.DeptNo = D.DeptNo
JOIN project P ON D.DeptNo = P.DeptNo;

-- D) retrieve all project along with the department and employees in that department.
Select P.ProjName AS Project, D.DName as Department, E.EName As Employee, E.Job 
FROM Project P  join department D on P.DeptNo = D.DeptNo 
JOIN employee E on D.DeptNo = E.DeptNo ORDER BY P.ProjName;

-- E) Find Employees working on projects in their Department with salary Greater than 40000.
SELECT E.EmpNo, E.EName, E.Job, E.Salary, D.DName as Department , P.ProjName as Project
FROM employee E join department D on E.DeptNo = D.DeptNo
JOIN project P on D.DeptNo = P.DeptNo where E.Salary> 40000;

-- F) Count How Many Employees are in each department working on a project.
Select D.DName AS Department, P.ProjName AS Project, COUNT(E.EmpNo) AS
TotalEmployees FROM employee E JOIN department D ON E.DeptNo = D.DeptNo
JOIN project P ON D.DeptNo = P.DeptNo GROUP BY D.DName, P.ProjName;

--  G)Retreive employees who are maangers and their Department's project
Select E.EmpNo, E.EName,E.Job,D.DName AS Department, P.ProjName AS Project
FROM employee E 
JOIN department D on E.DeptNo = D.DeptNo
JOIN project P on D.DeptNo = P.DeptNo WHERE E.Job = 'Manager';

-- update employee salary.

update employee  set Salary = 45000 WHERE EmpNo = 'E003';

create TABLE EMPX(eid VARCHAR(20), constraint empx_pk PRIMARY KEY (eid),
designation varchar(20) constraint empx_des check (designation in ('manager', 'clerk','teacher')),
Age int constraint empx_age check (Age>18),DOJ datetime DEFAULT CURRENT_TIMESTAMP, 
Gender varchar(1), Email varchar(20), telno int);
use bscs2;
 desc empx;
  ALTER TABLE empx ADD CONSTRAINT empx_Gender check (Gender in ('M','F'));
  ALTER TABLE empx DROP CONSTRAINT empx_Gender;
  ALTER Table empx ADD CONSTRAINT empx_Gender check (Gender = 'M' or Gender = 'F');
--   emails should be unique/distict.
  ALTER TABLE empx ADD CONSTRAINT empx_email UNIQUE (email);

--    telno should be of 10 digits.
  ALTER TABLE empx ADD CONSTRAINT empx_telno check (length(telno)=10);
  insert INTO empx (eid, designation,Age,Gender,Email, telno)VALUES ('E001', 'manager', 34, 'M', 'Obba@gmail.com',1798109404);
   SELECT*FROM empx; 
select CONSTRAINT_NAME, CONSTRAINT_type FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_NAME= 'empx';
-- create table empy 
--  EID nimber should have four aphanumeric values.
-- Age should be greater than 18 - 60
-- LName should be in Capital letters.
-- salary should be  in the range of 40000 and 100000
-- Phone number should be distinct
-- All emails must have an @ symbol
-- Gender should not be empty or left blank.
-- All the EIDS must start with with letter E
-- 

-- CREATE TABLE EMPY(Eid VARCHAR(4) CONSTRAINT empy_pk primary key,
-- Age int constraint empy_age check (age >=18 And age <= 60),
-- Gender VARCHAR(1) NOT NULL constraint empy_gender check (gender = 'M' or gender = 'F'),
-- LName VARCHAR(255)  constraint empy_LName check (LName = UPPER(LName)),
-- DName VARCHAR(255) ,
-- Salary DECIMAL(10,2) constraint empy_salary check (salary >= 40000 and salary <= 100000),
-- Phone VARCHAR(10) constraint empy_phone UNIQUE(Phone) ,
--  Email VARCHAR(255) constraint empy_email check (email LIKE '%@%' ),
--  DOJ DATE DEFAULT CURRENT_TIMESTAMP);

CREATE TABLE EMPY (
    eid VARCHAR(4) PRIMARY KEY,
    Age INT CONSTRAINT empy_age CHECK (age >= 18 AND age <= 60),
    Gender VARCHAR(1) NOT NULL CONSTRAINT empy_gender CHECK (gender IN ('M', 'F')),
    LName VARCHAR(255) CONSTRAINT empy_LName CHECK (LNAME = UPPER(LNAME)),
    DName VARCHAR(255),
    Salary DECIMAL(10,2) CONSTRAINT empy_salary CHECK (salary BETWEEN 40000 AND 100000),
    Phone VARCHAR(10),
    Email VARCHAR(255) CONSTRAINT empy_email CHECK (email LIKE '%@%'),
    DOJ DATETIME DEFAULT CURRENT_TIMESTAMP
);
ALTER table empy ADD CONSTRAINT empy_eid check (length (eid)=4);

ALTER TABLE empy ADD CONSTRAINT empy_Phone UNIQUE(Phone);

-- all EID's must start with letter E.
 ALTER TABLE empy ADD CONSTRAINT empy_eid_start CHECK (eid LIKE 'E%');

--  Eliminate the constraint appended on V  to accommodate for any salary values.
 ALTER TABLE empy DROP CONSTRAINT empy_salary;
 
 --  Create a new constraint to ensure that the salary is not negative.
 ALTER TABLE empy ADD CONSTRAINT empy_salary CHECK (Salary >= 0);

 insert into empy values (
    'E001', '20', 'M', 'ODONGKARA','OSCAR', '20000','0771301999','oscar@gmail.com', '2025-02-24'
);
insert into empy values (
    'E002', '22', 'M', 'OBBA','MARK', '40000','0789109404','obba@gmail.com', '2025-02-24'
);
ALTER Table empy drop constraint empy_phone;
select * FROM empy;


delimiter /
 create Procedure teacher()
begin
select*from employee where job = 'Teacher';
 end /

call teacher()/

CREATE Procedure joptype1(in id1 varchar(50))
begin
select*from employee where job = id1;
end/
call joptype1('Manager')/

select*from employee/



-- procedure that will get the total amount of a particular jobtile from employee.
CREATE PROCEDURE amount_spent(IN id2 VARCHAR(50))
BEGIN
    SELECT SUM(salary) FROM employee WHERE
    job = id2;
END /

CALL amount_spent('Manager');




--  produce 
create PROCEDURE xyt(IN id3 VARCHAR(50), in id4 varchar(10))
begin
SELECT count(*) FROM employee where job = id3 and DeptNo = id4;
end/
call xyt('Manager','30')/



-- procedure that updates the employee
create Procedure update_pro(in id4 varchar(20), in id5 int )
begin
    UPDATE employee SET salary = id5 WHERE EmpNo = id4;

END /

CALL update_pro('E003', 50000)/
select* from employee/



-- procedure that insert row into employee.
create Procedure insert_data(in id6 varchar(10), in id7 varchar(10), in id8 varchar(10), in id9 varchar(10))
begin
insert into department values(id6, id7, id8, id9);
end;

call insert_data(20,'IT','KAMPALA','Kissai');
call insert_data(50,'SALES','KAMPALA','BukotoL');
call insert_data(60,'SALES','KAMPALA','Nitnda');
SELECT* FROM department;
-- how to show all the procedures
SHOW  procedures;



-- to be done in the cmdline command prompt
-- creating a new user.
CREATE USER 'calvin'@'localhost' IDENTIFIED BY 'calo';

-- changing the password
ALTER USER 'calvin'@'localhost' PASSWORD EXPIRE;

-- lock access
ALTER USER 'calvin'@'localhost' account lock;

-- unlock our account

ALTER USER 'calvin'@'localhost' account unlock;

-- granting privileges


CREATE USER 'calvin'@'localhost' IDENTIFIED BY 'calo';
 alter user'seven'@'localhost' passward expire;

grant select , insert on bscs2.* 'demo'@'localhost';

GRANT select , insert on bscs2.* TO 'dem'@'localhost';
grant insert, update, select on *.* to 'seven'@'localhost';

grant select on bscs2.department to 'Ten'@'localhost';
-- revoking privilegesj

REVOKE SELECT, INSERT ON bscs2.* FROM 'demo'@'localhost';

REVOKE SELECT, INSERT ON bscs2.* FROM 'dem'@'localhost';
--   Deprive user James from being able to udpate details of only the  SAlARY column in the  employee table in the bscs2 database . other columns values should be updatable by user James .

GRANT SELECT, UPDATE(salary) ON bscs2.* TO 'James'@'localhost';

GRANT UPDATE(salary) ON bscs2.employee TO 'James'@'localhost';




-- PS C:\Users\UNETS COMPUTERS\OneDrive\Desktop\Academics\Year 2\Sem 2\Database Programming> cd\
-- PS C:\> 
-- PS C:\> cd '.\Program Files (x86)\'
-- PS C:\Program Files (x86)> mysql
-- ERROR 1045 (28000): Access denied for user 'ODBC'@'localhost' (using password: NO)
-- PS C:\Program Files (x86)> cd mysql
-- PS C:\Program Files (x86)\mysql> cd My SQL server 8.0               
-- Set-Location : A positional parameter cannot be found that accepts argument 'SQL'.
-- At line:1 char:1
-- + cd My SQL server 8.0
-- + ~~~~~~~~~~~~~~~~~~~~
--     + CategoryInfo          : InvalidArgument: (:) [Set-Location], ParameterBindingException
--     + FullyQualifiedErrorId : PositionalParameterNotFound,Microsoft.PowerShell.Commands.SetLocationCommand
 
-- PS C:\Program Files (x86)\mysql> cd My SQLserver 8.0 
-- Set-Location : A positional parameter cannot be found that accepts argument 'SQLserver'.
-- At line:1 char:1exit
-- + cd My SQLserver 8.0
-- + ~~~~~~~~~~~~~~~~~~~
--     + CategoryInfo          : InvalidArgument: (:) [Set-Location], ParameterBindingException
--     + FullyQualifiedErrorId : PositionalParameterNotFound,Microsoft.PowerShell.Commands.SetLocationCommand

-- PS C:\Program Files (x86)\mysql> cd My SQLserver 8.0
-- Set-Location : A positional parameter cannot be found that accepts argument 'SQLserver'.
-- At line:1 char:1
-- + cd My SQLserver 8.0
-- + ~~~~~~~~~~~~~~~~~~~
--     + CategoryInfo          : InvalidArgument: (:) [Set-Location], ParameterBindingException
--     + FullyQualifiedErrorId : PositionalParameterNotFound,Microsoft.PowerShell.Commands.SetLocationCommand
 
-- PS C:\Program Files (x86)\mysql> cd My SQL server 8.0
-- Set-Location : A positional parameter cannot be found that accepts argument 'SQL'.
-- At line:1 char:1
-- + cd My SQL server 8.0
-- + ~~~~~~~~~~~~~~~~~~~~
--     + CategoryInfo          : InvalidArgument: (:) [Set-Location], ParameterBindingException
--     + FullyQualifiedErrorId : PositionalParameterNotFound,Microsoft.PowerShell.Commands.SetLocationCommand

-- PS C:\Program Files (x86)\mysql> cd '.\MySQL Server 8.0\'
-- cd : Cannot find path 'C:\Program Files (x86)\mysql\MySQL Server 8.0\' because it does not exist.
-- At line:1 char:1
-- + cd '.\MySQL Server 8.0\'
-- + ~~~~~~~~~~~~~~~~~~~~~~~~
--     + CategoryInfo          : ObjectNotFound: (C:\Program File...SQL Server 8.0\:String) [Set-Location], ItemNotFoundException
--     + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.SetLocationCommand

-- PS C:\Program Files (x86)\mysql> cd
-- PS C:\Program Files (x86)\mysql> cd\
-- PS C:\> cd '.\Program Files (x86)\'
-- PS C:\Program Files (x86)> mysql
-- ERROR 1045 (28000): Access denied for user 'ODBC'@'localhost' (using password: NO)
-- PS C:\Program Files (x86)> cd mysql
-- PS C:\Program Files (x86)\mysql> cd '.\MySQL Server 8.0\'
-- cd : Cannot find path 'C:\Program Files (x86)\mysql\MySQL Server 8.0\' because it does not exist.
-- At line:1 char:1
-- + cd '.\MySQL Server 8.0\'
-- + ~~~~~~~~~~~~~~~~~~~~~~~~
--     + CategoryInfo          : ObjectNotFound: (C:\Program File...SQL Server 8.0\:String) [Set-Location], ItemNotFoundException
--     + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.SetLocationCommand

-- PS C:\Program Files (x86)\mysql> cd '.\Program Files\'
-- cd : Cannot find path 'C:\Program Files (x86)\mysql\Program Files\' because it does not exist.
-- At line:1 char:1
-- + cd '.\Program Files\'
-- + ~~~~~~~~~~~~~~~~~~~~~
--     + CategoryInfo          : ObjectNotFound: (C:\Program File...\Program Files\:String) [Set-Location], ItemNotFoundException
--     + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.SetLocationCommand

-- PS C:\Program Files (x86)\mysql> cd '.\MySQL Server 8.0\'
-- cd : Cannot find path 'C:\Program Files (x86)\mysql\MySQL Server 8.0\' because it does not exist.
-- At line:1 char:1
-- + cd '.\MySQL Server 8.0\'
-- + ~~~~~~~~~~~~~~~~~~~~~~~~
--     + CategoryInfo          : ObjectNotFound: (C:\Program File...SQL Server 8.0\:String) [Set-Location], ItemNotFoundException
--     + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.SetLocationCommand

-- PS C:\Program Files (x86)\mysql> cd MySQL Server 8.0     
-- Set-Location : A positional parameter cannot be found that accepts argument 'Server'.
-- At line:1 char:1
-- + cd MySQL Server 8.0
-- + ~~~~~~~~~~~~~~~~~~~
--     + CategoryInfo          : InvalidArgument: (:) [Set-Location], ParameterBindingException
--     + FullyQualifiedErrorId : PositionalParameterNotFound,Microsoft.PowerShell.Commands.SetLocationCommand

-- PS C:\Program Files (x86)\mysql> cd\
-- PS C:\> cd '.\Program Files\'   
-- PS C:\Program Files> cd '.\MySQL Server 8.0\'
-- cd : Cannot find path 'C:\Program Files\MySQL Server 8.0\' because it does not exist.
-- At line:1 char:1
-- + cd '.\MySQL Server 8.0\'
-- + ~~~~~~~~~~~~~~~~~~~~~~~~
--     + CategoryInfo          : ObjectNotFound: (C:\Program Files\MySQL Server 8.0\:String) [Set-Location], ItemNotFoundException
--     + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.SetLocationCommand

-- PS C:\Program Files> cd mysql
-- PS C:\Program Files\mysql> cd '.\MySQL Server 8.0\'
-- PS C:\Program Files\mysql\MySQL Server 8.0> cd bin
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u root -p
-- Enter password: *************
-- Welcome to the MySQL monitor.  Commands end with ; or \g.
-- Your MySQL connection id is 39
-- Server version: 8.0.41 MySQL Community Server - GPL

-- PS C:\Program Files> cd mysql
-- PS C:\Program Files\mysql> cd '.\MySQL Server 8.0\'
-- PS C:\Program Files\mysql\MySQL Server 8.0> cd bin
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u root -p
-- PS C:\Program Files> cd mysql
-- PS C:\Program Files\mysql> cd '.\MySQL Server 8.0\'
-- PS C:\Program Files> cd mysql
-- PS C:\Program Files> cd mysql
-- PS C:\Program Files\mysql> cd '.\MySQL Server 8.0\'
-- PS C:\Program Files\mysql\MySQL Server 8.0> cd bin
-- PS C:\Program Files> cd mysql
-- PS C:\Program Files> cd mysql
-- PS C:\Program Files> cd mysql
-- PS C:\Program Files\mysql> cd '.\MySQL Server 8.0\'
-- PS C:\Program Files\mysql\MySQL Server 8.0> cd bin
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u root -p       
-- Enter password: *************
-- Welcome to the MySQL monitor.  Commands end with ; or \g.
-- Your MySQL connection id is 39
-- Server version: 8.0.41 MySQL Community Server - GPL

-- Copyright (c) 2000, 2025, Oracle and/or its affiliates.

-- Oracle is a registered trademark of Oracle Corporation and/or its      
-- affiliates. Other names may be trademarks of their respective
-- owners.

-- Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

-- mysql> CREATE User "six"@"localhost" IDENTIFIED by "six";
-- Query OK, 0 rows affected (0.15 sec)

-- mysql> CREATE User "seven"@"localhost" IDENTIFIED by "seven";
-- Query OK, 0 rows affected (0.10 sec)

-- mysql> CREATE User "eight"@"localhost" IDENTIFIED by "eight";
-- Query OK, 0 rows affected (0.10 sec)

-- mysql> ALTER user "six"@"localhost" IDENTIFIED by "six123"
--     -> ;
-- Query OK, 0 rows affected (0.02 sec)

-- mysql> SELECT CURRENT_USER();
-- +----------------+
-- | CURRENT_USER() |
-- +----------------+
-- | root@localhost |
-- +----------------+
-- 1 row in set (0.05 sec)

-- mysql> SELECT User, Host FROM mysql.user;
-- +------------------+-----------+
-- | User             | Host      |
-- +------------------+-----------+
-- | Calvin           | %         |
-- | ROOT             | %         |
-- | calvin           | localhost |
-- | eight            | localhost |
-- | mysql.infoschema | localhost |
-- | mysql.session    | localhost |
-- | mysql.sys        | localhost |
-- | root             | localhost |
-- | seven            | localhost |
-- | six              | localhost |
-- +------------------+-----------+
-- 10 rows in set (0.00 sec)

-- mysql>
-- mysql> Rename user "six@localhost" to "demo"@"localhost";
-- ERROR 1396 (HY000): Operation RENAME USER failed for 'six@localhost'@'%'
-- mysql> exit
-- Bye
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u root -p
-- Enter password: *************
-- Welcome to the MySQL monitor.  Commands end with ; or \g.
-- Your MySQL connection id is 40
-- Server version: 8.0.41 MySQL Community Server - GPL

-- Copyright (c) 2000, 2025, Oracle and/or its affiliates.

-- Oracle is a registered trademark of Oracle Corporation and/or its      
-- mysql> Rename user 'six'@'localhost'to'demo'@'localhost';
-- Query OK, 0 rows affected (0.06 sec)

-- mysql> Rename user 'six'@'localhost'to'demo'@'localhost';alter user "seven"@"localhost" password expire;
-- ERROR 1396 (HY000): Operation RENAME USER failed for 'six'@'localhost'
-- ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ' expire' at line 1     
-- mysql> alter user "seven"@"localhost" password expire;
-- ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ' expire' at line 1     
-- mysql> alter user 'seven'@'localhost' password expire;
-- ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ' expire' at line 1     
-- mysql> alter user "seven"@"localhost" password expire;
-- ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ' expire' at line 1     
-- mysql> alter user 'seven'@'local' account lock;
-- ERROR 1396 (HY000): Operation ALTER USER failed for 'seven'@'local'
-- mysql> exit                                                  
-- Bye
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u six  -p
-- Enter password: ******
-- ERROR 1045 (28000): Access denied for user 'six'@'localhost' (using password: YES)
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u six  -p
-- Enter password: ******
-- ERROR 1045 (28000): Access denied for user 'six'@'localhost' (using password: YES)
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u six  -p
-- Enter password: ******
-- ERROR 1045 (28000): Access denied for user 'six'@'localhost' (using password: YES)
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u six  -p
-- Enter password: ******
-- ERROR 1045 (28000): Access denied for user 'six'@'localhost' (using password: YES)
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u six  -p
-- Enter password:     
-- ERROR 1045 (28000): Access denied for user 'six'@'localhost' (using password: NO)
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u six -p 
-- Enter password: ******
-- ERROR 1045 (28000): Access denied for user 'six'@'localhost' (using password: YES)
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u six -p
-- Enter password: 
-- ERROR 1045 (28000): Access denied for user 'six'@'localhost' (using password: NO)
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u demo -p
-- Enter password: ******
-- Welcome to the MySQL monitor.  Commands end with ; or \g.
-- Your MySQL connection id is 48
-- Server version: 8.0.41 MySQL Community Server - GPL

-- Copyright (c) 2000, 2025, Oracle and/or its affiliates.

-- Oracle is a registered trademark of Oracle Corporation and/or its
-- affiliates. Other names may be trademarks of their respective
-- owners.

-- Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

-- mysql> show database;
-- ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'database' at line 1
-- mysql> show databases;
-- +--------------------+
-- | Database           |
-- +--------------------+
-- | information_schema |
-- | performance_schema |
-- +--------------------+
-- 2 rows in set (0.05 sec)

-- mysql> exit
-- Bye
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u root -p
-- Enter password: *************
-- Welcome to the MySQL monitor.  Commands end with ; or \g.
-- Your MySQL connection id is 49
-- Server version: 8.0.41 MySQL Community Server - GPL

-- Copyright (c) 2000, 2025, Oracle and/or its affiliates.

-- Oracle is a registered trademark of Oracle Corporation and/or its
-- affiliates. Other names may be trademarks of their respective
-- owners.

-- Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

-- mysql> grant select, insert on cs.*to 'demo'@localhost';
--     '> grant select , insert on bscs2.*to 'demo'@localhost';
-- ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '';
-- grant select , insert on bscs2.*to 'demo'@localhost'' at line 1
-- mysql> grant select , insert on bscs2.* to 'demo'@localhost';
--     '> 
--     '> ;
--     '> /
--     '> grant select , insert on bscs2.*to 'demo'@localhost'; 
-- ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '';

-- ;
-- /
-- grant select , insert on bscs2.*to 'demo'@localhost'' at line 1
-- mysql> grant select , insert on bscs2.* to 'demo'@localhost';
--     '> exit
--     '> exit;
--     '> grant select , insert on bscs2.*to 'demo'@localhost'; 
-- ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '';
-- exit
-- exit;
-- grant select , insert on bscs2.*to 'demo'@localhost'' at line 1.
-- mysql> grant select , insert on BSCS2.* 'demo'@'localhost'; 
-- ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ''demo'@'localhost'' at line 1
-- mysql> grant select , insert on bscs2.* 'demo'@'localhost';
-- ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ''demo'@'localhost'' at line 1
-- mysql> grant select , insert on bscs2.* 'six'@'localhost'; 
-- ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ''six'@'localhost'' at line 1
-- mysql> exit
-- Bye
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u root -p
-- Enter password: *************
-- Welcome to the MySQL monitor.  Commands end with ; or \g.
-- Your MySQL connection id is 53
-- Server version: 8.0.41 MySQL Community Server - GPL

-- Copyright (c) 2000, 2025, Oracle and/or its affiliates.

-- Oracle is a registered trademark of Oracle Corporation and/or its
-- affiliates. Other names may be trademarks of their respective
-- owners.

-- Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

-- mysql> grant insert update select on *.* to 'seven'@'localhost';
-- ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'update select on *.* to 'seven'@'localhost'' at line 1
-- mysql> grant insert, update, select on *.* to 'seven'@'localhost';
-- Query OK, 0 rows affected (0.06 sec)

-- mysql> exit
-- Bye
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u seven -p
-- Enter password: *****
-- Welcome to the MySQL monitor.  Commands end with ; or \g.
-- Your MySQL connection id is 54
-- Server version: 8.0.41 MySQL Community Server - GPL

-- Copyright (c) 2000, 2025, Oracle and/or its affiliates.

-- Oracle is a registered trademark of Oracle Corporation and/or its
-- affiliates. Other names may be trademarks of their respective
-- owners.

-- Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

-- mysql> show databases;
-- +--------------------+
-- | Database           |
-- +--------------------+
-- | aircraftfmnt       |
-- | bscs               |
-- | bscs2              |
-- | class              |
-- | dreamhome          |
-- | farmersmarket      |
-- | information_schema |
-- | mysql              |
-- | performance_schema |
-- | sales              |
-- | school             |
-- | shop               |
-- | shop1              |
-- | sys                |
-- | tp1                |
-- | work2              |
-- +--------------------+
-- 16 rows in set (0.05 sec)

-- mysql> exit;
-- Bye
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u root -p
-- Enter password: *************
-- Welcome to the MySQL monitor.  Commands end with ; or \g.
-- Your MySQL connection id is 55
-- Server version: 8.0.41 MySQL Community Server - GPL

-- Copyright (c) 2000, 2025, Oracle and/or its affiliates.

-- Oracle is a registered trademark of Oracle Corporation and/or its
-- affiliates. Other names may be trademarks of their respective
-- owners.

-- Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

-- mysql> create user 'Ten'@'localhost' identified by 'Ten';
-- Query OK, 0 rows affected (0.07 sec)

-- mysql> grant select on bscs2.department to 'ten'@'localhost';
-- ERROR 1410 (42000): You are not allowed to create a user with GRANT
-- mysql> grant select on class.employee to 'ten'@'localhost';                                                          
-- ERROR 1410 (42000): You are not allowed to create a user with GRANT
-- mysql> grant select on class.employee to 'Ten'@'localhost';
-- Query OK, 0 rows affected (0.05 sec)

-- mysql> grant select on bscs2.department to 'Ten'@'localhost';
-- Query OK, 0 rows affected (0.05 sec)

-- mysql> grant select on bscs2.department to 'Ten'@'localhost';
-- Query OK, 0 rows affected (0.05 sec)

-- mysql> revoke select on class.employee from 'Ten'@'localhost';
-- Query OK, 0 rows affected (0.05 sec)

-- mysql> select current_user();
-- +----------------+
-- | current_user() |
-- +----------------+
-- | root@localhost |
-- +----------------+
-- 1 row in set (0.00 sec)

-- mysql> exit
-- Bye
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u demo -p
-- Enter password: ******
-- Welcome to the MySQL monitor.  Commands end with ; or \g.
-- Your MySQL connection id is 58
-- Server version: 8.0.41 MySQL Community Server - GPL

-- Copyright (c) 2000, 2025, Oracle and/or its affiliates.

-- Oracle is a registered trademark of Oracle Corporation and/or its
-- affiliates. Other names may be trademarks of their respective
-- owners.

-- Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

-- mysql> show databases;
-- +--------------------+
-- | Database           |
-- +--------------------+
-- | information_schema |
-- | performance_schema |
-- +--------------------+
-- 2 rows in set (0.00 sec)

-- mysql> exit;
-- Bye
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u Ten -p 
-- Enter password: ***
-- Welcome to the MySQL monitor.  Commands end with ; or \g.
-- Your MySQL connection id is 59
-- Server version: 8.0.41 MySQL Community Server - GPL

-- Copyright (c) 2000, 2025, Oracle and/or its affiliates.

-- Oracle is a registered trademark of Oracle Corporation and/or its
-- affiliates. Other names may be trademarks of their respective
-- owners.

-- Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

-- mysql> show databases;
-- +--------------------+
-- | Database           |
-- +--------------------+
-- | bscs2              |
-- | information_schema |
-- | performance_schema |
-- +--------------------+
-- 3 rows in set (0.00 sec)

-- mysql> use bscs2;
-- Database changed
-- mysql> select * from department;
-- +--------+------------+---------+----------+
-- | DeptNo | DName      | Loc     | Location |
-- +--------+------------+---------+----------+
-- |     10 | SALES      | KAMPALA | NULL     |
-- |     20 | IT         | KAMPALA | Kissai   |
-- |     30 | ACCOUNTING | MUKONO  | NULL     |
-- |     40 | MARKETING  | ENTEBBE | NULL     |
-- |     50 | SALES      | KAMPALA | BukotoL  |
-- |     60 | SALES      | KAMPALA | Nitnda   |
-- +--------+------------+---------+----------+
-- 6 rows in set (0.07 sec)

-- mysql> exit
-- Bye
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u root -p
-- Enter password: *************
-- Welcome to the MySQL monitor.  Commands end with ; or \g.
-- Your MySQL connection id is 60
-- Server version: 8.0.41 MySQL Community Server - GPL

-- Copyright (c) 2000, 2025, Oracle and/or its affiliates.

-- Oracle is a registered trademark of Oracle Corporation and/or its
-- affiliates. Other names may be trademarks of their respective
-- owners.

-- Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

-- mysql> show grants from 'root'@'localhost';
-- ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'from 'root'@'localhost'' at line 1
-- mysql> show grants for 'root'@'localhost'; 
-- +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
-- | Grants for root@localhost                                                                                                                                             
                                                                                                                                                                        
                                                                                                                                                                        
                                                                                                                                                                        
--                                                                                                |
-- +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
-- | GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, SHUTDOWN, PROCESS, FILE, REFERENCES, INDEX, ALTER, SHOW DATABASES, SUPER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER, CREATE TABLESPACE, CREATE ROLE, DROP ROLE ON *.* TO `root`@`localhost` WITH GRANT OPTION                                                                                                              
                                                                                                                                                                        
--                                                                                                |
-- | GRANT APPLICATION_PASSWORD_ADMIN,AUDIT_ABORT_EXEMPT,AUDIT_ADMIN,AUTHENTICATION_POLICY_ADMIN,BACKUP_ADMIN,BINLOG_ADMIN,BINLOG_ENCRYPTION_ADMIN,CLONE_ADMIN,CONNECTION_ADMIN,ENCRYPTION_KEY_ADMIN,FIREWALL_EXEMPT,FLUSH_OPTIMIZER_COSTS,FLUSH_STATUS,FLUSH_TABLES,FLUSH_USER_RESOURCES,GROUP_REPLICATION_ADMIN,GROUP_REPLICATION_STREAM,INNODB_REDO_LOG_ARCHIVE,INNODB_REDO_LOG_ENABLE,PASSWORDLESS_USER_ADMIN,PERSIST_RO_VARIABLES_ADMIN,REPLICATION_APPLIER,REPLICATION_SLAVE_ADMIN,RESOURCE_GROUP_ADMIN,RESOURCE_GROUP_USER,ROLE_ADMIN,SENSITIVE_VARIABLES_OBSERVER,SERVICE_CONNECTION_ADMIN,SESSION_VARIABLES_ADMIN,SET_USER_ID,SHOW_ROUTINE,SYSTEM_USER,SYSTEM_VARIABLES_ADMIN,TABLE_ENCRYPTION_ADMIN,TELEMETRY_LOG_ADMIN,XA_RECOVER_ADMIN ON *.* TO `root`@`localhost` WITH GRANT OPTION |
-- | GRANT PROXY ON ``@`` TO `root`@`localhost` WITH GRANT OPTION                                                                                                          
                                                                                                                                                                        
                                                                                                                                                                        
                                                                                                                                                                        
--                                                                                                |
-- +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
-- 3 rows in set (0.05 sec)

-- mysql> grant all on *.* to 'eight'@'localhost' with grant option;            
-- Query OK, 0 rows affected (0.05 sec)

-- mysql> show grants for 'eight'@'localhost';
-- +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
-- | Grants for eight@localhost                                                                                                                                            
                                                                                                                                                                        
                                                                                                                                                                        
                                                                                                                                                                        
--                                                                                                 |
-- +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
-- | GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, SHUTDOWN, PROCESS, FILE, REFERENCES, INDEX, ALTER, SHOW DATABASES, SUPER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER, CREATE TABLESPACE, CREATE ROLE, DROP ROLE ON *.* TO `eight`@`localhost` WITH GRANT OPTION                                                                                                             
                                                                                                                                                                        
--                                                                                                 |
-- | GRANT APPLICATION_PASSWORD_ADMIN,AUDIT_ABORT_EXEMPT,AUDIT_ADMIN,AUTHENTICATION_POLICY_ADMIN,BACKUP_ADMIN,BINLOG_ADMIN,BINLOG_ENCRYPTION_ADMIN,CLONE_ADMIN,CONNECTION_ADMIN,ENCRYPTION_KEY_ADMIN,FIREWALL_EXEMPT,FLUSH_OPTIMIZER_COSTS,FLUSH_STATUS,FLUSH_TABLES,FLUSH_USER_RESOURCES,GROUP_REPLICATION_ADMIN,GROUP_REPLICATION_STREAM,INNODB_REDO_LOG_ARCHIVE,INNODB_REDO_LOG_ENABLE,PASSWORDLESS_USER_ADMIN,PERSIST_RO_VARIABLES_ADMIN,REPLICATION_APPLIER,REPLICATION_SLAVE_ADMIN,RESOURCE_GROUP_ADMIN,RESOURCE_GROUP_USER,ROLE_ADMIN,SENSITIVE_VARIABLES_OBSERVER,SERVICE_CONNECTION_ADMIN,SESSION_VARIABLES_ADMIN,SET_USER_ID,SHOW_ROUTINE,SYSTEM_USER,SYSTEM_VARIABLES_ADMIN,TABLE_ENCRYPTION_ADMIN,TELEMETRY_LOG_ADMIN,XA_RECOVER_ADMIN ON *.* TO `eight`@`localhost` WITH GRANT OPTION |
-- +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
-- 2 rows in set (0.00 sec)

-- mysql> select current_user();   
-- +----------------+
-- | current_user() |
-- +----------------+
-- | root@localhost |
-- +----------------+
-- 1 row in set (0.00 sec)

-- mysql> create role Data_entrant;
-- Query OK, 0 rows affected (0.01 sec)

-- mysql> create role Data_manager;
-- Query OK, 0 rows affected (0.05 sec)

-- mysql> grant insert, select on bscs2.employee to Data_entrant;
-- Query OK, 0 rows affected (0.00 sec)

-- mysql> grant insert, select, update, delete on bscs2. employee to Data_manager;
-- Query OK, 0 rows affected (0.05 sec)

-- mysql> grant Data_entrant to 'demo'@'localhost';
-- Query OK, 0 rows affected (0.06 sec)

-- mysql> grant Data_manager to 'Ten'@'localhost';
-- Query OK, 0 rows affected (0.05 sec)

-- mysql> exit
-- Bye
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u Ten -p 
-- Enter password: ***
-- Welcome to the MySQL monitor.  Commands end with ; or \g.
-- Your MySQL connection id is 61
-- Server version: 8.0.41 MySQL Community Server - GPL

-- Copyright (c) 2000, 2025, Oracle and/or its affiliates.

-- Oracle is a registered trademark of Oracle Corporation and/or its
-- affiliates. Other names may be trademarks of their respective
-- owners.

-- Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

-- mysql> show databases;
-- +--------------------+
-- | Database           |
-- +--------------------+
-- | bscs2              |
-- | information_schema |
-- | performance_schema |
-- +--------------------+
-- 3 rows in set (0.05 sec)

-- mysql> use bscs2
-- Database changed
-- mysql> select* from employee;
-- ERROR 1142 (42000): SELECT command denied to user 'Ten'@'localhost' for table 'employee'
-- mysql> show tables;
-- +-----------------+
-- | Tables_in_bscs2 |
-- +-----------------+
-- | department      |
-- +-----------------+
-- 1 row in set (0.06 sec)

-- mysql> select* from mysql.role_edges;
-- ERROR 1142 (42000): SELECT command denied to user 'Ten'@'localhost' for table 'role_edges'
-- mysql> select * from employee;       
-- ERROR 1142 (42000): SELECT command denied to user 'Ten'@'localhost' for table 'employee'
-- mysql> show tables
--     -> ;
-- +-----------------+
-- | Tables_in_bscs2 |
-- +-----------------+
-- | department      |
-- +-----------------+
-- 1 row in set (0.00 sec)

-- mysql> exit;
-- Bye
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u eight -p
-- Enter password: *****
-- Welcome to the MySQL monitor.  Commands end with ; or \g.
-- Your MySQL connection id is 63
-- Server version: 8.0.41 MySQL Community Server - GPL

-- Copyright (c) 2000, 2025, Oracle and/or its affiliates.

-- Oracle is a registered trademark of Oracle Corporation and/or its
-- affiliates. Other names may be trademarks of their respective
-- owners.

-- Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

-- mysql> exit;
-- Bye
-- PS C:\Program Files\mysql\MySQL Server 8.0\bin> mysql -u root -p 
-- Enter password: *************
-- Welcome to the MySQL monitor.  Commands end with ; or \g.
-- Your MySQL connection id is 64
-- Server version: 8.0.41 MySQL Community Server - GPL

-- Copyright (c) 2000, 2025, Oracle and/or its affiliates.

-- Oracle is a registered trademark of Oracle Corporation and/or its
-- affiliates. Other names may be trademarks of their respective
-- owners.

-- Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

-- mysql> create user 'James'@'localhost' identified by 'James' pasword expire;
-- ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'pasword expire' at line 1
-- mysql> create user 'James'@'localhost' identified by 'James' password expire;
-- Query OK, 0 rows affected (0.12 sec)

-- mysql> GRANT SELECT, UPDATE(salary) ON bscs2.* TO 'James'@'localhost';
-- ERROR 1144 (42000): Illegal GRANT/REVOKE command; please consult the manual to see which privileges can be used
-- mysql> GRANT SELECT, UPDATE ON bscs2.* TO 'James'@'localhost';        
-- Query OK, 0 rows affected (0.05 sec)

-- mysql> revoke update(salary) on bscs2.* 'James'@'localhost';
-- ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ''James'@'localhost'' at line 1
-- mysql> revoke update(Salary) on bscs2.* 'James'@'localhost';
-- ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ''James'@'localhost'' at line 1
-- mysql> revoke update(Salary) on bscs2.employee 'James'@'localhost';
-- ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ''James'@'localhost'' at line 1
-- mysql>
-- mysql> revoke update(salary) on bscs2.employee from 'James'@'localhost';
-- ERROR 1147 (42000): There is no such grant defined for user 'James' on host 'localhost' on table 'employee'
-- mysql>