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

