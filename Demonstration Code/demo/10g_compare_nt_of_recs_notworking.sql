/* DOES NOT WORK */
DECLARE
   TYPE employees_t IS TABLE OF employees%rowtype;
   n1   employees_t := employees_t ();
   n2   employees_t := employees_t ();
   n3   employees_t;
BEGIN
/*
   IF n1 = n2
   THEN
      DBMS_OUTPUT.put_line ('=');
   END IF;
*/

   n3 := n1 MULTISET UNION n2;
   n3 := n1 MULTISET INTERSECT n2;
   n3 := n1 MULTISET EXCEPT n2;
END;
/