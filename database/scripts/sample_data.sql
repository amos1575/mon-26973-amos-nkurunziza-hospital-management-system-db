-- Sample data for Hospital Management System
-- Run as AMOS user
-- Note: Restriction triggers block DML on weekdays/holidays, so run on weekends or disable triggers temporarily

-- Optional: Disable triggers for bulk insert
-- ALTER TRIGGER trg_patients_restrict DISABLE;
-- ALTER TRIGGER trg_doctors_restrict DISABLE;
-- ALTER TRIGGER trg_appointments_compound DISABLE;

-- Fix user quota (run as SYS in PDB if needed)
-- ALTER USER amos QUOTA UNLIMITED ON index_ts;

-- IMPORTANT: Insert Order Matters Due to Foreign Keys
-- 1. Departments (no dependencies)
-- 2. Doctors (depends on departments)
-- 3. Patients (no dependencies)
-- 4. Medications (no dependencies)
-- 5. Public Holidays (no dependencies)
-- 6. Appointments (depends on patients/doctors)
-- 7. Medical Records (depends on patients/doctors)
-- 8. Prescriptions (depends on medical_records/medications)

-- === STEP 1: Departments ===
INSERT INTO departments (department_id, department_name, location, contact_number) VALUES (101, 'Cardiology', 'Building A - Floor 3', '250-788-1001');
INSERT INTO departments (department_id, department_name, location, contact_number) VALUES (102, 'Neurology', 'Building A - Floor 4', '250-788-1002');
INSERT INTO departments (department_id, department_name, location, contact_number) VALUES (103, 'Pediatrics', 'Building B - Floor 1', '250-788-1003');
INSERT INTO departments (department_id, department_name, location, contact_number) VALUES (104, 'Orthopedics', 'Building B - Floor 2', '250-788-1004');
INSERT INTO departments (department_id, department_name, location, contact_number) VALUES (105, 'Emergency', 'Building C - Ground', '250-788-1005');
INSERT INTO departments (department_id, department_name, location, contact_number) VALUES (106, 'Radiology', 'Building A - Basement', '250-788-1006');
INSERT INTO departments (department_id, department_name, location, contact_number) VALUES (107, 'Surgery', 'Building D - Floor 2', '250-788-1007');
INSERT INTO departments (department_id, department_name, location, contact_number) VALUES (108, 'Internal Medicine', 'Building A - Floor 2', '250-788-1008');
INSERT INTO departments (department_id, department_name, location, contact_number) VALUES (109, 'Gynecology', 'Building B - Floor 3', '250-788-1009');
INSERT INTO departments (department_id, department_name, location, contact_number) VALUES (110, 'Dermatology', 'Building A - Floor 1', '250-788-1010');
COMMIT; -- Critical: Must commit before inserting doctors

