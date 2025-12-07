-- Create and open Pluggable Database (PDB)
-- NOTE: Run as a privileged CDB user (SYS AS SYSDBA)
ALTER SESSION SET CONTAINER = CDB$ROOT;

CREATE PLUGGABLE DATABASE mon_26973_amosnkurunziza_hospitalMS_db
  ADMIN USER amos IDENTIFIED BY "Amos"
  FILE_NAME_CONVERT = (
    'C:\APP\HP\PRODUCT\21C\ORADATA\XE\PDBSEED\',
    'C:\APP\HP\PRODUCT\21C\ORADATA\XE\MON_26973_AMOSNKURUNZIZA_HOSPITALMS_DB\'
  );

-- Open and save state
ALTER PLUGGABLE DATABASE mon_26973_amosnkurunziza_hospitalMS_db OPEN;
ALTER PLUGGABLE DATABASE mon_26973_amosnkurunziza_hospitalMS_db SAVE STATE;

-- Connect session to the new PDB when needed
-- ALTER SESSION SET CONTAINER = mon_26973_amosnkurunziza_hospitalMS_db;
