/* This works, with the abbreviation */

CREATE OR REPLACE FUNCTION plch_hours_from_EST (tz_abbrev_in IN VARCHAR2)
   RETURN VARCHAR2
IS
BEGIN
   RETURN TZ_OFFSET (tz_abbrev_in);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_hours_from_EST ('EST'));
END;
/

/* Have to watch out for duplicate abbreviations! 

ORA-01422: exact fetch returns more than requested number of rows

*/

CREATE OR REPLACE FUNCTION plch_hours_from_EST (tz_abbrev_in IN VARCHAR2)
   RETURN VARCHAR2
IS
   l_name   v$timezone_names.tzname%TYPE;
BEGIN
   SELECT tzname
     INTO l_name
     FROM v$timezone_names
    WHERE tzabbrev = tz_abbrev_in;

   RETURN TZ_OFFSET (l_name);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_hours_from_EST ('EST'));
END;
/

/* Just return one */

CREATE OR REPLACE FUNCTION plch_hours_from_EST (tz_abbrev_in IN VARCHAR2)
   RETURN VARCHAR2
IS
   l_name   v$timezone_names.tzname%TYPE;
BEGIN
   SELECT tzname
     INTO l_name
     FROM v$timezone_names
    WHERE tzabbrev = tz_abbrev_in AND ROWNUM < 2;

   RETURN TZ_OFFSET (l_name);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_hours_from_EST ('EST'));
END;
/

/* No such column in the view */

CREATE OR REPLACE FUNCTION plch_hours_from_EST (tz_abbrev_in IN VARCHAR2)
   RETURN VARCHAR2
IS
   l_offset   v$timezone_names.tzoffset%TYPE;
BEGIN
   SELECT tzoffset
     INTO l_offset
     FROM v$timezone_names
    WHERE tzabbrev = tz_abbrev_in;

   RETURN l_offset;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_hours_from_EST ('EST'));
END;
/

/* Clean up */

DROP FUNCTION plch_hours_from_EST
/