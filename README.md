# Hospital Management System Database
## PL/SQL Capstone Project

### Student Information
- **Student ID**: 26973
- **Name**: NKURUNZIZA Amos
- **Institution**: Adventist University of Central Africa (AUCA)
- **Course**: Database Development with PL/SQL (INSY 8311)
- **Academic Year**: 2025-2026
- **Project Completion Date**: December 7, 2025

---

## Problem Statement

### Problem Definition
The Hospital Management System (HMS) is designed to streamline and automate healthcare operations of a hospital facility. It provides a comprehensive database solution to manage patient information, physician details, appointments scheduling, medical records, prescription tracking, and inventory management.

### Context
This system will be implemented in mid-sized to large hospital facilities where manual record-keeping has become inefficient and error-prone. The HMS will serve as the central data management system connecting all hospital departments.

### Target Users
- Hospital administrative staff
- Doctors and medical professionals
- Nurses and support staff
- Pharmacy department
- Patients (for appointment viewing/scheduling)

### Project Goals
- Streamline patient registration and information management
- Automate appointment scheduling and tracking
- Maintain comprehensive electronic medical records
- Track medication prescriptions and inventory
- Enhance data security and access control
- Generate reports for administrative decision-making
- Reduce paperwork and administrative overhead
- Minimize errors in patient care and medication administration

---

## Solution Overview

### Key Objectives
- Design normalized database for hospital operations (3NF)
- Implement business rules with PL/SQL packages and procedures
- Create automated audit system with comprehensive logging
- Enable advanced analytics capabilities using window functions
- Develop Business Intelligence dashboards for decision support

### Scope
- Patient management module
- Doctor/departments module
- Appointment scheduling system
- Medical records and prescriptions
- Audit and compliance tracking
- Business intelligence reporting

### Key Features
- Weekend/holiday data modification restrictions
- Comprehensive audit logging with detailed violation records
- Role-based access control
- Advanced analytics with window functions
- Business intelligence dashboard planning

---

## Database Design

### Entity-Relationship Model
![Hospital Management System ER Diagram](documentation/images/hospital_er_diagram.png)

### Entities and Attributes

1. **Departments**
   - department_id (PK): NUMBER
   - department_name: VARCHAR2(100)
   - location: VARCHAR2(100)
   - head_doctor_id (FK): NUMBER
   - contact_number: VARCHAR2(20)
   - created_date: TIMESTAMP

2. **Doctors**
   - doctor_id (PK): NUMBER
   - first_name: VARCHAR2(50) NOT NULL
   - last_name: VARCHAR2(50) NOT NULL
   - specialization: VARCHAR2(100)
   - department_id (FK): NUMBER
   - contact_number: VARCHAR2(20)
   - email: VARCHAR2(100)
   - hire_date: DATE
   - created_date: TIMESTAMP

3. **Patients**
   - patient_id (PK): NUMBER
   - first_name: VARCHAR2(50) NOT NULL
   - last_name: VARCHAR2(50) NOT NULL
   - date_of_birth: DATE NOT NULL
   - gender: VARCHAR2(10)
   - blood_group: VARCHAR2(5)
   - address: VARCHAR2(200)
   - contact_number: VARCHAR2(20)
   - email: VARCHAR2(100)
   - emergency_contact: VARCHAR2(100)
   - insurance_details: VARCHAR2(200)
   - registration_date: DATE
   - created_date: TIMESTAMP

4. **Appointments**
   - appointment_id (PK): NUMBER
   - patient_id (FK): NUMBER
   - doctor_id (FK): NUMBER
   - appointment_date: DATE NOT NULL
   - appointment_time: TIMESTAMP NOT NULL
   - purpose: VARCHAR2(200)
   - status: VARCHAR2(20) CHECK (status IN ('Scheduled', 'Completed', 'Cancelled', 'No-Show'))
   - notes: VARCHAR2(500)
   - created_date: TIMESTAMP

5. **Medical_Records**
   - record_id (PK): NUMBER
   - patient_id (FK): NUMBER
   - doctor_id (FK): NUMBER
   - diagnosis: VARCHAR2(200)
   - treatment: VARCHAR2(500)
   - prescription: VARCHAR2(500)
   - notes: VARCHAR2(1000)
   - record_date: DATE
   - follow_up_date: DATE
   - created_date: TIMESTAMP

