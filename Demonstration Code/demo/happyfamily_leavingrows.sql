CREATE or replace TYPE list_of_names_t IS TABLE OF varchar2(100);
/

GRANT EXECUTE ON list_of_names_t TO PUBLIC
/

DECLARE
   happyfamily   list_of_names_t := list_of_names_t ();
   children      list_of_names_t := list_of_names_t ();
   parents       list_of_names_t := list_of_names_t ();
BEGIN
   happyfamily.EXTEND (4);
   happyfamily (1) := 'Eli';
   --happyfamily (2) := 'Steven';
   happyfamily (2) := 'Chris';
   --happyfamily (4) := 'Veva';

   children.EXTEND;
   children (children.LAST) := 'Chris';
   children.EXTEND;
   children (children.LAST) := 'Eli';

   parents := happyfamily MULTISET EXCEPT children;
p.l (parents.first);
p.l (parents.last);

   FOR l_row IN parents.FIRST .. parents.LAST
   LOOP
      DBMS_OUTPUT.put_line (l_row || '-' || parents (l_row));
   END LOOP;
END;
/
