drop table employee2;
create table employee2 as select * from employee;
insert into employee2 select * from employee2;
insert into employee2 select * from employee2;
insert into employee2 select * from employee2;
insert into employee2 select * from employee2;
insert into employee2 select * from employee2;
insert into employee2 select * from employee2;
insert into employee2 select * from employee2;
commit;

DECLARE
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
   
   CURSOR fuo IS
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
        FROM employee2 e, salhist
        FOR UPDATE;
   frec fuo%ROWTYPE;
BEGIN
   sf_timer.start_timer;
   OPEN query;
   sf_timer.show_elapsed_time ('Open query');
   sf_timer.start_timer;
   FETCH query INTO qrec;
   sf_timer.show_elapsed_time ('Fetch first');
   CLOSE query;
   
   sf_timer.start_timer;
   OPEN fuo;
   sf_timer.show_elapsed_time ('Open query FUO');
   sf_timer.start_timer;
   FETCH fuo INTO frec;
   sf_timer.show_elapsed_time ('Fetch first FUO');
   CLOSE fuo;
END;
/

/*
Results:

Open query Elapsed: 0 seconds.
Fetch first Elapsed: .11 seconds.
Open query FUO Elapsed: 14.31 seconds.
Fetch first FUO Elapsed: .02 seconds.

*/
