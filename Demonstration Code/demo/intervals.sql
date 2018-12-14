/* Steven's career length as of June 2011 */

DECLARE
   career_length     INTERVAL YEAR (2) TO MONTH;
BEGIN
   career_length := INTERVAL '31-2' YEAR TO MONTH;

   DBMS_OUTPUT.put_line (TO_CHAR (career_length, 'FMYY years and MM months'));
END;
/

DECLARE
   l_years           VARCHAR2 (2) := '31';
   l_months          VARCHAR2 (1) := '2';
   l_time_together   VARCHAR2 (10) := l_years || '-' || l_months;
   career_length     INTERVAL YEAR (2) TO MONTH;
BEGIN
   career_length := INTERVAL l_time_together YEAR TO MONTH;

   DBMS_OUTPUT.put_line (TO_CHAR (career_length, 'FMYY years and MM months'));
END;
/

DECLARE
   career_length     INTERVAL YEAR (2) TO MONTH;
BEGIN
   career_length := '31-2';

   DBMS_OUTPUT.put_line (TO_CHAR (career_length, 'FMYY years and MM months'));
END;
/


DECLARE
   career_length     INTERVAL YEAR (2) TO MONTH;
BEGIN
   career_length := TO_YMINTERVAL('31-2');

   DBMS_OUTPUT.put_line (TO_CHAR (career_length, 'FMYY years and MM months'));
END;
/

