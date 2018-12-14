DROP TABLE parts;
DROP TABLE parts2;

CREATE TABLE parts (
   partnum NUMBER,
   partname VARCHAR2(15)
   );

CREATE TABLE parts2 (
   partnum NUMBER,
   partname VARCHAR2(15)
   );

CREATE OR REPLACE PROCEDURE compare_inserting ( num IN INTEGER )
IS
   TYPE numtab IS TABLE OF parts.partnum%TYPE
      INDEX BY BINARY_INTEGER;

   TYPE nametab IS TABLE OF parts.partname%TYPE
      INDEX BY BINARY_INTEGER;

   pnums numtab;
   pnames nametab;
   l_start NUMBER;
BEGIN
   DBMS_SESSION.free_unused_user_memory;

   FOR indx IN 1 .. num
   LOOP
      pnums ( indx ) := indx;
      pnames ( indx ) := 'Part ' || TO_CHAR ( indx );
   END LOOP;

   l_start := DBMS_UTILITY.get_time;

   FOR indx IN 1 .. num
   LOOP
      INSERT INTO parts
           VALUES ( pnums ( indx ), pnames ( indx ));
   END LOOP;

   DBMS_OUTPUT.put_line (    'FOR loop insert = '
                          || TO_CHAR ( DBMS_UTILITY.get_time - l_start )
                        );
   ROLLBACK;
   l_start := DBMS_UTILITY.get_time;
   FORALL indx IN pnums.FIRST .. pnums.LAST
      INSERT INTO parts
           VALUES ( pnums ( indx ), pnames ( indx ));
   DBMS_OUTPUT.put_line (    'FORALL insert FIRST to LAST = '
                          || TO_CHAR ( DBMS_UTILITY.get_time - l_start )
                        );
   ROLLBACK;
   l_start := DBMS_UTILITY.get_time;
   FORALL indx IN INDICES OF pnums
      INSERT INTO parts
           VALUES ( pnums ( indx ), pnames ( indx ));
   DBMS_OUTPUT.put_line (    'FORALL insert with INDICES OF = '
                          || TO_CHAR ( DBMS_UTILITY.get_time - l_start )
                        );
   ROLLBACK;
END;
/

BEGIN
   compare_inserting ( 100000 );
/*
Oracle 10gR2 
FOR loop insert = 578
FORALL insert FIRST to LAST = 30
FORALL insert with INDICES OF = 28
*/   
END;
/
