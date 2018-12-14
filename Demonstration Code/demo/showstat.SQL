CREATE OR REPLACE PROCEDURE show_status (s IN VARCHAR2
                                       , n IN VARCHAR2
                                       , t IN VARCHAR2
                                        )
IS
   l_status   all_objects.status%TYPE;
BEGIN
   SELECT status
     INTO l_status
     FROM all_objects
    WHERE owner = s AND object_name = n AND object_type = t;

   DBMS_OUTPUT.put_line (l_status);
END show_status;
/