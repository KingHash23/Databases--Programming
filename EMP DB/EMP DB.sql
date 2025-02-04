-- Active: 1738044664712@@localhost@3306@emp
use EMP;
Create Table Department(DeptNo int primary key , DName varchar (50), Loc varchar(50));
desc Department;
 Create table Employee(EmpNo int var primary key, EName varchar(50), Job varchar(50), Salary int, DeptNo int, foreign key(DeptNo) references Department(DeptNo));
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

