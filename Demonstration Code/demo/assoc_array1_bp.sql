DECLARE
   /* Hide explicit types behind SUBTYPEs to improve
      readabiliy of code. */
      
   SUBTYPE population_count_t IS PLS_INTEGER;

   SUBTYPE location_name_t IS VARCHAR2 (2000);

   TYPE population_type IS TABLE OF population_count_t
                              INDEX BY location_name_t;

   country_population     population_type;
   continent_population   population_type;
   
   l_howmany              population_count_t;
   l_limit                location_name_t;
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
      'Population of Greenland is ' || country_population ('Greenland')
   );
   l_limit := continent_population.FIRST;
   DBMS_OUTPUT.put_line ('FIRST row = ' || l_limit);
   DBMS_OUTPUT.put_line ('FIRST value = ' || continent_population (l_limit));
   l_limit := continent_population.LAST;
   DBMS_OUTPUT.put_line ('LAST row = ' || l_limit);
   DBMS_OUTPUT.put_line ('LAST value = ' || continent_population (l_limit));
/* THIS WILL NOT WORK
FOR indx IN
   continent_population.FIRST .. continent_population.LAST
LOOP
   NULL;
END LOOP;
*/
END;
/