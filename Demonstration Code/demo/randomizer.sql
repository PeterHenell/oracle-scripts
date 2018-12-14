DECLARE
   l_strings   randomizer.maxvarchar2_aat;
BEGIN
   l_strings :=
      randomizer.random_strings (count_in                => 100
                               , min_length_in           => 3
                               , max_length_in           => 20
                               , string_type_in          => 'x'
                               , distinct_values_in      => TRUE
                                );

   FOR indx IN 1 .. l_strings.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_strings (indx));
   END LOOP;
END;
/

DECLARE
   l_integers   randomizer.integer_aat;
BEGIN
   l_integers :=
      randomizer.random_integers (count_in                => 25
                                , min_value_in           => 1
                                , max_value_in           => 25
                                , distinct_values_in      => TRUE
                                 );

   FOR indx IN 1 .. l_integers.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_integers (indx));
   END LOOP;
END;
/