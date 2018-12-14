DECLARE
   rem_in INTEGER DEFAULT 0;
   start_in INTEGER DEFAULT 1;
   end_in INTEGER DEFAULT 100;
   prefix_in VARCHAR2 ( 1000 ) DEFAULT NULL;
   suffix_in VARCHAR2 ( 1000 ) DEFAULT NULL;
   placedholder_in VARCHAR2 ( 1000 ) DEFAULT '$prime';
BEGIN
   FOR indx IN start_in .. end_in
   LOOP
      IF MOD ( indx, 2 ) = rem_in
      THEN
         DBMS_OUTPUT.put_line (    REPLACE ( prefix_in
                                           , placedholder_in
                                           , TO_CHAR ( indx )
                                           )
                                || TO_CHAR ( indx )
                                || REPLACE ( suffix_in
                                           , placedholder_in
                                           , TO_CHAR ( indx )
                                           )
                              );
      END IF;
   END LOOP;
END primes;
