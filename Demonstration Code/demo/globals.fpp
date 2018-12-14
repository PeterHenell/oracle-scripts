PACKAGE salespkg
IS
   FUNCTION total RETURN NUMBER;
   PROCEDURE set_total (total_in IN NUMBER);
END;

PACKAGE BODY salespkg
IS
   FUNCTION total RETURN NUMBER
   IS
   BEGIN
      RETURN :GLOBAL.totalsales;
   END;

   PROCEDURE set_total (total_in IN NUMBER)
   IS
   BEGIN
      :GLOBAL.totalsales := total_in;
   END;
END;

