## KPI Definitions

- **Appointments Scheduled (MTD)**: Count of `appointments` with status = 'Scheduled' in current month
  - SQL: `SELECT COUNT(*) FROM appointments WHERE status='Scheduled' AND TRUNC(appointment_date,'MM')=TRUNC(SYSDATE,'MM');`

- **Completion Rate**: Completed / Scheduled
  - SQL: `SELECT ROUND( SUM(CASE WHEN status='Completed' THEN 1 END) / NULLIF(SUM(CASE WHEN status='Scheduled' THEN 1 END),0) * 100,2) AS pct FROM appointments;`

- **No-Show Rate**: No-Show / Scheduled
  - SQL: `SELECT ROUND( SUM(CASE WHEN status='No-Show' THEN 1 END) / NULLIF(SUM(CASE WHEN status='Scheduled' THEN 1 END),0) * 100,2) AS pct FROM appointments;`

- **Doctor Utilization**: Appointments per doctor per week
  - SQL: see ranking query in `analytics_queries.sql`

- **Top Medications**: Highest prescription count per month
  - SQL: see CTE `m` in `analytics_queries.sql`
