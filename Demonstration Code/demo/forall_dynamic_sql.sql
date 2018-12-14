CREATE OR REPLACE TYPE numlist IS TABLE OF NUMBER
/

CREATE OR REPLACE TYPE namelist IS TABLE OF VARCHAR2 (15)
/

CREATE OR REPLACE PROCEDURE update_emps (col_in      IN VARCHAR2
                                       , empnos_in   IN numlist)
IS
   enames   namelist;
BEGIN
   FORALL indx IN empnos_in.FIRST .. empnos_in.LAST
      EXECUTE IMMEDIATE
            'UPDATE employees SET '
         || col_in
         || ' = '
         || col_in
         || ' * 1.1 WHERE employee_id = :1
         RETURNING last_name INTO :2'
         USING empnos_in (indx)
         RETURNING BULK COLLECT INTO enames;

   FOR indx IN 1 .. enames.COUNT
   LOOP
      DBMS_OUTPUT.put_line ('10% raise to ' || enames (indx));
   END LOOP;
END;
/

DECLARE
   l_ids   numlist := numlist (138, 147);
BEGIN
   update_emps ('salary', l_ids);
END;
/