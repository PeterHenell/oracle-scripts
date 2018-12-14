BEGIN
   DBMS_OUTPUT.put_line (1);

   BEGIN
      RETURN;
   END;

   DBMS_OUTPUT.put_line (2);

   RETURN;

   DBMS_OUTPUT.put_line (3);
END;
/