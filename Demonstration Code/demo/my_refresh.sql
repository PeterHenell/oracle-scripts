set serveroutput on

EXEC DBMS_OUTPUT.PUT_LINE(CHR(9) || 'Creating Refresh Procedure');

CREATE OR REPLACE PROCEDURE my_refresh AS

  /*
    || MY_REFRESH
    ||
    || This procedure is to be submitted as a DBMS_JOB
    || to complete a refresh of snapshots.
    ||
    || The default facilities will not suffice for the
    || following reasons :
    ||    1) If the fast refresh fails we only want to try the
    ||       complete refresh ONCE. It may take a long period
    ||       of time to complete. If it fails then stop everything
    ||       and tell somebody to fix it.
    ||    2) We need to add a method of logging things and fixing
    ||       errors on the fly as much as possible.
    ||    3) Delete log entries greater than 3 days old.
  */

  /*-- get snapshots */
  CURSOR curs_get_snaps IS
  SELECT owner,
         name
    FROM all_snapshots,
         all_refresh
   WHERE rowner = 'REPADMIN'
     AND rname = 'MY_CLUSTER'
     AND refresh_group = refgroup;

  /*-- dynamic SQl variable */
  v_curs  PLS_INTEGER;
  v_fdbck INTEGER;
  v_stmnt VARCHAR2(5000);
  v_sdate DATE;
  v_edate DATE;

BEGIN

  /*-- remove log entries greater than 3 days old */
  DELETE my_refresh_log
  WHERE start_date < sysdate - 3;

  /*-- get the start date time */
  v_sdate := SYSDATE;

  /*-- first try the fast refresh of the whole damn cluster! */
  dbms_refresh.refresh('repadmin.my_cluster');

  /*-- get the end date time */
  v_edate := SYSDATE;
  
  INSERT INTO my_refresh_log
    (refresh_type,
     start_date,
     end_date)
  VALUES
    ('F',
      v_sdate,
      v_edate);

EXCEPTION

  WHEN OTHERS THEN

    /*-- If the error results because FAST refresh is not available then
         make the bold assumption that a complete refresh will make everyone
         happy. Note that complete refreshes must be done on a per snapshot
         basis */
    IF SQLCODE = -12004 THEN

      FOR v_snap_rec IN curs_get_snaps LOOP
        v_curs := DBMS_SQL.OPEN_CURSOR;
        v_stmnt := 'BEGIN DBMS_SNAPSHOT.REFRESH(' || '''' || v_snap_rec.owner || '.'  ||
                                                             v_snap_rec.name  || '''' || ',' || '''' ||
                                                             'C'              || '''' || '); END;';
         DBMS_SQL.PARSE(v_curs,v_stmnt,DBMS_SQL.NATIVE);
         v_fdbck := DBMS_SQL.EXECUTE(v_curs);
         DBMS_SQL.CLOSE_CURSOR(v_curs);
       END LOOP;

       /*-- get the end date time */
       v_edate := SYSDATE;
  
       INSERT INTO my_refresh_log
       (refresh_type,
        start_date,
        end_date)
       VALUES
       ('C',
        v_sdate,
        v_edate);

    ELSE

       /*-- get the end date time */
       v_edate := SYSDATE;

       INSERT INTO my_refresh_log
       (refresh_type,
        start_date,
        end_date)
       VALUES
       ('E',
        v_sdate,
        v_edate);

       RAISE;

     END IF;

END my_refresh;
/

EXEC DBMS_OUTPUT.PUT_LINE(CHR(9) || 'Refresh Procedure Created');

