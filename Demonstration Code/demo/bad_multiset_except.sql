DECLARE
   happyfamily   list_of_names_t := list_of_names_t ();
   children      list_of_names_t := list_of_names_t ();
   parents       list_of_names_t := list_of_names_t ();
   l_row pls_integer;
BEGIN
   happyfamily.EXTEND (4);
   happyfamily (1) := 'Eli';
   happyfamily (2) := 'Steven';
   happyfamily (4) := 'Veva';
   dbms_output.put_line ( '*'||happyfamily (3) );
   --
    l_row := happyfamily.last;

   WHILE (l_row IS NOT NULL)
   LOOP
      DBMS_OUTPUT.put_line (   'Value at index '
                            || l_row
                            || ' = '
                            || happyfamily (l_row)
                           );
      l_row := happyfamily.prior (l_row);
   END LOOP;
   dbms_output.put_line ( '---' );
   children.EXTEND;
   children (children.LAST) := 'Chris';
   children.EXTEND;
   children (children.LAST) := 'Eli';

   parents := happyfamily MULTISET EXCEPT children;
   
   IF parents.COUNT > 0
   THEN
      FOR l_row IN parents.FIRST .. parents.LAST
      LOOP
         DBMS_OUTPUT.put_line (parents (l_row));
      END LOOP;
   END IF;
END;
/
