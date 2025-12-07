-- Package: appointment_ops
-- Operations to schedule, cancel, and reschedule appointments with basic checks

CREATE OR REPLACE PACKAGE appointment_ops AS
  FUNCTION is_doctor_available(
    p_doctor_id IN NUMBER,
    p_date      IN DATE,
    p_time      IN TIMESTAMP
  ) RETURN BOOLEAN;

  PROCEDURE schedule_appointment(
    p_patient_id IN NUMBER,
    p_doctor_id  IN NUMBER,
    p_date       IN DATE,
    p_time       IN TIMESTAMP,
    p_purpose    IN VARCHAR2
  );

  PROCEDURE cancel_appointment(
    p_appointment_id IN NUMBER,
    p_reason         IN VARCHAR2
  );

  PROCEDURE reschedule_appointment(
    p_appointment_id IN NUMBER,
    p_new_date       IN DATE,
    p_new_time       IN TIMESTAMP
  );
END appointment_ops;
/

CREATE OR REPLACE PACKAGE BODY appointment_ops AS
  FUNCTION is_doctor_available(
    p_doctor_id IN NUMBER,
    p_date      IN DATE,
    p_time      IN TIMESTAMP
  ) RETURN BOOLEAN IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count
      FROM appointments
     WHERE doctor_id = p_doctor_id
       AND appointment_date = p_date
       AND appointment_time = p_time
       AND status IN ('Scheduled');
    RETURN v_count = 0;
  END is_doctor_available;

  PROCEDURE schedule_appointment(
    p_patient_id IN NUMBER,
    p_doctor_id  IN NUMBER,
    p_date       IN DATE,
    p_time       IN TIMESTAMP,
    p_purpose    IN VARCHAR2
  ) IS
  BEGIN
    IF NOT is_doctor_available(p_doctor_id, p_date, p_time) THEN
      RAISE_APPLICATION_ERROR(-20010, 'Doctor not available at requested time');
    END IF;

    INSERT INTO appointments(
      appointment_id, patient_id, doctor_id, appointment_date, appointment_time, purpose, status
    ) VALUES (
      appt_seq.NEXTVAL, p_patient_id, p_doctor_id, p_date, p_time, p_purpose, 'Scheduled'
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20011, 'Failed to schedule appointment: ' || SQLERRM);
  END schedule_appointment;

  PROCEDURE cancel_appointment(
    p_appointment_id IN NUMBER,
    p_reason         IN VARCHAR2
  ) IS
  BEGIN
    UPDATE appointments
       SET status = 'Cancelled',
           notes  = NVL(notes, '') || ' | Cancel reason: ' || p_reason
     WHERE appointment_id = p_appointment_id;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20012, 'Failed to cancel appointment: ' || SQLERRM);
  END cancel_appointment;

  PROCEDURE reschedule_appointment(
    p_appointment_id IN NUMBER,
    p_new_date       IN DATE,
    p_new_time       IN TIMESTAMP
  ) IS
    v_doctor NUMBER;
  BEGIN
    SELECT doctor_id INTO v_doctor FROM appointments WHERE appointment_id = p_appointment_id;
    IF NOT is_doctor_available(v_doctor, p_new_date, p_new_time) THEN
      RAISE_APPLICATION_ERROR(-20013, 'Doctor not available at new requested time');
    END IF;

    UPDATE appointments
       SET appointment_date = p_new_date,
           appointment_time = p_new_time,
           status           = 'Scheduled'
     WHERE appointment_id   = p_appointment_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20014, 'Appointment not found');
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20015, 'Failed to reschedule appointment: ' || SQLERRM);
  END reschedule_appointment;
END appointment_ops;
/
