-- Active: 1738044664712@@localhost@3306@guildelections2025

-- CREATE DATABASE GuildElections2025;
USE GuildElections2025;

-- Create structure for tables
CREATE TABLE candidates (
    candidate_id INT AUTO_INCREMENT PRIMARY KEY,
    candidate_name VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    candidate_contact_number VARCHAR(15) NOT NULL -- 
);

CREATE TABLE NORMINATIONS (
    nomination_id INT AUTO_INCREMENT PRIMARY KEY,
    N_NAMES VARCHAR(50) NOT NULL,
    N_POSITION VARCHAR(50) NOT NULL,
    N_CONTACT_NUMBER VARCHAR(15) NOT NULL 
);

CREATE TABLE VETTING (
    vetting_id INT AUTO_INCREMENT PRIMARY KEY,
    v_NAME VARCHAR(50) NOT NULL,
    v_POSITION VARCHAR(50) NOT NULL,
    v_CONTACT_NUMBER VARCHAR(10) NOT NULL 
);


CREATE TABLE APPICATIONS (
    application_id INT AUTO_INCREMENT PRIMARY KEY,
    application_name VARCHAR(50) NOT NULL,
    application_date DATE NOT NULL,
    application_status VARCHAR(20) NOT NULL CHECK (application_status IN ('Pending', 'Approved', 'Denied')), -- Application status validation
    application_position VARCHAR(50) NOT NULL
    );


-- Election table
CREATE TABLE election (
    election_id INT AUTO_INCREMENT PRIMARY KEY,
    election_name VARCHAR(50) NOT NULL,
    election_start_date DATE NOT NULL,
    election_end_date DATE NOT NULL
);

-- Voter table
CREATE TABLE voter (
    voter_id INT AUTO_INCREMENT PRIMARY KEY,
    voter_name VARCHAR(50) NOT NULL,
    voter_contact_number VARCHAR(15) NOT NULL UNIQUE, -- 
    faculty VARCHAR(50) NOT NULL,
    year_of_study INT NOT NULL CHECK (year_of_study BETWEEN 1 AND 4), --
    resident VARCHAR(10) NOT NULL CHECK (resident IN ('Yes', 'No')) -- Resident validation
);

-- Vote table
CREATE TABLE vote (
    vote_id INT AUTO_INCREMENT PRIMARY KEY,
    voter_id INT NOT NULL,
    candidate_id INT NOT NULL,
    election_id INT NOT NULL,
    vote_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (voter_id) REFERENCES voter(voter_id),
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id),
    FOREIGN KEY (election_id) REFERENCES election(election_id)
);


-- Candidate log table
CREATE TABLE candidate_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    candidate_id INT,
    candidate_name VARCHAR(50),
    position VARCHAR(50),
    action_type VARCHAR(20), 
    log_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Candidate vote count table
CREATE TABLE candidate_vote_count (
    candidate_id INT PRIMARY KEY,
    vote_count INT DEFAULT 0,
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id)
);

-- Election log table
CREATE TABLE election_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    election_id INT,
    election_name VARCHAR(50),
    action VARCHAR(50),
    action_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- Triggers

-- Log candidate actions
DELIMITER $$
CREATE TRIGGER log_candidate_insert
AFTER INSERT ON candidates
FOR EACH ROW
BEGIN
    INSERT INTO guildelections2025_log (candidate_id, candidate_name, position, action_type)
    VALUES (NEW.candidate_id, NEW.candidate_name, NEW.position, 'INSERT');
END $$
DELIMITER ;

-- Trigger to prevent duplicate votes
DELIMITER $$
CREATE TRIGGER prevent_duplicate_vote
BEFORE INSERT ON vote
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM vote 
        WHERE voter_id = NEW.voter_id AND candidate_id = NEW.candidate_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Duplicate vote detected: A voter cannot vote for the same candidate more than once.';
    END IF;
END $$
DELIMITER ;

-- Trigger to update vote count
DELIMITER $$
CREATE TRIGGER update_vote_count
AFTER INSERT ON vote
FOR EACH ROW
BEGIN
    UPDATE candidate_vote_count
    SET vote_count = vote_count + 1
    WHERE candidate_id = NEW.candidate_id;

    IF ROW_COUNT() = 0 THEN
        INSERT INTO candidate_vote_count (candidate_id, vote_count)
        VALUES (NEW.candidate_id, 1);
    END IF;
END $$
DELIMITER ;

