-- Audit queries for validation of restriction rules and logging

-- All audit entries (latest first)
SELECT * FROM audit_logs ORDER BY action_date DESC FETCH FIRST 100 ROWS ONLY;

-- Denied operations summary by table
SELECT table_name,
       COUNT(*) AS denied_count
  FROM audit_logs
 WHERE status = 'DENIED'
 GROUP BY table_name
 ORDER BY denied_count DESC;

-- Attempted operations by user and day
SELECT user_id,
       TRUNC(action_date) AS action_day,
       COUNT(*) AS attempts,
       SUM(CASE WHEN status = 'DENIED' THEN 1 ELSE 0 END) AS denied,
       SUM(CASE WHEN status = 'ALLOWED' THEN 1 ELSE 0 END) AS allowed
  FROM audit_logs
 GROUP BY user_id, TRUNC(action_date)
 ORDER BY action_day DESC, user_id;
