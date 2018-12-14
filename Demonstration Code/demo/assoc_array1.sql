DECLARE
   SUBTYPE location_t IS VARCHAR2 (1000);

   TYPE population_type IS TABLE OF PLS_INTEGER
      INDEX BY location_t;

   country_population     population_type;
   continent_population   population_type;

   l_howmany              PLS_INTEGER;
   l_index_value          VARCHAR2 (1000);
BEGIN
   country_population ('Greenland') := 100000;
   country_population ('Iceland') := 750000;
   --
   continent_population ('Australia') := 22000000;
   continent_population ('Antarctica') := 1000;
   continent_population ('antarctica') := 1001;
   continent_population ('New Zealand') := 4000000;
   --
   l_howmany := country_population.COUNT;
   DBMS_OUTPUT.put_line ('COUNT = ' || l_howmany);
   DBMS_OUTPUT.put_line (
         'Population of Greenland is '
      || country_population ('Greenland'));
   --
   l_index_value := continent_population.FIRST;
   DBMS_OUTPUT.put_line ('FIRST row = ' || l_index_value);
   DBMS_OUTPUT.put_line (
      'FIRST value = ' || continent_population (l_index_value));
   --
   l_index_value := continent_population.LAST;
   DBMS_OUTPUT.put_line ('LAST row = ' || l_index_value);
   DBMS_OUTPUT.put_line (
      'LAST value = ' || continent_population (l_index_value));

   l_index_value := continent_population.FIRST;

   WHILE (l_index_value IS NOT NULL)
   LOOP
      DBMS_OUTPUT.put_line (
            'Population in continent '
         || l_index_value
         || ' = '
         || continent_population (l_index_value));

      l_index_value := continent_population.NEXT (l_index_value);
   END LOOP;
/* THis will raise VALUE_ERROR
FOR indx IN continent_population.FIRST .. continent_population.LAST
LOOP
   NULL;
END LOOP;
*/
END;
/