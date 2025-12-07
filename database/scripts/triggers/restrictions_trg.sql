-- Restriction triggers and auditing
-- Business Rule:
-- Employees CANNOT INSERT/UPDATE/DELETE on WEEKDAYS (Mon-Fri) and on PUBLIC HOLIDAYS.
-- Uses audit_pkg for checks and logging.

-- Simple BEFORE triggers for patients and doctors
CREATE OR REPLACE TRIGGER trg_patients_restrict
  BEFORE INSERT OR UPDATE OR DELETE ON patients
DECLARE
  v_allowed BOOLEAN;
BEGIN
  v_allowed := audit_pkg.is_operation_allowed(SYSDATE);
  IF v_allowed THEN
    audit_pkg.log_action(USER, 'patients', ORA_SYSEVENT, 'ALLOWED', 'Operation permitted');
  ELSE
    audit_pkg.log_action(USER, 'patients', ORA_SYSEVENT, 'DENIED', 'Operation blocked by restriction rule');
    RAISE_APPLICATION_ERROR(-20900, 'Operation not allowed on weekdays or public holidays');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_doctors_restrict
  BEFORE INSERT OR UPDATE OR DELETE ON doctors
DECLARE
  v_allowed BOOLEAN;
BEGIN
  v_allowed := audit_pkg.is_operation_allowed(SYSDATE);
  IF v_allowed THEN
    audit_pkg.log_action(USER, 'doctors', ORA_SYSEVENT, 'ALLOWED', 'Operation permitted');
  ELSE
    audit_pkg.log_action(USER, 'doctors', ORA_SYSEVENT, 'DENIED', 'Operation blocked by restriction rule');
    RAISE_APPLICATION_ERROR(-20901, 'Operation not allowed on weekdays or public holidays');
  END IF;
END;
/

-- Compound trigger for appointments (captures row-level and statement-level)
CREATE OR REPLACE TRIGGER trg_appointments_compound
FOR INSERT OR UPDATE OR DELETE ON appointments
COMPOUND TRIGGER
  v_allowed BOOLEAN;

  BEFORE STATEMENT IS
  BEGIN
    v_allowed := audit_pkg.is_operation_allowed(SYSDATE);
    IF NOT v_allowed THEN
      audit_pkg.log_action(USER, 'appointments', 'STATEMENT', 'DENIED', 'Statement blocked by restriction rule');
      RAISE_APPLICATION_ERROR(-20902, 'Operation not allowed on weekdays or public holidays');
    ELSE
      audit_pkg.log_action(USER, 'appointments', 'STATEMENT', 'ALLOWED', 'Statement permitted');
    END IF;
  END BEFORE STATEMENT;

  AFTER EACH ROW IS
  BEGIN
    audit_pkg.log_action(USER, 'appointments', 'ROW', 'ALLOWED', 'Row processed');
  END AFTER EACH ROW;
END trg_appointments_compound;
/
