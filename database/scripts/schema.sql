-- Project schema: sequences, tables, constraints, indexes
-- Schema owner: amos
-- Naming convention: snake_case for tables and columns

-- Sequences
CREATE SEQUENCE dept_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE doctor_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE patient_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE appt_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE record_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE med_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE presc_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE audit_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE holiday_seq START WITH 1 INCREMENT BY 1 NOCACHE;

-- Departments
CREATE TABLE departments (
  department_id    NUMBER        PRIMARY KEY,
  department_name  VARCHAR2(100) NOT NULL,
  location         VARCHAR2(100),
  head_doctor_id   NUMBER,
  contact_number   VARCHAR2(20),
  created_at       TIMESTAMP     DEFAULT SYSTIMESTAMP
);

-- Doctors
CREATE TABLE doctors (
  doctor_id      NUMBER        PRIMARY KEY,
  first_name     VARCHAR2(50)  NOT NULL,
  last_name      VARCHAR2(50)  NOT NULL,
  specialization VARCHAR2(100),
  department_id  NUMBER,
  contact_number VARCHAR2(20),
  email          VARCHAR2(100),
  hire_date      DATE,
  created_at     TIMESTAMP     DEFAULT SYSTIMESTAMP
);

ALTER TABLE departments
  ADD CONSTRAINT fk_dept_head_doctor
  FOREIGN KEY (head_doctor_id) REFERENCES doctors(doctor_id);

ALTER TABLE doctors
  ADD CONSTRAINT fk_doctor_department
  FOREIGN KEY (department_id) REFERENCES departments(department_id);

-- Patients
CREATE TABLE patients (
  patient_id        NUMBER        PRIMARY KEY,
  first_name        VARCHAR2(50)  NOT NULL,
  last_name         VARCHAR2(50)  NOT NULL,
  date_of_birth     DATE          NOT NULL,
  gender            VARCHAR2(10),
  blood_group       VARCHAR2(5),
  address           VARCHAR2(200),
  contact_number    VARCHAR2(20),
  email             VARCHAR2(100),
  emergency_contact VARCHAR2(100),
  insurance_details VARCHAR2(200),
  registration_date DATE          DEFAULT SYSDATE,
  created_at        TIMESTAMP     DEFAULT SYSTIMESTAMP
);

-- Appointments
CREATE TABLE appointments (
  appointment_id   NUMBER        PRIMARY KEY,
  patient_id       NUMBER        NOT NULL,
  doctor_id        NUMBER        NOT NULL,
  appointment_date DATE          NOT NULL,
  appointment_time TIMESTAMP     NOT NULL,
  purpose          VARCHAR2(200),
  status           VARCHAR2(20)  CHECK (status IN ('Scheduled','Completed','Cancelled','No-Show')),
  notes            VARCHAR2(500),
  created_at       TIMESTAMP     DEFAULT SYSTIMESTAMP
);

ALTER TABLE appointments
  ADD CONSTRAINT fk_appt_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id);
ALTER TABLE appointments
  ADD CONSTRAINT fk_appt_doctor  FOREIGN KEY (doctor_id)  REFERENCES doctors(doctor_id);

-- Medical Records
CREATE TABLE medical_records (
  record_id    NUMBER        PRIMARY KEY,
  patient_id   NUMBER        NOT NULL,
  doctor_id    NUMBER        NOT NULL,
  diagnosis    VARCHAR2(200),
  treatment    VARCHAR2(500),
  notes        VARCHAR2(1000),
  record_date  DATE,
  follow_up_date DATE,
  created_at   TIMESTAMP     DEFAULT SYSTIMESTAMP
);

ALTER TABLE medical_records
  ADD CONSTRAINT fk_rec_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id);
ALTER TABLE medical_records
  ADD CONSTRAINT fk_rec_doctor  FOREIGN KEY (doctor_id)  REFERENCES doctors(doctor_id);

-- Medications
CREATE TABLE medications (
  medication_id   NUMBER        PRIMARY KEY,
  medication_name VARCHAR2(100) NOT NULL,
  description     VARCHAR2(500),
  dosage_form     VARCHAR2(50),
  manufacturer    VARCHAR2(100),
  unit_price      NUMBER(10,2),
  stock_quantity  NUMBER,
  created_at      TIMESTAMP     DEFAULT SYSTIMESTAMP
);

-- Prescriptions (junction table between medical_records and medications)
CREATE TABLE prescriptions (
  prescription_id NUMBER        PRIMARY KEY,
  record_id       NUMBER        NOT NULL,
  medication_id   NUMBER        NOT NULL,
  dosage          VARCHAR2(50),
  frequency       VARCHAR2(50),
  duration        VARCHAR2(50),
  notes           VARCHAR2(200),
  created_at      TIMESTAMP     DEFAULT SYSTIMESTAMP
);

ALTER TABLE prescriptions
  ADD CONSTRAINT fk_presc_record     FOREIGN KEY (record_id)     REFERENCES medical_records(record_id);
ALTER TABLE prescriptions
  ADD CONSTRAINT fk_presc_medication FOREIGN KEY (medication_id) REFERENCES medications(medication_id);

-- Public Holidays (for restriction rules)
CREATE TABLE public_holidays (
  holiday_id   NUMBER        PRIMARY KEY,
  holiday_date DATE          NOT NULL,
  holiday_name VARCHAR2(100),
  description  VARCHAR2(200)
);

-- Audit Logs
CREATE TABLE audit_logs (
  log_id      NUMBER        PRIMARY KEY,
  user_id     VARCHAR2(50),
  action_date TIMESTAMP     DEFAULT SYSTIMESTAMP,
  table_name  VARCHAR2(50),
  operation   VARCHAR2(20),
  status      VARCHAR2(20), -- ALLOWED / DENIED
  details     VARCHAR2(500)
);

-- Indexes for foreign keys
CREATE INDEX idx_doctors_department ON doctors(department_id) TABLESPACE index_ts;
CREATE INDEX idx_appt_patient       ON appointments(patient_id) TABLESPACE index_ts;
CREATE INDEX idx_appt_doctor        ON appointments(doctor_id)  TABLESPACE index_ts;
CREATE INDEX idx_rec_patient        ON medical_records(patient_id) TABLESPACE index_ts;
CREATE INDEX idx_rec_doctor         ON medical_records(doctor_id)  TABLESPACE index_ts;
CREATE INDEX idx_presc_record       ON prescriptions(record_id)     TABLESPACE index_ts;
CREATE INDEX idx_presc_medication   ON prescriptions(medication_id) TABLESPACE index_ts;

-- Helper comments: use sequences when inserting
-- Example: INSERT INTO patients(patient_id, first_name, ...) VALUES (patient_seq.NEXTVAL, 'John', ...);
