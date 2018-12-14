CREATE OR REPLACE PACKAGE insga
/*
|| Author: Steven Feuerstein
||
|| Overview: API to SGA shared pool area cache of PL/SQL code.
||           Provides various programs to access information of
||           interest to PL/SQL developers for tuning access to
||           their code in the SGA.
||
|| Dependencies:
||    Run grantv$.sql to grant access to any number of V$
||    accessed in this package -- or run from SYS!
||
||    pl.sp - Replacement for DBMS_OUTPUT.PUT_LINE
||
|| Either compile/run in SYS or run the GRANTV$.sql script
|| to make sure you have access to the needed views.
*/
IS
   /* Interface to:

   V$DB_OBJECT_CACHE
       Name           Type
       -------------- ----
       OWNER          VARCHAR2(64)
       NAME           VARCHAR2(1000)
       DB_LINK        VARCHAR2(64)
       NAMESPACE      VARCHAR2(15)  TABLE/PROCEDURE for PACKAGE
                                    BODY for PACKAGE BODY
       TYPE           VARCHAR2(24)  NOT LOADED, PACKAGE, PACKAGE BODY
       SHARABLE_MEM   NUMBER  0 if not loaded
       LOADS          NUMBER  0 if not loaded
       EXECUTIONS     NUMBER  0 if not loaded
       LOCKS          NUMBER
       PINS           NUMBER
       KEPT           VARCHAR2(3)

   And V$SQLAREA...
   */

   CURSOR cache_cur (
      nm IN VARCHAR2 := NULL,
      sch IN VARCHAR2 := NULL,
      tp IN VARCHAR2 := '%',
      minLoads IN PLS_INTEGER := 1,
      minExecutions IN PLS_INTEGER := 1,
      isKept IN VARCHAR2,
      includeSYS IN VARCHAR2
      )
   IS
      SELECT OWNER,
             NAME ,
             DB_LINK,
             NAMESPACE,
             TYPE,
             SHARABLE_MEM,
             LOADS,
             EXECUTIONS,
             LOCKS,
             PINS,
             KEPT
       FROM  V$DB_OBJECT_CACHE C
      WHERE owner LIKE NVL (sch, USER)
        AND (INSTR (UPPER (name), UPPER (nm)) > 0
             OR UPPER (name) LIKE UPPER (nm)) -- LIKE NVL (UPPER (nm), '%')
        AND type LIKE NVL (UPPER (tp), '%')
        AND loads >= minLoads
        AND executions >= minExecutions
        AND (kept = UPPER (isKept) OR isKept IS NULL)
        AND type != 'SYNONYM'
        AND (includesys = 'Y' OR (owner NOT IN ('SYS', 'SYSTEM')))
       ORDER BY owner, name, type;

   CURSOR cachesize_cur (
      nm IN VARCHAR2 := NULL,
      sch IN VARCHAR2 := NULL,
      tp IN VARCHAR2 := '%',
      minLoads IN PLS_INTEGER := 1,
      minExecutions IN PLS_INTEGER := 0,
      isKept IN VARCHAR2,
      includeSYS IN VARCHAR2
      )
   IS
      SELECT c.OWNER          ,
             c.NAME           ,
             DB_LINK        ,
             NAMESPACE      ,
             c.TYPE           ,
             SHARABLE_MEM   ,
             LOADS          ,
             EXECUTIONS     ,
             LOCKS          ,
             PINS           ,
             KEPT           ,
             s.code_size,
             s.code_size + s.parsed_size kept_size
       FROM  V$DB_OBJECT_CACHE C,
             (SELECT DISTINCT owner, object_name
                FROM ALL_OBJECTS
               WHERE owner LIKE sch
                 AND (includesys = 'Y' OR
                       (owner NOT IN ('SYS', 'SYSTEM')))) O,
             DBA_OBJECT_SIZE S
      WHERE C.owner LIKE NVL (UPPER (sch), USER)
        AND c.name LIKE NVL (UPPER (nm), '%')
        AND C.name = o.object_name
        AND c.type LIKE NVL (UPPER (tp), '%')
        AND loads >= minLoads
        AND executions >= minExecutions
        AND (kept = UPPER (isKept) OR isKept IS NULL)
        AND c.type != 'SYNONYM'
        AND S.owner = c.owner
        AND O.owner = c.owner
        AND S.name = o.object_name
        AND S.type = C.type
       ORDER BY c.owner, c.name, c.type;

   PROCEDure showDBcache (
      nm IN VARCHAR2 := '%',
      sch IN VARCHAR2 := USER,
      tp IN VARCHAR2 := '%',
      minLoads IN PLS_INTEGER := 1,
      minExecutions IN PLS_INTEGER := 1,
      isKept IN BOOLEAN := NULL,
      includeSYS IN BOOLEAN := FALSE
      );

   PROCEDure showDBcache_size (
      nm IN VARCHAR2 := '%',
      sch IN VARCHAR2 := USER,
      tp IN VARCHAR2 := '%',
      minLoads IN PLS_INTEGER := 1,
      minExecutions IN PLS_INTEGER := 0,
      isKept IN BOOLEAN := NULL,
      includeSYS IN BOOLEAN := FALSE
      );

   FUNCTION numExecutions (
      nm IN VARCHAR2,
      sch IN VARCHAR2 := USER,
      tp IN VARCHAR2 := '%')
      RETURN PLS_INTEGER;

   FUNCTION numLoads (
      nm IN VARCHAR2,
      sch IN VARCHAR2 := USER,
      tp IN VARCHAR2 := '%')
      RETURN PLS_INTEGER;

   PROCEDure show_hitratio (
      rc_floor IN INTEGER := 95,
      lc_floor IN INTEGER := 95);

   FUNCTION lcd_sql (
      str IN VARCHAR2,
      startat IN PLS_INTEGER := 1,
      stopat IN PLS_INTEGER := NULL,
      remove_list IN VARCHAR2 := NULL)
      RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES (lcd_sql, WNDS, WNPS);

   FUNCTION lcd_sql (
      str IN VARCHAR2,
      stopat IN VARCHAR2,
      nth IN PLS_INTEGER := 1,
      remove_list IN VARCHAR2 := NULL)
      RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES (lcd_sql, WNDS, WNPS);

   PROCEDURE show_sqltext (
      sqltext IN VARCHAR2 := '%',
      maxlen IN PLS_INTEGER := NULL);

   PROCEDURE show_similar (
      sqltext IN VARCHAR2 := '%',
      startat IN PLS_INTEGER := 1,
      stopat IN PLS_INTEGER := NULL,
      remove_list IN VARCHAR2 := NULL,
      title IN VARCHAR2 := NULL);

   PROCEDURE show_similar (
      sqltext IN VARCHAR2,
      stopat IN VARCHAR2,
      nth IN PLS_INTEGER := 1,
      remove_list IN VARCHAR2 := NULL,
      title IN VARCHAR2 := NULL);
END;
/
