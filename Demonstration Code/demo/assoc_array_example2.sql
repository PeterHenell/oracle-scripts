DECLARE
   TYPE types_t IS TABLE OF VARCHAR2 (32767)
                      INDEX BY VARCHAR2 (10);

   family_members   types_t;
   l_index_value    VARCHAR2 (10);
BEGIN
   family_members ('Eli') := 'Youngest Son';
   family_members ('Steven') := 'Father';
   family_members ('Chris') := 'Oldest Son';
   family_members ('Veva') := 'Mother';

   l_index_value := family_members.FIRST;

   WHILE (l_index_value IS NOT NULL)
   LOOP
      DBMS_OUTPUT.put_line (
         l_index_value || ' is ' || family_members (l_index_value)
      );
      l_index_value := family_members.NEXT (l_index_value);
   END LOOP;
END;