-- === STEP 2: Doctors ===
INSERT INTO doctors (doctor_id, first_name, last_name, specialization, department_id, contact_number, email, hire_date) 
VALUES (201, 'Jean', 'Uwamahoro', 'Cardiologist', 101, '250-788-2001', 'j.uwamahoro@hospital.rw', DATE '2018-01-15');
INSERT INTO doctors (doctor_id, first_name, last_name, specialization, department_id, contact_number, email, hire_date) 
VALUES (202, 'Marie', 'Mukamana', 'Cardiologist', 101, '250-788-2002', 'm.mukamana@hospital.rw', DATE '2019-03-20');
INSERT INTO doctors (doctor_id, first_name, last_name, specialization, department_id, contact_number, email, hire_date) 
VALUES (203, 'Patrick', 'Nshimiyimana', 'Neurologist', 102, '250-788-2003', 'p.nshimiyimana@hospital.rw', DATE '2017-06-10');
INSERT INTO doctors (doctor_id, first_name, last_name, specialization, department_id, contact_number, email, hire_date) 
VALUES (204, 'Grace', 'Kabera', 'Neurologist', 102, '250-788-2004', 'g.kabera@hospital.rw', DATE '2020-02-14');
INSERT INTO doctors (doctor_id, first_name, last_name, specialization, department_id, contact_number, email, hire_date) 
VALUES (205, 'Emmanuel', 'Habimana', 'Pediatrician', 103, '250-788-2005', 'e.habimana@hospital.rw', DATE '2016-09-01');
INSERT INTO doctors (doctor_id, first_name, last_name, specialization, department_id, contact_number, email, hire_date) 
VALUES (206, 'Alice', 'Umutoni', 'Pediatrician', 103, '250-788-2006', 'a.umutoni@hospital.rw', DATE '2021-01-10');
INSERT INTO doctors (doctor_id, first_name, last_name, specialization, department_id, contact_number, email, hire_date) 
VALUES (207, 'David', 'Mugisha', 'Orthopedic Surgeon', 104, '250-788-2007', 'd.mugisha@hospital.rw', DATE '2019-07-22');
INSERT INTO doctors (doctor_id, first_name, last_name, specialization, department_id, contact_number, email, hire_date) 
VALUES (208, 'Sarah', 'Uwera', 'Orthopedic Surgeon', 104, '250-788-2008', 's.uwera@hospital.rw', DATE '2020-11-05');
INSERT INTO doctors (doctor_id, first_name, last_name, specialization, department_id, contact_number, email, hire_date) 
VALUES (209, 'Eric', 'Niyonzima', 'Emergency Physician', 105, '250-788-2009', 'e.niyonzima@hospital.rw', DATE '2018-04-18');
INSERT INTO doctors (doctor_id, first_name, last_name, specialization, department_id, contact_number, email, hire_date) 
VALUES (210, 'Diane', 'Ingabire', 'Emergency Physician', 105, '250-788-2010', 'd.ingabire@hospital.rw', DATE '2019-08-30');
-- Add 40 more doctors (abbreviated for brevity)
INSERT INTO doctors (doctor_id, first_name, last_name, specialization, department_id, contact_number, email, hire_date) 
VALUES (211, 'Joseph', 'Manzi', 'Radiologist', 106, '250-788-2011', 'j.manzi@hospital.rw', DATE '2017-12-01');
INSERT INTO doctors (doctor_id, first_name, last_name, specialization, department_id, contact_number, email, hire_date) 
VALUES (212, 'Christine', 'Uwineza', 'Surgeon', 107, '250-788-2012', 'c.uwineza@hospital.rw', DATE '2016-05-15');
INSERT INTO doctors (doctor_id, first_name, last_name, specialization, department_id, contact_number, email, hire_date) 
VALUES (213, 'Paul', 'Hakizimana', 'Internal Medicine', 108, '250-788-2013', 'p.hakizimana@hospital.rw', DATE '2018-10-20');
INSERT INTO doctors (doctor_id, first_name, last_name, specialization, department_id, contact_number, email, hire_date) 
VALUES (214, 'Rose', 'Nyiraneza', 'Gynecologist', 109, '250-788-2014', 'r.nyiraneza@hospital.rw', DATE '2019-03-08');
INSERT INTO doctors (doctor_id, first_name, last_name, specialization, department_id, contact_number, email, hire_date) 
VALUES (215, 'Frank', 'Bizimana', 'Dermatologist', 110, '250-788-2015', 'f.bizimana@hospital.rw', DATE '2020-06-12');
-- Continue pattern for remaining 35 doctors...
COMMIT; -- Commit doctors

-- === STEP 3: Patients ===
INSERT INTO patients (patient_id, first_name, last_name, date_of_birth, gender, blood_group, address, contact_number, email, emergency_contact, insurance_details) 
VALUES (301, 'John', 'Mutabazi', DATE '1985-03-15', 'Male', 'O+', 'KG 12 Ave, Kigali', '250-788-3001', 'j.mutabazi@email.rw', '250-788-4001', 'MMI - Policy 12345');
INSERT INTO patients (patient_id, first_name, last_name, date_of_birth, gender, blood_group, address, contact_number, email, emergency_contact, insurance_details) 
VALUES (302, 'Jane', 'Uwase', DATE '1990-07-22', 'Female', 'A+', 'KG 45 St, Kigali', '250-788-3002', 'j.uwase@email.rw', '250-788-4002', 'RAMA - ID 67890');
INSERT INTO patients (patient_id, first_name, last_name, date_of_birth, gender, blood_group, address, contact_number, email, emergency_contact, insurance_details) 
VALUES (303, 'Peter', 'Ndayambaje', DATE '1978-11-05', 'Male', 'B+', 'KN 5 Rd, Kigali', '250-788-3003', 'p.ndayambaje@email.rw', '250-788-4003', 'MMI - Policy 23456');
INSERT INTO patients (patient_id, first_name, last_name, date_of_birth, gender, blood_group, address, contact_number, email, emergency_contact, insurance_details) 
VALUES (304, 'Agnes', 'Mukamazimpaka', DATE '1995-02-18', 'Female', 'AB+', 'KG 78 Ave, Kigali', '250-788-3004', 'a.mukamazimpaka@email.rw', '250-788-4004', 'RAMA - ID 34567');
INSERT INTO patients (patient_id, first_name, last_name, date_of_birth, gender, blood_group, address, contact_number, email, emergency_contact, insurance_details) 
VALUES (305, 'Samuel', 'Nsengimana', DATE '1982-09-30', 'Male', 'O-', 'KG 23 St, Kigali', '250-788-3005', 's.nsengimana@email.rw', '250-788-4005', 'Private Insurance');
-- Continue for 195 more patients...
COMMIT; -- Commit patients

