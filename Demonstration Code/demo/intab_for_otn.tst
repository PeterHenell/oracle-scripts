@intab_dbms_sql_for_otn.sp

DROP TABLE intab_test
/
CREATE TABLE intab_test (
   NAME VARCHAR(100),
   ID NUMBER (5),
   amount NUMBER (10,2),
   dob DATE)
/

BEGIN
   INSERT INTO intab_test
               (NAME, ID, amount, dob
               )
        VALUES ('Steven', 304, 500.46, ADD_MONTHS (SYSDATE, -12 * 46)
               );

   INSERT INTO intab_test
               (NAME, ID, amount, dob
               )
        VALUES ('Roger', 111, 7080.90, ADD_MONTHS (SYSDATE, -12 * 12)
               );

   INSERT INTO intab_test
               (NAME, ID, amount, dob
               )
        VALUES ('Sally', 1000, 100000, ADD_MONTHS (SYSDATE, -12 * 25)
               );

   COMMIT;
END;
/

BEGIN
   -- Show all rows in the table.
   intab (schema_in => USER, table_in => 'INTAB_TEST');
END;
/

BEGIN
   -- Show all rows whose name column values contain the letter "S".
   intab (schema_in           => USER
         ,table_in            => 'INTAB_TEST'
         ,from_append_in      => 'where name like ''S%'''
         );
END;
/

BEGIN
   -- Show all rows whose name column values contain the letter "S".
   -- This time, use the user-defined quote character (avaliable
   -- in Oracle Database 10g only).
   intab (schema_in           => USER
         ,table_in            => 'INTAB_TEST'
         ,from_append_in      => q'[where name like 'S%']'
         );
END;
/

BEGIN
   -- Order data displayed by NAME.
   intab (schema_in           => USER
         ,table_in            => 'INTAB_TEST'
         ,from_append_in      => 'order by name'
         );
END;
/

BEGIN
   -- Order by name and show only columns whose names contain an "A".
   intab (schema_in            => USER
         ,table_in             => 'INTAB_TEST'
         ,from_append_in       => 'order by name'
         ,colname_like_in      => '%A%'
         );
END;
/

DROP TABLE intab_test2
/
CREATE TABLE intab_test2 ("c c" NUMBER)
/
INSERT INTO intab_test2
            ("c c"
            )
     VALUES (1
            )
/

BEGIN
   intab (schema_in => USER, table_in => 'intab_test2');
END;
/

DROP TABLE intab_test3
/
CREATE TABLE intab_test3 (i NUMBER)
/
INSERT INTO intab_test3
            (i
            )
     VALUES (304
            )
/

BEGIN
   intab (schema_in           => USER
         ,table_in            => 'intab_test'
         ,from_append_in      => ', intab_test3 where id=i'
         );
END;
/