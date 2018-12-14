DECLARE
   rec      employee%ROWTYPE;
   l_name   srf_employee.full_name_t;

   PROCEDURE check_srf (val IN INTEGER, rec_in IN employee%ROWTYPE)
   IS
   BEGIN
      IF srf_employee.nrf (rec)
      THEN
         DBMS_OUTPUT.put_line ('NRF for ' || val);
      ELSE
         DBMS_OUTPUT.put_line
            ('RF for ' || val || ' last name = ' || rec_in.last_name);
      END IF;
   END;

   PROCEDURE check_name (val IN INTEGER, NAME_IN IN employee.last_name%TYPE)
   IS
   BEGIN
      IF srf_employee.nrf_last_name (NAME_IN)
      THEN
         DBMS_OUTPUT.put_line ('NRF-col for ' || val);
      ELSE
         DBMS_OUTPUT.put_line
            ('RF-col for ' || val || ' last name = ' || NAME_IN);
      END IF;
   END;

   PROCEDURE check_fullname (
      val       IN   INTEGER
     ,NAME_IN   IN   srf_employee.full_name_t
   )
   IS
   BEGIN
      IF srf_employee.nrf_full_name (NAME_IN)
      THEN
         DBMS_OUTPUT.put_line ('NRF-col for ' || val);
      ELSE
         DBMS_OUTPUT.put_line
            ('RF-col for ' || val || ' full name = ' || NAME_IN);
      END IF;
   END;
BEGIN
   rec := srf_employee.onerow (7499);
   check_srf (7499, rec);
   rec := srf_employee.onerow (-15);
   check_srf (-15, rec);
   --
   rec.last_name := srf_employee.last_name (7499);
   check_name (7499, rec.last_name);
   rec.last_name := srf_employee.last_name (-15);
   check_name (-15, rec.last_name);
   --
   l_name := srf_employee.full_name (7499);
   check_fullname (7499, l_name);
   l_name := srf_employee.full_name (-15);
   check_fullname (-15, l_name);
END;
/