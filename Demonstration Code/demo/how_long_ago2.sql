CREATE OR REPLACE FUNCTION how_long_ago (
   date_in   IN DATE,
   full_in   IN BOOLEAN DEFAULT FALSE)
   RETURN VARCHAR2
IS
   c_seconds_in_minute   CONSTANT PLS_INTEGER := 60;
   c_seconds_in_hour   CONSTANT PLS_INTEGER := 60 * c_seconds_in_minute;
   c_seconds_in_day   CONSTANT PLS_INTEGER := 24 * c_seconds_in_hour;
   c_seconds          CONSTANT INTEGER
      := (SYSDATE - date_in) * c_seconds_in_day ;
   l_days                      INTEGER;
   l_hours                     INTEGER;
   l_minutes                   INTEGER;
   l_seconds                   INTEGER;

   PROCEDURE parse_seconds (seconds_in    IN     INTEGER,
                            days_out      IN OUT INTEGER,
                            hours_out     IN OUT INTEGER,
                            minutes_out   IN OUT INTEGER,
                            seconds_out   IN OUT INTEGER)
   IS
   BEGIN
      days_out := FLOOR (seconds_in / c_seconds_in_day);
      hours_out :=
         FLOOR ( (seconds_in - (days_out * c_seconds_in_day)) / c_seconds_in_hour);
      minutes_out :=
         FLOOR (
              (  seconds_in
               - (days_out * c_seconds_in_day)
               - (hours_out * c_seconds_in_hour))
            / 60);
      seconds_out :=
           seconds_in
         - (days_out * c_seconds_in_day)
         - (hours_out * c_seconds_in_hour)
         - (minutes_out * c_seconds_in_minute);
   END;

   FUNCTION time_description (number_in   IN INTEGER,
                              label_in    IN VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN CASE number_in
                WHEN 0
                THEN
                   NULL
                ELSE
                      ' '
                   || number_in
                   || ' '
                   || label_in
                   || CASE number_in
                         WHEN 1 THEN NULL
                         ELSE 's'
                      END
             END;
   END;
BEGIN
   parse_seconds (c_seconds,
                  l_days,
                  l_hours,
                  l_minutes,
                  l_seconds);
   RETURN LTRIM (
                CASE
                   WHEN c_seconds < c_seconds_in_minute
                   THEN
                      time_description (l_seconds, 'second')
                   WHEN c_seconds < c_seconds_in_hour
                   THEN
                         time_description (l_minutes, 'minute')
                      || CASE
                            WHEN full_in
                            THEN
                               time_description (l_seconds,
                                                 'second')
                         END
                   WHEN c_seconds < c_seconds_in_day
                   THEN
                         time_description (l_hours, 'hour')
                      || CASE
                            WHEN full_in
                            THEN
                                  time_description (l_minutes,
                                                    'minute')
                               || time_description (l_seconds,
                                                    'second')
                         END
                   ELSE
                         time_description (l_days, 'day')
                      || CASE
                            WHEN full_in
                            THEN
                                  time_description (l_hours,
                                                    'hour')
                               || time_description (l_minutes,
                                                    'minute')
                               || time_description (l_seconds,
                                                    'second')
                         END
                END
             || ' ago');
END;
/ 

BEGIN
   DBMS_OUTPUT.put_line (how_long_ago (SYSDATE - 5));
   DBMS_OUTPUT.put_line (how_long_ago (SYSDATE - 2 / 24));
   DBMS_OUTPUT.put_line (
      how_long_ago (SYSDATE - 70 / (24 * 60)));
   DBMS_OUTPUT.put_line (
      how_long_ago (SYSDATE - 70 / (24 * 60), TRUE));
   DBMS_OUTPUT.put_line (
      how_long_ago (SYSDATE - 15 / (24 * 3600)));
END;
/