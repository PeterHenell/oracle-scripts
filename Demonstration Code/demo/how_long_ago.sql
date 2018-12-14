CREATE OR REPLACE FUNCTION how_long_ago (date_in IN DATE)
   RETURN VARCHAR2
IS
   c_seconds   CONSTANT INTEGER := ABS ( (SYSDATE - date_in) * 86400);
   c_days      CONSTANT INTEGER := FLOOR (c_seconds / 86400);
   c_hours     CONSTANT INTEGER
                           := FLOOR ( (c_seconds - (c_days * 86400)) / 3600) ;
   c_minutes   CONSTANT INTEGER
      := FLOOR ( (c_seconds - (c_days * 86400) - (c_hours * 3600)) / 60) ;
   c_secs      CONSTANT INTEGER
      := c_seconds - (c_days * 86400) - (c_hours * 3600) - (c_minutes * 60) ;

   FUNCTION add_s (number_in IN INTEGER)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN CASE number_in WHEN 1 THEN NULL ELSE 's' END;
   END;

   FUNCTION descrip_for (number_in IN INTEGER, label_in IN VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN CASE number_in
                WHEN 0 THEN NULL
                ELSE ' ' || number_in || ' ' || label_in || add_s (number_in)
             END;
   END;
BEGIN
/*
   DBMS_OUTPUT.put_line (c_days);
   DBMS_OUTPUT.put_line (c_hours);
   DBMS_OUTPUT.put_line (c_minutes);
   DBMS_OUTPUT.put_line (c_secs);
*/

   RETURN LTRIM (
                CASE
                   WHEN c_seconds < 60
                   THEN
                      descrip_for (c_secs, 'second')
                   WHEN c_seconds < 3600
                   THEN
                         descrip_for (c_minutes, 'minute')
                      || descrip_for (c_secs, 'second')
                   WHEN c_seconds < 86400
                   THEN
                         descrip_for (c_hours, 'hour')
                      || descrip_for (c_minutes, 'minute')
                      || descrip_for (c_secs, 'second')
                   ELSE
                         descrip_for (c_days, 'day')
                      || descrip_for (c_hours, 'hour')
                      || descrip_for (c_minutes, 'minute')
                      || descrip_for (c_secs, 'second')
                END
             || ' ago');
END;
/

BEGIN
   DBMS_OUTPUT.put_line (how_long_ago (SYSDATE - 5));
   DBMS_OUTPUT.put_line (how_long_ago (SYSDATE - 2/ 24));
   DBMS_OUTPUT.put_line (how_long_ago (SYSDATE - 70 / (24*60)));
   DBMS_OUTPUT.put_line (how_long_ago (SYSDATE - 15 / (24*3600)));
END;
/