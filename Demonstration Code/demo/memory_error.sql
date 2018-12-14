DECLARE
   l_strings   DBMS_SQL.varchar2a;
BEGIN
   FOR indx IN 1 .. 2 ** 31 - 1
   LOOP
      l_strings (indx) := RPAD ('abc', 32767, 'def');
   END LOOP;
END;
/

/* You will see eventually (8 seconds on my 4G laptop):

ORA-04030: out of process memory when trying to allocate 40932 bytes (koh-kghu call ,pl/sql vc2)

*/