DECLARE
   TYPE my_tabtype IS TABLE OF VARCHAR2 (32767)
      INDEX BY PLS_INTEGER;

   my_tab   my_tabtype;
   --
   l_gap    PLS_INTEGER := 100000;
BEGIN
   show_memory ('Before');

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
   show_memory ('After');
END;
/
