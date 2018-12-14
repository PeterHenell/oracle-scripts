DECLARE
   TYPE dates_tt
   IS
      TABLE OF DATE
         INDEX BY PLS_INTEGER;

   birthdays   dates_tt;
BEGIN
   FOR rowind IN birthdays.FIRST .. birthdays.LAST
   LOOP
      DBMS_OUTPUT.put_line (birthdays (rowind));
   END LOOP;
END;