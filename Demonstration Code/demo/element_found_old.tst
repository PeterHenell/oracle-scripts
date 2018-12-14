DECLARE
   l_collection DBMS_SQL.varchar2s;
BEGIN
   l_collection ( 1 ) := 'ABC';
   l_collection ( 10 ) := 'DEF';
   l_collection ( 11 ) := NULL;
   l_collection ( 100 ) := '123';

   IF ( element_found ( collection_in       => l_collection
                      , value_in            => 'ABC'
                      , start_index_in      => NULL
                      , end_index_in        => NULL
                      , nulls_eq_in         => TRUE
                      )
      )
   THEN
      DBMS_OUTPUT.put_line ( 'FOUND!' );
   ELSE
      DBMS_OUTPUT.put_line ( 'NOT FOUND!' );
   END IF;

   IF ( element_found ( collection_in       => l_collection
                      , value_in            => NULL
                      , start_index_in      => NULL
                      , end_index_in        => NULL
                      , nulls_eq_in         => NULL
                      )
      )
   THEN
      DBMS_OUTPUT.put_line ( 'FOUND!' );
   ELSE
      DBMS_OUTPUT.put_line ( 'NOT FOUND!' );
   END IF;

   IF ( element_found ( collection_in       => l_collection
                      , value_in            => 'ABCDEF'
                      , start_index_in      => NULL
                      , end_index_in        => NULL
                      , nulls_eq_in         => TRUE
                      )
      )
   THEN
      DBMS_OUTPUT.put_line ( 'FOUND!' );
   ELSE
      DBMS_OUTPUT.put_line ( 'NOT FOUND!' );
   END IF;
END;