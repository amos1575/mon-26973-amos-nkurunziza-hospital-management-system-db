-- Basic retrieval queries to validate data and relationships

-- Patients
SELECT * FROM patients FETCH FIRST 20 ROWS ONLY;

-- Doctors
SELECT * FROM doctors FETCH FIRST 20 ROWS ONLY;

-- Departments
SELECT * FROM departments FETCH FIRST 20 ROWS ONLY;

-- Appointments with joins
SELECT a.appointment_id,
       p.first_name || ' ' || p.last_name AS patient_name,
       d.first_name || ' ' || d.last_name AS doctor_name,
       a.appointment_date,
       a.appointment_time,
       a.status
  FROM appointments a
  JOIN patients p   ON p.patient_id = a.patient_id
  JOIN doctors  d   ON d.doctor_id  = a.doctor_id
 ORDER BY a.appointment_date, a.appointment_time;

-- Medical records with doctor and patient
SELECT mr.record_id,
       p.first_name || ' ' || p.last_name AS patient_name,
       d.first_name || ' ' || d.last_name AS doctor_name,
       mr.diagnosis,
       mr.treatment,
       mr.record_date
  FROM medical_records mr
  JOIN patients p ON p.patient_id = mr.patient_id
  JOIN doctors  d ON d.doctor_id  = mr.doctor_id
 ORDER BY mr.record_date DESC;
