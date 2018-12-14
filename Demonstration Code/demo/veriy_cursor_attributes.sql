DECLARE
   CURSOR c
   IS
      SELECT * FROM DUAL;

   PROCEDURE try_attribute (attr_in   IN VARCHAR2
                          , type_in   IN VARCHAR2 DEFAULT 'BOOLEAN')
   IS
   BEGIN
      EXECUTE IMMEDIATE 'DECLARE
     CURSOR source_cur IS SELECT * FROM ALL_SOURCE WHERE ROWNUM < 2;
   BEGIN
     FOR rec IN source_cur 
     LOOP
        IF source_cur%'
                       || attr_in
                       || CASE type_in
                             WHEN 'BOOLEAN' THEN NULL
                             ELSE ' = 0'
                          END
                       || ' THEN NULL; END IF;
        END LOOP;
        END;';

      DBMS_OUTPUT.
       put_line ('"' || attr_in || '" is a valid cursor attribute.');
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.
          put_line (
               'Error using "'
            || attr_in
            || '" as a cursor attribute: '
            || DBMS_UTILITY.format_error_stack);
   END;
BEGIN
   try_attribute ('NOTFOUND');
   try_attribute ('ROWCOUNT', 'INTEGER');
   try_attribute ('ISOPEN');
   try_attribute ('FOUND');
   DBMS_OUTPUT.put_line ('Nothing valid from here on....');
   try_attribute ('ROWNUM');
   try_attribute ('TOO_MANY_ROWS');
   try_attribute ('NO_DATA_FOUND');
   try_attribute ('ISCLOSED');
   try_attribute ('ISOPENED');
END;
/