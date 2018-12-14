SET FEEDBACK OFF

CREATE OR REPLACE PROCEDURE proc1
IS
BEGIN
   DBMS_OUTPUT.put_line ( 'running proc1' );
   RAISE NO_DATA_FOUND;
END;
/

CREATE OR REPLACE PROCEDURE proc2
IS
   l_str VARCHAR2 ( 30 ) := 'calling proc1';
BEGIN
   DBMS_OUTPUT.put_line ( l_str );
   proc1;
END;
/

CREATE OR REPLACE PROCEDURE proc3
IS
   l_val VARCHAR2 ( 32767 );

   FUNCTION oraversion
      RETURN VARCHAR2
   IS
      retval VARCHAR2 ( 100 );

      FUNCTION oracle8_version
         RETURN VARCHAR2
      IS
         retval VARCHAR2 ( 100 );
      BEGIN
         SELECT VERSION
           INTO retval
           FROM product_component_version
          WHERE ROWNUM < 2
            AND (    UPPER ( product ) LIKE 'ORACLE7%'
                  OR UPPER ( product ) LIKE 'PERSONAL ORACLE%'
                  OR UPPER ( product ) LIKE 'ORACLE8%'
                  OR UPPER ( product ) LIKE 'ORACLE9%'
                  OR UPPER ( product ) LIKE 'ORACLE10%'
                );

         RETURN retval;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN NULL;
      END oracle8_version;
   BEGIN
      /* 1.2 If on Oracle8i, use old query, otherwise
            use the major, minor logic that works for 9i, 10g, etc. */
      retval := oracle8_version;

      IF retval LIKE '8%'
      THEN
         retval := SUBSTR ( retval, 1, 3 );
      ELSE
         SELECT    major
                || '.'
                || SUBSTR ( minor_version, 1, INSTR ( minor_version, '.' ) - 1 )
           INTO retval
           FROM ( SELECT major
                       , SUBSTR ( VERSION, LENGTH ( major ) + 2 )
                                                                minor_version
                   FROM ( SELECT SUBSTR ( VERSION
                                        , 1
                                        , INSTR ( VERSION, '.' ) - 1
                                        ) major
                               , VERSION
                           FROM product_component_version p
                          WHERE UPPER ( product ) LIKE 'ORACLE%'
                             OR UPPER ( product ) LIKE 'PERSONAL ORACLE%' ));
      END IF;

      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END;
BEGIN
   DBMS_OUTPUT.put_line ( 'calling proc2' );
   proc2;
EXCEPTION
   WHEN OTHERS
   THEN
      --DBMS_OUTPUT.put_line ( 'Error stack at top level:' );
      --DBMS_OUTPUT.put_line ( DBMS_UTILITY.format_error_backtrace );
      IF oraversion LIKE '10%'
      THEN
         DBMS_OUTPUT.put_line
                           ( 'Dynamically acquired error stack at top level:' );

         EXECUTE IMMEDIATE 'BEGIN :val := DBMS_UTILITY.format_error_backtrace; END;'
                     USING OUT l_val;

         DBMS_OUTPUT.put_line ( l_val );
      END IF;
END;
/

BEGIN
   DBMS_OUTPUT.put_line ( 'Proc3 -> Proc2 -> Proc1 backtrace' );
   proc3;
END;
/
