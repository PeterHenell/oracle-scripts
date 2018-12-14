ALTER SESSION SET PLSQL_CCFLAGS = 'max_id_length:30'
/

CREATE OR REPLACE PACKAGE plsql_limits
IS
   /* "No error" error code */
   c_no_error CONSTANT PLS_INTEGER := 0;
   
   /* Range of allowable user-defined error codes */
   c_max_user_code CONSTANT PLS_INTEGER := -20000;
   c_min_user_code CONSTANT PLS_INTEGER := -20999;

   -- Maximum size for VARCHAR2 in PL/SQL
   SUBTYPE maxvarchar2 IS VARCHAR2( 32767 );

   -- Maximum size for VARCHAR2 in database
   SUBTYPE dbmaxvarchar2 IS VARCHAR2( 4000 );

   -- Maximum size of Oracle Developer GLOBAL variable
   SUBTYPE odev_global_variable IS VARCHAR2( 255 );

   -- Maximum size of Oracle identifier: use conditional compilation!
   SUBTYPE identifier_t IS VARCHAR2( 30 );

   -- Prague May 2006
-- c_max_identifier_length CONSTANT PLS_INTEGER := $$max_id_length;
-- SUBTYPE identifier_t IS VARCHAR2 ($$max_id_length);

-- Maximum number of columns in table
   c_max_columns CONSTANT PLS_INTEGER := 1000;

   /* Function access to PLS_INTEGER range */
   FUNCTION max_pls_integer
      RETURN pls_integer;

   FUNCTION min_pls_integer
      RETURN pls_integer;
END plsql_limits;
/

CREATE OR REPLACE PACKAGE BODY plsql_limits
IS
   -- Maximum and minimum BINARY_ and PLS_INTEGER values
   c_max_pls_integer CONSTANT PLS_INTEGER := POWER( 2, 31 ) - 1;
   c_min_pls_integer CONSTANT PLS_INTEGER := -1 * POWER( 2, 31 ) + 1;
   
    FUNCTION max_pls_integer
       RETURN pls_integer
    IS
    BEGIN
       RETURN c_max_pls_integer;
    END max_pls_integer;

    FUNCTION min_pls_integer
       RETURN pls_integer
    IS
    BEGIN
       RETURN c_min_pls_integer;
    END min_pls_integer;

END plsql_limits;

/


/*
BEGIN
   DBMS_PREPROCESSOR.print_post_processed_source(
                                                  'PACKAGE',
                                                  USER,
                                                  'PLSQL_LIMITS'
   );
END;
*/
