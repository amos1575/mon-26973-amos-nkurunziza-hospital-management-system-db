## Architecture Overview

- **Oracle 19c PDB**: `mon_26973_amosnkurunziza_hospitalMS_db`
- **Tablespaces**: `data_ts` (tables), `index_ts` (indexes), `temp_ts` (temp)
- **Schema Owner**: `AMOS`
- **Schema Objects**:
  - Tables: core HMS entities (`patients`, `doctors`, `appointments`, etc.)
  - Sequences: for PK generation
  - Packages: `patient_mgmt`, `appointment_ops`, `audit_pkg`
  - Triggers: restriction and audit logging
- **BI Layer**: Queries for KPIs and dashboards

Flow:
1. Data captured via tables and enforced by constraints
2. Procedures/functions encapsulate business logic
3. Triggers enforce restriction rules and record audit events
4. Queries power analytics dashboards and reports
