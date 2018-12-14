DECLARE
   TYPE types_t IS TABLE OF VARCHAR2 (32767)
                      INDEX BY VARCHAR2 (10);

   family    types_t;
   l_index   VARCHAR2 (10);
BEGIN
   family ('Eli') := 'Youngest Son';
   family ('Steven') := 'Father';
   family ('Chris') := 'Oldest Son';
   family ('Veva') := 'Mother';

   l_index := family.LAST;

   WHILE (l_index IS NOT NULL)
   LOOP
      DBMS_OUTPUT.put_line (l_index || ' is ' || family (l_index));
      l_index := family.PRIOR (l_index);
   END LOOP;
END;