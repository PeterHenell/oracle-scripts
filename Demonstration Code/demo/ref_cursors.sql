CREATE OR REPLACE PACKAGE refcursor_pkg
IS
   -- Use this REF CURSOR to declare cursor variables whose
   -- queries return data from the ALL_OBJECTS table.
   
   TYPE all_objects_t IS REF CURSOR
      RETURN all_objects%ROWTYPE;

   -- Use this REF CURSOR to declare cursor variables whose
   -- queries return any number of columns.
   
   TYPE weak_t IS REF CURSOR;

   -- Return rows in ALL_OBJECTS for any objects
   -- in the specified schema
   FUNCTION objects_in_schema_cv (
      schema_in        IN   all_objects.owner%TYPE
    , name_filter_in   IN   VARCHAR2
   )
      RETURN all_objects_t;

   -- Return data from whatever query is passed as an argument.
   FUNCTION data_from_any_query_cv (query_in IN VARCHAR2)
      RETURN weak_t;

   -- Return data from whatever query is passed as an argument.
   -- But this time, use the predefined weak type,
   -- available in Oracle9i Database Release 2 and above.
   FUNCTION data_from_any_query_cv2 (query_in IN VARCHAR2)
      RETURN sys_refcursor;
END refcursor_pkg;
/

CREATE OR REPLACE PACKAGE BODY refcursor_pkg
IS
   FUNCTION objects_in_schema_cv (
      schema_in        IN   all_objects.owner%TYPE
    , name_filter_in   IN   VARCHAR2
   )
      RETURN all_objects_t
   IS
      l_cursor_variable   all_objects_t;
   BEGIN
      IF name_filter_in IS NULL
      THEN
         OPEN l_cursor_variable FOR
            SELECT *
              FROM all_objects
             WHERE owner = schema_in;
      ELSE
         OPEN l_cursor_variable FOR
            SELECT *
              FROM all_objects
             WHERE owner = schema_in AND object_name LIKE name_filter_in;
      END IF;

      RETURN l_cursor_variable;
   END objects_in_schema_cv;

   FUNCTION data_from_any_query_cv (query_in IN VARCHAR2)
      RETURN weak_t
   IS
      l_cursor_variable   weak_t;
   BEGIN
      OPEN l_cursor_variable FOR query_in;

      RETURN l_cursor_variable;
   END data_from_any_query_cv;

   FUNCTION data_from_any_query_cv2 (query_in IN VARCHAR2)
      RETURN sys_refcursor
   IS
      l_cursor_variable   sys_refcursor;
   BEGIN
      OPEN l_cursor_variable FOR query_in;

      RETURN l_cursor_variable;
   END data_from_any_query_cv2;
END refcursor_pkg;
/

/*
Demonstrate strong ref cursor type.
 
Note: to show compile time mis-match analysis, change the 
      query in the above package.
*/

DECLARE
   l_objects   refcursor_pkg.all_objects_t;
   l_object    all_objects%ROWTYPE;
BEGIN
   l_objects := refcursor_pkg.objects_in_schema_cv (USER, '%EMP%');

   LOOP
      FETCH l_objects
       INTO l_object;

      EXIT WHEN l_objects%NOTFOUND;
      DBMS_OUTPUT.put_line (l_object.object_name);
   END LOOP;

   CLOSE l_objects;
END;
/

/*
Demonstrate weak ref cursor type.
 
Note: to show compile time mis-match analysis, change the 
      query in the above package.
*/

DECLARE
   l_objects   sys_refcursor;
   l_object    all_objects%ROWTYPE;
BEGIN
   l_objects :=
      refcursor_pkg.data_from_any_query_cv2
                ('SELECT * FROM all_objects WHERE object_name LIKE ''%EMP%''');

   LOOP
      FETCH l_objects
       INTO l_object;

      EXIT WHEN l_objects%NOTFOUND;
      DBMS_OUTPUT.put_line (l_object.object_name);
   END LOOP;
   
   CLOSE l_objects;
END;
/