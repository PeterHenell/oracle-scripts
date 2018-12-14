DECLARE
   str     VARCHAR2 (2000);
   LIST    DBMS_UTILITY.uncl_array;
   nrows   PLS_INTEGER;
BEGIN
   /* Will not accept a NULL. */
   DBMS_UTILITY.comma_to_table (str, nrows, LIST);

   FOR indx IN 1 .. LIST.COUNT
   LOOP
      DBMS_OUTPUT.put_line (LIST (indx));
   END LOOP;
END;
/

DECLARE
   str     VARCHAR2 (2000);
   tab     DBMS_UTILITY.uncl_array;
   nrows   PLS_INTEGER;

   PROCEDURE parse (thisstr IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('PARSING "' || thisstr || '" into:');
      DBMS_UTILITY.comma_to_table (thisstr, nrows, tab);

      FOR indx IN 1 .. nrows
      LOOP
         DBMS_OUTPUT.put_line (tab (indx));
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack ());
   END;
BEGIN
   parse ('a,b,c');
   parse ('a123,b#,c$');
   parse ('a123,b456,c^');
   parse ('a,b,c,123');
   parse ('123,456,789');
END;
/