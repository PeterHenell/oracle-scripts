BEGIN
   DBMS_OUTPUT.put_line (POWER (2, 3));
END;
/

BEGIN
   DBMS_OUTPUT.put_line (MULT (2, 3));
END;
/

BEGIN
   DBMS_OUTPUT.put_line (2 ** 3);
END;
/

DECLARE
   FUNCTION power_up (base_in IN INTEGER, power_in IN INTEGER)
      RETURN INTEGER
   IS
      l_return   INTEGER := 1;
   BEGIN
      FOR indx IN 1 .. power_in
      LOOP
         l_return := l_return * base_in;
      END LOOP;

      RETURN l_return;
   END;
BEGIN
   DBMS_OUTPUT.put_line (power_up (2, 3));
END;
/

BEGIN
   DBMS_OUTPUT.put_line (2 // 3);
END;
/