-- Inserting data into tables
INSERT INTO voter (voter_name, voter_contact_number, faculty, year_of_study, resident)
VALUES
    ('muboolo', '0789123456', 'Computing', 2, 'Yes'),
    ('waluso keneth', '0789876543', 'Engineering', 3, 'No'),
    ('keza John', '0787654381', 'Law', 1, 'Yes'),
    ('Jane azuei', '0785432109', 'Business', 4, 'No'),
    ('matia Doreen', '0781122334', 'Science', 4, 'Yes'),
    ('muboolo keza', '0789103456', 'Computing', 2, 'Yes'),
    ('ibra keza', '0789663456', 'Computing', 2, 'Yes'),
    ('mary jane', '0782333456', 'Computing', 2, 'Yes'),
    ('keeza kido', '0782222333', 'Law', 2, 'Yes'),
    ('keneth kuto', '0782222433', 'Computing', 2, 'Yes'),
    ('edna meera', '0782229044', 'Computing', 2, 'Yes'),
    ('josh kera', '0792222433', 'Business', 3, 'Yes'),
    ('michael jordan', '0782078976', 'Social Science', 2, 'No'),
    ('emily naguma', '0780937654', 'Social Science', 1, 'No'),
    ('james okilo', '0782278976', 'Science', 3, 'No'),
    ('Patience', '0780903654', 'Social Science', 1, 'No'),
    ('Josheph etana', '0780937774', 'Law', 3, 'No'),
    ('moses naker', '0780900654', 'Social Science', 2, 'No'),
    ('mark calvin', '0780909654', 'Law', 1, 'No'),
    ('kera longman', '0782272433', 'Computing', 2, 'Yes'),
    ('isaac wasswa', '0790272433', 'Computing', 2, 'Yes');


    

INSERT INTO candidates (candidate_name, position, candidate_contact_number)
VALUES
    (001,'Michael', 'President', '0782278976'),
    ('Emily', 'Resident_MP', '0780937654'),
    ('Patience', 'Resident_MP', '0780903654'),
    ('Josheph etana', 'Resident_MP', '0780937654'),
    ('muboolo', 'President', '0789123456'),
    ('keeza John', 'President', '0787654321'),
    ('Jane azuei', 'Resident_MP', '0785432109'),
    ('matia Doreen', 'President', '0781122334'),
    ('muboolo keza', 'NON_RESIDENT_MP', '0789023456'),
    ('ibra keza', 'President', '0789663456'),
    ('mary jane', 'ENG_FUCULTY_MP', '0782333456'),
    ('ATOMIX', 'NON_RESIDENT_MP', '0782333456'),
    ('keeza', 'NON_RESIDENT_MP', '0782222333'),
    ('keneth', 'ENG_FUCULTY_MP', '0782222433'),
    ('edna', 'LAW_FUCULTY_MP', '0782229044'),
    ('josh kera', 'LAW_FUCULTY_MP', '0792222433'),
    ('michael', 'NON_RESIDENT_MP', '0782278976'),
    ('emily', 'NON_RESIDENT_MP', '0780937654');

INSERT INTO NORMINATIONS ( N_NAMES, N_POSITION, N_CONTACT_NUMBER) 
VALUES 
    ('Michael', 'President', '0782278976'),
    ('Emily', 'Resident_MP', '0780937654'),
    ('Patience', 'Resident_MP', '0780903654'),
    ('Josheph etana', 'Resident_MP', '0780937654'),
    ('muboolo', 'President', '0789123456'),
    ('keeza John', 'President', '0787654321'),
    ('Jane azuei', 'Resident_MP', '0785432109'),
    ('matia Doreen', 'President', '0781122334'),
    ('muboolo keza', 'NON_RESIDENT_MP', '0789123456'),
    ('ibra keza', 'President', '0789663456'),
    ('mary jane', 'ENG_FUCULTY_MP', '0782333456'),
    ('ATOMIX', 'NON_RESIDENT_MP', '0782333456'),
    ('keeza', 'NON_RESIDENT_MP', '0782222333'),
    ('keneth', 'ENG_FUCULTY_MP', '0782222433'),
    ('edna', 'LAW_FUCULTY_MP', '0782229044'),
    ('josh kera', 'LAW_FUCULTY_MP', '0792222433'),
    ('michael', 'NON_RESIDENT_MP', '0782278976'),
    ('emily', 'NON_RESIDENT_MP', '0780937654'),
    ('kera', 'PRESIDENT', '0782272433'),
    ('Josh', 'NON_RESIDENT_MP', '0792272433'),
    ('mubiro', 'RESIDENT_MP', '0782272433'),
    ('Joshua', 'NON_RESIDENT_MP', '0792272433'),
    ('keza', 'ENG_FUCULTY_MP', '0782272433'),
    ('keeza', 'NON_RESIDENT_MP', '0782272433'),
    ('emily', 'NON_RESIDENT_MP', '0792272433');


