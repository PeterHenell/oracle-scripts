/* This procedure is used in the parallel activity. */
CREATE OR REPLACE PROCEDURE updnumval (
   tab_in IN VARCHAR2,
   col_in IN VARCHAR2,
   val_in IN NUMBER,
   where_in IN VARCHAR2 := NULL)
IS
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   upd PLV.dbmaxvc2 :=
      'UPDATE ' || tab_in || ' SET ' || col_in || ' = ' || val_in ||
      ' WHERE ' || NVL (where_in, '1=1');
   fdbk PLS_INTEGER;
BEGIN
   DBMS_SQL.PARSE (cur, upd, DBMS_SQL.NATIVE);
   fdbk := DBMS_SQL.EXECUTE (cur);
   DBMS_SQL.CLOSE_CURSOR (cur);
EXCEPTION
   WHEN OTHERS
   THEN
      p.l ('Updnumval error ' || SQLCODE || ' on ' || upd);
      RAISE;
END;
/

/*
   Create three different copies of the employee table, emulating
   a distributed environment. The simultaneous processes will
   update the rows in each of the different tables/locations.
*/

ALTER TABLE employee MODIFY last_name VARCHAR2(100);

DROP TABLE ny_employee;
CREATE TABLE ny_employee AS SELECT * FROM employee;
UPDATE ny_employee SET last_name = 'NY.' || last_name;

DROP TABLE la_employee;
CREATE TABLE la_employee AS SELECT * FROM employee;
UPDATE la_employee SET last_name = 'LA.' || last_name;

DROP TABLE hk_employee;
CREATE TABLE hk_employee AS SELECT * FROM employee;
UPDATE hk_employee SET last_name = 'HK.' || last_name;

COMMIT;

CREATE OR REPLACE PACKAGE parallel
/*
|| Demonstration of use of DBMS_PIPE to allow for
|| simultaneous or parallel execution of programs.
||
|| Author: Steven Feuerstein
||   Date: June 1998
||
|| Dependencies:
||   Execute authority on DBMS_PIPE
||   Execute authority on DBMS_LOCK
||   Installation of PL/Vision (Lite, Professional or Trial)
||      to time execution
||
|| Instructions:
||   1. Create the package.
||
||   2. Start up four sessions in SQL*Plus or another execution,
||      environment, connecting to the account that owns this package.
||
||   3. In one session, execute parallel.seq_jobs. This will
||      execute the three jobs in sequence and show the total elapsed
||      time, which should be roughly 1.5 minutes, since each job
||      consumes about 30 seconds with a one second pause between
||      employee row updates.
||
||   4. In each of three sessions, SET SERVEROUTPUT ON and then
||      run one of the following:
||         exec parallel.exec_job ('NY')
||         exec parallel.exec_job ('LA')
||         exec parallel.exec_job ('HK')
||
||      You will not see any immediate response.
||      These programs are waiting for the signal to start.
||
||   5. In the fourth session, enter:
||         exec parallel.par_job
||      In approximately 30 seconds, each of the three exec_jobN
||      programs should complete and display their job name, and
||      the parallel execution of the jobs will also be completed.
||
|| NOTE: the default definition of this package "cheats" by having the
||       processes go to sleep for one second after each row updated.
||       This is necessary to demonstrate the effect on a single processor.
||       If you want to test this "for real" in a multi CPU system,
||       execute these commands in each of the sessions before you start
||       your test:
||
||       SQL> exec parallel.secs_pause := 0;
||       SQL> exec parallel.spam_upd_count := 100;
||
||       The first line sets the pause to 0, which means you will have
||       continual processing in your different sessions. The second
||       line requests that the update be done 100 times instead of once.
||       This will generate activity over a period of time that will allow
||       you to get a better sense of the effect.
*/
IS
   secs_pause PLS_INTEGER := 1;
   spam_upd_count PLS_INTEGER := 1;
   waittime CONSTANT INTEGER := 180;

   /* The job to be executed by each parallel stream. */
   PROCEDURE updsal (
      loc IN VARCHAR2, bonus IN employee.salary%TYPE);

   /* Program to execute each job in response to a command
      delivered through a database pipe. */
   PROCEDURE exec_job (loc IN VARCHAR2);

   /* Run the jobs in sequence */
   PROCEDURE seq_jobs;

   /* Run the jobs in parallel */
   PROCEDURE par_jobs;
