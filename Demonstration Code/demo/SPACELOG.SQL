REM
REM Queue up free space analyze to run every 30 minutes.
REM
REM Access is needed to the DBA views.
REM
REM Run showspc.sql to display contents of db_space.
REM
SET VERIFY OFF

CONNECT sys/&&syspwd
GRANT SELECT ON dba_free_space TO scott;
GRANT SELECT ON dba_data_files TO scott;
GRANT SELECT ON dba_jobs TO scott;

CONNECT scott/tiger
DROP TABLE db_space
/
CREATE TABLE db_space
   (tablespace_name   VARCHAR(30)  NOT NULL
   ,calc_date      DATE    NOT NULL
   ,total_bytes    NUMBER  NOT NULL
   ,free_bytes     NUMBER  NOT NULL);

CREATE OR REPLACE VIEW tbs_space_df
AS
   SELECT  tablespace_name     tbsname
           ,SUM(bytes)         totbytes
     FROM  dba_data_files
    GROUP BY tablespace_name;

CREATE OR REPLACE VIEW tbs_space_fs
AS
   SELECT  tablespace_name     tbsname
           ,SUM(bytes)         freebytes
     FROM  dba_free_space
    GROUP BY tablespace_name;

CREATE OR REPLACE VIEW tbs_space
   (tablespace_name
   ,total_bytes
   ,free_bytes)
AS
   SELECT  DF.tbsname         tablespace_name
          ,DF.totbytes        total_bytes
          ,FS.freebytes       free_bytes
     FROM tbs_space_df DF, tbs_space_fs FS
    WHERE DF.tbsname = FS.tbsname;

/* Remove the job if it already is running */
DECLARE
   jobno INTEGER;
BEGIN
   SELECT total_bytes INTO jobno
     FROM db_space
    WHERE tablespace_name = '*JOB NUMBER*';

   DBMS_OUTPUT.PUT_LINE (jobno);
   DBMS_JOB.REMOVE (jobno);
   DELETE FROM db_space WHERE tablespace_name = '*JOB NUMBER*';

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;
/
CREATE OR REPLACE PROCEDURE space_logger
AS
   /*
   || records total size and free space for all
   || tablespaces in table db_space
   ||
   || Author:  John Beresniewicz, Savant Corp
   ||
   || 01/26/98: created
   ||
   || Compilation requirements:
   ||
   || SELECT on TBS_SPACE view
   || INSERT on DB_SPACE table
   */

   CURSOR tbs_space_cur
   IS
   SELECT tablespace_name, total_bytes, free_bytes
     FROM tbs_space;

BEGIN
   FOR tbs_space_rec IN tbs_space_cur
   LOOP
      INSERT INTO db_space VALUES
         (tbs_space_rec.tablespace_name
         ,SYSDATE
         ,tbs_space_rec.total_bytes
         ,tbs_space_rec.free_bytes);
   END LOOP;
   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      DECLARE
         jobno INTEGER;
      BEGIN
         SELECT total_bytes INTO jobno
           FROM db_space
          WHERE tablespace_name = '*JOB NUMBER*';
         DBMS_JOB.BROKEN (jobno, TRUE);
         DBMS_OUTPUT.put_line ('Job number ' || jobno || ' set to "broken".');
      END;
END space_logger;
/

DECLARE
   jobno   NUMBER;
BEGIN
   DBMS_JOB.SUBMIT
      (job  => jobno
      ,what => 'BEGIN space_logger; END;'
      ,next_date => SYSDATE
      ,interval  => 'SYSDATE+30/1440');

   /*
      Use the db_space table to hold the job number.
      That way I can get the job number to break
      the job if necessary.
   */
   INSERT INTO db_space VALUES
      ('*JOB NUMBER*'
      ,SYSDATE
      ,jobno
      ,jobno);

   COMMIT;
END;
/
BEGIN
   /*
   SQL> alter session set nls_date_format = 'HH MI SS';
   SQL>  select * from db_space;

   With Unwrapped Version of PL/Vision Installed

   TABLESPACE_NAME                CALC_DAT TOTAL_BYTES FREE_BYTES
   ------------------------------ -------- ----------- ----------
   ROLLBACK_DATA                  08 00 05    26214400    4597760
   SYSTEM                         08 00 05    41943040    8552448
   TEMPORARY_DATA                 08 00 05     2097152    2095104
   USER_DATA                      08 00 05     3145728     686080

   After Install of Wrapped Version of PL/Vision

   ROLLBACK_DATA                  09 00 11    26214400    4085760
   SYSTEM                         09 00 11    41943040    8327168
   TEMPORARY_DATA                 09 00 11     2097152    2095104
   USER_DATA                      09 00 11     3145728     675840
   */
   NULL;
END;
/
