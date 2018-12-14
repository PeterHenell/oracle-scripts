/* Formatted on 2002/02/08 07:03 (Formatter Plus v4.6.0) */
CREATE OR REPLACE PROCEDURE test_open_cursors (down_by IN PLS_INTEGER := 8)
IS
   l_max    PLS_INTEGER;
   sqlstr   VARCHAR2 (32767);
BEGIN
   SELECT   VALUE
          - down_by
     INTO l_max
     FROM v$parameter
    WHERE NAME = 'open_cursors';

   sqlstr :=
            'DECLARE CURSOR last_straw IS SELECT * FROM dual; BEGIN DECLARE ';

   FOR indx IN 1 .. l_max
   LOOP
      sqlstr :=    sqlstr
                || 'CURSOR cur'
                || indx
                || ' IS SELECT * FROM dual;';
   END LOOP;

   sqlstr :=    sqlstr
             || 'BEGIN ';

   FOR indx IN 1 .. l_max
   LOOP
      sqlstr :=    sqlstr
                || 'OPEN cur'
                || indx
                || ';' 
				/*
				|| 'CLOSE cur'
                || indx
                || ';'
				*/
				;
   END LOOP;

   sqlstr :=    sqlstr
             || 'EXCEPTION WHEN OTHERS THEN '
             || '   DBMS_OUTPUT.PUT_LINE (''INNER: '' || SQLCODE); '
             || 'END; OPEN last_straw; '
             || 'EXCEPTION WHEN OTHERS THEN '
             || '   DBMS_OUTPUT.PUT_LINE (''OUTER: '' || SQLCODE); END;';
   --p.l (sqlstr);
   EXECUTE IMMEDIATE sqlstr;
END;
