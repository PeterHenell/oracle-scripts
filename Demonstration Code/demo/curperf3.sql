drop table employee2;
create table employee2 as select * from employee;
insert into employee2 select * from employee2;
insert into employee2 select * from employee2;
insert into employee2 select * from employee2;
insert into employee2 select * from employee2;
insert into employee2 select * from employee2;
insert into employee2 select * from employee2;
commit;

DECLARE
   v_count PLS_INTEGER;
   
   CURSOR query IS
      SELECT e.EMPLOYEE_ID            
             LAST_NAME         ,     
             FIRST_NAME        ,     
             MIDDLE_INITIAL    ,     
             JOB_ID            ,     
             MANAGER_ID        ,     
             HIRE_DATE         ,     
             e.SALARY            ,     
             COMMISSION        ,     
             DEPARTMENT_ID     ,
             RAISE_DATE        ,
             COMMENTS            
        FROM employee2 e, salhist;
   qrec query%ROWTYPE;
   
   PROCEDURE showcount (str IN VARCHAR2)
   IS
   BEGIN
      SELECT COUNT(*)            
        INTO v_count
        FROM employee2 e, salhist;
      p.l(str, v_count);
   END;
BEGIN
   showcount ('before delete');
   sf_timer.start_timer;
   OPEN query;
   sf_timer.show_elapsed_time ('Open query before delete then sleep 20 seconds');
   DBMS_LOCK.SLEEP (20);
   showcount ('delete occurred while sleeping');
   sf_timer.start_timer;
   FETCH query INTO qrec;
   sf_timer.show_elapsed_time ('Fetch first after delete');
   LOOP
      EXIT WHEN query%NOTFOUND;
      v_count := query%ROWCOUNT;
      FETCH query INTO qrec;
   END LOOP;
   p.l ('Fetched', v_count);
   CLOSE query;
   showcount ('cursor closed');
END;
/

/*
Results

before delete: 131072
Open query before delete then sleep 20 seconds Elapsed: .01 seconds.
delete occurred while sleeping: 131072
Fetch first after delete Elapsed: 0 seconds.
Fetched: 131072
cursor closed: 131072

*/