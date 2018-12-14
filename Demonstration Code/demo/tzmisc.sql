@tzset_show.sql

ALTER SESSION
  SET nls_timestamp_format = 'DD-Mon-YYYY  HH24:MI:SSXFF';

ALTER SESSION SET TIME_ZONE = DBTIMEZONE                   /* see bug #2201620
                    Specify DBTIMEZONE to set the current session time zone
                    to match the value set for the database time zone.
                    If you specify this setting, the DBTIMEZONE function
                    will return the database time zone as a UTC offset or
                    a timezone region, depending on how the database time zone
                    has been set.
                    */
                                        ;

BEGIN
   DBMS_OUTPUT.put_line (SESSIONTIMEZONE);
   DBMS_OUTPUT.put_line (CURRENT_TIMESTAMP);
   DBMS_OUTPUT.put_line (LOCALTIMESTAMP);
END;
/

BEGIN
   tz_set_and_show;                                       -- Current settings
   tz_set_and_show ('US/Eastern');
   tz_set_and_show ('US/Pacific');
END;
/

-- Ready to start now!
----------------------------------------------------------------------
--
-- The third form is most reliable because it specifies the rules to
-- follow at the point when switching to daylight savings time.
--
-- TIMESTAMP '1999-04-15 8:00:00 -8:00'
-- TIMESTAMP '1999-04-15 8:00:00 US/Pacific'
-- TIMESTAMP '1999-10-31 01:30:00 US/Pacific PDT'

DROP TABLE with_time_zone;
CREATE TABLE with_time_zone ( ID NUMBER PRIMARY KEY, tstamp TIMESTAMP(3) WITH TIME ZONE );
TRUNCATE TABLE with_time_zone;

COLUMN parameter format a30
COLUMN value format a50
SELECT *
  FROM v$nls_parameters
 WHERE LOWER (parameter) LIKE '%time%'
/* NLS_TIMESTAMP_TZ_FORMAT  DD-MON-RR HH.MI.SSXFF AM TZR */
;

ALTER SESSION
  /* Using default NLS_TIMESTAMP_TZ_FORMAT format model is risky ! */
SET   nls_timestamp_tz_format =
                      'DD-Mon-YYYY  HH24:MI:SSXFF   TZR         TZD';

COLUMN value format a100
SELECT VALUE
  FROM nls_session_parameters
 WHERE parameter = 'NLS_TIMESTAMP_TZ_FORMAT'                       /* wierd */
                                            ;

INSERT INTO with_time_zone
     VALUES (1
           ,                                                      /* winter */
             TO_TIMESTAMP_TZ ('25-Dec-2001    13:00:00.123  US/Pacific  PST'));
INSERT INTO with_time_zone
     VALUES (2
           ,                                                      /* summer */
             TO_TIMESTAMP_TZ ('25-Jun-2002    13:00:00.123  US/Pacific  PDT'));

SELECT ID, EXTRACT (TIMEZONE_REGION FROM tstamp) e
  FROM with_time_zone;
/*
ID E
-- -------------------
 1 US/Pacific
 2 US/Pacific
*/
SELECT ID, EXTRACT (TIMEZONE_ABBR FROM tstamp) e
  FROM with_time_zone;
/*
ID E
-- ---
 1 PST
 2 PDT
*/

SELECT ID, tstamp
  FROM with_time_zone;
/*
ID TSTAMP
-- --------------------------------------------------
 1 25-Dec-2001  13:00:00.123   US/PACIFIC         PST
 2 25-Jun-2002  13:00:00.123   US/PACIFIC         PDT
*/

----------------------------------------------------------------------
--
-- 'US/Pacific' and 'PDT' are incompatible for 25-DEC, hence ORA-01857

INSERT INTO with_time_zone
     VALUES                             /* ORA-01857: not a valid time zone */
            (3
           , TO_TIMESTAMP_TZ
                  ('25-DEC-2002   13:00:00.123  US/Pacific PDT'
                 ,                                              /* conflict */
                   'DD-Mon-YYYY HH24:MI:SSXFF   TZR                 TZD'
                  ));