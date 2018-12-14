CREATE OR REPLACE PROCEDURE silent_drop (table_in IN VARCHAR2)
IS
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || table_in;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Unable to drop ' || table_in);
      DBMS_OUTPUT.put_line ('   Error: ' || DBMS_UTILITY.format_error_stack);
END silent_drop;
/

BEGIN
   silent_drop ('FMD1');
   silent_drop ('FMD2');
   silent_drop ('ERR$_FMD1');
   silent_drop ('ERR$_FMD2');
END;
/

CREATE TABLE fmd1 (
   NAME VARCHAR2(20),
   favorite VARCHAR2(20) NOT NULL
)
/
CREATE UNIQUE INDEX un_fmd1 ON fmd1 (NAME)
/
CREATE TABLE fmd2 (
   NAME VARCHAR2(20),
   favorite VARCHAR2(20) NOT NULL
)
/
CREATE UNIQUE INDEX un_fmd2 ON fmd2 (NAME)
/

BEGIN
   DBMS_ERRLOG.create_error_log (dml_table_name => 'FMD1');
   DBMS_ERRLOG.create_error_log (dml_table_name => 'FMD2');
END;
/

DECLARE
/*
Populate the tables with 10000 rows each.
*/
   TYPE name_tt IS TABLE OF fmd1.NAME%TYPE
      INDEX BY PLS_INTEGER;

   names       name_tt;

   TYPE favorite_tt IS TABLE OF fmd1.favorite%TYPE
      INDEX BY PLS_INTEGER;

   favorites   favorite_tt;
BEGIN
   FOR indx IN 1 .. 10000
   LOOP
      names (indx) := 'Larry' || indx;
      favorites (indx) := 'Chocolate' || indx;
   END LOOP;

   FORALL indx IN 1 .. 10000
      INSERT INTO fmd1
           VALUES (names (indx), favorites (indx));
   FORALL indx IN 1 .. 10000
      INSERT INTO fmd2
           VALUES (names (indx), favorites (indx));
   COMMIT;
END;
/

