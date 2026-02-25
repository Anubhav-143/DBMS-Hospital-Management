-- =====================================
-- DATABASE CREATION
-- =====================================
CREATE DATABASE HospitalDB;
USE HospitalDB;

-- =====================================
-- PATIENT TABLE
-- =====================================
CREATE TABLE Patient(
    Patient_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Age INT,
    Gender ENUM('Male','Female','Other'),
    Phone VARCHAR(15),
    Address VARCHAR(100),
    Blood_Group VARCHAR(5)
);

-- =====================================
-- DOCTOR TABLE
-- =====================================
CREATE TABLE Doctor(
    Doctor_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Specialization VARCHAR(50),
    Phone VARCHAR(15),
    Experience INT,
    Salary DECIMAL(10,2)
);

-- =====================================
-- APPOINTMENT TABLE
-- =====================================
CREATE TABLE Appointment(
    Appointment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID INT,
    Doctor_ID INT,
    Date DATE,
    Time TIME,
    Status VARCHAR(20),

    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)
);

-- =====================================
-- TREATMENT TABLE
-- =====================================
CREATE TABLE Treatment(
    Treatment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID INT,
    Doctor_ID INT,
    Diagnosis TEXT,
    Prescription TEXT,
    Treatment_Date DATE,

    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)
);

-- =====================================
-- BILLING TABLE
-- =====================================
CREATE TABLE Billing(
    Bill_ID INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID INT,
    Amount DECIMAL(10,2),
    Payment_Status ENUM('Paid','Pending'),
    Bill_Date DATE,

    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID)
);

-- =====================================
-- DEPARTMENT TABLE (Extra for realism)
-- =====================================
CREATE TABLE Department(
    Department_ID INT PRIMARY KEY AUTO_INCREMENT,
    Dept_Name VARCHAR(50),
    Location VARCHAR(50)
);

-- =====================================
-- NURSE TABLE (Extra Table)
-- =====================================
CREATE TABLE Nurse(
    Nurse_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Phone VARCHAR(15),
    Shift VARCHAR(20),
    Department_ID INT,

    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID)
);

-- =====================================
-- ROOM TABLE
-- =====================================
CREATE TABLE Room(
    Room_ID INT PRIMARY KEY AUTO_INCREMENT,
    Room_Type VARCHAR(20),
    Charges DECIMAL(8,2),
    Status VARCHAR(20)
);

-- =====================================
-- ADMISSION TABLE
-- =====================================
CREATE TABLE Admission(
    Admission_ID INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID INT,
    Room_ID INT,
    Admit_Date DATE,
    Discharge_Date DATE,

    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),
    FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID)
);

-- =====================================
-- MEDICINE TABLE
-- =====================================
CREATE TABLE Medicine(
    Medicine_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Price DECIMAL(6,2),
    Stock INT
);

-- =====================================
-- PRESCRIPTION DETAILS TABLE
-- =====================================
CREATE TABLE Prescription_Details(
    Prescription_ID INT PRIMARY KEY AUTO_INCREMENT,
    Treatment_ID INT,
    Medicine_ID INT,
    Dosage VARCHAR(50),

    FOREIGN KEY (Treatment_ID) REFERENCES Treatment(Treatment_ID),
    FOREIGN KEY (Medicine_ID) REFERENCES Medicine(Medicine_ID)
);

-- =====================================
-- DEMO DATA INSERTION
-- =====================================

INSERT INTO Patient(Name,Age,Gender,Phone,Address,Blood_Group) VALUES
('Rahul Sharma',25,'Male','9876543210','Delhi','O+'),
('Priya Singh',30,'Female','9876501234','Noida','A+'),
('Aman Verma',40,'Male','9123456789','Ghaziabad','B+');

INSERT INTO Doctor(Name,Specialization,Phone,Experience,Salary) VALUES
('Dr. Mehta','Cardiologist','9998887776',10,120000),
('Dr. Khan','Dermatologist','8887776665',7,90000),
('Dr. Roy','Orthopedic','7776665554',12,140000);

INSERT INTO Department(Dept_Name,Location) VALUES
('Cardiology','Block A'),
('Orthopedic','Block B'),
('Skin','Block C');

INSERT INTO Nurse(Name,Phone,Shift,Department_ID) VALUES
('Nurse A','9871111111','Day',1),
('Nurse B','9872222222','Night',2);

