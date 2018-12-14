/*
Script created by Bryn Llewellyn, PL/SQL Product Manager
*/

CONNECT Sys/quest@oracle11 AS SYSDBA


DECLARE
   user_does_not_exist   EXCEPTION;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);
BEGIN
   BEGIN
      EXECUTE IMMEDIATE 'drop user Usr cascade';
   EXCEPTION
      WHEN user_does_not_exist
      THEN
         NULL;
   END;

   EXECUTE IMMEDIATE 'grant Create Session, Resource to Usr identified by p';
END;
/

CREATE PROCEDURE usr.create_table_t (no_of_batches IN PLS_INTEGER)
AUTHID CURRENT_USER
IS
   t0                    INTEGER;
   t1                    INTEGER;
   batchsize    CONSTANT PLS_INTEGER := 1000;
   no_of_rows   CONSTANT PLS_INTEGER := batchsize * no_of_batches;
   n                     INTEGER     := 0;

   TYPE pks_t IS TABLE OF NUMBER
      INDEX BY PLS_INTEGER;

   pks                   pks_t;

   TYPE n1s_t IS TABLE OF NUMBER
      INDEX BY PLS_INTEGER;

   n1s                   n1s_t;

   TYPE n2s_t IS TABLE OF NUMBER
      INDEX BY PLS_INTEGER;

   n2s                   n2s_t;

   TYPE v1s_t IS TABLE OF VARCHAR2 (30)
      INDEX BY PLS_INTEGER;

   v1s                   v1s_t;

   TYPE v2s_t IS TABLE OF VARCHAR2 (30)
      INDEX BY PLS_INTEGER;

   v2s                   v2s_t;
BEGIN
   DECLARE
      table_does_not_exist   EXCEPTION;
      PRAGMA EXCEPTION_INIT (table_does_not_exist, -00942);
   BEGIN
      EXECUTE IMMEDIATE 'drop table Usr.t';
   EXCEPTION
      WHEN table_does_not_exist
      THEN
         NULL;
   END;

   EXECUTE IMMEDIATE '
    create table Usr.t(
      PK number                      not null,
      n1 number       default 11     not null,
      n2 number       default 12     not null,
      v1 varchar2(30) default ''v1'' not null,
      v2 varchar2(30) default ''v2'' not null)';

   EXECUTE IMMEDIATE '
    create or replace package Usr.Tmplt is
      type T_Rowtype is record(
        PK number        not null := 0,
        n1 number        not null := 11,
        n2 number        not null := 12,
        v1 varchar2(30)  not null := ''v1'',
        v2 varchar2(30)  not null := ''v2'');
    end Tmplt;';

   t0 := DBMS_UTILITY.get_time ();

   FOR j IN 1 .. no_of_batches
   LOOP
      FOR j IN 1 .. batchsize
      LOOP
         n := n + 1;
         pks (j) := n;
         n1s (j) := n * n;
         n2s (j) := n1s (j) * n;
         v1s (j) := n1s (j);
         v2s (j) := n2s (j);
      END LOOP;

      FORALL j IN 1 .. batchsize
         EXECUTE IMMEDIATE '
        insert into  Usr.t(PK,     n1,     n2,     v1,     v2)
        values            (:PK,    :n1,    :n2,    :v1,    :v2)'
                     USING pks (j), n1s (j), n2s (j), v1s (j), v2s (j);
   END LOOP;

   t1 := DBMS_UTILITY.get_time ();

   EXECUTE IMMEDIATE 'alter table Usr.t add constraint t_PK primary key(PK)';

   DBMS_OUTPUT.put_line ((t1 - t0) || ' centisec');
END create_table_t;
/

CONNECT Usr/p@oracle11
SET SERVEROUTPUT ON FORMAT WRAPPED

/*

Different semantics from forall's save exceptions.
Operates at the row level, not the statement level.

*/


BEGIN
   usr.create_table_t (no_of_batches => 1);
END;
/

CREATE TABLE details(t_pk NUMBER, seq NUMBER, n NUMBER,
  CONSTRAINT details_pk PRIMARY KEY (t_pk, seq),
  CONSTRAINT details_fk FOREIGN KEY (t_pk) REFERENCES t(pk))
/

BEGIN
   FOR j IN 1 .. 100
   LOOP
      INSERT INTO details
                  (t_pk
                 , seq
                 , n
                  )
           VALUES (j * 10
                 , 1
                 , j
                  );
   END LOOP;

   COMMIT;
END;
/

/*
 ORA-02292: integrity constraint (USR.DETAILS_FK) violated - child record found
*/

CREATE OR REPLACE PROCEDURE p
IS
   TYPE pks_t IS TABLE OF t.pk%TYPE
      INDEX BY PLS_INTEGER;

   pks           pks_t;
   bulk_errors   EXCEPTION;
   PRAGMA EXCEPTION_INIT (bulk_errors, -24381);
BEGIN
   FOR j IN 1 .. 200
   LOOP
      pks (j) := j * 5;
   END LOOP;

   FORALL j IN 1 .. pks.COUNT () SAVE EXCEPTIONS
      DELETE FROM t a
            WHERE a.pk BETWEEN p.pks (j) - 1 AND p.pks (j) + 1;
EXCEPTION
   WHEN bulk_errors
   THEN
      DBMS_OUTPUT.PUT_LINE ( 'FORALL Errors Detected (Index, Value, Error):' );
      FOR j IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
      LOOP
         DBMS_OUTPUT.put_line
                         (   LPAD (SQL%BULK_EXCEPTIONS (j).ERROR_INDEX, 4)
                          || ' '
                          || LPAD (pks (SQL%BULK_EXCEPTIONS (j).ERROR_INDEX)
                                 , 4
                                  )
                          || ' '
                          || SQL%BULK_EXCEPTIONS (j).ERROR_CODE
                         );
      END LOOP;
END p;
/

BEGIN
   p ();
END;
/

SELECT COUNT (*)
  FROM t
/
ROLLBACK
/

BEGIN
   DBMS_ERRLOG.create_error_log (dml_table_name          => 'T'
                               , err_log_table_name      => 'T_Errors'
                                );
END;
/

/*
DESCRIBE T_Errors


ORA_ERR_NUMBER$
ORA_ERR_MESG$
ORA_ERR_ROWID$
ORA_ERR_OPTYP$
ORA_ERR_TAG$
PK
N1
N2
V1
V2
*/


DELETE FROM t
      WHERE pk BETWEEN 8 AND 12
      log errors into T_Errors reject limit unlimited
/

begin dbms_output.put_line ( 'Error message after DELETE: ' ||
dbms_utility.Format_error_stack () || '-' || sqlcode);end;
/

CREATE OR REPLACE PROCEDURE p
IS
   TYPE pks_t IS TABLE OF t.pk%TYPE
      INDEX BY PLS_INTEGER;

   pks   pks_t;
BEGIN
   FOR j IN 1 .. 200
   LOOP
      pks (j) := j * 5;
   END LOOP;

   FORALL j IN 1 .. pks.COUNT ()
      DELETE FROM t a
            WHERE a.pk BETWEEN p.pks (j) - 1 AND p.pks (j) + 1
            log errors into T_Errors reject limit unlimited
      ;
END p;
/

BEGIN
   p ();
END;
/

SELECT COUNT (*)
  FROM t
/
ROLLBACK
/

SELECT DISTINCT ora_err_mesg$
           FROM t_errors
/