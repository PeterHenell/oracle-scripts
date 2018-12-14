CREATE OR REPLACE PROCEDURE check_boolean1 (
   expr   IN VARCHAR2,
   disp   IN BOOLEAN DEFAULT TRUE)
IS
   l_count   PLS_INTEGER;
BEGIN
   EXECUTE IMMEDIATE 'select count(*) from dual where ' || expr
      INTO l_count;

   IF disp
   THEN
      DBMS_OUTPUT.put_line (l_count);
   END IF;
END;
/

BEGIN
   check_boolean1 ('1 = 1');
   check_boolean1 ('1 = 0');
END;
/

CREATE OR REPLACE PROCEDURE check_boolean2 (
   expr   IN VARCHAR2,
   disp   IN BOOLEAN DEFAULT TRUE)
IS
   l_count   PLS_INTEGER;
BEGIN
   EXECUTE IMMEDIATE
         'begin :val := case when '
      || expr
      || ' then 1 else 0 end; end;'
      USING OUT l_count;

   IF disp
   THEN
      DBMS_OUTPUT.put_line (l_count);
   END IF;
END;
/

BEGIN
   check_boolean2 ('1 = 1');
   check_boolean2 ('1 = 0');
END;
/

DECLARE
   counter   INTEGER := 10000;
BEGIN
   sf_timer.start_timer;

   FOR i IN 1 .. counter
   LOOP
      check_boolean1 ('1 = 1', FALSE);
   END LOOP;

   sf_timer.show_elapsed_time ('SELECT');
   --
   sf_timer.start_timer;

   FOR i IN 1 .. counter
   LOOP
      check_boolean2 ('1 = 1', FALSE);
   END LOOP;

   sf_timer.show_elapsed_time ('CASE');
END;
/