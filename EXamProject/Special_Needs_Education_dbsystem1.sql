-- Active: 1738044664712@@localhost@3306@special_needs_education_dbsystem
CREATE DATABASE Special_Needs_Education_dbsystem; 

USE Special_Needs_Education_dbsystem;

-- Create Teacher table
CREATE TABLE Teacher (
    TID VARCHAR(10) PRIMARY KEY,
    CONSTRAINT chk_teacherID CHECK (TID LIKE 'T%'),
    TName VARCHAR(100) NOT NULL,
    T_Gender VARCHAR(1) NOT NULL,
    Constraint chk_teacher_Gender check(T_Gender ='M' or T_Gender ='F'),
    Specialization VARCHAR(100) NOT NULL,
    constraint chk_teacher_specs check (Specialization in ('visual impairment','hearing impairment','intellectual impairment','Autism','Dyslexia')),
    PhoneNo VARCHAR(10) NOT NULL UNIQUE,
    WorkEmail VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT chk_teacher_phone CHECK (PhoneNo REGEXP '^[0-9]{10}$'),
    CONSTRAINT chk_teacher_email CHECK (WorkEmail REGEXP '^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}$')
);
Desc Teacher;

-- Create Guardian table
CREATE TABLE Guardian (
    GID VARCHAR(10) PRIMARY KEY
    CONSTRAINT chk_guardianID CHECK (GID LIKE 'G%'),
    GF_Name VARCHAR(50) NOT NULL,
    GL_Name VARCHAR(50) NOT NULL,
    PhoneNo VARCHAR(10) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Relationship VARCHAR(50) NOT NULL,
    CONSTRAINT chk_guardian_relationship CHECK (Relationship IN ('Parent','Sibling','other')),
    CONSTRAINT chk_guardian_phone CHECK (PhoneNo REGEXP '^[0-9]{10}$'),
    CONSTRAINT chk_guardian_email CHECK (Email REGEXP '^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}$')
);
Desc guardian;


-- Create Student table
CREATE TABLE Student (
    StID VARCHAR(10) PRIMARY KEY
    CONSTRAINT chk_studentID CHECK (StID LIKE 'S%'),
    StName VARCHAR(100) NOT NULL,
    DOB DATE NOT NULL,
    St_Gender VARCHAR(1) NOT NULL,
    Constraint chk_student_gender CHECK (St_Gender ='M' or St_Gender ='F'),
    Disability_Type VARCHAR(100) NOT NULL,
    CONSTRAINT chk_student_disability CHECK (Disability_Type IN ('visual impairment','hearing impairment','intellectual impairment','Autism','Dyslexia')),
    GID VARCHAR(10) NOT NULL,
    TID VARCHAR(10) NOT NULL,
    FOREIGN KEY (GID) REFERENCES Guardian(GID),
    FOREIGN KEY (TID) REFERENCES Teacher(TID)
   
);
Desc student;


-- Create Subjects table
CREATE TABLE Subjects (
    SubID VARCHAR(10) PRIMARY KEY,
     CONSTRAINT chk_subjectID CHECK (SubID LIKE 'S%'),
    SubjectName VARCHAR(100) NOT NULL,
    description VARCHAR(50) NOT NULL,
    TID VARCHAR(10) NOT NULL,
    FOREIGN KEY (TID) REFERENCES Teacher(TID)
);
Desc subjects;




-- Create Learning_plan table
CREATE TABLE Learning_plan (
    PID VARCHAR(10) PRIMARY KEY,
    CONSTRAINT chk_planID CHECK (PID LIKE 'P%'),
    P_Name VARCHAR(100) NOT NULL UNIQUE, 
    Plan_details TEXT NOT NULL,
    Created_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    SubID VARCHAR(10) NOT NULL,
    StID VARCHAR(10) NOT NULL,
    TID VARCHAR(10) NOT NULL,
    FOREIGN KEY (StID) REFERENCES Student(StID),
    FOREIGN KEY (TID) REFERENCES Teacher(TID),
    FOREIGN KEY (SubID) REFERENCES Subjects(SubID)
);
Desc  learning_plan;



