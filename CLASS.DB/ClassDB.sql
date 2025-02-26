-- Active: 1738044664712@@localhost@3306@class
CREATE DATABASE CLASS;
use class;
CREATE table employee(
    EmployeeID int primary key AUTO_INCREMENT,
    FirstName varchar(50) NOT NULL,
    LastName varchar(50) NOT NULL,
    Age int constraint empy_Age check (Age>= 18),
    Email varchar(100) UNIQUE
);
insert INTO  Employee(FirstName, LastName, Age, Email) values 
 ('Obba', 'Mark', 22, 'oscar@gmail.com'),
 ('Mark', 'Timo', 23, 'mark@gmail.com'),
 ('Timo', 'Odongkara', 24, 'timo@gmail.com');
 select* FROM Employee;
--  drop constraint empy_Age.
 ALTER TABLE Employee DROP CONSTRAINT empy_Age;

alter table Employee ADD constraint empy_Age check (Age >=17);

-- Default constraint.
-- add a column DOJ and default constraint of datetime as current_timestamp.
 ALTER TABLE Employee ADD COLUMN DOJ DATETIME DEFAULT CURRENT_TIMESTAMP;
 --alter table Employee ADD COLUMN DOJ DATE DEFAULT CURRENT_DATE;
--  drop Default.
 ALTER TABLE Employee ALTER COLUMN DOJ DROP DEFAULT;
  ALTER TABLE employee DROP COLUMN DOJ ;
ALTER TABLE Employee ADD COLUMN DOJ DATETIME DEFAULT CURRENT_TIMESTAMP;
 
--  CHECK constraint.


--  UNQUE constraint.COMMENT it prevent duplicates.
 ALTER TABLE Employee ADD  COLUMN PhoneNO int UNIQUE(PhoneNo);
 -- drop unique constraint.

 desc employee;
 CREATE table Project(
    ProjectID int primary key AUTO_INCREMENT,
    ProjectName varchar(100) NOT NULL,
    EmployeeID int,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE ON UPDATE CASCADE
);
desc project;

select CONSTRAINT_NAME, CONSTRAINT_Type
 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
 WHERE TABLE_NAME = 'Employee';
 
 
 




 
