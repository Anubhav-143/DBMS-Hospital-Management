##  Advanced SQL Queries (All-in-One)

```sql
-- =====================================
-- INNER JOIN: Patients with Appointments
-- =====================================
SELECT p.Name AS Patient, a.Appointment_ID, d.Name AS Doctor
FROM Patient p
INNER JOIN Appointment a ON p.Patient_ID = a.Patient_ID
INNER JOIN Doctor d ON a.Doctor_ID = d.Doctor_ID;


-- =====================================
-- LEFT JOIN: All Patients (Including Without Appointments)
-- =====================================
SELECT p.Name, a.Appointment_ID
FROM Patient p
LEFT JOIN Appointment a ON p.Patient_ID = a.Patient_ID;


-- =====================================
-- RIGHT JOIN: All Appointments with Patient Info
-- =====================================
SELECT p.Name, a.Appointment_ID
FROM Patient p
RIGHT JOIN Appointment a ON p.Patient_ID = a.Patient_ID;


-- =====================================
-- Total Appointments per Doctor
-- =====================================
SELECT d.Name, COUNT(a.Appointment_ID) AS Total_Appointments
FROM Doctor d
JOIN Appointment a ON d.Doctor_ID = a.Doctor_ID
GROUP BY d.Name;


-- =====================================
-- Doctors with More Than 2 Appointments
-- =====================================
SELECT d.Name, COUNT(a.Appointment_ID) AS Total_Appointments
FROM Appointment a
JOIN Doctor d ON a.Doctor_ID = d.Doctor_ID
GROUP BY d.Name
HAVING COUNT(a.Appointment_ID) > 2;


-- =====================================
-- Total Visits per Patient
-- =====================================
SELECT p.Name, COUNT(a.Appointment_ID) AS Total_Visits
FROM Appointment a
JOIN Patient p ON a.Patient_ID = p.Patient_ID
GROUP BY p.Patient_ID, p.Name;


-- =====================================
-- Patients Without Any Appointments
-- =====================================
SELECT Name
FROM Patient
WHERE Patient_ID NOT IN (
    SELECT Patient_ID FROM Appointment
);


-- =====================================
-- Bills Between Range
-- =====================================
SELECT *
FROM Billing
WHERE Amount BETWEEN 1000 AND 5000;


-- =====================================
-- Average Billing Amount
-- =====================================
SELECT AVG(Amount) AS Avg_Bill
FROM Billing;


-- =====================================
-- Patients Treated by Specific Doctor
-- =====================================
SELECT DISTINCT p.Name
FROM Patient p
JOIN Treatment t ON p.Patient_ID = t.Patient_ID
WHERE t.Doctor_ID = 1;


-- =====================================
-- Total Revenue Generated
-- =====================================
SELECT SUM(Amount) AS Total_Revenue
FROM Billing
WHERE Payment_Status = 'Paid';


-- =====================================
-- Currently Admitted Patients
-- =====================================
SELECT p.Name, r.Room_Type
FROM Admission ad
JOIN Patient p ON ad.Patient_ID = p.Patient_ID
JOIN Room r ON ad.Room_ID = r.Room_ID
WHERE ad.Discharge_Date IS NULL;
```
