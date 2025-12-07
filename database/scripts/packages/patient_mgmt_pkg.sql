-- Package: patient_mgmt
-- Public API for patient CRUD and utilities

CREATE OR REPLACE PACKAGE patient_mgmt AS
  PROCEDURE add_patient(
    p_first_name        IN VARCHAR2,
    p_last_name         IN VARCHAR2,
    p_date_of_birth     IN DATE,
    p_gender            IN VARCHAR2,
    p_blood_group       IN VARCHAR2,
    p_address           IN VARCHAR2,
    p_contact_number    IN VARCHAR2,
    p_email             IN VARCHAR2,
    p_emergency_contact IN VARCHAR2,
    p_insurance_details IN VARCHAR2
  );

  PROCEDURE update_patient(
    p_patient_id        IN NUMBER,
    p_address           IN VARCHAR2,
    p_contact_number    IN VARCHAR2,
    p_email             IN VARCHAR2
  );

  PROCEDURE delete_patient(
    p_patient_id IN NUMBER
  );

  FUNCTION get_patient_age(p_date_of_birth IN DATE) RETURN NUMBER;
END patient_mgmt;
/

CREATE OR REPLACE PACKAGE BODY patient_mgmt AS
  PROCEDURE add_patient(
    p_first_name        IN VARCHAR2,
    p_last_name         IN VARCHAR2,
    p_date_of_birth     IN DATE,
    p_gender            IN VARCHAR2,
    p_blood_group       IN VARCHAR2,
    p_address           IN VARCHAR2,
    p_contact_number    IN VARCHAR2,
    p_email             IN VARCHAR2,
    p_emergency_contact IN VARCHAR2,
    p_insurance_details IN VARCHAR2
  ) IS
  BEGIN
    INSERT INTO patients(
      patient_id, first_name, last_name, date_of_birth, gender, blood_group,
      address, contact_number, email, emergency_contact, insurance_details
    ) VALUES (
      patient_seq.NEXTVAL, p_first_name, p_last_name, p_date_of_birth, p_gender, p_blood_group,
      p_address, p_contact_number, p_email, p_emergency_contact, p_insurance_details
    );
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20001, 'Failed to add patient: ' || SQLERRM);
  END add_patient;

  PROCEDURE update_patient(
    p_patient_id        IN NUMBER,
    p_address           IN VARCHAR2,
    p_contact_number    IN VARCHAR2,
    p_email             IN VARCHAR2
  ) IS
  BEGIN
    UPDATE patients
       SET address        = p_address,
           contact_number = p_contact_number,
           email          = p_email
     WHERE patient_id     = p_patient_id;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20002, 'Failed to update patient: ' || SQLERRM);
  END update_patient;

  PROCEDURE delete_patient(
    p_patient_id IN NUMBER
  ) IS
  BEGIN
    DELETE FROM patients WHERE patient_id = p_patient_id;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20003, 'Failed to delete patient: ' || SQLERRM);
  END delete_patient;

  FUNCTION get_patient_age(p_date_of_birth IN DATE) RETURN NUMBER IS
    v_years NUMBER;
  BEGIN
    v_years := FLOOR(MONTHS_BETWEEN(SYSDATE, p_date_of_birth) / 12);
    RETURN v_years;
  END get_patient_age;
END patient_mgmt;
/
