/* Avoid redundant use of formulas */

CREATE OR REPLACE PROCEDURE plch_proc (
   d1_in               IN DATE,
   d2_in               IN DATE,
   reference_date_in   IN DATE)
IS
BEGIN
   DBMS_OUTPUT.put_line (
      TO_CHAR (
         d1_in,
         CASE
            WHEN d1_in > reference_date_in THEN 'YYYY-MM'
            ELSE 'YYYY-MM-DD'
         END));

   DBMS_OUTPUT.put_line (
      TO_CHAR (
         d2_in,
         CASE
            WHEN d2_in > reference_date_in THEN 'YYYY-MM'
            ELSE 'YYYY-MM-DD'
         END));
END;
/

BEGIN
   plch_proc (DATE '2013-01-01',
              DATE '2013-10-01',
              DATE '2013-05-01');
END;
/

/* Nested subprograms */

/* Bad refactoring */

CREATE OR REPLACE PROCEDURE plch_proc (
   d1_in               IN DATE,
   d2_in               IN DATE,
   reference_date_in   IN DATE)
IS
   FUNCTION the_mask (date_in IN DATE)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN CASE
                WHEN d1_in > reference_date_in THEN 'YYYY-MM'
                ELSE 'YYYY-MM-DD'
             END;
   END;
BEGIN
   DBMS_OUTPUT.put_line (TO_CHAR (d1_in, the_mask (d1_in)));
   DBMS_OUTPUT.put_line (TO_CHAR (d2_in, the_mask (d2_in)));
END;
/

BEGIN
   plch_proc (DATE '2013-01-01',
              DATE '2013-10-01',
              DATE '2013-05-01');
END;
/

/* Good refactoring */

CREATE OR REPLACE PROCEDURE plch_proc (
   d1_in               IN DATE,
   d2_in               IN DATE,
   reference_date_in   IN DATE)
IS
   FUNCTION the_mask (date_in IN DATE)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN CASE
                WHEN date_in > reference_date_in THEN 'YYYY-MM'
                ELSE 'YYYY-MM-DD'
             END;
   END;
BEGIN
   DBMS_OUTPUT.put_line (TO_CHAR (d1_in, the_mask (d1_in)));
   DBMS_OUTPUT.put_line (TO_CHAR (d2_in, the_mask (d2_in)));
END;
/

BEGIN
   plch_proc (DATE '2013-01-01',
              DATE '2013-10-01',
              DATE '2013-05-01');
END;
/

/* External function, first without pushing reference date to parm list */

CREATE OR REPLACE FUNCTION the_mask (date_in IN DATE)
   RETURN VARCHAR2
IS
BEGIN
   RETURN CASE
             WHEN date_in > reference_date_in THEN 'YYYY-MM'
             ELSE 'YYYY-MM-DD'
          END;
END;
/

CREATE OR REPLACE PROCEDURE plch_proc (
   d1_in               IN DATE,
   d2_in               IN DATE,
   reference_date_in   IN DATE)
IS
BEGIN
   DBMS_OUTPUT.put_line (TO_CHAR (d1_in, the_mask (d1_in)));
   DBMS_OUTPUT.put_line (TO_CHAR (d2_in, the_mask (d2_in)));
END;
/

BEGIN
   plch_proc (DATE '2013-01-01',
              DATE '2013-10-01',
              DATE '2013-05-01');
END;
/

/* External function, complete refactoring */

CREATE OR REPLACE FUNCTION the_mask (
   date_in             IN DATE,
   reference_date_in   IN DATE)
   RETURN VARCHAR2
IS
BEGIN
   RETURN CASE
             WHEN date_in > reference_date_in THEN 'YYYY-MM'
             ELSE 'YYYY-MM-DD'
          END;
END;
/

CREATE OR REPLACE PROCEDURE plch_proc (
   d1_in               IN DATE,
   d2_in               IN DATE,
   reference_date_in   IN DATE)
IS
BEGIN
   DBMS_OUTPUT.put_line (
      TO_CHAR (d1_in, the_mask (d1_in, reference_date_in)));
   DBMS_OUTPUT.put_line (
      TO_CHAR (d2_in, the_mask (d2_in, reference_date_in)));
END;
/


BEGIN
   plch_proc (DATE '2013-01-01',
              DATE '2013-10-01',
              DATE '2013-05-01');
END;
/