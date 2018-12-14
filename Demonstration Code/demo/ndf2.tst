DECLARE
   PROCEDURE test_table_ndf (NAME_IN IN VARCHAR2)
   IS
      l_test   ndf_test%ROWTYPE;
   BEGIN
      l_test := ndf_test_get_row (NAME_IN);

      IF ndf.ndf_returned ('NDF_TEST', l_test.NAME)
      THEN
         DBMS_OUTPUT.put_line ('No row found for name = ' || NAME_IN);
      ELSE
         DBMS_OUTPUT.put_line ('Row found for name = ' || l_test.NAME);
      END IF;
   END test_table_ndf;

   PROCEDURE test_column_value_ndf (NAME_IN IN VARCHAR2)
   IS
      l_test   ndf_test.VALUE%TYPE;
   BEGIN
      l_test := ndf_test_get_value_for_name (NAME_IN);

      IF ndf.ndf_returned ('NDF_TEST', l_test, 'VALUE')
      THEN
         DBMS_OUTPUT.put_line ('No value found for name = ' || NAME_IN);
      ELSE
         DBMS_OUTPUT.put_line ('Value for name ' || NAME_IN || ' = ' || l_test
                              );
      END IF;
   END test_column_value_ndf;

   PROCEDURE test_column_fav_ndf (NAME_IN IN VARCHAR2)
   IS
      l_test   ndf_test.favorite%TYPE;
   BEGIN
      l_test := ndf_test_get_fav_for_name (NAME_IN);

      IF ndf.ndf_returned ('NDF_TEST', l_test, 'FAVORITE')
      THEN
         DBMS_OUTPUT.put_line ('No favorite found for name = ' || NAME_IN);
      ELSE
         DBMS_OUTPUT.put_line ('Favorite for name ' || NAME_IN || ' = '
                               || l_test
                              );
      END IF;
   END test_column_fav_ndf;
BEGIN
   DBMS_OUTPUT.put_line ('No row found values for....');
   DBMS_OUTPUT.put_line (   '   NDF_TEST string  = '
                         || ndf.ndf_string_value ('NDF_TEST')
                        );
   DBMS_OUTPUT.put_line (   '   NDF_TEST numeric = '
                         || ndf.ndf_numeric_value ('NDF_TEST')
                        );
   DBMS_OUTPUT.put_line (   '   NDF_TEST.FAVORITE = '
                         || ndf.ndf_string_value ('NDF_TEST', 'FAVORITE')
                        );
   DBMS_OUTPUT.put_line (   '   NDF_TEST.VALUE = '
                         || ndf.ndf_numeric_value ('NDF_TEST', 'VALUE')
                        );
   DBMS_OUTPUT.put_line ('');
   --
   test_table_ndf ('STEVEN');
   test_table_ndf ('STEVE');
   DBMS_OUTPUT.put_line ('');
   --
   test_column_value_ndf ('STEVEN');
   test_column_value_ndf ('STEVE');
   DBMS_OUTPUT.put_line ('');
   --
   test_column_fav_ndf ('STEVEN');
   test_column_fav_ndf ('STEVE');
--
END;
/
