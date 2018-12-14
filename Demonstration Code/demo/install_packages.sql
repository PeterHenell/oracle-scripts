SET VERIFY OFF
DEFINE install_owner = SWYG
REM DEFINE obj_wildcard = MT
COLUMN oneline FORMAT a100
COLUMN ord FORMAT 9 NOPRINT
COLUMN name FORMAT a100 NOPRINT

SPOOL temp_i_packages.sql
PROMPT
PROMPT REM Installation script for Mentat Packages
PROMPT REM DO NOT MODIFY
PROMPT REM Run package_installs.ogs to refresh this script.
PROMPT
SELECT 1 ord
     ,    'PROMPT Compiling types package specification for "'
       || NAME
       || '"...'
       || CHR (10)
       || '@@'
       || NAME
       || '_tp.pks'
       || CHR (10)
       || 'SHOW ERRORS' line
  FROM sm_object
 WHERE owner = '&install_owner'
                               --  AND NAME LIKE '&obj_wildcard' || '%'
       AND TYPE IN ('TABLE')
UNION
SELECT 2 ord
     ,    'PROMPT Compiling query package specification for "'
       || NAME
       || '"...'
       || CHR (10)
       || '@@'
       || NAME
       || '_qp.pks'
       || CHR (10)
       || 'SHOW ERRORS' line
  FROM sm_object
 WHERE owner = '&install_owner'
                               --  AND NAME LIKE '&obj_wildcard' || '%'
       AND TYPE IN ('TABLE')
UNION
SELECT 3 ord
     ,    'PROMPT Compiling change package specification for "'
       || NAME
       || '"...'
       || CHR (10)
       || '@@'
       || NAME
       || '_cp.pks'
       || CHR (10)
       || 'SHOW ERRORS' line
  FROM sm_object
 WHERE owner = '&install_owner'
                               --  AND NAME LIKE '&obj_wildcard' || '%'
       AND TYPE IN ('TABLE')
UNION
SELECT 3.5 ord
     ,    'PROMPT Compiling specification for "'
       || NAME
       || '"...'
       || CHR (10)
       || '@@'
       || NAME
       || '.pks'
       || CHR (10)
       || 'SHOW ERRORS' line
  FROM sm_object
 WHERE owner = '&install_owner'                               
   AND TYPE IN ('PACKAGE')
   AND NAME NOT LIKE '%_TP'
   AND NAME NOT LIKE '%_QP'
   AND NAME NOT LIKE '%_CP'
   AND NAME NOT LIKE '%_GP'
UNION
SELECT 4 ord
     ,    'PROMPT Compiling group package specification for "'
       || sm_object.NAME
       || '"...'
       || CHR (10)
       || '@@'
       || sm_object.NAME
       || '_gp.pks'
       || CHR (10)
       || 'SHOW ERRORS' line
  FROM sm_object
 WHERE owner = '&install_owner'
   --  AND NAME LIKE '&obj_wildcard' || '%'
   AND NAME IN
          ('SM_SHOWME'
         , 'SM_OBJECT'
         , 'SU_SHOWME'
         , 'SG_SCRIPT'
         , 'SM_TASK'
          )
UNION
SELECT 6 ord
     ,    'PROMPT Compiling query package body for "'
       || NAME
       || '"...'
       || CHR (10)
       || '@@'
       || NAME
       || '_qp.pkb'
       || CHR (10)
       || 'SHOW ERRORS' line
  FROM sm_object
 WHERE owner = '&install_owner'
                               --  AND NAME LIKE '&obj_wildcard' || '%'
       AND TYPE IN ('TABLE')
UNION
SELECT 7 ord
     ,    'PROMPT Compiling change package body for "'
       || NAME
       || '"...'
       || CHR (10)
       || '@@'
       || NAME
       || '_cp.pkb'
       || CHR (10)
       || 'SHOW ERRORS' line
  FROM sm_object
 WHERE owner = '&install_owner'
                               --  AND NAME LIKE '&obj_wildcard' || '%'
       AND TYPE IN ('TABLE')
UNION
SELECT 8 ord
     ,    'PROMPT Compiling group package body for "'
       || sm_object.NAME
       || '"...'
       || CHR (10)
       || '@@'
       || sm_object.NAME
       || '_gp.pkb'
       || CHR (10)
       || 'SHOW ERRORS' line
  FROM sm_object
 WHERE owner = '&install_owner'
   AND NAME IN
          ('SM_SHOWME'
         , 'SM_OBJECT'
         , 'SU_SHOWME'
         , 'SG_SCRIPT'
         , 'SM_TASK'
          )
--  AND NAME LIKE '&obj_wildcard' || '%'
UNION
SELECT 9 ord
     ,    'PROMPT Compiling body for "'
       || NAME
       || '"...'
       || CHR (10)
       || '@@'
       || NAME
       || '.pkb'
       || CHR (10)
       || 'SHOW ERRORS' line
  FROM sm_object
 WHERE owner = '&install_owner'
   --  AND NAME LIKE '&obj_wildcard' || '%'
   AND TYPE IN ('PACKAGE')
   AND NAME NOT LIKE '%_TP'
   AND NAME NOT LIKE '%_QP'
   AND NAME NOT LIKE '%_CP'
   AND NAME NOT LIKE '%_GP'
/
SPOOL OFF