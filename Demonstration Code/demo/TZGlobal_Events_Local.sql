DROP TABLE global_events_local;

CREATE TABLE global_events_local (
  descr VARCHAR2(80) PRIMARY KEY,
  tzname VARCHAR2(80),
  tstamp TIMESTAMP(0) WITH LOCAL TIME ZONE );

TRUNCATE TABLE global_events_local;

DECLARE
   dep_time                 TIMESTAMP ( 0 ) WITH TIME ZONE;
   arr_time                 TIMESTAMP ( 0 ) WITH TIME ZONE;
   dep_time_local           TIMESTAMP ( 0 ) WITH LOCAL TIME ZONE;
   arr_time_local           TIMESTAMP ( 0 ) WITH LOCAL TIME ZONE;
   dep_time_tzname          VARCHAR2 (80);
   arr_time_tzname          VARCHAR2 (80);
   flight_time              INTERVAL DAY (3)TO SECOND (3);
   flight_time_from_table   INTERVAL DAY (3)TO SECOND (3);
BEGIN
   dep_time :=
      TO_TIMESTAMP_TZ ('16-NOV-2001   17:30:00.0    US/Pacific     PST'
                     , 'DD-MON-YYYY HH24:MI:SSXFF   TZR            TZD'
                      );
   dep_time_tzname := EXTRACT (TIMEZONE_REGION FROM dep_time);

   /* this doesn't work! So select from dual */
   --dep_time_local := cast ( dep_time as timestamp(0) with local time zone );
   SELECT CAST (dep_time AS TIMESTAMP ( 0 ) WITH LOCAL TIME ZONE)
     INTO dep_time_local
     FROM DUAL;

   arr_time :=
      TO_TIMESTAMP_TZ ('17-NOV-2001   11:50:00.0    Europe/London  GMT'
                     , 'DD-MON-YYYY HH24:MI:SSXFF   TZR            TZD'
                      );
   arr_time_tzname := EXTRACT (TIMEZONE_REGION FROM arr_time);

   SELECT CAST (arr_time AS TIMESTAMP ( 0 ) WITH LOCAL TIME ZONE)
     INTO arr_time_local
     FROM DUAL;

   INSERT INTO global_events_local
               (descr, tzname, tstamp
               )
        VALUES ('Depart SFO', dep_time_tzname, dep_time_local
               );

   INSERT INTO global_events_local
               (descr, tzname, tstamp
               )
        VALUES ('Arrive LHR', arr_time_tzname, arr_time_local
               );

   flight_time := arr_time_local - dep_time_local;
   DBMS_OUTPUT.put_line (TO_CHAR (flight_time, 'DD HH:MI:SSXFF'));

   SELECT tstamp
     INTO dep_time_local
     FROM global_events_local
    WHERE descr = 'Depart SFO';

   SELECT tstamp
     INTO arr_time_local
     FROM global_events_local
    WHERE descr = 'Arrive LHR';

   IF arr_time_local - dep_time_local <> flight_time
   THEN
      raise_application_error (-20000, 'Weird');
   END IF;
END;
/

/*
+000000 10:20:00.000000000
*/
ALTER SESSION SET nls_timestamp_format =
  'DD-Mon-YYYY  HH24:MI:SSXFF';
COLUMN descr format a20
COLUMN tzname format a20
SELECT *
  FROM global_events_local;
/*
DESCR                TZNAME               TSTAMP
-------------------- -------------------- ---------------------
Depart SFO           US/Pacific           16-Nov-2001  17:30:00
Arrive LHR           Europe/London        17-Nov-2001  03:50:00
*/

/*
Try the above again after doing...
*/
ALTER DATABASE SET TIME_ZONE = 'US/Eastern'                   /* and bounce */
                                           ;
/*
However, "select SessionTimezone from dual" gives "-08:00" - BIZARRE -
unless do "alter session set time_zone = DbTimezone", but then get...

DESCR                TZNAME               TSTAMP
-------------------- -------------------- ---------------------
Depart SFO           US/Pacific           16-Nov-2001  20:30:00
Arrive LHR           Europe/London        17-Nov-2001  06:50:00
*/
/*
Else, if not "set time_zone = DbTimezone", then no change.
*/
SELECT *
  FROM global_events_local;
/*
The more natural test is just...
*/
ALTER SESSION SET TIME_ZONE = 'US/Eastern';
/*
after running the above with DbTimezone='US/Pacific' same result
*/
SELECT *
  FROM global_events_local;