END;
/
CREATE OR REPLACE PACKAGE BODY parallel
IS
   c_confirm_pipe CONSTANT CHAR(7) := 'CONFIRM';

   PROCEDURE updsal (loc IN VARCHAR2, bonus IN employee.salary%TYPE)
   IS
      v_name employee.last_name%TYPE;
   BEGIN
      p.l ('Updating salary at ' || loc || ' by ' || bonus);
      FOR spam_upd IN 1 .. spam_upd_count
      LOOP
         FOR rec IN (SELECT * FROM employee)
         LOOP
            v_name := loc || '.' || rec.last_name;

            updnumval (
               loc || '_employee',
               'salary',
               rec.salary + bonus,
               'last_name = ''' || v_name || '''');

            IF spam_upd = 1
            THEN
               p.l ('New salary of ' || v_name, rec.salary + bonus);
            END IF;
            DBMS_LOCK.SLEEP (secs_pause);
         END LOOP;
      END LOOP;
      COMMIT;
   END;

   PROCEDURE kickoff_job (loc IN VARCHAR2, bonus IN NUMBER)
   IS
      stat INTEGER;
   BEGIN
      DBMS_PIPE.RESET_BUFFER;
      DBMS_PIPE.PACK_MESSAGE (bonus);
      stat := DBMS_PIPE.SEND_MESSAGE (loc, timeout => waittime);
   END;

   PROCEDURE exec_job (loc IN VARCHAR2)
   IS
      bonus NUMBER;
      stat INTEGER;
   BEGIN
      sf_timer.start_timer;

      stat := DBMS_PIPE.RECEIVE_MESSAGE (loc, timeout => waittime);
      DBMS_PIPE.UNPACK_MESSAGE (bonus);

      updsal (loc, bonus);

      --PLVdyn.plsql ('SCOTT.parallel.updsal(''' || loc || ''',' || bonus || ')');

      DBMS_PIPE.RESET_BUFFER;
      DBMS_PIPE.PACK_MESSAGE (loc);
      stat := DBMS_PIPE.SEND_MESSAGE (c_confirm_pipe, timeout => waittime);

     sf_timer.show_elapsed_time (loc || ' completed with status ' || stat);
   END;

   PROCEDURE wait_for_confirmation
   IS
     stat INTEGER;
     loc VARCHAR2(2);

     PROCEDURE receive_confirm
     IS
     BEGIN
        stat := DBMS_PIPE.RECEIVE_MESSAGE (c_confirm_pipe, timeout => 3 * waittime);
        DBMS_PIPE.UNPACK_MESSAGE (loc);
        p.l ('Bonus confirmed from ' || loc);
     END;
   BEGIN
     /* Wait for confirmation for each location. */
     receive_confirm;
     receive_confirm;
     receive_confirm;
   END;

   PROCEDURE seq_jobs
   IS
   BEGIN
      sf_timer.start_timer;
      updsal ('NY', 1000);
      updsal ('LA', 1500);
      updsal ('HK', 2000);
      sf_timer.show_elapsed_time ('sequential');
   END;

   PROCEDURE par_jobs
   IS
   BEGIN
      sf_timer.start_timer;
      kickoff_job ('NY', 1000);
      kickoff_job ('LA', 1500);
      kickoff_job ('HK', 2000);
      wait_for_confirmation;
      sf_timer.show_elapsed_time ('parallel');
   END;

END;
/
