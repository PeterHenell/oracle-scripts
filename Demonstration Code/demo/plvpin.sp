CREATE OR REPLACE PROCEDURE plvpin (
   plvschema IN VARCHAR2,
   stdplsql IN BOOLEAN := TRUE
   )
IS
   cur PLS_INTEGER;

   PROCEDURE keep (sch IN VARCHAR2, pkg IN VARCHAR2) IS
   BEGIN
      SYS.DBMS_SHARED_POOL.KEEP (sch || '.' || pkg, 'P');
   END;
BEGIN
   IF stdplsql
   THEN
      keep ('SYS', 'STANDARD');
      keep ('SYS', 'DBMS_STANDARD');
      keep ('SYS', 'DIUTIL');
      keep ('SYS', 'DBMS_SYS_SQL');
      keep ('SYS', 'DBMS_OUTPUT');

      /* Force the loading of the packages */
      IF STANDARD.TO_CHAR (SYSDATE) IS NOT NULL
      THEN
         DBMS_STANDARD.COMMIT;
         cur := DBMS_SQL.OPEN_CURSOR;
         DBMS_SQL.PARSE (cur, 'SELECT ''x'' FROM dual', DBMS_SQL.NATIVE);
         DBMS_SQL.CLOSE_CURSOR (cur);
         DBMS_OUTPUT.ENABLE (1000000);
      END IF;
   END IF;

   keep (plvschema, 'plvrep');
   keep (plvschema, 'plvdata');
   keep (plvschema, 'plvexc');
   keep (plvschema, 'plvlog');
   keep (plvschema, 'p');
   keep (plvschema, 'plvlst');
   keep (plvschema, 'plvobj');

   /* Force the loading of the packages */
   IF NOT PLVexc.tracing OR TRUE
   THEN
      IF PLVlog.logging OR TRUE
      THEN
         IF PLVrep.tracing OR TRUE
         THEN
            IF PLVdata.tracing OR TRUE
            THEN
               IF NVL (p.prefix, '*') IS NOT NULL
               THEN
                  IF PLVlst.tracing OR TRUE
                  THEN
                     IF PLVobj.tracing
                     THEN
                        NULL;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
END;
/

