DECLARE
   TYPE numtab1 IS TABLE OF NUMBER;

   TYPE numtab2 IS TABLE OF NUMBER;

   tab1 numtab1 := numtab1 ();
   tab2 numtab2 := numtab2 ();

   PROCEDURE passit (tab IN numtab1)
   IS
   BEGIN
      NULL;
   END;
BEGIN
   passit (tab2);
END;
/
