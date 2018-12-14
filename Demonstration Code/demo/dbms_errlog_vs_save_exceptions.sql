/*
  Compare row level error suppression of DBMS_ERRLOG
  to statement level error suppression with SAVE EXCEPTIONS.
*/
DROP TABLE parts
/

CREATE TABLE parts
(
   id     NUMBER
 , name   VARCHAR2 (10)
)
/

BEGIN
   INSERT INTO parts
        VALUES (1, 'Gearbox');

   INSERT INTO parts
        VALUES (2, 'Box');

   INSERT INTO parts
        VALUES (3, 'Gear');

   INSERT INTO parts
        VALUES (4, 'Brace');

   INSERT INTO parts
        VALUES (5, 'Buckle');

   INSERT INTO parts
        VALUES (6, 'Lid');

   INSERT INTO parts
        VALUES (7, 'Log');

   INSERT INTO parts
        VALUES (8, 'Lift');

   INSERT INTO parts
        VALUES (9, 'Gearhead');

   COMMIT;
END;
/

/*
Now I will modify each part name identified by
the filter in the binding array.

First with SAVE EXCEPTIONS....
*/

DECLARE
   bulk_errors   EXCEPTION;
   PRAGMA EXCEPTION_INIT (bulk_errors, -24381);

   TYPE filters_t IS TABLE OF parts.name%TYPE;

   l_filters     filters_t := filters_t ('G%', 'B%', 'L%');
BEGIN
   FORALL indx IN 1 .. l_filters.COUNT
   SAVE EXCEPTIONS
      UPDATE parts
         SET name = name || name
       WHERE name LIKE l_filters (indx);

   ROLLBACK;
EXCEPTION
   WHEN bulk_errors
   THEN
      DBMS_OUTPUT.put_line ('--------------------------------------');
      DBMS_OUTPUT.put_line ('Error information with SAVE_EXCEPTIONS');
      DBMS_OUTPUT.put_line ('--------------------------------------');
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
      DBMS_OUTPUT.put_line ('Updated ' || SQL%ROWCOUNT || ' rows.');

      DBMS_OUTPUT.put_line ('Error count: ' || SQL%BULK_EXCEPTIONS.COUNT);

      FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
      LOOP
         DBMS_OUTPUT.
          put_line (
               'Error '
            || indx
            || ' occurred on index '
            || SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX
            || ' attempting to update name to "'
            || l_filters (SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX)
            || '"');
         DBMS_OUTPUT.
          put_line (
            'Oracle error is '
            || SQLERRM (-1 * SQL%BULK_EXCEPTIONS (indx).ERROR_CODE));
      END LOOP;

      ROLLBACK;
END;
/

/* Now with LOG ERRORS */

BEGIN
   dbms_errlog_helper.create_objects ('PARTS');
END;
/

DECLARE
   TYPE filters_t IS TABLE OF parts.name%TYPE;

   l_filters   filters_t := filters_t ('G%', 'B%', 'L%');
   --
   l_errors    elp$_parts.error_log_tc := elp$_parts.error_log_tc ();
BEGIN
   FORALL indx IN 1 .. l_filters.COUNT
          /* SAVE EXCEPTIONS */
          UPDATE parts
             SET name = name || name
           WHERE name LIKE l_filters (indx)
      LOG ERRORS REJECT LIMIT UNLIMITED;

   DBMS_OUTPUT.put_line ('---------------------------------');
   DBMS_OUTPUT.put_line ('Error information with LOG ERRORS');
   DBMS_OUTPUT.put_line ('---------------------------------');

   /* How many rows were updated? */

   DBMS_OUTPUT.put_line ('Updated ' || SQL%ROWCOUNT || ' rows.');

   FOR indx IN 1 .. l_filters.COUNT
   LOOP
      DBMS_OUTPUT.
       put_line (
            'Rows updated for "'
         || l_filters (indx)
         || ': '
         || SQL%BULK_ROWCOUNT (indx));
   END LOOP;

   FOR rec IN (SELECT * FROM parts)
   LOOP
      DBMS_OUTPUT.put_line (rec.id || ' - ' || rec.name);
   END LOOP;

   l_errors := elp$_parts.error_log_contents;

   DBMS_OUTPUT.put_line ('Error count: ' || l_errors.COUNT);

   FOR indx IN 1 .. l_errors.COUNT
   LOOP
      DBMS_OUTPUT.put_line ('For part "' || l_errors (indx).name || '"...');
      DBMS_OUTPUT.put_line ('   ' || l_errors (indx).ora_err_mesg$);
   END LOOP;

   elp$_parts.clear_error_log;
   ROLLBACK;
END;
/