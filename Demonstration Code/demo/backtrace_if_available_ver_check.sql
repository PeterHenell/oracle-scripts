CREATE OR REPLACE FUNCTION error_trace RETURN VARCHAR2
IS
   l_val   VARCHAR2 (32767);

   FUNCTION oraversion RETURN NUMBER
   IS
      retval   NUMBER;
   BEGIN
      SELECT VERSION
        INTO retval
        FROM product_component_version
       WHERE ROWNUM < 2
         AND (   UPPER (product) LIKE 'ORACLE7%'
              OR UPPER (product) LIKE 'PERSONAL ORACLE%'
              OR UPPER (product) LIKE 'ORACLE8%'
              OR UPPER (product) LIKE 'ORACLE9%'
              OR UPPER (product) LIKE 'ORACLE%10%'
             );

      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END oraversion;
BEGIN
   IF oraversion >= 10
   THEN
      EXECUTE IMMEDIATE 'BEGIN :val := DBMS_UTILITY.format_error_backtrace; END;'
                  USING OUT l_val;

      RETURN l_val;
   ELSE
      RETURN DBMS_UTILITY.format_error_stack;
   END IF;
END;
/
