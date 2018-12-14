-- _______________________________
-- |									        
-- |   Recompile Utility		
-- |______________________________
--
-- AUTHOR:	Solomon Yakobson, mods by Steven Feuerstein
-- NOTE: See recompile8.sql for full documentation
--
CREATE TABLE recompile_log (
   recompiled_on DATE,
   description VARCHAR2(2000)
   );
   
CREATE OR REPLACE PROCEDURE auto_recompile (
   o_owner IN VARCHAR2 := USER,
   o_name IN VARCHAR2 := '%',
   o_type IN VARCHAR2 := '%',
   o_status IN VARCHAR2 := 'INVALID',
   display IN BOOLEAN := TRUE,
   write_to_log IN BOOLEAN := FALSE)
IS
   -- Exceptions

   successwithcompilationerror EXCEPTION;
   PRAGMA EXCEPTION_INIT (successwithcompilationerror,- 24344);

   -- Return Codes

   invalid_type CONSTANT INTEGER := 1;
   invalid_parent CONSTANT INTEGER := 2;
   compile_errors CONSTANT INTEGER := 4;

   cnt NUMBER;
   dyncur INTEGER;
   type_status INTEGER := 0;
   parent_status INTEGER := 0;
   recompile_status INTEGER := 0;
   object_status VARCHAR2(30);
   CURSOR invalid_parent_cursor (
      oowner VARCHAR2,
      oname VARCHAR2,
      otype VARCHAR2,
      ostatus VARCHAR2,
      oid NUMBER)
   IS
      SELECT   /*+ RULE */o.object_id
        FROM public_dependency d, dba_objects o
       WHERE     d.object_id = oid
             AND o.object_id = d.referenced_object_id
             AND o.status != 'VALID'
      MINUS
      SELECT   /*+ RULE */object_id
        FROM dba_objects
       WHERE     owner LIKE UPPER (oowner)
             AND object_name LIKE UPPER (oname)
             AND object_type LIKE UPPER (otype)
             AND status LIKE UPPER (ostatus);
   CURSOR recompile_cursor (oid NUMBER)
   IS

      SELECT   /*+ RULE */'ALTER '||
             DECODE (
                object_type,
                'PACKAGE BODY', 'PACKAGE',
                'TYPE BODY', 'TYPE',
                object_type
             ) ||
             ' '||
             owner ||
             '.'||
             object_name ||
             ' COMPILE '||
             DECODE (
                object_type,
                'PACKAGE BODY', ' BODY',
                'TYPE BODY', 'BODY',
                'TYPE', 'SPECIFICATION',
                ''
             ) stmt,
             object_type,
             owner,
             object_name
        FROM dba_objects
       WHERE object_id = oid;
   recompile_record recompile_cursor%ROWTYPE;
   CURSOR obj_cursor (
      oowner VARCHAR2,
      oname VARCHAR2,
      otype VARCHAR2,
      ostatus VARCHAR2)
   IS
      SELECT   /*+ RULE */MAX (LEVEL) dlevel, object_id
        FROM sys.public_dependency
       START WITH object_id IN ( SELECT object_id
                                   FROM dba_objects
                                  WHERE     owner LIKE UPPER (oowner)
                                        AND object_name LIKE UPPER (oname)
                                        AND object_type LIKE UPPER (otype)
                                        AND status LIKE UPPER (ostatus))
       CONNECT BY object_id = PRIOR referenced_object_id
       GROUP BY object_id
      HAVING MIN (LEVEL) = 1
      UNION ALL
      SELECT 1 dlevel, object_id
        FROM dba_objects o
       WHERE     owner LIKE UPPER (oowner)
             AND object_name LIKE UPPER (oname)
             AND object_type LIKE UPPER (otype)
             AND status LIKE UPPER (ostatus)
             AND NOT EXISTS (SELECT 1
                   FROM sys.public_dependency d
                  WHERE d.object_id = o.object_id)
      ORDER BY 1 desc;
   CURSOR status_cursor (oid NUMBER)
   IS
      SELECT   /*+ RULE */status
        FROM dba_objects
       WHERE object_id = oid;