INSERT INTO vetting (V_NAME, V_POSITION, V_CONTACT_NUMBER)
VALUES 
    ('Michael', 'President', '0782278976'),
    ('Emily', 'Resident_MP', '0780937654'),
    ('Patience', 'Resident_MP', '0780903654'),
    ('Josheph etana', 'Resident_MP', '0780937654'),
    ('muboolo', 'President', '0789123456'),
    ('keeza John', 'President', '0787654321'),
    ('Jane azuei', 'Resident_MP', '0785432109'),
    ('matia Doreen', 'President', '0781122334'),
    ('muboolo keza', 'NON_RESIDENT_MP', '0789123456'),
    ('ibra keza', 'President', '0789663456'),
    ('mary jane', 'ENG_FUCULTY_MP', '0782333456'),
    ('ATOMIX', 'NON_RESIDENT_MP', '0782333456'),
    ('keeza', 'NON_RESIDENT_MP', '0782222333'),
    ('keneth', 'ENG_FUCULTY_MP', '0782222433'),
    ('edna', 'LAW_FUCULTY_MP', '0782229044'),
    ('josh kera', 'LAW_FUCULTY_MP', '0792222433'),
    ('michael', 'NON_RESIDENT_MP', '0782278976'),
    ('emily', 'NON_RESIDENT_MP', '0780937654'),
    ('humprey', 'PRESIDENT', '0789972433'),
    ('obba', 'NON_RESIDENT_MP', '0782222330'),
    ('kera', 'PRESIDENT', '0782272433'),
    ('Josh', 'NON_RESIDENT_MP', '0792272433'),
    ('mubiro', 'RESIDENT_MP', '0782272433'),
    ('Joshua', 'NON_RESIDENT_MP', '0792272433'),
    ('keza', 'ENG_FUCULTY_MP', '0782272433'),
    ('keeza', 'NON_RESIDENT_MP', '0782272433'),
    ('emily', 'NON_RESIDENT_MP', '0792272433');





INSERT INTO election (election_name, election_start_date, election_end_date)
VALUES
    ('Guild President Elections', '2025-01-10', '2025-01-11'),
    ('Guild Representative Elections', '2025-01-12', '2025-01-13');


select* from voter;

select* from candidates;

select* from norminations;

select* from vetting;

select* from election;



-- PROCEDURES --------------------------------

-- Add a new voter
DELIMITER $$
CREATE PROCEDURE add_voter(
    IN name VARCHAR(50),
    IN contact_number VARCHAR(15),
    IN faculty VARCHAR(50),
    IN year_of_study INT,
    IN resident VARCHAR(10)
)
BEGIN
    INSERT INTO voter (voter_name, voter_contact_number, faculty, year_of_study, resident)
    VALUES (name, contact_number, faculty, year_of_study, resident);
END $$
DELIMITER ;


-- Add a new candidate
DELIMITER $$
CREATE PROCEDURE add_candidate(
    IN name VARCHAR(50),
    IN position VARCHAR(50),
    IN contact_number VARCHAR(15)
)
BEGIN
    INSERT INTO candidates (candidate_name, position, candidate_contact_number)
    VALUES (name, position, contact_number);
END $$
DELIMITER ; 