-- === STEP 4: Medications ===
INSERT INTO medications (medication_id, medication_name, description, dosage_form, manufacturer, unit_price, stock_quantity) 
VALUES (401, 'Paracetamol 500mg', 'Pain reliever and fever reducer', 'Tablet', 'Pharma Ltd', 500, 10000);
INSERT INTO medications (medication_id, medication_name, description, dosage_form, manufacturer, unit_price, stock_quantity) 
VALUES (402, 'Amoxicillin 250mg', 'Antibiotic', 'Capsule', 'MedCare Inc', 1200, 5000);
INSERT INTO medications (medication_id, medication_name, description, dosage_form, manufacturer, unit_price, stock_quantity) 
VALUES (403, 'Ibuprofen 400mg', 'Anti-inflammatory', 'Tablet', 'HealthPlus', 800, 8000);
INSERT INTO medications (medication_id, medication_name, description, dosage_form, manufacturer, unit_price, stock_quantity) 
VALUES (404, 'Metformin 500mg', 'Diabetes medication', 'Tablet', 'DiabetCare', 1500, 6000);
INSERT INTO medications (medication_id, medication_name, description, dosage_form, manufacturer, unit_price, stock_quantity) 
VALUES (405, 'Aspirin 100mg', 'Blood thinner', 'Tablet', 'CardioMed', 600, 7000);
-- Continue for 45 more medications...
COMMIT; -- Commit medications

-- === STEP 5: Public Holidays ===
INSERT INTO public_holidays (holiday_id, holiday_date, holiday_name, description) VALUES (501, DATE '2025-01-01', 'New Year', 'Public Holiday');
INSERT INTO public_holidays (holiday_id, holiday_date, holiday_name, description) VALUES (502, DATE '2025-04-07', 'Genocide Memorial Day', 'National Day of Mourning');
INSERT INTO public_holidays (holiday_id, holiday_date, holiday_name, description) VALUES (503, DATE '2025-07-04', 'Liberation Day', 'National Holiday');
INSERT INTO public_holidays (holiday_id, holiday_date, holiday_name, description) VALUES (504, DATE '2025-12-25', 'Christmas', 'Public Holiday');
COMMIT; -- Commit holidays

-- === STEP 6: Appointments ===
-- Sample appointments linking patients and doctors
INSERT INTO appointments 
(appointment_id, patient_id, doctor_id, appointment_date, appointment_time, status, notes)
VALUES 
(601, 301, 201, DATE '2025-01-15', TO_TIMESTAMP('09:00', 'HH24:MI'), 'Scheduled', 'Routine checkup');

INSERT INTO appointments 
(appointment_id, patient_id, doctor_id, appointment_date, appointment_time, status, notes)
VALUES 
(602, 302, 202, DATE '2025-01-16', TO_TIMESTAMP('10:30', 'HH24:MI'), 'Completed', 'Follow-up visit');

INSERT INTO appointments 
(appointment_id, patient_id, doctor_id, appointment_date, appointment_time, status, notes)
VALUES 
(603, 303, 203, DATE '2025-01-17', TO_TIMESTAMP('11:00', 'HH24:MI'), 'Cancelled', 'Patient rescheduled');

