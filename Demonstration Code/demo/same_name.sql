DECLARE
   l_variable   NUMBER := 1;
   l_variable   DATE := SYSDATE;
BEGIN
   DBMS_OUTPUT.put_line (1);
END;
/

DECLARE
   l_variable   NUMBER := 1;
   l_variable   DATE := SYSDATE;
BEGIN
   DECLARE
      l_variable   NUMBER := 1;
   BEGIN
      DBMS_OUTPUT.put_line (l_variable);
   END;
END;
/

/* All the rest:

   PLS-00371: at most one declaration for 'L_VARIABLE' is permitted
*/

DECLARE
   l_variable   NUMBER := 1;
   l_variable   DATE := SYSDATE;
BEGIN
   DBMS_OUTPUT.put_line (l_variable);
END;
/

DECLARE
   l_variable   NUMBER := 1;
   l_variable   DATE := SYSDATE;
BEGIN
   DBMS_OUTPUT.put_line (POWER (l_variable, 1));
END;
/

DECLARE
   l_variable   NUMBER := 1;
   l_variable2   l_variable%type := 1;   
   l_variable   DATE := SYSDATE;
BEGIN
   DBMS_OUTPUT.put_line (1);
END;
/