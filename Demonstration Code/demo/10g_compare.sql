DECLARE
   TYPE clients_list_t IS TABLE OF VARCHAR2 (30);

   l_clients1   clients_list_t := clients_list_t ('Customer 1', 'Customer 3');
   l_clients2   clients_list_t := clients_list_t ('Customer 3', 'Customer 1');
   l_clients3   clients_list_t
                   := clients_list_t ('Customer 1', 'Customer 3', NULL);
   l_clients4   clients_list_t
                   := clients_list_t ('Customer 3', NULL, 'Customer 1');

   PROCEDURE compare_clients (clients1_in   IN clients_list_t
                            , clients2_in   IN clients_list_t)
   IS
   BEGIN
      IF clients1_in = clients2_in
      THEN
         DBMS_OUTPUT.put_line ('=');
      ELSIF clients1_in <> clients2_in
      THEN
         DBMS_OUTPUT.put_line ('<>');
      ELSIF (clients1_in = clients2_in) IS NULL
      THEN
         DBMS_OUTPUT.put_line ('NULL');
      END IF;
   END compare_clients;
BEGIN
   compare_clients (l_clients1, l_clients2);
   compare_clients (l_clients1, l_clients3);
   compare_clients (l_clients3, l_clients3);
   compare_clients (l_clients3, l_clients4);
END;
/