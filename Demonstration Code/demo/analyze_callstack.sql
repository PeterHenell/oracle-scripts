CREATE OR REPLACE PROCEDURE analyze_callstack (callstack_in IN VARCHAR2)
/*
   Overview: Analyze authid settings in call stack to identify a situation
             in which a definer rights program is calling an invoker rights
             program.

   Author: Steven Feuerstein, steven@stevenfeuerstein.com

   Here are examples of the string returned by DBMS_UTILITY.FORMAT_CALL_STACK:

   ----- PL/SQL Call Stack -----
     object      line  object
     handle    number  name
   6A46A1AC        10  package body QNXO_DEMO.PKG
   67C68C68         4  procedure QNXO_DEMO.PROC2
   69AADC94         4  procedure QNXO_DEMO.PROC3
   689C9FA8         2  anonymous block

   A very short stack: single anonymous block.

   ----- PL/SQL Call Stack -----
     object      line  object
     handle    number  name
   6A39D12C         2  anonymous block

   Here are the rules I used to parse the contents of this string:

   1. The top of the stack is found on the fourth line of the string
      (as defined by CHR(10) delimiters).

   2. The object handle is found in the first 8 characters in the line.

   3. The line number is found in the next 10 characters in the line.

   4. The program type and name follows the line number after two spaces.

   Note: If Oracle changes the format of this string then this program
         will have to be modified.
*/
IS
   c_new_line             CONSTANT CHAR (1) := CHR (10);
   c_prefix               CONSTANT CHAR (2) := '> ';
   c_last_unit            CONSTANT VARCHAR2 (100) := 'anonymous block';
   c_obj_handle_length    CONSTANT PLS_INTEGER := 8;
   c_line_number_length   CONSTANT PLS_INTEGER := 10;
   c_before_type_name     CONSTANT PLS_INTEGER := 2;
   c_authid_length        CONSTANT PLS_INTEGER := 12;
   c_offset_to_program CONSTANT PLS_INTEGER
         :=   c_obj_handle_length
            + c_line_number_length
            + c_before_type_name
            + 1 ;

   /* Start at the fourth line in the stack. */
   l_cr_seq               PLS_INTEGER := 3;
   l_start                PLS_INTEGER;
   l_end                  PLS_INTEGER;
   l_line                 VARCHAR2 (32767);
   l_program_call         VARCHAR2 (32767);

   FUNCTION authid_setting (program_name_in IN VARCHAR2)
      RETURN VARCHAR2
   IS
      l_after_space   PLS_INTEGER := INSTR (program_name_in, ' ') + 1;
      l_authid        all_procedures.authid%TYPE;
   BEGIN
      SELECT authid
        INTO l_authid
        FROM all_procedures
       WHERE owner =
                SUBSTR (program_name_in
                      , l_after_space
                      , INSTR (program_name_in, '.') - l_after_space
                       )
             AND object_name =
                   SUBSTR (program_name_in, INSTR (program_name_in, '.') + 1)
             AND procedure_name IS NULL;

      RETURN l_authid;
   END authid_setting;
BEGIN
   /* Iterate through all the lines in the stack and load up the array. */
   LOOP
      l_start := INSTR (callstack_in, c_new_line, 1, l_cr_seq) + 1;
      l_end := INSTR (callstack_in, c_new_line, 1, l_cr_seq + 1);

      l_program_call :=
         RTRIM(SUBSTR (
                  CASE
                     WHEN l_end = 0 THEN SUBSTR (callstack_in, l_start)
                     ELSE SUBSTR (callstack_in, l_start, l_end - l_start)
                  END
                ,   c_obj_handle_length
                  + c_line_number_length
                  + c_before_type_name
                  + 1
               ));

      EXIT WHEN l_program_call = c_last_unit;

      DBMS_OUTPUT.put_line(c_prefix
                           || RPAD (authid_setting (l_program_call)
                                  , c_authid_length
                                   )
                           || ' '
                           || l_program_call
                           || ' called by...');


      l_cr_seq := l_cr_seq + 1;
   END LOOP;

   DBMS_OUTPUT.put_line (
      c_prefix || LPAD (' ', c_authid_length + 1) || c_last_unit
   );
END analyze_callstack;
/

CREATE OR REPLACE PROCEDURE proc1
   AUTHID CURRENT_USER
IS
BEGIN
   analyze_callstack (DBMS_UTILITY.format_call_stack);
END;
/

CREATE OR REPLACE PROCEDURE proc2
IS
BEGIN
   proc1;
END;
/

CREATE OR REPLACE PROCEDURE proc3
   AUTHID CURRENT_USER
IS
BEGIN
   proc2;
END;
/

BEGIN
   proc3;
END;
/