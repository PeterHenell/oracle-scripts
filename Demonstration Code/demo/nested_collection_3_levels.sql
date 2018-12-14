CREATE OR REPLACE PACKAGE plch_pkg
IS
   PROCEDURE plch1 (string1_in    IN VARCHAR2
                  , date1_in      IN DATE
                  , boolean1_in   IN BOOLEAN);

   PROCEDURE plch1 (string2_in IN VARCHAR2, boolean2_in IN BOOLEAN);

   PROCEDURE plch1 (date3_in IN DATE);
END;
/

/* Match declarations with usages... */

DECLARE
   /*DECLARATIONS*/
BEGIN
   FOR rec IN (  SELECT *
                   FROM user_arguments
                  WHERE package_name = 'PLCH_PKG'
               ORDER BY object_name, overload, sequence)
   LOOP
      /*ASSIGNMENT*/
      NULL;
   END LOOP;

   /*DISPLAY*/
END;
/

/* Three level nested, correct assignment, etc. */

DECLARE
   TYPE arguments_t IS TABLE OF user_arguments%ROWTYPE
                          INDEX BY PLS_INTEGER;

   TYPE overloadings_t IS TABLE OF arguments_t
                             INDEX BY PLS_INTEGER;

   TYPE programs_t IS TABLE OF overloadings_t
                         INDEX BY user_arguments.object_name%TYPE;

   l_programs   programs_t;
   l_program    VARCHAR2 (100);
BEGIN
   sys.DBMS_OUTPUT.put_line ('Normalized');

   FOR rec IN (  SELECT *
                   FROM user_arguments
                  WHERE package_name = 'PLCH_PKG'
               ORDER BY object_name, overload, sequence)
   LOOP
      l_programs (rec.object_name) (rec.overload) (rec.sequence) := rec;
   END LOOP;

   sys.DBMS_OUTPUT.put_line (l_programs.FIRST);
   sys.DBMS_OUTPUT.put_line (l_programs ('PLCH1') (1).COUNT);
   sys.DBMS_OUTPUT.put_line (l_programs ('PLCH1') (2) (2).argument_name);
END;
/

/* One level nesting, brute force. */

DECLARE
   TYPE arguments_t IS TABLE OF user_arguments%ROWTYPE
                          INDEX BY PLS_INTEGER;

   l_arguments   arguments_t;
   l_counter     PLS_INTEGER := 0;
BEGIN
   sys.DBMS_OUTPUT.put_line ('Brute Force');

   FOR rec IN (  SELECT *
                   FROM user_arguments
                  WHERE package_name = 'PLCH_PKG'
               ORDER BY object_name, overload, sequence)
   LOOP
      l_arguments (l_arguments.COUNT + 1) := rec;
   END LOOP;

   sys.DBMS_OUTPUT.put_line (l_arguments (1).object_name);

   FOR indx IN 1 .. l_arguments.COUNT
   LOOP
      IF l_arguments (indx).overload = 1
      THEN
         l_counter := l_counter + 1;
      END IF;
   END LOOP;

   sys.DBMS_OUTPUT.put_line (l_counter);

   FOR indx IN 1 .. l_arguments.COUNT
   LOOP
      IF l_arguments (indx).overload = 2 AND l_arguments (indx).sequence = 2
      THEN
         sys.DBMS_OUTPUT.put_line (l_arguments (indx).argument_name);
         EXIT;
      END IF;
   END LOOP;
END;
/

/* Three level nested, wrong order in assignment, etc. */

DECLARE
   TYPE arguments_t IS TABLE OF user_arguments%ROWTYPE
                          INDEX BY PLS_INTEGER;

   TYPE overloadings_t IS TABLE OF arguments_t
                             INDEX BY PLS_INTEGER;

   TYPE programs_t IS TABLE OF overloadings_t
                         INDEX BY user_arguments.object_name%TYPE;

   l_programs   programs_t;
   l_program    VARCHAR2 (100);
BEGIN
   sys.DBMS_OUTPUT.put_line ('Normalized');

   FOR rec IN (  SELECT *
                   FROM user_arguments
                  WHERE package_name = 'PLCH_PKG'
               ORDER BY object_name, overload, sequence)
   LOOP
      l_programs (rec.sequence) (rec.overload) (rec.object_name) := rec;
   END LOOP;

   sys.DBMS_OUTPUT.put_line (l_programs.FIRST);
   sys.DBMS_OUTPUT.put_line (l_programs (1) ('PLCH1').COUNT);
   sys.DBMS_OUTPUT.put_line (l_programs (2) (2) ('PLCH1').argument_name);
END;
/

/* Three level nested, invalid index by types. */

DECLARE
   TYPE arguments_t IS TABLE OF user_arguments%ROWTYPE
                          INDEX BY user_arguments.sequence%TYPE;

   TYPE overloadings_t IS TABLE OF arguments_t
                             INDEX BY user_arguments.overload%TYPE;

   TYPE programs_t IS TABLE OF overloadings_t
                         INDEX BY user_arguments.object_name%TYPE;

   l_programs   programs_t;
   l_program    VARCHAR2 (100);
BEGIN
   sys.DBMS_OUTPUT.put_line ('Cannot use %TYPE with Integer Index');

   FOR rec IN (  SELECT *
                   FROM user_arguments
                  WHERE package_name = 'PLCH_PKG'
               ORDER BY object_name, overload, sequence)
   LOOP
      l_programs (rec.object_name) (rec.overload) (rec.sequence) := rec;
   END LOOP;

   sys.DBMS_OUTPUT.put_line (l_programs.FIRST);
   sys.DBMS_OUTPUT.put_line (l_programs ('PLCH1') (1).COUNT);
   sys.DBMS_OUTPUT.put_line (l_programs ('PLCH1') (2) (2).argument_name);
END;
/

/* Full loop through nested collections */

DECLARE
   TYPE arguments_t IS TABLE OF user_arguments%ROWTYPE
                          INDEX BY PLS_INTEGER;

   TYPE overloadings_t IS TABLE OF arguments_t
                             INDEX BY PLS_INTEGER;

   TYPE programs_t IS TABLE OF overloadings_t
                         INDEX BY user_arguments.object_name%TYPE;

   l_programs   programs_t;
   l_program    VARCHAR2 (100);
BEGIN
   FOR rec IN (  SELECT *
                   FROM user_arguments
                  WHERE package_name = 'PLCH_PKG'
               ORDER BY object_name, overload, sequence)
   LOOP
      l_programs (rec.object_name) (rec.overload) (rec.sequence) := rec;
   END LOOP;

   l_program := l_programs.FIRST;

   LOOP
      EXIT WHEN l_program IS NULL;
      sys.DBMS_OUTPUT.put_line ('Subprogram: ' || l_program);

      FOR indx IN l_programs (l_program).FIRST .. l_programs (l_program).LAST
      LOOP
         sys.DBMS_OUTPUT.put_line ('Overloading: ' || indx);

         FOR parm_indx IN l_programs (l_program) (indx).FIRST ..
                          l_programs (l_program) (indx).LAST
         LOOP
            sys.DBMS_OUTPUT.put_line (
               l_programs (l_program) (indx) (parm_indx).argument_name);
         END LOOP;
      END LOOP;

      l_program := l_programs.NEXT (l_program);
   END LOOP;
END;
/