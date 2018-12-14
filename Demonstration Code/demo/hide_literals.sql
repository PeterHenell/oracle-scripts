DROP TABLE my_employees
/

CREATE TABLE my_employees
(
   employee_id            INTEGER
 ,  is_active              CHAR (1)
 ,  ineligible_for_bonus   CHAR (1)
 ,  missed_work            CHAR (1)
)
/

CREATE OR REPLACE VIEW lots_of_yes_no_v
AS
   SELECT employee_id
     FROM my_employees
    WHERE is_active = 'Y' AND ineligible_for_bonus = 'N' AND missed_work = 'N'
/

CREATE OR REPLACE PACKAGE app_config
IS
   /* YES value */
   c_yes   CONSTANT CHAR (1) := 'Y';

   /* NO value */
   c_no    CONSTANT CHAR (1) := 'N';
END app_config;
/

CREATE OR REPLACE PROCEDURE check_employee (emp_in IN my_employees%ROWTYPE)
IS
BEGIN
   IF     emp_in.is_active = app_config.c_yes
      AND emp_in.ineligible_for_bonus = app_config.c_no
      AND emp_in.missed_work = app_config.c_no
   THEN
      DBMS_OUTPUT.put_line ('Check!');
   END IF;
END;
/

/* This will not work */

CREATE OR REPLACE VIEW lots_of_yes_no_v
AS
   SELECT employee_id
     FROM my_employees
    WHERE     is_active = app_config.c_yes
          AND ineligible_for_bonus = app_config.c_no
          AND missed_work = app_config.c_no
/

CREATE OR REPLACE PACKAGE app_config
IS
   /* YES value */
   FUNCTION yes_value
      RETURN VARCHAR2;

   /* NO value */
   FUNCTION no_value
      RETURN VARCHAR2;
END app_config;
/

CREATE OR REPLACE PACKAGE BODY app_config
IS
   /* YES value */
   FUNCTION yes_value
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN 'Y';
   END;

   /* NO value */
   FUNCTION no_value
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN 'N';
   END;
END app_config;
/

/* This works, but could be a problem from the
   standpoint of performance */

CREATE OR REPLACE VIEW lots_of_yes_no_v
AS
   SELECT employee_id
     FROM my_employees
    WHERE     is_active = app_config.yes_value
          AND ineligible_for_bonus = app_config.no_value
          AND missed_work = app_config.no_value
/

/* And now application contexts */

CREATE OR REPLACE PACKAGE app_context_pkg
IS
   PROCEDURE set_config_values;
END;
/

CREATE OR REPLACE PACKAGE BODY app_context_pkg
IS
   PROCEDURE set_config_values
   IS
   BEGIN
      DBMS_SESSION.set_context ('app_config_ctx', 'yes', 'Y');
      DBMS_SESSION.set_context ('app_config_ctx', 'no', 'N');
   END;
END;
/

CREATE CONTEXT app_config_ctx USING app_context_pkg;
/

CREATE OR REPLACE VIEW lots_of_yes_no_v
AS
   SELECT employee_id
     FROM my_employees
    WHERE     is_active = SYS_CONTEXT ('app_config_ctx', 'yes')
          AND ineligible_for_bonus = SYS_CONTEXT ('app_config_ctx', 'no')
          AND missed_work = SYS_CONTEXT ('app_config_ctx', 'no')
/