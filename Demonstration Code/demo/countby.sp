CREATE OR REPLACE PROCEDURE countBy (
   tab IN VARCHAR2,
   col IN VARCHAR2, 
   atleast IN INTEGER := NULL,
   sch IN VARCHAR2 := NULL,
   whr IN VARCHAR2 := NULL)
IS
   TYPE cv_type IS REF CURSOR;
   cv cv_type;
   
   SQL_string VARCHAR2(32767);
   v_val VARCHAR2(4000);
   v_count INTEGER;
   
   PROCEDURE display_header 
   IS
      v_hdr VARCHAR2(120) :=
         'Count by ' || 
         UPPER (tab) || '.' || UPPER (col);
   BEGIN
      DBMS_OUTPUT.PUT_LINE (RPAD ('-', 70, '-'));
      
      IF atleast IS NOT NULL
      THEN
         v_hdr := 
            v_hdr || ' with at least ' || 
            atleast || ' occurrences';
      END IF;
      
      DBMS_OUTPUT.PUT_LINE (v_hdr);
         
      DBMS_OUTPUT.PUT_LINE (RPAD ('-', 70, '-'));
   END;
   
   FUNCTION column_length RETURN INTEGER 
   IS
      retval INTEGER;
   BEGIN
      SELECT data_length INTO retval
        FROM ALL_TAB_COLUMNS
       WHERE OWNER = NVL (UPPER (sch), USER)
         AND TABLE_NAME = UPPER (tab)
         AND COLUMN_NAME = UPPER (col);
      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN RETURN NULL;
   END;
BEGIN
   SQL_string := 
      'SELECT ' || col || ', COUNT(*) 
         FROM ' || NVL (sch, USER) || '.' || tab ||
      ' WHERE ' || NVL (whr, '1 = 1') || 
      ' GROUP BY ' || col;
   
   IF atleast IS NOT NULL
   THEN
      SQL_string := 
         SQL_string || ' HAVING COUNT(*) >= ' || 
         atleast;
   END IF;
 
   OPEN cv FOR SQL_String;
   
   LOOP
      FETCH cv INTO v_val, v_count;
      EXIT WHEN cv%NOTFOUND;
      
      IF cv%ROWCOUNT = 1
      THEN
         display_header;
      END IF;
      
      DBMS_OUTPUT.PUT_LINE (
         RPAD (v_val, column_length) || ' ' || v_count);
   END LOOP;
   
   CLOSE cv;
END;
/   