INSERT INTO appointments 
(appointment_id, patient_id, doctor_id, appointment_date, appointment_time, status, notes)
VALUES 
(604, 304, 204, DATE '2025-01-18', TO_TIMESTAMP('14:00', 'HH24:MI'), 'Scheduled', 'Initial consultation');

INSERT INTO appointments 
(appointment_id, patient_id, doctor_id, appointment_date, appointment_time, status, notes)
VALUES 
(605, 305, 205, DATE '2025-01-19', TO_TIMESTAMP('15:30', 'HH24:MI'), 'Completed', 'Vaccination');

COMMIT; -- Commit appointments

-- === STEP 7: Medical Records ===
-- Sample medical records linking patients and doctors
INSERT INTO medical_records (record_id, patient_id, doctor_id, diagnosis, treatment, notes, record_date, follow_up_date, created_at) 
VALUES (701, 301, 201, 'Hypertension', 'Prescribed medication', 'Follow-up needed', TO_DATE('15-JAN-2025', 'DD-MON-YYYY'), TO_DATE('15-FEB-2025', 'DD-MON-YYYY'), SYSDATE);
INSERT INTO medical_records (record_id, patient_id, doctor_id, diagnosis, treatment, notes, record_date, follow_up_date, created_at) 
VALUES (702, 302, 202, 'Migraine', 'Rest and painkillers', 'No follow-up', TO_DATE('16-JAN-2025', 'DD-MON-YYYY'), NULL, SYSDATE);
INSERT INTO medical_records (record_id, patient_id, doctor_id, diagnosis, treatment, notes, record_date, follow_up_date, created_at) 
VALUES (703, 303, 203, 'Sprained ankle', 'Physical therapy', 'Follow-up needed', TO_DATE('17-JAN-2025', 'DD-MON-YYYY'), TO_DATE('24-JAN-2025', 'DD-MON-YYYY'), SYSDATE);
INSERT INTO medical_records (record_id, patient_id, doctor_id, diagnosis, treatment, notes, record_date, follow_up_date, created_at) 
VALUES (704, 304, 204, 'Allergic reaction', 'Antihistamines', 'No follow-up', TO_DATE('18-JAN-2025', 'DD-MON-YYYY'), NULL, SYSDATE);
INSERT INTO medical_records (record_id, patient_id, doctor_id, diagnosis, treatment, notes, record_date, follow_up_date, created_at) 
VALUES (705, 305, 205, 'Flu vaccination', 'Vaccine administered', 'No follow-up', TO_DATE('19-JAN-2025', 'DD-MON-YYYY'), NULL, SYSDATE);
COMMIT; -- Commit medical records

-- === STEP 8: Prescriptions ===
-- Sample prescriptions linking medical records and medications
INSERT INTO prescriptions (prescription_id, record_id, medication_id, dosage, frequency, duration, notes, created_at) 
VALUES (801, 701, 401, '1 tablet', 'Twice daily', 30, 'Take with food', SYSDATE);
INSERT INTO prescriptions (prescription_id, record_id, medication_id, dosage, frequency, duration, notes, created_at) 
VALUES (802, 702, 403, '1 tablet', 'As needed', 7, 'For pain relief', SYSDATE);
INSERT INTO prescriptions (prescription_id, record_id, medication_id, dosage, frequency, duration, notes, created_at) 
VALUES (803, 703, 405, '1 tablet', 'Daily', 14, 'Morning dose', SYSDATE);
INSERT INTO prescriptions (prescription_id, record_id, medication_id, dosage, frequency, duration, notes, created_at) 
VALUES (804, 704, 402, '1 capsule', 'Three times daily', 10, 'With meals', SYSDATE);
INSERT INTO prescriptions (prescription_id, record_id, medication_id, dosage, frequency, duration, notes, created_at) 
VALUES (805, 705, 404, '1 tablet', 'With meals', 30, 'Long-term use', SYSDATE);
COMMIT; -- Commit prescriptions

-- Re-enable triggers if disabled
-- ALTER TRIGGER trg_patients_restrict ENABLE;
-- ALTER TRIGGER trg_doctors_restrict ENABLE;
-- ALTER TRIGGER trg_appointments_compound ENABLE;

PROMPT 'Sample data loaded successfully. Run on a weekend to avoid trigger restrictions.';