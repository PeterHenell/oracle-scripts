CREATE OR REPLACE FUNCTION most_reports_before_manager (
   report_hire_dates_cur   IN   sys_refcursor,
   manager_hire_date       IN   DATE
)
-- Example provided by Bryn Llewellyn of Oracle Corporation
   RETURN NUMBER
IS
   TYPE report_hire_date_t IS TABLE OF employees.hire_date%TYPE
      INDEX BY BINARY_INTEGER;

   report_hire_dates   report_hire_date_t;
   before              INTEGER            := 0;
   after               INTEGER            := 0;
BEGIN
   FETCH report_hire_dates_cur BULK COLLECT INTO report_hire_dates;

   IF report_hire_dates.COUNT > 0
   THEN
      FOR j IN report_hire_dates.FIRST .. report_hire_dates.LAST
      LOOP
	     -- Gratuitous CASE expression!
         CASE report_hire_dates(j) < manager_hire_date
            WHEN TRUE THEN before:=before+1;
            ELSE after:=after+1;
         END CASE;
      END LOOP;
   END IF;

   IF before > after
   THEN RETURN 1;
   ELSE RETURN 0;
   END IF;

END most_reports_before_manager;
/

CREATE OR REPLACE VIEW young_managers AS
  SELECT managers.employee_id manager_employee_id
    FROM employees managers
    WHERE Most_Reports_Before_Manager
      (
        CURSOR ( SELECT reports.hire_date FROM employees reports
                   WHERE reports.manager_id = managers.employee_id
               ),
        managers.hire_date
      ) = 1;