BEGIN

   -- Recompile requested objects based on their dependency levels.

   IF display
   THEN
      DBMS_OUTPUT.put_line (CHR (0));
      DBMS_OUTPUT.put_line ('                            RECOMPILING OBJECTS');
      DBMS_OUTPUT.put_line (CHR (0));
      DBMS_OUTPUT.put_line (
         '                            Object Owner is  '|| o_owner
      );
      DBMS_OUTPUT.put_line (
         '                            Object Name is   '|| o_name
      );
      DBMS_OUTPUT.put_line (
         '                            Object Type is   '|| o_type
      );
      DBMS_OUTPUT.put_line (
         '                            Object Status is '|| o_status
      );
      DBMS_OUTPUT.put_line (CHR (0));
   END IF;
   dyncur := DBMS_SQL.open_cursor;
   FOR obj_record IN obj_cursor (o_owner, o_name, o_type, o_status)
   LOOP
      OPEN recompile_cursor (obj_record.object_id);
      FETCH recompile_cursor INTO recompile_record;
      CLOSE recompile_cursor;

      -- We can recompile only Functions, Packages, Package Bodies,
      -- Procedures, Triggers, Views, Types and Type Bodies.

      IF recompile_record.object_type IN ('FUNCTION',
               'PACKAGE',
               'PACKAGE BODY',
               'PROCEDURE',
               'TRIGGER',
               'VIEW',
               'TYPE',
               'TYPE BODY'
              )
      THEN

         -- There is no sense to recompile an object that depends on
         -- invalid objects outside of the current recompile request.

         OPEN invalid_parent_cursor (
                 o_owner,
                 o_name,
                 o_type,
                 o_status,
                 obj_record.object_id
              );
         FETCH invalid_parent_cursor INTO cnt;
         IF invalid_parent_cursor%NOTFOUND
         THEN

            -- Recompile object.

            BEGIN
               DBMS_SQL.parse (dyncur, recompile_record.stmt, DBMS_SQL.native);
            EXCEPTION
               WHEN successwithcompilationerror
               THEN
                  NULL;
            END;
            OPEN status_cursor (obj_record.object_id);
            FETCH status_cursor INTO object_status;
            CLOSE status_cursor;
            IF display
            THEN
               DBMS_OUTPUT.put_line (
                  recompile_record.object_type ||
                  ' '||
                  recompile_record.owner ||
                  '.'||
                  recompile_record.object_name ||
                  ' is recompiled. Object status is '||
                  object_status ||
                  '.'
               );
            END IF;
            IF write_to_log /* Added by Steven Feuerstein */
            THEN
               INSERT INTO recompile_log VALUES (
                  SYSDATE,
                  recompile_record.object_type ||
                  ' '||
                  recompile_record.owner ||
                  '.'||
                  recompile_record.object_name ||
                  ' is recompiled. Object status is '||
                  object_status ||
                  '.'
               );
            END IF;
            IF object_status <> 'VALID'
            THEN
               recompile_status := compile_errors;
            END IF;
         ELSE
            IF display
            THEN
               DBMS_OUTPUT.put_line (
                  recompile_record.object_type ||
                  ' '||
                  recompile_record.owner ||
                  '.'||
                  recompile_record.object_name ||
                  ' references invalid object(s)'||
                  ' outside of this request.'
               );
            END IF;
            IF write_to_log /* Added by Steven Feuerstein */
            THEN
               INSERT INTO recompile_log VALUES (
                  SYSDATE,
                  recompile_record.object_type ||
                  ' '||
                  recompile_record.owner ||
                  '.'||
                  recompile_record.object_name ||
                  ' references invalid object(s)'||
                  ' outside of this request.'
               );
            END IF;
            parent_status := invalid_parent;
         END IF;
         CLOSE invalid_parent_cursor;
      ELSE
         IF display
         THEN
            DBMS_OUTPUT.put_line (
               recompile_record.owner ||
               '.'||
               recompile_record.object_name ||
               ' is a '||
               recompile_record.object_type ||
               ' and can not be recompiled.'
            );
         END IF;
         type_status := invalid_type;
      END IF;
   END LOOP;
   DBMS_SQL.close_cursor (dyncur);
   IF write_to_log
   THEN
      COMMIT;
   END IF;
   -- RETURN type_status + parent_status + recompile_status;
EXCEPTION
   WHEN OTHERS
   THEN
      IF obj_cursor%ISOPEN
      THEN
         CLOSE obj_cursor;
      END IF;
      IF recompile_cursor%ISOPEN
      THEN
         CLOSE recompile_cursor;
      END IF;
      IF invalid_parent_cursor%ISOPEN
      THEN
         CLOSE invalid_parent_cursor;
      END IF;
      IF status_cursor%ISOPEN
      THEN
         CLOSE status_cursor;
      END IF;
      IF DBMS_SQL.is_open (dyncur)
      THEN
         DBMS_SQL.close_cursor (dyncur);
      END IF;
      RAISE;
END;
/
DECLARE
   jobno   NUMBER;
BEGIN
   DBMS_JOB.SUBMIT
      (job  => jobno
      ,what =>
         'BEGIN
             auto_recompile (
                display=>FALSE,write_to_log=>TRUE);
          END;'
      ,next_date => SYSDATE
      ,interval  => 'SYSDATE+60/1440');
   COMMIT;
END;
/      
