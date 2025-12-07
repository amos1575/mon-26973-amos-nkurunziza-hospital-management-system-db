-- Admin/user setup for the project schema
-- Run in PDB: mon_26973_amosnkurunziza_hospitalMS_db

-- Create schema owner
CREATE USER amos IDENTIFIED BY "Amos"
  DEFAULT TABLESPACE data_ts
  TEMPORARY TABLESPACE temp_ts
  QUOTA UNLIMITED ON data_ts
  QUOTA UNLIMITED ON index_ts;  -- Also need quota for indexes

-- Grant required privileges
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE,
      CREATE PROCEDURE, CREATE TRIGGER, CREATE TYPE
TO amos;

-- Optional: role grants (if available)
-- GRANT RESOURCE TO amos;
