DROP TABLE id_name
/

CREATE TABLE id_name (id NUMBER, name VARCHAR2 (100))
/

DECLARE
   TYPE id_name_rt IS RECORD (id NUMBER, name VARCHAR2 (100));

   TYPE nested_t IS TABLE OF id_name_rt;

   nt1   nested_t := nested_t ();
   nt2   nested_t := nested_t ();
   nt3   nested_t := nested_t ();
BEGIN
   nt1.EXTEND (1);
   nt1(1).id := 1;
   nt1(1).name := 'abc';
   nt3 := nt1 MULTISET UNION nt2;
   DBMS_OUTPUT.put_line ('Union ' || nt3.COUNT);
   /* Doesn't work with INTERSECT...
   nt3 := nt1 MULTISET INTERSECT nt2;
   DBMS_OUTPUT.put_line ('Intersect ' || nt3.COUNT);
   */
   /* Doesn't work with ECXEPT...
   wh_intersect_data := wh_current_data MULTISET EXCEPT wh_previous_data;
   DBMS_OUTPUT.put_line ('Minus ' || nt3.COUNT);
   */
END;
/