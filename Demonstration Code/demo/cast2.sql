/* Formatted on 2002/02/11 08:04 (Formatter Plus v4.6.0) */
SELECT employee_id, cast (hire_date AS  VARCHAR2 (30))
  FROM employee;

DECLARE
   hd_display   VARCHAR2 (30);
BEGIN
   hd_display := CAST (SYSDATE AS  VARCHAR2);
END;