6. **Medications**
   - medication_id (PK): NUMBER
   - medication_name: VARCHAR2(100) NOT NULL
   - description: VARCHAR2(500)
   - dosage_form: VARCHAR2(50)
   - manufacturer: VARCHAR2(100)
   - unit_price: NUMBER(10,2)
   - stock_quantity: NUMBER
   - created_date: TIMESTAMP

7. **Prescriptions**
   - prescription_id (PK): NUMBER
   - record_id (FK): NUMBER
   - medication_id (FK): NUMBER
   - dosage: VARCHAR2(50)
   - frequency: VARCHAR2(50)
   - duration: VARCHAR2(50)
   - notes: VARCHAR2(200)
   - created_date: TIMESTAMP

8. **Public_Holidays** (Added for Phase 7 requirements)
   - holiday_id (PK): NUMBER
   - holiday_date: DATE NOT NULL
   - holiday_name: VARCHAR2(100)
   - description: VARCHAR2(200)

9. **Audit_Logs** (Added for Phase 7 requirements)
   - log_id (PK): NUMBER
   - user_id: VARCHAR2(50)
   - action_date: TIMESTAMP
   - table_name: VARCHAR2(50)
   - operation: VARCHAR2(20)
   - status: VARCHAR2(20)
   - details: VARCHAR2(500)

### Relationships & Constraints
- **Doctors to Departments**: Many-to-One (Doctors belong to one department)
- **Departments to Doctors**: One-to-One (Each department has one head doctor)
- **Patients to Appointments**: One-to-Many (Patients can have multiple appointments)
- **Doctors to Appointments**: One-to-Many (Doctors can have multiple appointments)
- **Patients to Medical_Records**: One-to-Many (Patients can have multiple medical records)
- **Doctors to Medical_Records**: One-to-Many (Doctors can create multiple medical records)
- **Medical_Records to Medications**: Many-to-Many (through Prescriptions junction table)

### Normalization
The database design adheres to the Third Normal Form (3NF):
- All non-key attributes are fully dependent on the primary key
- No transitive dependencies
- No partial dependencies on composite keys
- Separate tables for independent entities

---

## Technical Implementation

### Technology Stack
- Oracle Database 21c XE
- PL/SQL Packages, Procedures, Functions
- Triggers and Sequences
- SQL Developer for modeling
- Oracle Enterprise Manager for monitoring

### Database Creation
```sql
-- Create Pluggable Database
CREATE PLUGGABLE DATABASE mon_26973_amosnkurunziza_hospitalMS_db
ADMIN USER charite IDENTIFIED BY amos2
FILE_NAME_CONVERT = (
    'C:\app\HP\product\21c\oradata\XE\PDBSEED\', 
    'C:\app\HP\product\21c\oradata\XE\MON_26973_AMOSNKURUNZIZA_HOSPITALMS_DB\'
);

-- Open the PDB
ALTER PLUGGABLE DATABASE mon_26973_amosnkurunziza_hospitalMS_db OPEN;

-- Switch to the PDB
ALTER SESSION SET CONTAINER = mon_26973_amosnkurunziza_hospitalMS_db;
```

### Table Creation
All tables were created with proper constraints, primary keys, foreign keys, and indexes for optimal performance.

### Data Volume
- 100-500+ rows per main table
- Realistic test data representing actual hospital scenarios
- Edge cases and null values included for comprehensive testing

---

## PL/SQL Development

### Packages Implemented

1. **Patient Management Package** (`patient_mgmt_pkg`)
   - Procedures for patient registration
   - Functions for patient validation
   - Appointment scheduling capabilities

2. **Appointment Operations Package** (`appointment_ops_pkg`)
   - Procedures for appointment management
   - Functions for availability checking
   - Notification systems

3. **Audit Package** (`audit_pkg`)
   - Functions for operation validation
   - Procedures for audit logging
   - Override mode for maintenance

### Triggers Implemented

1. **Restriction Triggers**
   - Block DML operations on weekdays (Monday-Friday)
   - Block DML operations on public holidays
   - Allow operations only on weekends and non-holiday weekdays

2. **Audit Triggers**
   - Comprehensive logging of all database operations
   - User identification and timestamp recording
   - Detailed operation descriptions

3. **Compound Trigger**
   - Captures both statement-level and row-level events
   - Ensures complete audit trails without mutating table errors

---

