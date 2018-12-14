CREATE OR REPLACE PROCEDURE array_to_string (
   array_in     IN     DBMS_SQL.varchar2_table,
   string_out      OUT VARCHAR2)
IS
   l_return   VARCHAR2 (10000);
BEGIN
   FOR indx IN 1 .. array_in.COUNT
   LOOP
      l_return := l_return || ',' || array_in (indx);
   END LOOP;

   string_out := LTRIM (l_return, ',');
END;
/