INSERT INTO Room(Room_Type,Charges,Status) VALUES
('General',1000,'Available'),
('ICU',5000,'Occupied'),
('Private',3000,'Available');

INSERT INTO Appointment(Patient_ID,Doctor_ID,Date,Time,Status) VALUES
(1,1,'2026-03-01','10:00:00','Completed'),
(2,2,'2026-03-02','12:00:00','Pending');

INSERT INTO Treatment(Patient_ID,Doctor_ID,Diagnosis,Prescription,Treatment_Date) VALUES
(1,1,'Heart Pain','ECG + Medicine','2026-03-01'),
(2,2,'Skin Allergy','Ointment','2026-03-02');

INSERT INTO Medicine(Name,Price,Stock) VALUES
('Paracetamol',20,100),
('Antibiotic',50,80);

INSERT INTO Prescription_Details(Treatment_ID,Medicine_ID,Dosage) VALUES
(1,1,'Twice Daily'),
(2,2,'Once Daily');

INSERT INTO Billing(Patient_ID,Amount,Payment_Status,Bill_Date) VALUES
(1,5000,'Paid','2026-03-01'),
(2,2000,'Pending','2026-03-02');

INSERT INTO Admission(Patient_ID,Room_ID,Admit_Date,Discharge_Date) VALUES
(1,2,'2026-03-01','2026-03-05');

-- =====================================
-- =====================================
1. Complex SQL Queries (Reports)
-- =====================================

📊 Patient Treatment History Report
-- =====================================
SELECT p.Name AS Patient, d.Name AS Doctor, t.Diagnosis, t.Treatment_Date
FROM Treatment t
JOIN Patient p ON t.Patient_ID = p.Patient_ID
JOIN Doctor d ON t.Doctor_ID = d.Doctor_ID;

-- =====================================
💰 Total Revenue Generated
-- =====================================
SELECT SUM(Amount) AS Total_Revenue FROM Billing WHERE Payment_Status='Paid';

-- =====================================
🩺 Doctor Appointment Count
-- =====================================
SELECT d.Name, COUNT(a.Appointment_ID) AS Total_Appointments
FROM Doctor d
LEFT JOIN Appointment a ON d.Doctor_ID=a.Doctor_ID
GROUP BY d.Name;

-- =====================================
🛏 Available Rooms
-- =====================================
SELECT * FROM Room WHERE Status='Available';

-- =====================================
⚡ 2. Triggers
-- =====================================
🧠 Auto Update Room Status After Admission
-- =====================================
DELIMITER //
CREATE TRIGGER after_admission
AFTER INSERT ON Admission
FOR EACH ROW
BEGIN
   UPDATE Room
   SET Status='Occupied'
   WHERE Room_ID = NEW.Room_ID;
END//
DELIMITER ;

-- =====================================
💊 Reduce Medicine Stock After Prescription
-- =====================================
DELIMITER //
CREATE TRIGGER reduce_stock
AFTER INSERT ON Prescription_Details
FOR EACH ROW
BEGIN
   UPDATE Medicine
   SET Stock = Stock - 1
   WHERE Medicine_ID = NEW.Medicine_ID;
END//
DELIMITER ;

-- =====================================
⚙️ 3. Stored Procedures
➕ Add New Patient
-- =====================================
DELIMITER //
CREATE PROCEDURE AddPatient(
    IN pname VARCHAR(50),
    IN page INT,
    IN pgender VARCHAR(10),
    IN pphone VARCHAR(15)
)
BEGIN
INSERT INTO Patient(Name,Age,Gender,Phone)
VALUES(pname,page,pgender,pphone);
END//
DELIMITER ;
Call it:
CALL AddPatient('Amit',28,'Male','9871112233');


-- =====================================
📅 Book Appointment Procedure
-- =====================================
DELIMITER //
CREATE PROCEDURE BookAppointment(
    IN pid INT,
    IN did INT,
    IN adate DATE,
    IN atime TIME
)
BEGIN
INSERT INTO Appointment(Patient_ID,Doctor_ID,Date,Time,Status)
VALUES(pid,did,adate,atime,'Pending');
END//
DELIMITER ;

-- =====================================
👁 4. Views📋 Patient Summary View
  -- =====================================