## Business Intelligence & Analytics

### KPIs Defined
- Patient throughput rates
- Doctor utilization metrics
- Appointment fulfillment ratios
- Audit violation trends
- Resource allocation efficiency

### Analytical Queries
Advanced analytics using Oracle window functions:
- `ROW_NUMBER()` for patient ranking
- `RANK()` and `DENSE_RANK()` for doctor performance comparison
- `LAG()` and `LEAD()` for trend analysis
- Partitioned aggregations for departmental reporting

### Dashboard Types Planned
1. **Executive Summary Dashboard**
   - Key metrics overview
   - Trend visualization
   - Performance indicators

2. **Audit Dashboard**
   - Security violations tracking
   - Access pattern analysis
   - Compliance monitoring

3. **Performance Dashboard**
   - Resource utilization metrics
   - Operational efficiency reports
   - Staff productivity analysis

---

## Results & Testing

### Database Objects Created
- 9 Tables with constraints
- 8 Sequences for ID generation
- 3 Packages with procedures/functions
- 3 Triggers deployed
- Indexes for performance optimization

### Test Results
- Data loading: 100+ records per table successfully inserted
- Trigger testing: Weekday denial/Weekend allowance working correctly
- Audit logging: All attempts captured with detailed information
- Analytics queries: Window functions producing expected results
- Constraint validation: Referential integrity maintained

### Validation Queries
Complex queries successfully executed to validate:
- Join operations across multiple tables
- Aggregation functions for reporting
- Subqueries for data filtering
- Window functions for analytics

---

## Repository Structure
```
your-project-repo/
├── README.md (project overview)
├── database/
│   ├── scripts/
│   │   ├── create_pdb.sql
│   │   ├── tablespaces.sql
│   │   ├── user_setup.sql
│   │   ├── schema.sql
│   │   └── packages/
│   │       ├── patient_mgmt_pkg.sql
│   │       ├── appointment_ops_pkg.sql
│   │       └── audit_pkg.sql
│   └── documentation/
│       ├── data_dictionary.md
│       ├── architecture.md
│       └── design_decisions.md
├── queries/
│   ├── data_retrieval.sql
│   ├── analytics_queries.sql
│   └── audit_queries.sql
├── business_intelligence/
│   ├── bi_requirements.md
│   ├── dashboards.md
│   └── kpi_definitions.md
├── screenshots/
│   ├── oem_monitoring/
│   ├── database_objects/
│   └── test_results/
└── documentation/
    ├── data_dictionary.md
    ├── architecture.md
    └── design_decisions.md
```

## Quick Start Instructions

1. Connect as a privileged CDB user and run `database/scripts/create_pdb.sql`
2. Connect to PDB `mon_26973_amosnkurunziza_hospitalMS_db` and run `database/scripts/tablespaces.sql`
3. Create the schema owner with `database/scripts/user_setup.sql`
4. As `AMOS`, run `database/scripts/schema.sql` to create tables, sequences, constraints, and indexes
5. Load PL/SQL packages:
   - `database/scripts/packages/patient_mgmt_pkg.sql`
   - `database/scripts/packages/appointment_ops_pkg.sql`
   - `database/scripts/packages/audit_pkg.sql`
6. Enable restriction/audit triggers: `database/scripts/triggers/restrictions_trg.sql`
7. Seed upcoming public holidays in `public_holidays` for testing
8. Validate using queries in `queries/` and capture screenshots into `screenshots/`

## Useful Links
- Documentation: `documentation/`
- BI: `business_intelligence/`
- Queries: `queries/`
- Scripts: `database/scripts/`

## Conclusion

### Achievements
- ✅ Complete hospital database system with 9 normalized tables
- ✅ Business rule enforcement with weekday/holiday restrictions
- ✅ Comprehensive audit system with detailed logging
- ✅ Advanced analytics capabilities using window functions
- ✅ Business intelligence dashboard planning with KPI definitions
- ✅ Professional code organization and documentation

### Lessons Learned
- Importance of constraint validation and referential integrity
- Power of PL/SQL packages for code organization and reuse
- Value of comprehensive audit trails for security and compliance
- Need for systematic testing with realistic data scenarios
- Benefits of proper database normalization for data quality

This project demonstrates proficiency in Oracle PL/SQL development, database design principles, business rule implementation, and analytics capabilities essential for enterprise database systems.