DECLARE
   bulk_errors   EXCEPTION;
   PRAGMA EXCEPTION_INIT (bulk_errors, -24381);

   TYPE strings_tt IS TABLE OF VARCHAR2 (1000);

   names         strings_tt
      := strings_tt ('Steven "I Love PL/SQL" Feuerstein'
                   , 'Steven'
                   , 'Larry767'
                   , 'Jean'
                    );
   favorites     strings_tt
      := strings_tt ('Vanilla'
                   , 'Purple Raspberry Delight with Almond Crunch'
                   , NULL
                   , 'Strawberry'
                    );
   CV            sys_refcursor;

   PROCEDURE show_non_std_data (table_in IN VARCHAR2)
   IS
      l_ns_names       strings_tt;
      l_ns_favorites   strings_tt;
   BEGIN
      OPEN CV FOR    'SELECT name, favorite FROM '
                  || table_in
                  || ' WHERE name NOT LIKE ''Larry%'''
                  || ' OR favorite NOT LIKE ''Chocolate%''';

      FETCH CV
      BULK COLLECT INTO l_ns_names, l_ns_favorites;

      DBMS_OUTPUT.put_line ('Non-Standard Data in ' || table_in);

      FOR indx IN 1 .. l_ns_names.COUNT
      LOOP
         DBMS_OUTPUT.put_line (   l_ns_names (indx)
                               || ' - '
                               || l_ns_favorites (indx)
                              );
      END LOOP;
   END show_non_std_data;

   PROCEDURE try_block (title_in IN VARCHAR2, block_in IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (RPAD ('=', 60, '='));
      DBMS_OUTPUT.put_line (   'FORALL with Multiple DML statements - '
                            || title_in
                           );
      FORALL indx IN names.FIRST .. names.LAST SAVE EXCEPTIONS
         EXECUTE IMMEDIATE block_in
                     USING names (indx), favorites (indx);
      DBMS_OUTPUT.put_line ('Inserted ' || SQL%ROWCOUNT || ' rows!');
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('FMD Error: '
                               || DBMS_UTILITY.format_error_stack
                              );
         DBMS_OUTPUT.put_line ('   Rows Inserted: ' || SQL%ROWCOUNT);

         IF SQL%ROWCOUNT > 0
         THEN
            show_non_std_data ('fmd1');
            show_non_std_data ('fmd2');
         END IF;

         FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
         LOOP
            DBMS_OUTPUT.put_line (   'Error encountered on index '
                                  || SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX
                                 );
            DBMS_OUTPUT.put_line (   'Error: '
                                  || SQL%BULK_EXCEPTIONS (indx).ERROR_CODE
                                 );
         END LOOP;
   END try_block;

   PROCEDURE show_dbms_errlogs
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('Error log for FMD1');

      FOR rec IN (SELECT ora_err_number$, ora_err_mesg$
                    FROM err$_fmd1)
      LOOP
         DBMS_OUTPUT.put_line (rec.ora_err_number$ || '-' || rec.ora_err_mesg$
                              );
      END LOOP;

      DBMS_OUTPUT.put_line ('Error log for FMD2');

      FOR rec IN (SELECT ora_err_number$, ora_err_mesg$
                    FROM err$_fmd2)
      LOOP
         DBMS_OUTPUT.put_line (rec.ora_err_number$ || '-' || rec.ora_err_mesg$
                              );
      END LOOP;
   END show_dbms_errlogs;
BEGIN
   try_block
      ('Save Exceptions Ignored!'
     , 'BEGIN
         INSERT INTO fmd1 VALUES (:name, :favorite);
         INSERT INTO fmd2 VALUES (:name, :favorite);
       END;'
      );
   try_block
      ('Exception Handler in Block'
     , 'BEGIN
         INSERT INTO fmd1 VALUES (:name, :favorite);
         INSERT INTO fmd2 VALUES (:name, :favorite);
       EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE (
          ''Failure on name-favorite: '' || :name || ''-'' || :favorite);
       END;'
      );
   try_block
      ('DBMS_ERRLOG in Block'
     , 'BEGIN
         INSERT INTO fmd1 VALUES (:name, :favorite)
            LOG ERRORS REJECT LIMIT UNLIMITED;
         INSERT INTO fmd2 VALUES (:name, :favorite)
            LOG ERRORS REJECT LIMIT UNLIMITED;
      END;'
      );
   show_dbms_errlogs;
   ROLLBACK;
END;
/

CREATE OR REPLACE PROCEDURE fmd_performance (count_in IN PLS_INTEGER)
IS
   TYPE name_tt IS TABLE OF fmd1.NAME%TYPE
      INDEX BY PLS_INTEGER;

   names       name_tt;

   TYPE favorite_tt IS TABLE OF fmd1.favorite%TYPE
      INDEX BY PLS_INTEGER;

   favorites   favorite_tt;

   PROCEDURE fill_collections
   IS
   BEGIN
      FOR indx IN 1 .. count_in
      LOOP
         names (indx) := 'Steven' || indx;
         favorites (indx) := 'Butter Pecan' || indx;
      END LOOP;
   END fill_collections;

   PROCEDURE singlerow_dml
   IS
   BEGIN
      sf_timer.start_timer;

      FOR indx IN 1 .. names.COUNT
      LOOP
         INSERT INTO fmd1
              VALUES (names (indx), favorites (indx));
      END LOOP;

      FOR indx IN 1 .. names.COUNT
      LOOP
         INSERT INTO fmd2
              VALUES (names (indx), favorites (indx));
      END LOOP;

      sf_timer.show_elapsed_time ('Singlet row inserts - no use of FORALL');
      ROLLBACK;
   END singlerow_dml;

   PROCEDURE forall_single_dml
   IS
   BEGIN
      sf_timer.start_timer;
      FORALL indx IN 1 .. names.COUNT
         INSERT INTO fmd1
              VALUES (names (indx), favorites (indx));
      FORALL indx IN 1 .. names.COUNT
         INSERT INTO fmd2
              VALUES (names (indx), favorites (indx));
      sf_timer.show_elapsed_time ('Single DMLs within two FORALLs');
      ROLLBACK;
   END forall_single_dml;

   PROCEDURE forall_mult_dml
   IS
   BEGIN
      sf_timer.start_timer;
      FORALL indx IN 1 .. names.COUNT
         EXECUTE IMMEDIATE 'BEGIN
         INSERT INTO fmd1 VALUES (:name, :favorite);
         INSERT INTO fmd2 VALUES (:name, :favorite);
       END;'
                     USING names (indx), favorites (indx);
      sf_timer.show_elapsed_time ('Multiple DMLs within one FORALL');
      ROLLBACK;
   END forall_mult_dml;
BEGIN
   DBMS_OUTPUT.put_line (   '======== Timing of '
                         || count_in
                         || ' inserts into FMD1 and FMD2 tables'
                        );
   fill_collections;
   singlerow_dml;
   forall_single_dml;
   forall_mult_dml;
END fmd_performance;
/

BEGIN
   fmd_performance (1000);
   fmd_performance (10000);
   fmd_performance (100000);
END;
/