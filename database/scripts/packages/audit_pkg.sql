-- Package: audit_pkg
-- Centralized audit logging and restriction checks

CREATE OR REPLACE PACKAGE audit_pkg AS
  -- Check if DML operations are allowed (weekends/holidays only)
  FUNCTION is_operation_allowed(p_op_date IN DATE) RETURN BOOLEAN;

  -- Log general audit actions
  PROCEDURE log_action(
    p_user_id    IN VARCHAR2,
    p_table_name IN VARCHAR2,
    p_operation  IN VARCHAR2,
    p_status     IN VARCHAR2,
    p_details    IN VARCHAR2
  );
  
  -- Log restriction attempts (when DML is blocked)
  PROCEDURE log_restriction_attempt(
    p_table_name IN VARCHAR2,
    p_operation  IN VARCHAR2,
    p_user_name  IN VARCHAR2,
    p_reason     IN VARCHAR2
  );
  
  -- Enable/disable restriction checks for maintenance
  PROCEDURE set_override_mode(p_enable IN BOOLEAN);
END audit_pkg;
/

CREATE OR REPLACE PACKAGE BODY audit_pkg AS
  -- Global variable for override mode
  g_override_mode BOOLEAN := FALSE;
  
  -- Check if DML operations are allowed (weekends/holidays only)
  FUNCTION is_operation_allowed(p_op_date IN DATE) RETURN BOOLEAN IS
    v_day VARCHAR2(3);
    v_holiday NUMBER;
  BEGIN
    -- If override mode is enabled, allow operations
    IF g_override_mode THEN
      RETURN TRUE;
    END IF;
    
    -- Weekday check (Mon-Fri are not allowed)
    v_day := TO_CHAR(p_op_date, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH');
    IF v_day IN ('MON','TUE','WED','THU','FRI') THEN
      RETURN FALSE;
    END IF;

    -- Public holiday check (assumes upcoming holidays loaded into public_holidays)
    SELECT COUNT(*) INTO v_holiday
      FROM public_holidays
     WHERE holiday_date = TRUNC(p_op_date);

    IF v_holiday > 0 THEN
      RETURN FALSE;
    END IF;

    RETURN TRUE;
  END is_operation_allowed;

  -- Log general audit actions
  PROCEDURE log_action(
    p_user_id    IN VARCHAR2,
    p_table_name IN VARCHAR2,
    p_operation  IN VARCHAR2,
    p_status     IN VARCHAR2,
    p_details    IN VARCHAR2
  ) IS
  BEGIN
    INSERT INTO audit_logs(
      log_id, user_id, action_date, table_name, operation, status, details
    ) VALUES (
      audit_seq.NEXTVAL, p_user_id, SYSTIMESTAMP, p_table_name, p_operation, p_status, p_details
    );
  END log_action;
  
  -- Log restriction attempts (when DML is blocked)
  PROCEDURE log_restriction_attempt(
    p_table_name IN VARCHAR2,
    p_operation  IN VARCHAR2,
    p_user_name  IN VARCHAR2,
    p_reason     IN VARCHAR2
  ) IS
  BEGIN
    INSERT INTO audit_logs(
      log_id, user_id, action_date, table_name, operation, status, details
    ) VALUES (
      audit_seq.NEXTVAL, p_user_name, SYSTIMESTAMP, p_table_name, p_operation, 'BLOCKED', p_reason
    );
  END log_restriction_attempt;
  
  -- Enable/disable restriction checks for maintenance
  PROCEDURE set_override_mode(p_enable IN BOOLEAN) IS
  BEGIN
    g_override_mode := p_enable;
  END set_override_mode;
  
END audit_pkg;
/
