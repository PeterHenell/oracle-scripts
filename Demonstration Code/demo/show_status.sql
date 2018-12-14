CREATE OR REPLACE PROCEDURE show_status (s IN VARCHAR2
                                       , n IN VARCHAR2
                                       , t IN VARCHAR2
                                       , title IN VARCHAR2 DEFAULT NULL
                                        )
IS
   l_status   all_objects.status%TYPE;
BEGIN
   SELECT status
     INTO l_status
     FROM all_objects
    WHERE owner = s AND object_name = n AND object_type = t;

   IF title IS NOT NULL
   THEN
      DBMS_OUTPUT.put_line (title);
   END IF;

   DBMS_OUTPUT.put_line (
      t || ' ' || s || '.' || n || ' status = ' || l_status
   );
END show_status;
/