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

-- update employee salary
update employee  set Salary = 45000 WHERE EmpNo = 'E003';

create TABLE EMPX(eid VARCHAR(20), constraint empx_pk PRIMARY KEY (eid),
designation varchar(20) constraint empx_des check (designation in ('manager', 'clerk','teacher')),
Age int constraint empx_age check (Age>18),DOJ datetime DEFAULT CURRENT_TIMESTAMP, 
Gender varchar(1), Email varchar(20), telno int);
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


 
