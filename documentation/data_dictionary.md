## Data Dictionary (Excerpt)

| Table | Column | Type | Constraints | Purpose |
|------|--------|------|-------------|---------|
| departments | department_id | NUMBER | PK | Department identifier |
| departments | department_name | VARCHAR2(100) | NOT NULL | Name |
| departments | head_doctor_id | NUMBER | FK->doctors.doctor_id | Head of department |
| doctors | doctor_id | NUMBER | PK | Doctor identifier |
| doctors | department_id | NUMBER | FK->departments.department_id | Affiliation |
| patients | patient_id | NUMBER | PK | Patient identifier |
| appointments | appointment_id | NUMBER | PK | Appointment identifier |
| appointments | patient_id | NUMBER | FK->patients.patient_id | Patient linkage |
| appointments | doctor_id | NUMBER | FK->doctors.doctor_id | Doctor linkage |
| medical_records | record_id | NUMBER | PK | Medical record |
| prescriptions | prescription_id | NUMBER | PK | Prescription entry |
| public_holidays | holiday_date | DATE | NOT NULL | Restriction date |
| audit_logs | log_id | NUMBER | PK | Audit entry |

Notes:
- All PK values are populated via project sequences (e.g., `patient_seq.NEXTVAL`).
- Indexes created on common FK columns for join performance.
- Use `snake_case` consistently across schema objects.
