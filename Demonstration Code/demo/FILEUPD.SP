CREATE OR REPLACE PROCEDURE upd_from_file 
   (loc IN VARCHAR2, file IN VARCHAR2)
IS
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk PLS_INTEGER;
   empnos DBMS_SQL.NUMBER_TABLE;
   sals DBMS_SQL.NUMBER_TABLE;

   fid UTL_FILE.FILE_TYPE;
   v_line VARCHAR2(2000);
   v_space PLS_INTEGER;

BEGIN
   fid := UTL_FILE.FOPEN (loc, file, 'R');

   BEGIN
      LOOP
         UTL_FILE.GET_LINE (fid, v_line);
         v_space := INSTR (v_line, ' ', 1, 1);

         empnos (NVL (empnos.LAST, 0) + 1) := 
            TO_NUMBER (SUBSTR (v_line, 1, v_space-1));

         sals (NVL (sals.LAST, 0) + 1) :=
            TO_NUMBER (SUBSTR (v_line, v_space+1));
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         UTL_FILE.FCLOSE (fid);
   END;

   DBMS_SQL.PARSE (cur, 
      'UPDATE emp SET sal = :sal WHERE empno = :empno', 
      DBMS_SQL.NATIVE);

   DBMS_SQL.BIND_ARRAY (cur, 'empno', empnos);
   DBMS_SQL.BIND_ARRAY (cur, 'sal', sals);

   fdbk := DBMS_SQL.EXECUTE (cur);

   p.l (fdbk);

   DBMS_SQL.CLOSE_CURSOR (cur);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM);
      DBMS_SQL.CLOSE_CURSOR (cur);
END;
/