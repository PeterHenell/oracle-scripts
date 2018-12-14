DECLARE
   l_day   VARCHAR2 (10) := TO_CHAR (SYSDATE, 'DY');
BEGIN
   DBMS_OUTPUT.put_line (
      CASE l_day
         WHEN 'SAT' THEN 'Weekend'
         WHEN 'SUN' THEN 'Weekend'
         ELSE 'Weekday'
      END);
END;
/

DECLARE
   l_day   VARCHAR2 (10) := TO_CHAR (SYSDATE, 'DY');
BEGIN
   DBMS_OUTPUT.put_line (
      DECODE (l_day,  'SAT', 'Weekend',  'SUN', 'Weekend',  'Weekday'));
END;
/

DECLARE
   l_day   VARCHAR2 (10) := TO_CHAR (SYSDATE, 'DY');
BEGIN
   DBMS_OUTPUT.put_line (
      CASE WHEN l_day IN ('SAT', 'SUN') THEN 'Weekend' ELSE 'Weekday' END);
END;
/

DECLARE
   l_day        VARCHAR2 (10) := TO_CHAR (SYSDATE, 'DY');
   l_day_type   VARCHAR2 (10);
BEGIN
   SELECT DECODE (l_day,  'SAT', 'Weekend',  'SUN', 'Weekend',  'Weekday')
     INTO l_day_type
     FROM DUAL;

   DBMS_OUTPUT.put_line (l_day_type);
END;
/

DECLARE
   l_day        VARCHAR2 (10) := TO_CHAR (SYSDATE, 'DY');
   l_day_type   VARCHAR2 (10);
BEGIN
   SELECT CASE l_day
             WHEN 'SAT' THEN 'Weekend'
             WHEN 'SUN' THEN 'Weekend'
             ELSE 'Weekday'
          END
     INTO l_day_type
     FROM DUAL;

   DBMS_OUTPUT.put_line (l_day_type);
END;
/

DECLARE
   l_day   VARCHAR2 (10) := TO_CHAR (SYSDATE, 'DY');
BEGIN
   IF l_day IN ('SAT', 'SUN')
   THEN
      DBMS_OUTPUT.put_line ('Weekend');
   ELSE
      DBMS_OUTPUT.put_line ('Weekday');
   END IF;
END;
/
