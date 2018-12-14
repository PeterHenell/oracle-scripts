DROP TABLE ndf_test
/
CREATE TABLE ndf_test (
   NAME VARCHAR2(100), favorite VARCHAR2(1000), VALUE NUMBER)
/

REM Put test data into the table.

INSERT INTO ndf_test
            (NAME, favorite, VALUE
            )
     VALUES ('STEVEN', 'TYPING', 100
            )
/
INSERT INTO ndf_test
            (NAME, favorite, VALUE
            )
     VALUES ('VEVA', 'CHOCOLATE', 200
            )
/

REM Populate the NO_DATA_FOUND metadata tables with data.

INSERT INTO ndf_table
            (owner, table_name
            ,ndf_string_value
            ,ndf_numeric_value
            )
     VALUES (USER, 'NDF_TEST'
            ,'NOVALUE'
            ,0
            )
/
INSERT INTO ndf_column
            (owner, table_name
            ,column_name
            ,ndf_string_value
            ,ndf_numeric_value
            )
     VALUES (USER, 'NDF_TEST'
            ,'FAVORITE'
            ,'UNDECIDED'
            ,NULL
            )
/
INSERT INTO ndf_column
            (owner, table_name
            ,column_name
            ,ndf_string_value
            ,ndf_numeric_value
            )
     VALUES (USER, 'NDF_TEST'
            ,'VALUE'
            ,NULL
            ,-1
            )
/
COMMIT
/

REM Create programs that rely on the framework.

CREATE OR REPLACE FUNCTION ndf_test_get_row (
   NAME_IN   IN   ndf_test.NAME%TYPE
)
   RETURN ndf_test%ROWTYPE
IS
   retval   ndf_test%ROWTYPE;
BEGIN
   SELECT *
     INTO retval
     FROM ndf_test
    WHERE NAME = NAME_IN;

   RETURN retval;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      retval.NAME :=
         ndf.ndf_string_value
                            ('NDF_TEST');
      RETURN retval;
END ndf_test_get_row;
/

CREATE OR REPLACE FUNCTION ndf_test_get_value_for_name (
   NAME_IN   IN   ndf_test.NAME%TYPE
)
   RETURN ndf_test.VALUE%TYPE
IS
   retval   ndf_test.VALUE%TYPE;
BEGIN
   SELECT VALUE
     INTO retval
     FROM ndf_test
    WHERE NAME = NAME_IN;

   RETURN retval;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN ndf.ndf_numeric_value
                           ('NDF_TEST'
                           ,'VALUE'
                           );
END ndf_test_get_value_for_name;
/

CREATE OR REPLACE FUNCTION ndf_test_get_fav_for_name (
   NAME_IN   IN   ndf_test.NAME%TYPE
)
   RETURN ndf_test.favorite%TYPE
IS
   retval   ndf_test.favorite%TYPE;
BEGIN
   SELECT favorite
     INTO retval
     FROM ndf_test
    WHERE NAME = NAME_IN;

   RETURN retval;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN ndf.ndf_string_value
                           ('NDF_TEST'
                           ,'FAVORITE'
                           );
END ndf_test_get_fav_for_name;
/
