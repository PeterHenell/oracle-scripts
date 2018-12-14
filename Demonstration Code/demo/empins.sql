create table emp(
    empno      number(4) not null,
    ename      varchar2(10),
    job        varchar2(9),
    mgr        number(4),
    hiredate   date,
    sal        number(7,2),
    comm       number(7,2),
    deptno     number(2))
/

delete from emp;

insert into emp values
	(7369,'SMITH','CLERK',7902,TO_DATE('12-17-80','MM-DD-YY'),
         800,NULL,20)
/
insert into emp values
	(7499,'ALLEN','SALESMAN',7698,TO_DATE('02-20-81','MM-DD-YY'),
         1600,300,30)
/
insert into emp values
	(7521,'WARD','SALESMAN',7698,TO_DATE('02-22-81','MM-DD-YY'),
         1250,500,30)
/
insert into emp values
	(7566,'JONES','MANAGER',7839,TO_DATE('04-02-81','MM-DD-YY'),
         2975,NULL,20)
/
insert into emp values
	(7654,'MARTIN','SALESMAN',7698,TO_DATE('09-28-81','MM-DD-YY'),
         1250,1400,30)
/
insert into emp values
	(7698,'BLAKE','MANAGER',7839,TO_DATE('05-1-81','MM-DD-YY'),
         2850,NULL,30)
/
insert into emp values
	(7782,'CLARK','MANAGER',7839,TO_DATE('06-9-81','MM-DD-YY'),
         2450,NULL,10)
/
insert into emp values
	(7788,'SCOTT','ANALYST',7566,SYSDATE-85,3000,NULL,20)
/
insert into emp values
	(7839,'KING','PRESIDENT',NULL,TO_DATE('11-17-81','MM-DD-YY'),
         5000,NULL,10)
/
insert into emp values
	(7844,'TURNER','SALESMAN',7698,TO_DATE('09-8-81','MM-DD-YY'),
         1500,0,30)
/
insert into emp values
	(7876,'ADAMS','CLERK',7788,SYSDATE-51,1100,NULL,20)
/
insert into emp values
	(7900,'JAMES','CLERK',7698,TO_DATE('12-3-81','MM-DD-YY'),
         950,NULL,30)
/
insert into emp values
	(7902,'FORD','ANALYST',7566,TO_DATE('12-3-81','MM-DD-YY'),
         3000,NULL,20)
/
insert into emp values
	(7934,'MILLER','CLERK',7782,TO_DATE('01-23-82','MM-DD-YY'),
         1300,NULL,10)
/
