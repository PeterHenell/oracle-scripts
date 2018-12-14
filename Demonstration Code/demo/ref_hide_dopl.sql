Step 1 Call DBMS_OUTPUT.PUT_LINE via a wrapper. (PL/SQL refactoring)

Step 1 in the refactoring of topic "Call DBMS_OUTPUT.PUT_LINE via a wrapper."

We replace SQLERRM with the much better DBMS_UTILITY.format_error_stack. Now we
e will see the full error stack information -- but if the string exceeds 255 ch
haracters, we get an ERROR!

Universal ID = {BD550B2F-4347-463A-BA1A-2167AC7603BB}

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (   'Qnxo_Name_Resolve cannot resolve "'
                            || name_in
                            || '"'
                           );
      DBMS_OUTPUT.PUT_LINE (DBMS_UTILITY.format_error_stack);
END name_resolve;
================================================================================
Step 2 Call DBMS_OUTPUT.PUT_LINE via a wrapper. (PL/SQL refactoring)

Step 2 in the refactoring of topic "Call DBMS_OUTPUT.PUT_LINE via a wrapper."

Instead of calling DBMS_OUTPUT.PUT_LINE, I call a local substitute for that pro
ogram. You can obtain this code by searching for the "Stand alone put line proc
cedure" script.

Universal ID = {9309653B-9910-48EF-9DD4-C312DA6052EE}

IS             
   PROCEDURE pl (str IN VARCHAR2, len IN INTEGER := 80)
   IS
      v_len     PLS_INTEGER     := LEAST (len, 255);
      v_len2    PLS_INTEGER;
      v_chr10   PLS_INTEGER;
      v_str     VARCHAR2 (2000);
   BEGIN
      IF LENGTH (str) > v_len
      THEN
         v_chr10 := INSTR (str, CHR (10));
 
         IF v_chr10 > 0 AND v_len >= v_chr10
         THEN
            v_len := v_chr10 - 1;
            v_len2 := v_chr10 + 1;
         ELSE
            v_len := v_len - 1;
            v_len2 := v_len;
         END IF;
 
         v_str := SUBSTR (str, 1, v_len);
         DBMS_OUTPUT.put_line (v_str);
         pl (SUBSTR (str, v_len2), len, expand_in);
      ELSE
         DBMS_OUTPUT.put_line (str);
      END IF;
   END pl;
BEGIN
   -- your code
   NULL;
EXCEPTION
   WHEN OTHERS
   THEN
      pl ('Qnxo_Name_Resolve cannot resolve "' || NAME_IN || '"');
      pl (DBMS_UTILITY.format_error_stack);
END name_resolve;
================================================================================
Step 0: Problematic code for  Call DBMS_OUTPUT.PUT_LINE via a wrapper. (PL/SQL refactoring)

The problematic code for that demonstrates "Call DBMS_OUTPUT.PUT_LINE via a wra
apper. (PL/SQL refactoring)"

Universal ID = {D3903510-0B15-4254-8053-01A04C9812C0}

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (   'Qnxo_Name_Resolve cannot resolve "'
                            || name_in
                            || '"'
                           );
      DBMS_OUTPUT.PUT_LINE (SQLERRM);
END name_resolve;
================================================================================
Step 3 Call DBMS_OUTPUT.PUT_LINE via a wrapper. (PL/SQL refactoring)

Step 2 in the refactoring of topic "Call DBMS_OUTPUT.PUT_LINE via a wrapper."

Finally, you can use a standard encapsulation for the DBMS_OUTPUT, so that you 
 do not have to include a local put line procedure all over your application. T
This script shows the use of qd_runtime.pl, which is available to anyone who ha
as installed Qnxo and/or built and deployed a QDA-based application.

Universal ID = {B77F445A-2691-4DE6-B453-FA7ADC641BB3}

EXCEPTION
   WHEN OTHERS
   THEN
      qd_runtime.pl (   'Qnxo_Name_Resolve cannot resolve "'
                            || name_in
                            || '"'
                           );
      qd_runtime.pl (DBMS_UTILITY.format_error_stack);
END name_resolve;
================================================================================