CREATE VIEW Patient_Summary AS
SELECT p.Patient_ID, p.Name, COUNT(a.Appointment_ID) AS Total_Visits
FROM Patient p
LEFT JOIN Appointment a ON p.Patient_ID=a.Patient_ID
GROUP BY p.Patient_ID;

-- =====================================
🧾 Billing Report View
-- =====================================
CREATE VIEW Billing_Report AS
SELECT p.Name, b.Amount, b.Payment_Status
FROM Billing b
JOIN Patient p ON b.Patient_ID=p.Patient_ID;

-- =====================================
🚀 5. Index Optimization Indexes make queries faster (important for viva explanation).
-- =====================================
CREATE INDEX idx_patient_name ON Patient(Name);
CREATE INDEX idx_doctor_specialization ON Doctor(Specialization);
CREATE INDEX idx_appointment_date ON Appointment(Date);
CREATE INDEX idx_bill_status ON Billing(Payment_Status);

-- =====================================
🔐 1. Role-Based Authentication System 👤 Users Table (Login Table)
-- =====================================
CREATE TABLE Users(
    User_ID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) UNIQUE,
    Password_Hash VARCHAR(255),
    Role ENUM('Admin','Doctor','Patient'),
    Status ENUM('Active','Blocked') DEFAULT 'Active',
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================
🔗 Link Users with System Entities
-- =====================================
ALTER TABLE Doctor ADD User_ID INT UNIQUE;
ALTER TABLE Patient ADD User_ID INT UNIQUE;
ALTER TABLE Doctor
ADD FOREIGN KEY (User_ID) REFERENCES Users(User_ID);
ALTER TABLE Patient
ADD FOREIGN KEY (User_ID) REFERENCES Users(User_ID);

-- =====================================
🔑 Demo Login Data
  -- =====================================
INSERT INTO Users(Username,Password_Hash,Role) VALUES
('admin1','hashedpass123','Admin'),
('drmehta','hashedpass456','Doctor'),
('rahul25','hashedpass789','Patient');

-- =====================================
-- =====================================
📊 2. Dashboard Queries
-- =====================================
👑 Admin Dashboard Shows system statistics
-- =====================================
SELECT
(SELECT COUNT(*) FROM Patient) AS Total_Patients,
(SELECT COUNT(*) FROM Doctor) AS Total_Doctors,
(SELECT COUNT(*) FROM Appointment) AS Total_Appointments,
(SELECT SUM(Amount) FROM Billing WHERE Payment_Status='Paid') AS Revenue;

-- =====================================
🩺 Doctor DashboardDoctor’s appointments today
-- =====================================
SELECT p.Name, a.Time, a.Status
FROM Appointment a
JOIN Patient p ON a.Patient_ID=p.Patient_ID
WHERE a.Doctor_ID=1
AND a.Date=CURDATE();

-- =====================================
🧑‍⚕️ Patient Dashboard Patient’s history
-- =====================================
SELECT d.Name AS Doctor, t.Diagnosis, t.Treatment_Date
FROM Treatment t
JOIN Doctor d ON t.Doctor_ID=d.Doctor_ID
WHERE t.Patient_ID=1;

-- =====================================
🌐 3. API-Ready Schema Design To make your database ready for backend APIs (Django / Node / Flask), add standard fields:
-- =====================================
ALTER TABLE Patient
ADD Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE Doctor
ADD Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE Appointment
ADD Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- =====================================
📡 API Log Table (Used in Real Systems)
-- =====================================
CREATE TABLE API_Log(
    Log_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT,
    Endpoint VARCHAR(100),
    Method VARCHAR(10),
    Status_Code INT,
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================
🛡 4. Security Table (Login Tracking)
-- =====================================
CREATE TABLE Login_History(
    Login_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT,
    Login_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IP_Address VARCHAR(50),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

-- =====================================
⚡ 5. Role Permission Table (Advanced Feature) Used in enterprise systems.
-- =====================================
CREATE TABLE Permissions(
    Permission_ID INT PRIMARY KEY AUTO_INCREMENT,
    Role VARCHAR(20),
    Permission_Name VARCHAR(50)
);

-- =====================================
Example Data:
-- =====================================
INSERT INTO Permissions(Role,Permission_Name) VALUES
('Admin','Manage Users'),
('Admin','View Reports'),
('Doctor','View Patients'),
('Doctor','Update Treatment'),
('Patient','View Records');
