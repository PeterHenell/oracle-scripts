DECLARE
   TYPE cursors_t IS TABLE OF SYS_REFCURSOR
                        INDEX BY PLS_INTEGER;

   l_cursors   cursors_t;
BEGIN
   NULL;
END;
/

DECLARE
   TYPE exceptions_t IS TABLE OF EXCEPTION
                        INDEX BY PLS_INTEGER;

   l_exceptions   exceptions_t;
BEGIN
   NULL;
END;
/