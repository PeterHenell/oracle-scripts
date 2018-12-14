DECLARE
   TYPE clientele IS TABLE OF VARCHAR2 (64);

   client_list_12    clientele := clientele ('Customer 1', 'Customer 2');
   client_list_13    clientele := clientele ('Customer 1', 'Customer 3');

   client_list_133   clientele
                   := clientele ('Customer 1', 'Customer 3', 'Customer 3');
						   
   client_list_empty clientele := clientele ();						   
BEGIN
   IF 'Customer 1' MEMBER OF client_list_12
   THEN
      DBMS_OUTPUT.put_line ('Customer 1 is in the 12 list');
   END IF;

   IF 'Customer 2' NOT MEMBER OF client_list_13
   THEN
      DBMS_OUTPUT.put_line ('Customer 2 is not in the 13 list');
   END IF;
   
   DBMS_OUTPUT.put_line ('List 133 contains ' || CARDINALITY (client_list_133) || ' items');
   
   IF client_list_empty IS EMPTY
   THEN
      DBMS_OUTPUT.put_line ('Client list is empty');
   END IF;

   IF client_list_133 IS NOT EMPTY
   THEN
      DBMS_OUTPUT.put_line ('Client list 133 is not empty');
   END IF;

END;
/