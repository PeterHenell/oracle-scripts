DELETE FROM ndf_column
/
DELETE FROM ndf_table
/
DROP TABLE ndf_test
/
CREATE TABLE ndf_test (
   NAME VARCHAR2(100), favorite VARCHAR2(1000), VALUE NUMBER)
/
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
INSERT INTO ndf_table
            (owner, table_name
            ,ndf_value
            )
     VALUES (USER, 'NDF_TEST'
            ,ANYDATA.convertvarchar2
                                   ('NOVALUE')
            )
/
INSERT INTO ndf_column
            (owner, table_name, column_name
            ,ndf_value
            )
     VALUES (USER, 'NDF_TEST', 'FAVORITE'
            ,ANYDATA.convertvarchar2
                                   ('NOVALUE')
            )
/
INSERT INTO ndf_column
            (owner, table_name, column_name
            ,ndf_value
            )
     VALUES (USER, 'NDF_TEST', 'VALUE'
            ,ANYDATA.convertnumber (-1)
            )
/
COMMIT
/

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
         ndf.ndf_value ('NDF_TEST'
                       ,NULL
                       ).accessvarchar2;
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
      RETURN ndf.ndf_value ('NDF_TEST'
                           ,'VALUE'
                           ).accessnumber;
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
      RETURN ndf.ndf_value ('NDF_TEST'
                           ,'FAVORITE'
                           ).accessvarchar2;
END ndf_test_get_fav_for_name;
/