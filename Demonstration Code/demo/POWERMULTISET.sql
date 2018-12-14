CREATE OR REPLACE TYPE names_t IS TABLE OF VARCHAR2 (100)
/

CREATE OR REPLACE TYPE name_lists_t IS TABLE OF names_t
/

CREATE OR REPLACE PROCEDURE plch_print_pairs (
   names_in IN name_lists_t)
IS
   l_count   PLS_INTEGER;
BEGIN
   DBMS_OUTPUT.put_line ('Buddies:');

   FOR indx IN 1 .. names_in.COUNT
   LOOP
      l_count := names_in (indx).COUNT;

      IF l_count = 2
      THEN
         FOR indx2 IN 1 .. l_count
         LOOP
            IF indx2 = l_count
            THEN
               DBMS_OUTPUT.put_line (names_in (indx) (indx2));
            ELSE
               DBMS_OUTPUT.put (names_in (indx) (indx2) || ' & ');
            END IF;
         END LOOP;
      END IF;
   END LOOP;
END;
/

/* PLS-00201: identifier 'POWERMULTISET' must be declared */

DECLARE
   l_nt1   names_t := names_t ('Tomas', 'Terry', 'Tammy');
   l_nl1   name_lists_t;
BEGIN
   l_nl1 := POWERMULTISET (l_nt1);

   plch_print_pairs (l_nl1);
END;
/

/* ORA-00932: inconsistent datatypes: 
    expected HR.SYSTPgsgVxFPaTQW9edMI1e415w== got HR.NAME_LISTS_T */

DECLARE
   l_nt1   names_t := names_t ('Tomas', 'Terry', 'Tammy');
   l_nl1   name_lists_t;
BEGIN
   SELECT POWERMULTISET (l_nt1) INTO l_nl1 FROM DUAL;

   plch_print_pairs (l_nl1);
END;
/

DECLARE
   l_nt1   names_t := names_t ('Tomas', 'Terry', 'Tammy');
   l_nl1   name_lists_t;
BEGIN
   SELECT CAST (POWERMULTISET (l_nt1) AS name_lists_t) 
     INTO l_nl1 FROM DUAL;

   plch_print_pairs (l_nl1);
END;
/

DECLARE
   l_nt1   names_t := names_t ('Tomas', 'Terry', 'Tammy');
   l_nl1   name_lists_t := name_lists_t ();
BEGIN
   FOR indx IN 1 .. l_nt1.COUNT
   LOOP
      FOR indx2 IN 1 .. l_nt1.COUNT
      LOOP
         IF indx <> indx2
         THEN
            l_nl1.EXTEND;
            l_nl1 (l_nl1.LAST) := 
               names_t (l_nt1 (indx), l_nt1 (indx2));
         END IF;
      END LOOP;
   END LOOP;

   plch_print_pairs (l_nl1);
END;
/

/* Clean up */

DROP TYPE names_t FORCE
/

DROP PROCEDURE plch_print_pairs
/