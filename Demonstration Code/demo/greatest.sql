/* No special handling for NULL, no good */

CREATE OR REPLACE PROCEDURE plch_show_biggest (
   NAME_IN              IN VARCHAR2,
   current_salary_in    IN NUMBER,
   proposed_salary_in   IN NUMBER,
   average_salary_in    IN NUMBER)
IS
BEGIN
   DBMS_OUTPUT.put_line (
         NAME_IN
      || '-'
      || GREATEST (current_salary_in,
                   proposed_salary_in,
                   average_salary_in));
END;
/

BEGIN
   plch_show_biggest ('Steven',
                      1000,
                      2000,
                      3000);
   plch_show_biggest ('Sam',
                      1000,
                      NULL,
                      3000);
END;
/


/* Use MAX */

CREATE OR REPLACE PROCEDURE plch_show_biggest (
   NAME_IN              IN VARCHAR2,
   current_salary_in    IN NUMBER,
   proposed_salary_in   IN NUMBER,
   average_salary_in    IN NUMBER)
IS
BEGIN
   DBMS_OUTPUT.put_line (
         NAME_IN
      || '-'
      || MAX (current_salary_in,
              proposed_salary_in,
              average_salary_in));
END;
/

BEGIN
   plch_show_biggest ('Steven',
                      1000,
                      2000,
                      3000);
   plch_show_biggest ('Sam',
                      1000,
                      NULL,
                      1500);
END;
/

/* Use NVL to make sure a value is returned */

CREATE OR REPLACE PROCEDURE plch_show_biggest (
   NAME_IN              IN VARCHAR2,
   current_salary_in    IN NUMBER,
   proposed_salary_in   IN NUMBER,
   average_salary_in    IN NUMBER)
IS
BEGIN
   DBMS_OUTPUT.put_line (
         NAME_IN
      || '-'
      || GREATEST (NVL (current_salary_in, -1),
                   NVL (proposed_salary_in, -1),
                   NVL (average_salary_in, -1)));
END;
/

BEGIN
   plch_show_biggest ('Steven',
                      1000,
                      2000,
                      3000);
   plch_show_biggest ('Sam',
                      1000,
                      NULL,
                      1500);
END;
/

/* Force not null values? No, that is not supported. */

CREATE OR REPLACE PROCEDURE plch_show_biggest (
   NAME_IN             IN VARCHAR2,
   current_salary_in   IN NUMBER NOT NULL,
   proposed_salary_in   IN NUMBER NOT NULL,
   average_salary_in    IN NUMBER NOT NULL)
IS
BEGIN
   DBMS_OUTPUT.put_line (
         NAME_IN
      || '-'
      || GREATEST (current_salary_in,
                   proposed_salary_in,
                   average_salary_in));
END;
/

BEGIN
   plch_show_biggest ('Steven',
                      1000,
                      2000,
                      3000);
   plch_show_biggest ('Sam',
                      1000,
                      NULL,
                      1500);
END;
/

/* Don't use greatest at all.... */

CREATE OR REPLACE PROCEDURE plch_show_biggest (
   NAME_IN              IN VARCHAR2,
   current_salary_in    IN NUMBER,
   proposed_salary_in   IN NUMBER,
   average_salary_in    IN NUMBER)
IS
   l_biggest   NUMBER := NVL (current_salary, -1);
BEGIN
   IF l_biggest < proposed_salary_in
   THEN
      l_biggest := proposed_salary_in;
   END IF;

   IF l_biggest < average_salary_in
   THEN
      l_biggest := average_salary_in;
   END IF;

   DBMS_OUTPUT.put_line (NAME_IN || '-'|| l_biggest);
END;
/

BEGIN
   plch_show_biggest ('Steven',
                      1000,
                      2000,
                      3000);
   plch_show_biggest ('Sam',
                      1000,
                      NULL,
                      1500);
END;
/

/* clean up */

DROP PROCEDURE plch_show_biggest
/