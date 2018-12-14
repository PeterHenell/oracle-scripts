CREATE OR REPLACE PROCEDURE file_to_arrays 
   (loc IN VARCHAR2, file IN VARCHAR2)
IS
   TYPE number_t IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;
   empnos number_t;
   sals number_t;

   fid UTL_FILE.FILE_TYPE;
   v_line VARCHAR2(2000);

BEGIN
   fid := UTL_FILE.FOPEN (loc, file, 'R');
   LOOP
      UTL_FILE.GET_LINE (fid, v_line);

      empnos (NVL (empnos.LAST, 0) + 1) := 
         TO_NUMBER (
            SUBSTR (v_line, 1, 
               INSTR (v_line, ' ', 1, 1)-1));

      sals (NVL (empnos.LAST, 0) + 1) :=
         TO_NUMBER (
            SUBSTR (v_line, 
               INSTR (v_line, ' ', 1, 1)+1));
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      UTL_FILE.FCLOSE (fid);
END;
/