-- Create Assessment table
CREATE TABLE Assessment (
    AID VARCHAR(10) PRIMARY KEY,
    CONSTRAINT chk_assessmentID CHECK (AID LIKE 'A%'),
    Grade VARCHAR(2) NOT NULL,
    CONSTRAINT chk_grade CHECK (Grade IN ('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'F')),
    Remark TEXT,
    DateTaken DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    StID VARCHAR(10) NOT NULL,
    TID VARCHAR(10) NOT NULL,
    SubID VARCHAR(10) NOT NULL,
    FOREIGN KEY (StID) REFERENCES Student(StID),
    FOREIGN KEY (TID) REFERENCES Teacher(TID),
    FOREIGN KEY (SubID) REFERENCES Subjects(SubID)
);
desc assessment;

-- Create Accessibility_Request table
CREATE TABLE Accessibility_Request (
    RID VARCHAR(10) PRIMARY KEY,
    CONSTRAINT chk_requestID CHECK (RID LIKE 'R%'),
    RequestType VARCHAR(100) NOT NULL,
    RequestStatus VARCHAR(50) NOT NULL DEFAULT 'Pending',
    CONSTRAINT chk_request_status CHECK (RequestStatus IN ('Pending', 'Approved', 'Denied')),
    SubmissionDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    StID VARCHAR(10) NOT NULL,
    TID VARCHAR(10) NOT NULL,
    SubID VARCHAR(10) NOT NULL,
    FOREIGN KEY (StID) REFERENCES Student(StID),
    FOREIGN KEY (TID) REFERENCES Teacher(TID),
    FOREIGN KEY (SubID) REFERENCES Subjects(SubID)
);
Desc accessibility_request;


-- Logs
--  Teacher logs:
CREATE TABLE Teacher_Log (
    Log_ID INT AUTO_INCREMENT PRIMARY KEY,
    TID VARCHAR(10),
    TName VARCHAR(100),
    ActionType VARCHAR(50) NOT NULL,
    constraint chk_Teacher_actiontype check (ActionType in ('INSERT', 'UPDATE', 'DELETE')),
    ActionTimes TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    performedBy VARCHAR(100) NOT NULL,
    FOREIGN KEY (TID) REFERENCES Teacher(TID)
); 


-- Trigger for Teacher logs.
DELIMITER //

CREATE TRIGGER trg_teacher_log
AFTER INSERT ON Teacher
FOR EACH ROW
BEGIN
    INSERT INTO Teacher_Log (TID, TName, ActionType, PerformedBy)
    VALUES (NEW.TID, NEW.TName, 'INSERT', USER());
END;
//


DELIMITER //
CREATE TRIGGER trg_teacher_update
AFTER UPDATE ON Teacher
FOR EACH ROW
BEGIN
    INSERT INTO Teacher_Log (TID, TName, ActionType, PerformedBy)
    VALUES (NEW.TID, NEW.TName, 'UPDATE', USER());

END;
//
drop Trigger trg_teacher_update;

DELIMITER //
CREATE TRIGGER trg_teacher_delete
AFTER DELETE ON Teacher
FOR EACH ROW
BEGIN
    INSERT INTO Teacher_Log (TID, TName, ActionType, PerformedBy)
    VALUES (OLD.TID, OLD.TName, 'DELETE', USER());
END;
//

-- Assessment Logs:
DELIMITER ;
CREATE TABLE Assessment_Log (
    LID INT(10)  AUTO_INCREMENT PRIMARY KEY,
    AID VARCHAR(10) NOT NULL,
    StID VARCHAR(10) NOT NULL,
    TID VARCHAR(10) NOT NULL,
    SubID VARCHAR(10) NOT NULL,
    ActionType VARCHAR(50) NOT NULL
    constraint chk_assessment_actiontype check (ActionType in ('INSERT', 'UPDATE', 'DELETE')),
    ActionTimestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PerformedBy VARCHAR(100) NOT NULL,  -- Stores who made the changes
    FOREIGN KEY (AID) REFERENCES Assessment(AID) ON DELETE CASCADE,
    FOREIGN KEY (StID) REFERENCES Student(StID),
    FOREIGN KEY (TID) REFERENCES Teacher(TID),
    FOREIGN KEY (SubID) REFERENCES Subjects(SubID)
);

-- Trigger for the Assessment_Log
DELIMITER //

CREATE TRIGGER trg_assessment_log
AFTER INSERT ON Assessment
FOR EACH ROW
BEGIN
    INSERT INTO Assessment_Log (AID, StID, TID, SubID, ActionType, PerformedBy)
    VALUES (NEW.AID, NEW.StID, NEW.TID, NEW.SubID, 'INSERT', USER());
END;
//

DELIMITER //
CREATE TRIGGER trg_assessment_update
AFTER UPDATE ON Assessment
FOR EACH ROW
BEGIN
    INSERT INTO Assessment_Log (AID, StID, TID, SubID, ActionType, PerformedBy)
    VALUES (NEW.AID, NEW.StID, NEW.TID, NEW.SubID, 'UPDATE', USER());
END;
//

CREATE TRIGGER trg_assessment_delete
AFTER DELETE ON Assessment
FOR EACH ROW
BEGIN
    INSERT INTO Assessment_Log (AID, StID, TID, SubID, ActionType, PerformedBy)
    VALUES (OLD.AID, OLD.StID, OLD.TID, OLD.SubID, 'DELETE', USER());
END;
//

-- Before triggers.
-- Ensure Teacher's Email Domain is Institutional.
DELIMITER //
CREATE TRIGGER before_teacher_insert
BEFORE INSERT ON Teacher
FOR EACH ROW
BEGIN
    IF NEW.WorkEmail NOT LIKE '%@iac.ac' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Teacher email must be an institutional email (@iac.iac)';
    END IF;
END;
//
--  Validate Phone Number Format (Guardians)
DELIMITER //
CREATE TRIGGER before_teacher_phone_insert
BEFORE INSERT ON Teacher
FOR EACH ROW
BEGIN
    IF NEW.PhoneNo NOT REGEXP '^[0-9]{10}$' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Invalid phone number! Must be exactly 10 digits.';
    END IF;
END;
//

--  inserting data
-- Teacher Table
INSERT INTO Teacher (TID, TName, T_Gender, Specialization, PhoneNo, WorkEmail) VALUES
     ('T001', 'Enos Peter ', 'M', 'visual impairment', '0734567890', 'enosp@iac.ac'),
     ('T002', 'Oketa Pual', 'M', 'hearing impairment', '0745678901', 'oketapeter@iac.ac'),
     ('T003', 'Ann Akum', 'F', 'intellectual impairment', '0756789012', 'annakum12@iac.ac'),
     ('T004', 'Buwembo David', 'M', 'Autism', '0767890123', 'david12@iac.ac'),
     ('T005', 'Apio Alice', 'F', 'Dyslexia', '0778901234', 'apio23@iac.ac'),
     ('T006', 'Obba Mark', 'M', 'visual impairment', '0789012345', 'obba23@iac.ac'),
     ('T007', 'Acheng Grace ', 'F', 'hearing impairment', '0790123456', 'grace45@iac.ac'),
     ('T008', ' Ssendi Henry', 'M', 'intellectual impairment', '0701234567', 'henryssendi@iac.ac'),
     ('T009', 'Nakayike Sandra ', 'F', 'Autism', '0712345678', 'sandra@iac.ac'),
     ('T010', 'Moro Yafes', 'M', 'Dyslexia', '0723456789', 'moro19@iac.ac'),
     ('T011', 'Amoding Kelly', 'F', 'visual impairment', '0722334455', 'kellyamoding@iac.ac'),
     ('T012', 'Mukwaya Ashlyn', 'M', 'hearing impairment', '0733445566', 'ashlyn@iac.ac'),
     ('T013', 'Anena Prossy', 'F', 'intellectual impairment', '0744556677', 'prossy@iac.ac'),
     ('T014', 'Anebo King', 'M', 'Autism', '0755667788', 'king@iac.ac'),
     ('T015', 'Akot Mercy', 'F', 'Dyslexia', '0766778899', 'akotmey@iac.ac');
select*FROM teacher;

-- Guardian Table

INSERT INTO Guardian (GID, GF_Name, GL_Name, PhoneNo, Email, Relationship) VALUES
    ('G001', 'Muboolo', 'Chris', '0734567890', 'muboolo@gmail.com', 'Parent'),
    ('G002', 'Muboogo', 'Smith', '0745678901', 'musmith12@gmail.com', 'Parent'),
    ('G003', 'Guye', 'Malith', '0756789012', 'malith@yahoo.com', 'Sibling'),
    ('G004', 'Deng', 'Akot', '0767890123', 'denakot@hotmail.com', 'Parent'),
    ('G005', 'Okoth', 'Joan', '0778901234', 'okoth2003@gmail.com', 'Parent'),
    ('G006', 'Abala', 'Sharon', '0789012345', 'abala@yahoo.com', 'Sibling'),
    ('G007', 'Mark', 'Peter', '0790123456', 'markpeter1738@gmail.com', 'Parent'),
    ('G008', 'Lwasa', 'Laura', '0701234567', 'laura@hotmail.com', 'Parent'),
    ('G009', 'Kiwanuka', 'Johnbosco', '0712345678', 'jbjoahn@yahoo.com', 'other'),
    ('G010', 'Kimuli', 'Sarah', '0723456789', 'sarah@gmail.com', 'Parent'),
    ('G011', 'Akumu', 'Prossy', '0722334455', 'prossy23@hotmail.com', 'Parent'),
    ('G012', 'Namaganda', 'Nancy', '0733445566', 'nancy2001@yahoo.com', 'Sibling'),
    ('G013', 'Nsubuga', 'Jacob', '0744556677', 'jacob25@gmail.com', 'Parent'),
    ('G014', 'Amotti', 'King', '0755667788', 'kingi@hotmail.com', 'Parent'),
    ('G015', 'Musoke', 'Brain', '0766778899', 'musokebr123@yahoo.com', 'Parent');
    select*FROM guardian;

-- students
INSERT INTO Student (StID, StName, DOB, St_Gender, Disability_Type, GID, TID) VALUES
    ('S001', 'Najuma Topista', '2010-05-15', 'F', 'visual impairment', 'G001', 'T001'),
    ('S002', 'Mutebi Jonna', '2011-08-20', 'M', 'hearing impairment', 'G002', 'T002'),
    ('S003', 'Appofia Stella', '2012-03-10', 'F', 'intellectual impairment', 'G003', 'T003'),
    ('S004', 'Lukwago Fahad', '2010-11-25', 'M', 'Autism', 'G004', 'T004'),
    ('S005', 'Namara Daniella', '2013-07-30', 'F', 'Dyslexia', 'G005', 'T005'),
    ('S006', 'Ssonko Anorld', '2011-01-12', 'M', 'visual impairment', 'G006', 'T006'),
    ('S007', 'Olivia Davis', '2012-09-05', 'F', 'hearing impairment', 'G007', 'T007'),
    ('S008', 'Sselemba Horris', '2010-04-18', 'M', 'intellectual impairment', 'G008', 'T008'),
    ('S009', 'Laker Petra', '2013-02-22', 'F', 'Autism', 'G009', 'T009'),
    ('S010', 'Ochen Joshua', '2011-06-14', 'M', 'Dyslexia', 'G010', 'T010'),
    ('S011', 'Zinda Zahara', '2012-12-01', 'F', 'visual impairment', 'G011', 'T011'),
    ('S012', 'Onen Andrew', '2010-10-08', 'M', 'hearing impairment', 'G012', 'T012'),
    ('S013', 'Akuma Lisa', '2013-03-17', 'F', 'intellectual impairment', 'G013', 'T013'),
    ('S014', 'Odongo Frank', '2011-07-29', 'M', 'Autism', 'G014', 'T014'),
    ('S015', 'Stella Mary', '2012-05-23', 'F', 'Dyslexia', 'G015', 'T015'),
    ('S016', 'Musa Olivia', '2010-01-15', 'F', 'Dyslexia', 'G001','T005'),
    ('S017', 'Chukwuka Omolo', '2011-05-20', 'M', 'hearing impairment', 'G012','T007'),
    ('S018', 'Felicia Nadia', '2012-09-10', 'F', 'intellectual impairment', 'G010','T008'),
    ('S019', 'Kamau Kemba', '2010-04-25', 'M', 'Autism', 'G001','T014'),
    ('S020', 'Somu Amara', '2013-02-28', 'F', 'Dyslexia', 'G001','T005');
    select*FROM student;


-- subjects
INSERT INTO Subjects (SubID, SubjectName, description, TID) VALUES
    ('Sub001', 'Math for Visual Impairment', 'Adapted math curriculum', 'T001'),
    ('Sub002', 'Sign Language Basics', 'Intro to sign language', 'T002'),
    ('Sub003', 'Cognitive Skills', 'Skill-building exercises', 'T003'),
    ('Sub004', 'Social Skills for Autism', 'Social interaction lessons', 'T004'),
    ('Sub005', 'Reading for Dyslexia', 'Phonics and comprehension', 'T005'),
    ('Sub006', 'Braille Literacy', 'Braille reading and writing', 'T006'),
    ('Sub007', 'Hearing Aid Tech', 'Tech for hearing support', 'T007'),
    ('Sub008', 'Life Skills', 'Daily living skills', 'T008'),
    ('Sub009', 'Behavioral Therapy', 'Therapy for autism', 'T009'),
    ('Sub010', 'Writing for Dyslexia', 'Adapted writing skills', 'T010'),
    ('Sub011', 'Visual Art Therapy', 'Art for visual impairment', 'T011'),
    ('Sub012', 'Speech Therapy', 'Speech improvement', 'T012'),
    ('Sub013', 'Problem Solving', 'Logic and reasoning', 'T013'),
    ('Sub014', 'Emotional Regulation', 'Managing emotions', 'T014'),
    ('Sub015', 'Spelling for Dyslexia', 'Spelling techniques', 'T015'),
    ('Sub016', 'Reading for Dyslexia', 'Phonics and comprehension', 'T010'),
    ('Sub017', 'Writing for Dyslexia', 'Adapted writing skills', 'T005'),
    ('Sub018', 'Visual Art Therapy', 'Art for visual impairment', 'T001'),
    ('Sub019', 'Speech Therapy', 'Speech improvement', 'T009'),
    ('Sub020', 'Problem Solving', 'Logic and reasoning', 'T008'),
    ('Sub021', 'Emotional Regulation', 'Managing emotions', 'T004');
select*FROM subjects;

-- Learniing PLan
INSERT INTO Learning_plan (PID, P_Name, Plan_details, Created_date, SubID, StID, TID) VALUES
    ('P001', 'Visual Math Plan', 'Custom math exercises', '2025-01-01 10:00:00', 'Sub001', 'S001', 'T001'),
    ('P002', 'Sign Language Plan', 'Daily sign practice', '2025-01-02 12:00:00', 'Sub002', 'S002', 'T002'),
    ('P003', 'Cognitive Plan', 'Memory games', '2025-01-03 09:00:00', 'Sub003', 'S003', 'T003'),
    ('P004', 'Social Skills Plan', 'Group activities', '2025-01-04 14:00:00', 'Sub004', 'S004', 'T004'),
    ('P005', 'Dyslexia Reading Plan', 'Phonics drills', '2025-01-05 11:00:00', 'Sub005', 'S005', 'T005'),
    ('P006', 'Braille Plan', 'Braille alphabet practice', '2025-01-06 13:00:00', 'Sub006', 'S006', 'T006'),
    ('P007', 'Hearing Plan', 'Audio exercises', '2025-01-07 15:00:00', 'Sub007', 'S007', 'T007'),
    ('P008', 'Life Skills Plan', 'Cooking lessons', '2025-01-08 10:00:00', 'Sub008', 'S008', 'T008'),
    ('P009', 'Behavioral Plan', 'Reward system', '2025-01-09 12:00:00', 'Sub009', 'S009', 'T009'),
    ('P010', 'Writing Plan', 'Handwriting practice', '2025-01-10 14:00:00', 'Sub010', 'S010', 'T010'),
    ('P011', 'Art Therapy Plan', 'Painting exercises', '2025-01-11 09:00:00', 'Sub011', 'S011', 'T011'),
    ('P012', 'Speech Plan', 'Vocal exercises', '2025-01-12 11:00:00', 'Sub012', 'S012', 'T012'),
    ('P013', 'Problem Solving Plan', 'Puzzles', '2025-01-13 13:00:00', 'Sub013', 'S013', 'T013'),
    ('P014', 'Emotion Plan', 'Calming techniques', '2025-01-14 15:00:00', 'Sub014', 'S014', 'T014'),
    ('P015', 'Spelling Plan', 'Word games', '2025-01-15 10:00:00', 'Sub015', 'S015', 'T015');
select*FROM learning_plan;


INSERT INTO Accessibility_Request (RID, RequestType, RequestStatus, SubmissionDate, StID, TID, SubID) VALUES
    ('R001', 'Braille Materials', 'Approved', '2025-03-01 10:00:00', 'S001', 'T001', 'Sub001'),
    ('R002', 'Sign Language Interpreter', 'Pending', '2025-03-02 12:00:00', 'S002', 'T002', 'Sub002'),
    ('R003', 'Extra Time', 'Approved', '2025-03-03 09:00:00', 'S003', 'T003', 'Sub003'),
    ('R004', 'Quiet Room', 'Denied', '2025-03-04 14:00:00', 'S004', 'T004', 'Sub004'),
    ('R005', 'Text-to-Speech Software', 'Approved', '2025-03-05 11:00:00', 'S005', 'T005', 'Sub005'),
    ('R006', 'Large Print Books', 'Pending', '2025-03-06 13:00:00', 'S006', 'T006', 'Sub006'),
    ('R007', 'Hearing Aid Adjustment', 'Approved', '2025-03-07 15:00:00', 'S007', 'T007', 'Sub007'),
    ('R008', 'Visual Aids', 'Denied', '2025-03-08 10:00:00', 'S008', 'T008', 'Sub008'),
    ('R009', 'Sensory Tools', 'Approved', '2025-03-09 12:00:00', 'S009', 'T009', 'Sub009'),
    ('R010', 'Speech-to-Text Software', 'Pending', '2025-03-10 14:00:00', 'S010', 'T010', 'Sub010'),
    ('R011', 'Color Overlays', 'Approved', '2025-03-11 09:00:00', 'S011', 'T011', 'Sub011'),
    ('R012', 'Audio Recordings', 'Denied', '2025-03-12 11:00:00', 'S012', 'T012', 'Sub012'),
    ('R013', 'Extended Breaks', 'Approved', '2025-03-13 13:00:00', 'S013', 'T013', 'Sub013'),
    ('R014', 'Fidget Tools', 'Pending', '2025-03-14 15:00:00', 'S014', 'T014', 'Sub014'),
    ('R015', 'Digital Worksheets', 'Approved', '2025-03-15 10:00:00', 'S015', 'T015', 'Sub015');
select*FROM accessibility_request;

-- Assessment
INSERT INTO Assessment (AID, Grade, Remark, DateTaken, StID, TID, SubID) VALUES
('A001', 'A', 'Excellent progress', '2025-02-01 10:00:00', 'S001', 'T001', 'Sub001'),
('A002', 'B+', 'Good effort', '2025-02-02 12:00:00', 'S002', 'T002', 'Sub002'),
('A003', 'B', 'Needs focus', '2025-02-03 09:00:00', 'S003', 'T003', 'Sub003'),
('A004', 'A-', 'Great teamwork', '2025-02-04 14:00:00', 'S004', 'T004', 'Sub004'),
('A005', 'A+', 'Outstanding', '2025-02-05 11:00:00', 'S005', 'T005', 'Sub005'),
('A006', 'B-', 'Improving', '2025-02-06 13:00:00', 'S006', 'T006', 'Sub006'),
('A007', 'C+', 'More practice needed', '2025-02-07 15:00:00', 'S007', 'T007', 'Sub007'),
('A008', 'A', 'Consistent effort', '2025-02-08 10:00:00', 'S008', 'T008', 'Sub008'),
('A009', 'B+', 'Positive attitude', '2025-02-09 12:00:00', 'S009', 'T009', 'Sub009'),
('A010', 'A-', 'Good improvement', '2025-02-10 14:00:00', 'S010', 'T010', 'Sub010'),
('A011', 'B', 'Creative work', '2025-02-11 09:00:00', 'S011', 'T011', 'Sub011'),
('A012', 'C', 'Needs support', '2025-02-12 11:00:00', 'S012', 'T012', 'Sub012'),
('A013', 'A+', 'Exceptional', '2025-02-13 13:00:00', 'S013', 'T013', 'Sub013'),
('A014', 'B+', ' Steady progress', '2025-02-14 15:00:00', 'S014', 'T014', 'Sub014'),
('A015', 'A', 'Strong spelling', '2025-02-15 10:00:00', 'S015', 'T015', 'Sub015'),
('A016', 'B-', 'Needs more practice', '2025-02-16 11:00:00', 'S016' ,'T005', 'Sub005'),
('A017', 'B+', 'Steady progress', '2025-02-17 13:00:00', 'S017','T007', 'Sub007'),
('A018', 'C-', 'Needs more support', '2025-02-18 15:00:00', 'S018','T008', 'Sub020'),
('A019', 'C+', 'Excellent progress', '2025-02-19 10:00:00', 'S019','T014', 'Sub014'),
('A020', 'B-', 'Needs improvement', '2025-02-20 11:00:00', 'S020','T005', 'Sub005');
select* from assessment;

DELIMITER ;
--  Testing the assessment_log trigger.
INSERT INTO Assessment (AID, Grade, Remark, DateTaken, StID, TID, SubID) VALUES
    ('A021', 'A+', 'Outstanding', '2025-02-21 11:00:00', 'S020','T005','Sub005');

DELIMITER ;

-- Testing the above trigger trg_assessment_update .
UPDATE Assessment SET Grade = 'A+' WHERE AID = 'A015';
    
DELIMITER ;
-- Testing the above trigger trg_assessment_delete .
 DELETE FROM Assessment WHERE AID = 'A023';





DELIMITER ;
-- testing
INSERT INTO Teacher (TID, TName, T_Gender, Specialization, PhoneNo, WorkEmail) VALUES 
    ('T016', 'Atomic alvin', 'M', 'visual impairment', '0789109404', 'alvin@iac.ac');

INSERT INTO Teacher (TID, TName, T_Gender, Specialization, PhoneNo, WorkEmail) VALUES 
    ('T017', 'Atomixs alvin', 'M', 'hearing impairment', '0789109489', 'atomixs@gmail.ac');


DELIMITER ;
INSERT INTO Teacher (TID, TName, T_Gender, Specialization, PhoneNo, WorkEmail) VALUES 
    ('T018', 'Kakembo alvin', 'M', 'intellectual impairment', '078910948', 'kakembo@iac.ac');


-- Views
-- 1 Assessment report.
CREATE VIEW Assessment_Report AS
SELECT s.stName AS StName,sub.SubjectName,a.Grade,a.DateTaken,tName AS Assessed_By
FROM  Assessment a JOIN Student s ON a.StID = s.StID
JOIN  Subjects sub ON a.SubID = sub.SubID JOIN Teacher t ON a.TID = t.TID;

SELECT * FROM assessment_report;

-- 2 Show each teacher with their assigned subjects and their number of students assigned. (inner join)
CREATE VIEW Assessment_Summary AS
SELECT a.AID,s.StName,sub.SubjectName,a.Grade,a.DateTaken
FROM Assessment a
JOIN Student s ON a.StID = s.StID
JOIN Subjects sub ON a.SubID = sub.SubID;
SELECT * FROM Assessment_Summary;

-- 3. Shows requests made by students and their current approval status. (inner join)
CREATE VIEW Accessibility_Status AS
SELECT ar.RID,s.StName,ar.RequestType,ar.RequestStatus,ar.SubmissionDate
FROM Accessibility_Request ar
JOIN Student s ON ar.StID = s.StID;
select * from accessibility_status;

-- 4. Shows the number of students assigned to each teacher. (left join)
CREATE VIEW Teacher_Student_Count AS
SELECT t.TID,t.TName,t.Specialization,COUNT(s.StID) AS NumberOfStudents
FROM Teacher t
LEFT JOIN Student s ON s.TID = t.TID
GROUP BY t.TID, t.TName, t.Specialization;
SELECT * FROM teacher_student_count;

-- 5 Lists students along with their guardian names and contact info in case of an emergency. (inner join)
CREATE VIEW Student_Guardian_Contact AS
SELECT s.StName,g.GF_Name,g.GL_Name,g.PhoneNo,g.Email,g.Relationship
FROM Student s
JOIN Guardian g ON s.GID = g.GID;
select * FROM student_guardian_contact;

-- 6. Students with their assessments
CREATE VIEW Student_Assessment_FullView AS
SELECT s.StID, s.StName, a.AID, a.Grade, a.DateTaken
FROM Student s LEFT JOIN Assessment a ON s.StID = a.StID
UNION
SELECT s.StID, s.StName, a.AID, a.Grade, a.DateTaken
FROM Assessment a RIGHT JOIN Student s ON s.StID = a.StID;
select * from student_assessment_fullview;

-- select statements
-- List all students with a pending accessibility request:
SELECT StName
FROM Student s
JOIN Accessibility_Request ar ON s.StID = ar.StID
WHERE ar.RequestStatus = 'Pending';

-- Learning plans for a specific student
SELECT s.StName, sub.SubjectName, lp.P_Name
FROM Learning_Plan lp
JOIN Student s ON lp.StID = s.StID
JOIN Subjects sub ON lp.SubID = sub.SubID
WHERE s.StID = 'S005';


-- Stored Procedures.

-- Procedure that Retrieves all pending accessibility requests
DELIMITER /
CREATE PROCEDURE GetPendingRequests()
BEGIN
    SELECT ar.RID, ar.RequestType, ar.StID, s.StName AS StudentName, ar.TID, ar.SubID, ar.SubmissionDate
    FROM Accessibility_Request ar
    JOIN Student s ON ar.StID = s.StID
    WHERE ar.RequestStatus = 'Pending';
END /
DELIMITER ;

-- Update Guadians's Phone number.
DELIMITER /
CREATE PROCEDURE UpdateGuardianPhone(IN g_GID VARCHAR(10), IN g_NewPhoneNo VARCHAR(10))
BEGIN
    UPDATE Guardian
    SET PhoneNo = g_NewPhoneNo
    WHERE GID = g_GID;
END /
DELIMITER ;

-- Recored Assessments.
DELIMITER /
CREATE PROCEDURE RecordAssessment(
    IN p_AID VARCHAR(10), IN p_Grade VARCHAR(2), IN p_Remark TEXT, IN p_SubmissionDate DATETIME,
    IN p_StID VARCHAR(10), IN p_TID VARCHAR(10), IN p_SubID VARCHAR(10)
)
BEGIN
    INSERT INTO Assessment (AID, Grade, Remark, StID, TID, SubID)
    VALUES (p_AID, p_Grade, p_Remark, p_StID, p_TID, p_SubID);
END /
DELIMITER ;

-- CountStudentsByTeacher
DELIMITER /
CREATE PROCEDURE CountStudentsByTeacher(IN p_TID VARCHAR(10))
BEGIN
    SELECT COUNT(*) AS StudentCount
    FROM Student
    WHERE TID = p_TID;
END /
DELIMITER ;

--   Deletes a specific learning plan by its ID.
DELIMITER /
CREATE PROCEDURE DeleteLearningPlan(IN p_PID VARCHAR(10))
BEGIN
    DELETE FROM Learning_plan
    WHERE PID = p_PID;
END /
DELIMITER ;


-- call the procedures
call GetPendingRequests();
CALL UpdateGuardianPhone('G001', '0789109489');
CALL RecordAssessment('A023', 'A', 'Excellent Progress', '2025-02-12 11:00:00', 'S012', 'T012', 'Sub012');
CALL CountStudentsByTeacher('T005');
CALL DeleteLearningPlan('P001');


-- Creating User acounts and the roles
SELECT User, Host FROM mysql.user;


-- Create the users
CREATE USER 'Admin'@'localhost' IDENTIFIED BY 'Admin';
CREATE USER 'Teacher'@'localhost' IDENTIFIED BY 'Teacher';
CREATE USER 'Guardian'@'localhost' IDENTIFIED BY 'Guardian';
-- Create the role
CREATE ROLE 'AdminRole';

-- Grant privileges to the role
GRANT ALL PRIVILEGES ON Special_Needs_Education_dbsystem.* TO 'Admin_Role';
GRANT SELECT,INSERT, UPDATE, DELETE ON Special_Needs_Education_dbsystem.* TO 'Teacher_Role';
GRANT SELECT ON Special_Needs_Education_dbsystem.* TO 'Guardian_Role';


-- assigning the roles to  users

GRANT 'Admin_Role' TO 'Admin'@'localhost';
GRANT 'Teacher' TO 'Teacher_Role';
GRANT 'Guardian_Role' TO 'Guardian'@'localhost';

-- Verify grants

SHOW GRANTS FOR 'Admin'@'localhost';
SHOW GRANTS FOR 'Teacher'@'localhost';
SHOW GRANTS FOR 'Guardian'@'localhost';

SELECT CURRENT_USER();


show triggers;


drop database Special_Needs_Education_dbsystem; 