-- Add a new election
DELIMITER $$
CREATE PROCEDURE add_election(
    IN name VARCHAR(50),
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    INSERT INTO election (election_name, election_start_date, election_end_date)
    VALUES (name, start_date, end_date);
END $$
DELIMITER ; 


-- Update voter information
DELIMITER $$
CREATE PROCEDURE update_voter_info(
    IN id INT,
    IN name VARCHAR(50),
    IN contact_number VARCHAR(15),
    IN faculty VARCHAR(50),
    IN year_of_study INT,
    IN resident VARCHAR(10)
)
BEGIN
    UPDATE voter
    SET voter_name = name, voter_contact_number = contact_number, faculty = faculty, year_of_study = year_of_study, resident = resident
    WHERE voter_id = id;
END $$
DELIMITER ;


-- Update candidate information
DELIMITER $$
CREATE PROCEDURE update_candidate_info(
    IN id INT,
    IN name VARCHAR(50),
    IN position VARCHAR(50),
    IN contact_number VARCHAR(15)
)
BEGIN
    UPDATE candidate_table
    SET candidate_name = name, position = position, candidate_contact_number = contact_number
    WHERE candidate_id = id;
END $$
DELIMITER ;


-- Delete voter
DELIMITER $$
CREATE PROCEDURE delete_voter(
    IN id INT
)
BEGIN
    DELETE FROM voter
    WHERE voter_id = id;
END $$
DELIMITER ; 

-- Delete candidate
DELIMITER $$
CREATE PROCEDURE delete_candidate(
    IN id INT
)
BEGIN
    DELETE FROM candidate_table
    WHERE candidate_id = id;
END $$
DELIMITER ;

-- triggers 

-- Before insert trigger for voter table
DELIMITER $$
CREATE TRIGGER before_insert_voter
BEFORE INSERT ON voter
FOR EACH ROW
BEGIN
    IF NEW.year_of_study < 1 OR NEW.year_of_study > 4 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid year of study. Year of study must be between 1 and 4.';
    END IF;
END $$
DELIMITER ;

-- After insert trigger for candidate table
DELIMITER $$
CREATE TRIGGER after_insert_candidate
AFTER INSERT ON candidates
FOR EACH ROW
BEGIN
    INSERT INTO candidate_vote_count (candidate_id, vote_count)
    VALUES (NEW.candidate_id, 0);
END $$
DELIMITER ;


-- Before update trigger for voter table
DELIMITER $$
CREATE TRIGGER before_update_voter
BEFORE UPDATE ON voter
FOR EACH ROW
BEGIN
    IF NEW.year_of_study < 1 OR NEW.year_of_study > 4 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid year of study. Year of study must be between 1 and 4.';
    END IF;
END $$
DELIMITER ;

call add_voter
    ('jessy', '0780037654', 'Computer Science', 4, 'Yes');
    ('festa', '0780037655', 'Computer Science', 5, 'Yes');

SELECT * FROM voter;



-- After update trigger for voter table
DELIMITER $$
CREATE TRIGGER after_update_voter
AFTER UPDATE ON voter
FOR EACH ROW
BEGIN
    UPDATE candidate_vote_count
    SET vote_count = vote_count + 1
    WHERE candidate_id = NEW.candidate_id;
END $$
DELIMITER ;



-- Before delete trigger for candidate table 
DELIMITER $$
CREATE TRIGGER before_delete_candidate
BEFORE DELETE ON candidates
FOR EACH ROW
BEGIN
    DELETE FROM candidate_vote_count
    WHERE candidate_id = OLD.candidate_id;
END $$
DELIMITER ;

DELETE from candidates
where candidate_id = 4;

SELECT * FROM candidates;





-- trigger to enforce resident voters to only vote for resident_MP
DELIMITER $$
CREATE TRIGGER enforce_resident_voters
BEFORE INSERT ON vote
FOR EACH ROW
BEGIN
    IF NEW.voter_id IN (
        SELECT voter_id
        FROM voter
        WHERE resident = 'No'
    ) AND NEW.candidate_id IN (
        SELECT candidate_id
        FROM candidates
        WHERE position != 'resident_MP'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Resident voters can only vote for resident_MP candidates.';
    END IF;
END $$
DELIMITER ;

-- trigger to enforce non-resident voters to only vote for resident_MP
DELIMITER $$
CREATE TRIGGER enforce_non_resident_voters
BEFORE INSERT ON vote
FOR EACH ROW
BEGIN
    IF NEW.voter_id IN (
        SELECT voter_id
        FROM voter
        WHERE resident = 'No'
    ) AND NEW.candidate_id IN (
        SELECT candidate_id
        FROM candidates
        WHERE position != 'non-resident_MP'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non-resident voters can only vote for non-resident_MP candidates.';
    END IF;
END $$
DELIMITER ;


-- Create log table
CREATE TABLE Guildelections2025_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(50) NOT NULL,
    affected_table VARCHAR(50) NOT NULL,
    action_details TEXT,
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger to log actions on the candidates table
DELIMITER $$
CREATE TRIGGER candidates_log
AFTER INSERT ON candidates
FOR EACH ROW

BEGIN
    INSERT INTO Guildelections2025_log (action_type, affected_table, action_details)
    VALUES ('INSERT', 'candidates', CONCAT('New candidate added: ', NEW.candidate_name));
END $$
DELIMITER ;

-- Trigger to log actions on the voter table
DELIMITER $$
CREATE TRIGGER voter_log
AFTER INSERT ON voter
FOR EACH ROW
BEGIN
    INSERT INTO Guildelections2025_log (action_type, affected_table, action_details)
    VALUES ('INSERT', 'voter', CONCAT('New voter added: ', NEW.voter_name));
END $$
DELIMITER ;

-- Trigger to log actions on the election table
DELIMITER $$
CREATE TRIGGER election_log
AFTER INSERT ON election
FOR EACH ROW
BEGIN
    INSERT INTO Guildelections2025_log (action_type, affected_table, action_details)
    VALUES ('INSERT', 'election', CONCAT('New election added: ', NEW.election_name));
END $$
DELIMITER ; 


show TRIGGERS;

---user account grants



-- Get all logs
CREATE VIEW all_logs AS
SELECT * FROM Guildelections2025_log;




SELECT * FROM Guildelections2025_log;

call get_voter_ details;

call get_candidate_details(1);

call get_election_details(1);

call get_election_candidates(1);

call count_votes_for_candidates;



-- guildelections2025_log

SELECT * FROM guildelections2025_log; ****************

describe guildelections2025_log;




-- Views

-- Get all voters
CREATE VIEW all_voters AS
SELECT * FROM voter;

-- Get all candidates
CREATE VIEW all_candidates AS
SELECT * FROM candidates;


-- Get all votes
CREATE VIEW all_votes AS
SELECT * FROM vote;

-- Get all elections
CREATE VIEW all_elections AS
SELECT * FROM election;

-- get all candidates and election with all votes

CREATE VIEW all_candidates_elections AS
SELECT c.candidate_id, c.candidate_name, c.position, e.election_id, e.election_name, COUNT(v.vote_id) AS vote_count
FROM candidates c
LEFT JOIN vote v ON c.candidate_id = v.candidate_id
    LEFT JOIN election e ON v.election_id = e.election_id
GROUP BY c.candidate_id, e.election_id
ORDER BY c.candidate_id, e.election_id;


select * from all_candidates_elections;




-- Stored Procedures

-- procedure to count votes for a candidate
DELIMITER $$
CREATE PROCEDURE count_votes_for_candidate(
    IN candidate_id INT,
    IN election_id INT,
    OUT vote_count INT
)
BEGIN
    SELECT COUNT(*) INTO vote_count
    FROM vote
    WHERE candidate_id = candidate_id AND election_id = election_id;
END $$

DELIMITER ;

-- procedure to retrieve election results
DELIMITER $$
CREATE PROCEDURE get_election_results(
    IN election_id INT,
    OUT candidate_id INT,
    OUT candidate_name VARCHAR(50),
    OUT position VARCHAR(50),
    OUT vote_count INT
)
BEGIN
    SELECT c.candidate_id, c.candidate_name, c.position, COUNT(v.vote_id) AS vote_count
    INTO candidate_id, candidate_name, position, vote_count
    FROM candidate_table c
    LEFT JOIN vote v ON c.candidate_id = v.candidate_id
    WHERE v.election_id = election_id
    GROUP BY c.candidate_id
    ORDER BY vote_count DESC;
END $$

DELIMITER ;

--procedure to fetch voter details by voter ID
DELIMITER $$
CREATE PROCEDURE get_voter_details(
    IN voter_id INT,
    OUT voter_name VARCHAR(50),
    OUT voter_contact_number VARCHAR(15),
    OUT faculty VARCHAR(50),
    OUT year_of_study INT,
    OUT resident VARCHAR(10)
)
BEGIN
    SELECT voter_name, voter_contact_number, faculty, year_of_study, resident
    INTO voter_name, voter_contact_number, faculty, year_of_study, resident
    FROM voter
    WHERE voter_id = voter_id;
END $$
DELIMITER ;


-- Cast a vote
DELIMITER $$
CREATE PROCEDURE cast_vote(
    IN voter_id INT,
    IN candidate_id INT,
    IN election_id INT
)
BEGIN
    INSERT INTO vote (voter_id, candidate_id, election_id)
    VALUES (voter_id, candidate_id, election_id);
END $$
DELIMITER ;

ALTER TABLE Voter 
ADD voted BOOLEAN DEFAULT FALSE;

ALTER TABLE Vote
ADD CONSTRAINT fk_voter FOREIGN KEY (voter_id) REFERENCES Voter(voter_id);




-- Get winning candidate
DELIMITER $$
CREATE PROCEDURE get_winning_candidate(
    IN election_id INT, 
    OUT winning_candidate_id INT, 
    OUT winning_candidate_name VARCHAR(50), 
    OUT winning_candidate_position VARCHAR(50), 
    OUT total_votes INT
)
BEGIN
    SELECT c.candidate_id, c.candidate_name, c.position, COUNT(v.vote_id) AS total_votes
    INTO winning_candidate_id, winning_candidate_name, winning_candidate_position, total_votes
    FROM candidate_table c
    LEFT JOIN vote v ON c.candidate_id = v.candidate_id
    WHERE v.election_id = election_id
    GROUP BY c.candidate_id
    ORDER BY total_votes DESC
    LIMIT 1;
END $$
DELIMITER ;

-- Get all candidates for a specific election
DELIMITER $$
CREATE PROCEDURE get_candidates_for_election(
    IN election_id INT, 
    OUT candidate_id INT, 
    OUT candidate_name VARCHAR(50), 
    OUT candidate_position VARCHAR(50)
)
BEGIN
    SELECT candidate_id, candidate_name, position
    INTO candidate_id, candidate_name, candidate_position
    FROM candidate_table
    WHERE election_id = election_id;
END $$
DELIMITER ; 

-- Get all voters for a specific election
DELIMITER $$
CREATE PROCEDURE get_voters_for_election(
    IN election_id INT, 
    OUT voter_id INT, 
    OUT voter_name VARCHAR(50), 
    OUT voter_contact_number VARCHAR(15)
)
BEGIN
    SELECT voter_id, voter_name, voter_contact_number
    INTO voter_id, voter_name, voter_contact_number
    FROM voter
    WHERE election_id = election_id;
END $$
DELIMITER ;

--creating user accounts
--manager account account
CREATE USER 'Manager'@'%' IDENTIFIED BY 'manager123';
GRANT SELECT, INSERT, UPDATE, DELETE ON GuildElections2025.* TO 'Manager'@'%';
FLUSH PRIVILEGES;   

--voter account

CREATE USER 'voter225'@'%' IDENTIFIED BY 'voter123';
GRANT SELECT ON GuildElections2025.* TO 'voter225'@'%';

--supervisor account
CREATE USER 'supervisor'@'%' IDENTIFIED BY 'supervisor123';

GRANT SELECT, INSERT, UPDATE ON GuildElections2025.* TO 'supervisor'@'%';


FLUSH PRIVILEGES;   



-- prevent duplicate voting
ALTER TABLE vote ADD CONSTRAINT unique_vote UNIQUE (voter_id, candidate_id, election_id);



-- indexes 
CREATE INDEX idx_vote_election_id ON vote (election_id);
CREATE INDEX idx_vote_voter_id ON vote (voter_id);
CREATE INDEX idx_vote_candidate_id ON vote (candidate_id);

-- indexe for candidate_voe_count
CREATE INDEX idx_candidate_vote_count_candidate_id ON candidate_vote_count (candidate_id);



-- Views

-- Voter details view
CREATE VIEW voter_details AS
SELECT voter_id, voter_name, voter_contact_number, faculty, year_of_study, resident
FROM voter;

-- Candidate votes view
CREATE VIEW candidate_votes AS
SELECT c.candidate_id, c.candidate_name, c.position, COUNT(v.vote_id) AS total_votes
FROM candidates c
LEFT JOIN vote v ON c.candidate_id = v.candidate_id
GROUP BY c.candidate_id;

-- Election details view
CREATE VIEW election_details AS
SELECT election_id, election_name, election_start_date, election_end_date
FROM election;

-- Test queries
SELECT * FROM voter_details;
SELECT * FROM candidate_votes;
SELECT * FROM election_details;

--election details
SELECT elections.election_id, elections.name AS election_name, COUNT(votes.election_id) AS total_votes
FROM elections
LEFT JOIN votes ON elections.election_id = votes.election_id
GROUP BY elections.election_id, elections.name
ORDER BY elections.election_id;







    DEFAULT CHARACTER SET = 'utf8mb4';