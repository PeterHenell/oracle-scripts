DECLARE
   TYPE clientele IS TABLE OF VARCHAR2 (64);
   client_list_3n1   clientele
       := clientele ('Customer 3', 'Customer 3', NULL, NULL, 'Customer 1');

   
BEGIN
   client_list_3n1  := set ( client_list_3n1 );
   for indx in 1 .. client_list_3n1.count
   loop
   dbms_output.put_line ( '> ' || nvl (client_list_3n1(indx) , 'Really NULL'));
   -- A bug in PUT_LINE?
   dbms_output.put_line ( client_list_3n1(indx));
   end loop;
END;
/
