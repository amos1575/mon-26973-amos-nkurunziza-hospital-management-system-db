-- Analytics queries using window functions

-- Appointments per patient with row numbering by date
SELECT patient_id,
       appointment_id,
       appointment_date,
       ROW_NUMBER() OVER (PARTITION BY patient_id ORDER BY appointment_date, appointment_time) AS rn
  FROM appointments
 ORDER BY patient_id, rn;

-- Doctor appointment load ranking (weekly)
SELECT doctor_id,
       TRUNC(appointment_date, 'IW') AS week_start,
       COUNT(*) AS appt_count,
       RANK()        OVER (PARTITION BY TRUNC(appointment_date, 'IW') ORDER BY COUNT(*) DESC) AS rnk,
       DENSE_RANK()  OVER (PARTITION BY TRUNC(appointment_date, 'IW') ORDER BY COUNT(*) DESC) AS drnk
  FROM appointments
 WHERE status = 'Scheduled'
 GROUP BY doctor_id, TRUNC(appointment_date, 'IW')
 ORDER BY week_start, rnk;

-- Patient visit cadence using LAG/LEAD
SELECT patient_id,
       appointment_id,
       appointment_date,
       LAG(appointment_date)  OVER (PARTITION BY patient_id ORDER BY appointment_date) AS prev_visit,
       LEAD(appointment_date) OVER (PARTITION BY patient_id ORDER BY appointment_date) AS next_visit
  FROM appointments
 ORDER BY patient_id, appointment_date;

-- Prescription volume per medication with top-N per month
WITH m AS (
  SELECT medication_id,
         TRUNC(created_at, 'MM') AS month_start,
         COUNT(*) AS cnt
    FROM prescriptions
   GROUP BY medication_id, TRUNC(created_at, 'MM')
)
SELECT medication_id, month_start, cnt,
       ROW_NUMBER() OVER (PARTITION BY month_start ORDER BY cnt DESC) AS rn
  FROM m
 WHERE cnt > 0
 ORDER BY month_start DESC, rn;
