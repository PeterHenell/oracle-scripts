DECLARE
-- sess2.sql
   TYPE strings_aat IS TABLE OF VARCHAR2 (500)
      INDEX BY PLS_INTEGER;

   my_tab   strings_aat;
   --
   l_gap    PLS_INTEGER := 100000;
BEGIN
   --DBMS_SESSION.reset_package;
   DBMS_SESSION.free_unused_user_memory;
   --
   my_session.MEMORY;

   FOR i IN 1 .. 1000
   LOOP
      my_tab (i) := TO_CHAR (i);
      my_tab (i + 1 * l_gap) := TO_CHAR (i);
      my_tab (i + 2 * l_gap) := TO_CHAR (i);
      my_tab (i + 3 * l_gap) := TO_CHAR (i);
      my_tab (i + 4 * l_gap) := TO_CHAR (i);
      my_tab (i + 5 * l_gap) := TO_CHAR (i);
   END LOOP;

   DBMS_OUTPUT.PUT_LINE (my_tab.COUNT);
   my_session.MEMORY;
END;
/
