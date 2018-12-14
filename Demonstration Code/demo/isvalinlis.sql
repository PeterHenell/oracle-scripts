CREATE TYPE string_list_nt IS TABLE OF VARCHAR2 (32767);
/

CREATE OR REPLACE FUNCTION value_is_in_list (list_in    IN string_list_nt,
                                             value_in   IN VARCHAR2)
   RETURN NUMBER
IS
   l_listcount     NUMBER;
   col_val         VARCHAR2 (80);
   exit_function   EXCEPTION;
BEGIN
   IF list_in.COUNT = 0
   THEN
      DBMS_OUTPUT.put_line ('List does not contain any values');
      RAISE exit_function;
   END IF;

   IF value_in IS NULL
   THEN
      DBMS_OUTPUT.put_line ('Value for matching must not be NULL.');
      RAISE exit_function;
   END IF;

   l_listcount := list_in.COUNT;

   FOR indx IN 1 .. l_listcount
   LOOP
      IF UPPER (list_in (indx)) = UPPER (value_in)
      THEN
         RETURN indx;
      END IF;
   END LOOP;

   RAISE exit_function;
EXCEPTION
   WHEN exit_function
   THEN
      RETURN 0;
END;
/

/* Reads right, but doesn't work. */

DECLARE
   l_values   string_list_nt := string_list_nt ('a', 'b', 'c');
BEGIN
   IF value_is_in_list (l_values, 'a')
   THEN
      DBMS_OUTPUT.put_line ('a is in the list!');
   END IF;
END;
/

/* This works but we stumble over it as we read. */

DECLARE
   l_values   string_list_nt := string_list_nt ('a', 'b', 'c');
BEGIN
   IF value_is_in_list (l_values, 'a') > 0
   THEN
      DBMS_OUTPUT.put_line ('a is in the list!');
   END IF;
END;
/

/* Better: offer an API with both */

CREATE OR REPLACE PACKAGE list_mgr
IS
   FUNCTION value_is_in_list (list_in    IN string_list_nt,
                              value_in   IN VARCHAR2)
      RETURN BOOLEAN;

   FUNCTION index_of_value_in_list (list_in    IN string_list_nt,
                                    value_in   IN VARCHAR2)
      RETURN PLS_INTEGER;
END;
/

CREATE OR REPLACE PACKAGE BODY list_mgr
IS
   FUNCTION value_is_in_list (list_in    IN string_list_nt,
                              value_in   IN VARCHAR2)
      RETURN BOOLEAN
   IS
      l_listcount     NUMBER;
      col_val         VARCHAR2 (80);
      exit_function   EXCEPTION;
   BEGIN
      IF list_in.COUNT = 0
      THEN
         DBMS_OUTPUT.put_line ('List does not contain any values');
         RAISE exit_function;
      END IF;

      IF value_in IS NULL
      THEN
         DBMS_OUTPUT.put_line ('Value for matching must not be NULL.');
         RAISE exit_function;
      END IF;

      l_listcount := list_in.COUNT;

      FOR indx IN 1 .. l_listcount
      LOOP
         IF UPPER (list_in (indx)) = UPPER (value_in)
         THEN
            RETURN TRUE;
         END IF;
      END LOOP;

      RAISE exit_function;
   EXCEPTION
      WHEN exit_function
      THEN
         RETURN FALSE;
   END;

   FUNCTION index_of_value_in_list (list_in    IN string_list_nt,
                                    value_in   IN VARCHAR2)
      RETURN PLS_INTEGER
   IS
      l_listcount     NUMBER;
      col_val         VARCHAR2 (80);
      exit_function   EXCEPTION;
   BEGIN
      IF list_in.COUNT = 0
      THEN
         DBMS_OUTPUT.put_line ('List does not contain any values');
         RAISE exit_function;
      END IF;

      IF value_in IS NULL
      THEN
         DBMS_OUTPUT.put_line ('Value for matching must not be NULL.');
         RAISE exit_function;
      END IF;

      l_listcount := list_in.COUNT;

      FOR indx IN 1 .. l_listcount
      LOOP
         IF UPPER (list_in (indx)) = UPPER (value_in)
         THEN
            RETURN indx;
         END IF;
      END LOOP;

      RAISE exit_function;
   EXCEPTION
      WHEN exit_function
      THEN
         RETURN 0;
   END;
END;
/

DECLARE
   l_values   string_list_nt := string_list_nt ('a', 'b', 'c');
BEGIN
   IF list_mgr.value_is_in_list (l_values, 'a')
   THEN
      DBMS_OUTPUT.put_line ('a is in the list!');
   END IF;

   IF list_mgr.index_of_value_is_list (l_values, 'a') > 0
   THEN
      DBMS_OUTPUT.put_line ('a is in the list!');
   END IF;
END;
/