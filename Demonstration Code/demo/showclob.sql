/* Could adapt this to display a specified CLOB. */
   
   PROCEDURE showsource (
      nm IN VARCHAR2, ignore_case IN BOOLEAN := FALSE)
   IS
      c_ignore CONSTANT CHAR(1) := 'I';
      c_apply CONSTANT CHAR(1) := 'A';
      c_newline CONSTANT CHAR(1) := CHR(10);
      nth_newline PLS_INTEGER := 1;
      newline_loc PLS_INTEGER := 1;
      last_newline PLS_INTEGER := 0;
      
      jsource CLOB;
      
      CURSOR jsource_cur (treat_case IN VARCHAR2)
      IS
         SELECT LOB
           FROM CREATE$JAVA$LOB$TABLE
          WHERE (name = nm AND treat_case = c_apply)
             OR (UPPER (name) = UPPER (nm) 
                   AND treat_case = c_ignore)
            FOR UPDATE;
   BEGIN
      IF ignore_case
      THEN
         OPEN jsource_cur (c_ignore);
      ELSE
         OPEN jsource_cur (c_apply);
      END IF;
      
      FETCH jsource_cur INTO jsource;
      
      IF jsource_cur%NOTFOUND
      THEN
         DBMS_OUTPUT.PUT_LINE (
            'No source found for ' || 
            USER || '.' || nm);
      ELSE
         /* Search for line breaks and then display each line
            individually. */
         LOOP
            newline_loc := 
               DBMS_LOB.INSTR (
                  jsource, c_newline, 
                  nth => nth_newline);
            IF newline_loc = 0
            THEN
               DBMS_OUTPUT.PUT_LINE (
                  DBMS_LOB.SUBSTR (jsource, 
                     offset => last_newline + 1));
               EXIT;
            ELSE
               DBMS_OUTPUT.PUT_LINE (
                  DBMS_LOB.SUBSTR (jsource, 
                     amount => newline_loc - last_newline + 1,
                     offset => last_newline + 1));
            END IF;
            
            nth_newline := nth_newline + 1;
            last_newline := newline_loc; 
         END LOOP;            
      END IF;
   END;
