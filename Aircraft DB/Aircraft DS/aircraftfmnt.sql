show databases;
use aircraftfmnt;
show tables;
create table Crew ( CrewID int AUTO_INCREMENT primary key, Name varchar(100) NOT NULL, 
                    Role ENUM('Co-Pilot', 'Flight Attendant', 'Ground Crew') NOT NULL, 
                    Certification varchar(100),Contactinfo varchar(100));
desc Crew;
Create table Passenger (PassengerID int AUTO_INCREMENT primary key, Name varchar(100) NOT NULL, 
                        Contactinfo varchar(100), BookingReference varchar(50));
desc Passenger;
create table Booking (BookingID int AUTO_INCREMENT primary key,  PassengerID int NOT NULL, FLightID int not NULL,
                      SeatNumber varchar(10), BokingStatus ENUM('Confirmed','Canceled') DEFAULT 'Confirmed',
                      foreign key (PassengerID) references Passenger(PassengerID), foreign key (FlightID) references Flight(FlightID));
desc Booking;
create table Maintainance (MaintainanceID int AUTO_INCREMENT primary key, AircraftID int NOT NULL,
                           Description TEXT,MaintainanceDate DATE, TechnicanName varchar(100), 
                           Statu ENUM('Scheduled','Completed','Pending') DEFAULT 'Scheduled',
                           foreign key (AircraftID) references Aircraft(AircraftID) );
desc maintainance;
create table  FlightCrewAssignment( AssignmentID int AUTO_INCREMENT primary key, FlightID int NOT NULL,
                                   CrewID int NOT NULL, Role ENUM('Pilot','Co-pilot','Flight Attendant') NOT NULL,
                                   foreign key (FlightID) references Flight(FlightID), Foreign key(CrewID) references Crew(CrewID));
desc flightcrewassignment;
create table GroundCrewAssignment ( AssignmentID int AUTO_INCREMENT primary key, AircraftID int NOT NULL, CrewID int NOT NULL,
                                   Task ENUM('Fueling','Loading', 'Cleaning','inspections') NOT NULL, 
                                   foreign key (AircraftID) references Aircraft(AircraftID), foreign key(CrewID) references Crew(CrewID));                     
desc groundcrewassignment;