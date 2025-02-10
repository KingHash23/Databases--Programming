-- Active: 1738044664712@@localhost@3306@bscs
-- Active: 1738044664712@@localhost@3306@emp
use BSCS;
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


SELECT EmpNo, Ename, Job, Salary, 
       CASE 
           WHEN Job = 'teacher' THEN Salary * 1.12 
           WHEN Job = 'manager' THEN Salary * 1.05 
           WHEN Job = 'clerk' THEN Salary * 1.1 
           ELSE Salary * 1.08 
       END AS Salary_increment 
FROM employee;
 select * from employee;
update employee set Salary = case WHEN Job = 'clerk' THEN Salary*1.1
                                  WHEN Job = 'manager' THEN Salary*1.05
                                  WHEN Job = 'teacher' THEN Salary*1.15
                                  ELSE Salary*1.08 
                                  END;
SELECT* FROM employee;
 create table Doctor (DID varchar(50) primary key , Dname varchar(50) , Specifity varchar(50));
 INSERT into doctor VALUES('D001','Peter','ENT'),
                          ('D002','Mary','OPTICIAN'),
                          ('D003','John','UROLOGIST');
select* from doctor;

Create table Patient (PID varchar(50) primary key ,Address varchar(50), Gender char(1),DID varchar(50), constraint  Foreign Key (DID) REFERENCES Doctor(DID));
insert into patient VALUES ('P001','KLA','M','D001'),
                           ('P002','ENTEBBE','F','D002'),
                           ('P003','MASINDI','F','D003');

select* from patient;
-- neural join with Doctor and Patient
SELECT doctor.`DID`,doctor.`Specifity`,patient.`PID`,patient.`Gender` FROM doctor, patient WHERE doctor.`DID` = patient.`DID`;

-- create a view of the join above
CREATE VIEW doc_patient AS SELECT doctor.`DID`,doctor.`Specifity`,patient.`PID`,patient.`Gender` FROM doctor, patient WHERE doctor.`DID` = patient.`DID`;

-- display the view
 SELECT * FROM doc_patient;

-- perform a search operation in the view
SELECT * FROM doc_patient WHERE PID LIKE 'P00%';
-- perform a search operation in the view
 select d.*,p.* from doctor d, patient p WHERE d.`DID`= p.`DID`;
-- LEFT JOIN
 select d.*,p.* from doctor d LEFT JOIN patient p on d.`DID`= p.`DID`;
--  Right Joins
 select d.*,p.* from doctor d RIGHT JOIN patient p on d.`DID`= p.`DID`;
--  Full Joins
 select d.*,p.* from doctor d FULL JOIN patient p on d.`DID`= p.`DID`;

 select d.*,p.* from doctor d LEFT JOIN patient p on d.`DID`= p.`DID` WHERE p.`PID` IS NULL;

 select d.*,p.* from doctor d LEFT JOIN patient p on d.`DID`= p.`DID` WHERE p.`PID` IS NOT NULL;

