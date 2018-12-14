@@pl.sp
CREATE OR REPLACE PROCEDURE dispcs
IS
   newline_char CONSTANT CHAR (1) := CHR (10);
   stk VARCHAR2 (10000)
      := DBMS_UTILITY.format_call_stack || newline_char;
   nextpos PLS_INTEGER;
   startpos PLS_INTEGER := 1;
BEGIN
   LOOP
      nextpos := 
         INSTR (stk, newline_char, startpos, 1);
      EXIT WHEN nextpos = 0;
      pl (RTRIM (
            SUBSTR (stk, startpos, nextpos - startpos + 1),
            newline_char
          )
      );
      startpos := nextpos + 1;
   END LOOP;
END;
/
