-- Active: 1738044664712@@localhost@3306@work2
Create DATABASE work2;
use work2;

CREATE TABLE Donation( DonorID varchar(50) PRIMARY KEY, 
                       Department varchar(50), Amount INT);
                       
INSERT INTO Donation VALUES('D/25', 'CT', 25000)
                         ,('D/67', 'SOT', 12000)
                         ,('D/45', 'CT', 15000)
                         ,('D/46', 'SOB',NULL)
                         ,('D/50', 'SOT', 11000);
select * FROM donation;
 delimiter /


--   Procedure1
    CREATE PROCEDURE Procedure1(id1 varchar(50))
    BEGIN
        SELECT MIN(Amount) AS Least_Amount_Received
        FROM Donation
        WHERE Department = id1 ;
    END /
    call Procedure1('CT')/


--  2. Procedure2  
    CREATE PROCEDURE Procedure2(id1 varchar(50))
    BEGIN
        SELECT Department, SUM(Amount) AS Total_Amount_Received
        FROM Donation
        WHERE Department = id1
        GROUP BY Department;
    END /
    call Procedure2('CT')/



--  3. Procedure3 
    CREATE PROCEDURE Procedure3()
    BEGIN
        DELETE FROM Donation
        WHERE Amount IS NULL OR Amount = 0;
    END /
    call Procedure3()/
    select * FROM donation;/


--  4.  Procedure4 .
    CREATE PROCEDURE Procedure4(id1 varchar(50), id2 varchar(50))
    BEGIN
        UPDATE Donation
        SET Department = id2
        WHERE Department = id1;
    END /
    call Procedure4('CT', 'CT_New')/
    SELECT * FROM Donation;/


--  5.Procedure5
    CREATE PROCEDURE Procedure5(id1 INT)
    BEGIN
        DELETE FROM Donation
        WHERE Amount < id1;
    END /
    call Procedure5(10000)/




--  6. Constraint Valid_departmentName.
    ALTER TABLE Donation
    ADD CONSTRAINT valid_departmentName CHECK (Department IN ('CT', 'SOT', 'SOB'));/



--  7.Constraint Valid_Amount.
    ALTER TABLE Donation ADD CONSTRAINT valid_amount CHECK (Amount BETWEEN 12000 AND 25000);/
    select * FROM donation;/


-- 8. Constraint Valid_DonorID.
    ALTER TABLE Donation ADD CONSTRAINT valid_donorID CHECK (DonorID REGEXP '^D[0-9]{3}$');/
    select * FROM donation;/

-- 9. Constraint Valid_sno.
    ALTER TABLE Department ADD CONSTRAINT valid_sno CHECK (SNO >= 4);/
    select * FROM department;/
desc donation;/


    

