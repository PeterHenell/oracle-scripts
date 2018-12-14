BEGIN
   BEGIN
      SELECT favorite
        INTO l_favorite
        FROM ndf_test
       WHERE NAME = NAME_IN;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT INTO ndf_test
                     (NAME, favorite, VALUE
                     )
              VALUES (NAME_IN, 'NOT SET', 0
                     );
   END;

   lots_more_code;
END ndf_process_entry;
/

BEGIN
   BEGIN
      SELECT favorite
        INTO l_favorite
        FROM ndf_test
       WHERE NAME = NAME_IN;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            INSERT INTO ndf_test
                        (NAME, favorite, VALUE
                        )
                 VALUES (NAME_IN, 'NOT SET', 0
                        );
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               NULL;
            WHEN OTHERS
            THEN
               log_error;
         END;
   END;

   lots_more_code;
END ndf_process_entry;
/