DROP TABLE loc;
DROP TABLE department;
DROP TABLE job;
DROP TABLE employee;
DROP TABLE locemp;
DROP TABLE salhist;
DROP TABLE table_w_excessively_long_nm;

CREATE TABLE loc (
        loc_ID             NUMBER(3),
        REGIONAL_GROUP          VARCHAR2(20)
        ,created_by VARCHAR2(100) DEFAULT USER NOT NULL
        ,created_on DATE DEFAULT SYSDATE NOT NULL
        ,changed_by VARCHAR2(100) DEFAULT USER NOT NULL
        ,changed_on DATE DEFAULT SYSDATE NOT NULL        
        );


CREATE TABLE DEPARTMENT (
        DEPARTMENT_ID           NUMBER(2),
        NAME                    VARCHAR2(14),
        loc_ID             NUMBER(3)
        ,created_by VARCHAR2(100) DEFAULT USER NOT NULL
        ,created_on DATE DEFAULT SYSDATE NOT NULL
        ,changed_by VARCHAR2(100) DEFAULT USER NOT NULL
        ,changed_on DATE DEFAULT SYSDATE NOT NULL        
        );


CREATE TABLE JOB (
        JOB_ID                  NUMBER(3),
        FUNCTION                VARCHAR2(30)
        ,created_by VARCHAR2(100) DEFAULT USER NOT NULL
        ,created_on DATE DEFAULT SYSDATE NOT NULL
        ,changed_by VARCHAR2(100) DEFAULT USER NOT NULL
        ,changed_on DATE DEFAULT SYSDATE NOT NULL        
        );


CREATE TABLE EMPLOYEE (
        EMPLOYEE_ID             NUMBER(4),
        LAST_NAME               VARCHAR2(15),
        FIRST_NAME              VARCHAR2(15),
        MIDDLE_INITIAL          VARCHAR2(1),
        JOB_ID                  NUMBER(3),
        MANAGER_ID              NUMBER(4),
        HIRE_DATE               DATE DEFAULT SYSDATE NOT NULL,
        SALARY                  NUMBER(7,2),
        COMMISSION              NUMBER(7,2),
        DEPARTMENT_ID           NUMBER(2),
        empno INTEGER,
        ename VARCHAR2(30)
        ,created_by VARCHAR2(100) DEFAULT USER NOT NULL
        ,created_on DATE DEFAULT SYSDATE NOT NULL
        ,changed_by VARCHAR2(100) DEFAULT USER NOT NULL
        ,changed_on DATE DEFAULT SYSDATE NOT NULL        
        );
CREATE TABLE EMPLOYEE_history (
        EMPLOYEE_ID             NUMBER(4),
        HIRE_DATE               DATE DEFAULT SYSDATE NOT NULL,
        SALARY                  NUMBER(7,2)  ,
		activity varchar2(100)    
        );


/* Intersection table, no non-primary key columns. */
CREATE TABLE locemp (
        EMPLOYEE_ID             NUMBER(4),
        loc_ID             NUMBER(3)
        ,created_by VARCHAR2(100) DEFAULT USER NOT NULL
        ,created_on DATE DEFAULT SYSDATE NOT NULL
        ,changed_by VARCHAR2(100) DEFAULT USER NOT NULL
        ,changed_on DATE DEFAULT SYSDATE NOT NULL        
        );


CREATE TABLE salhist (
   employee_id NUMBER(4),
   raise_date DATE,
   salary NUMBER(7,2),
   comments VARCHAR2(2000)
        ,created_by VARCHAR2(100) DEFAULT USER NOT NULL
        ,created_on DATE DEFAULT SYSDATE NOT NULL
        ,changed_by VARCHAR2(100) DEFAULT USER NOT NULL
        ,changed_on DATE DEFAULT SYSDATE NOT NULL        
           );



/* Table with very long names. */
CREATE TABLE table_w_excessively_long_nm (
   first_column_with_very_long_nm INTEGER,
   sec_column_with_very_long_nm VARCHAR2(100)
        ,created_by VARCHAR2(100) DEFAULT USER NOT NULL
        ,created_on DATE DEFAULT SYSDATE NOT NULL
        ,changed_by VARCHAR2(100) DEFAULT USER NOT NULL
        ,changed_on DATE DEFAULT SYSDATE NOT NULL        
   );

REM Insert Data
INSERT INTO loc
     VALUES (122, 'NEW YORK', USER, SYSDATE, USER, SYSDATE);
INSERT INTO loc
     VALUES (124, 'DALLAS', USER, SYSDATE, USER, SYSDATE);
INSERT INTO loc
     VALUES (123, 'CHICAGO', USER, SYSDATE, USER, SYSDATE);
INSERT INTO loc
     VALUES (167, 'BOSTON', USER, SYSDATE, USER, SYSDATE);

INSERT INTO department
     VALUES (10, 'ACCOUNTING', '122', USER, SYSDATE, USER, SYSDATE);
INSERT INTO department
     VALUES (20, 'RESEARCH', '124', USER, SYSDATE, USER, SYSDATE);
INSERT INTO department
     VALUES (30, 'SALES', '123', USER, SYSDATE, USER, SYSDATE);
INSERT INTO department
     VALUES (40, 'OPERATIONS', '167', USER, SYSDATE, USER, SYSDATE);

INSERT INTO department
     VALUES (12, 'RESEARCH12', '122', USER, SYSDATE, USER, SYSDATE);

INSERT INTO department
     VALUES (13, 'SALES13', '122', USER, SYSDATE, USER, SYSDATE);

INSERT INTO department
     VALUES (14, 'OPERATIONS14', '122', USER, SYSDATE, USER, SYSDATE);

INSERT INTO department
     VALUES (23, 'SALES23', '124', USER, SYSDATE, USER, SYSDATE);

INSERT INTO department
     VALUES (24, 'OPERATIONS24', '124', USER, SYSDATE, USER, SYSDATE);

INSERT INTO department
     VALUES (34, 'OPERATIONS34', '123', USER, SYSDATE, USER, SYSDATE);

INSERT INTO department
     VALUES (43, 'SALES43', '167', USER, SYSDATE, USER, SYSDATE);

INSERT INTO job
     VALUES (667, 'CLERK', USER, SYSDATE, USER, SYSDATE);
INSERT INTO job
     VALUES (668, 'STAFF', USER, SYSDATE, USER, SYSDATE);
INSERT INTO job
     VALUES (669, 'ANALYST', USER, SYSDATE, USER, SYSDATE);
INSERT INTO job
     VALUES (670, 'SALESPERSON', USER, SYSDATE, USER, SYSDATE);
INSERT INTO job
     VALUES (671, 'MANAGER', USER, SYSDATE, USER, SYSDATE);
INSERT INTO job
     VALUES (672, 'PRESIDENT', USER, SYSDATE, USER, SYSDATE);

INSERT INTO employee
     VALUES (
        7369,
        'SMITH',
        'JOHN',
        'Q',
        667,
        7902,
        TO_DATE (
           2446052,
           'J'
        ),
        800,
        NULL,
        20,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7499,
        'ALLEN',
        'KEVIN',
        'J',
        670,
        7698,
        TO_DATE (
           2446117,
           'J'
        ),
        1600,
        300,
        30,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7505,
        'DOYLE',
        'JEAN',
        'K',
        671,
        7839,
        TO_DATE (
           2446160,
           'J'
        ),
        2850,
        NULL,
        13,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7506,
        'DENNIS',
        'LYNN',
        'S',
        671,
        7839,
        TO_DATE (
           2446201,
           'J'
        ),
        2750,
        NULL,
        23,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7507,
        'BAKER',
        'LESLIE',
        'D',
        671,
        7839,
        TO_DATE (
           2446227,
           'J'
        ),
        2200,
        NULL,
        14,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7521,
        'WARD',
        'CYNTHIA',
        'D',
        670,
        7698,
        TO_DATE (
           2446119,
           'J'
        ),
        1250,
        500,
        30,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7555,
        'PETERS',
        'DANIEL',
        'T',
        670,
        7505,
        TO_DATE (
           2446156,
           'J'
        ),
        1250,
        300,
        13,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7557,
        'SHAW',
        'KAREN',
        'P',
        670,
        7505,
        TO_DATE (
           2446158,
           'J'
        ),
        1250,
        1200,
        13,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7560,
        'DUNCAN',
        'SARAH',
        'S',
        670,
        7506,
        TO_DATE (
           2446217,
           'J'
        ),
        1250,
        NULL,
        23,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7564,
        'LANGE',
        'GREGORY',
        'J',
        670,
        7506,
        TO_DATE (
           2446218,
           'J'
        ),
        1250,
        300,
        23,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7566,
        'JONES',
        'TERRY',
        'M',
        671,
        7839,
        TO_DATE (
           2446158,
           'J'
        ),
        2975,
        NULL,
        20,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7569,
        'ALBERTS',
        'CHRIS',
        'L',
        671,
        7839,
        TO_DATE (
           2446162,
           'J'
        ),
        3000,
        NULL,
        12,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7600,
        'PORTER',
        'RAYMOND',
        'Y',
        670,
        7505,
        TO_DATE (
           2446171,
           'J'
        ),
        1250,
        900,
        13,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7609,
        'LEWIS',
        'RICHARD',
        'M',
        668,
        7507,
        TO_DATE (
           2446172,
           'J'
        ),
        1800,
        NULL,
        24,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7654,
        'MARTIN',
        'KENNETH',
        'J',
        670,
        7698,
        TO_DATE (
           2446337,
           'J'
        ),
        1250,
        1400,
        30,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7676,
        'SOMMERS',
        'DENISE',
        'D',
        668,
        7507,
        TO_DATE (
           2446175,
           'J'
        ),
        1850,
        NULL,
        34,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7698,
        'BLAKE',
        'MARION',
        'S',
        671,
        7839,
        TO_DATE (
           2446187,
           'J'
        ),
        2850,
        NULL,
        30,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7782,
        'CLARK',
        'CAROL',
        'F',
        671,
        7839,
        TO_DATE (
           2446226,
           'J'
        ),
        2450,
        NULL,
        10,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7788,
        'SCOTT',
        'DONALD',
        'T',
        669,
        7566,
        TO_DATE (
           2446774,
           'J'
        ),
        3000,
        NULL,
        20,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7789,
        'WEST',
        'LIVIA',
        'N',
        670,
        7506,
        TO_DATE (
           2446160,
           'J'
        ),
        1500,
        1000,
        23,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7799,
        'FISHER',
        'MATTHEW',
        'G',
        669,
        7569,
        TO_DATE (
           2446777,
           'J'
        ),
        3000,
        NULL,
        12,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7820,
        'ROSS',
        'PAUL',
        'S',
        670,
        7505,
        TO_DATE (
           2446218,
           'J'
        ),
        1300,
        800,
        43,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7839,
        'KING',
        'FRANCIS',
        'A',
        672,
        NULL,
        TO_DATE (
           2446387,
           'J'
        ),
        5000,
        NULL,
        10,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7844,
        'TURNER',
        'MARY',
        'A',
        670,
        7698,
        TO_DATE (
           2446317,
           'J'
        ),
        1500,
        0,
        30,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7876,
        'ADAMS',
        'DIANE',
        'G',
        667,
        7788,
        TO_DATE (
           2446808,
           'J'
        ),
        1100,
        NULL,
        20,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7900,
        'JAMES',
        'FRED',
        'S',
        667,
        7698,
        TO_DATE (
           2446403,
           'J'
        ),
        950,
        NULL,
        30,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7902,
        'FORD',
        'JENNIFER',
        'D',
        669,
        7566,
        TO_DATE (
           2446403,
           'J'
        ),
        3000,
        NULL,
        20,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7916,
        'ROBERTS',
        'GRACE',
        'M',
        669,
        7569,
        TO_DATE (
           2446800,
           'J'
        ),
        2875,
        NULL,
        12,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7919,
        'DOUGLAS',
        'MICHAEL',
        'A',
        667,
        7799,
        TO_DATE (
           2446800,
           'J'
        ),
        800,
        NULL,
        12,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7934,
        'MILLER',
        'BARBARA',
        'M',
        667,
        7782,
        TO_DATE (
           2446454,
           'J'
        ),
        1300,
        NULL,
        10,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7950,
        'JENSEN',
        'ALICE',
        'B',
        667,
        7505,
        TO_DATE (
           2446811,
           'J'
        ),
        750,
        NULL,
        13,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );
INSERT INTO employee
     VALUES (
        7954,
        'MURRAY',
        'JAMES',
        'T',
        667,
        7506,
        TO_DATE (
           2446812,
           'J'
        ),
        750,
        NULL,
        23,
        NULL,
        NULL,
        USER,
        SYSDATE,
        USER,
        SYSDATE
     );

INSERT INTO locemp
    SELECT DISTINCT employee_id, loc_id, USER, SYSDATE, USER, SYSDATE
      FROM employee, loc;

INSERT INTO salhist
    SELECT employee_id, hire_date, salary, NULL, USER, SYSDATE, USER, SYSDATE
      FROM employee;

INSERT INTO salhist
    SELECT employee_id,
           ADD_MONTHS (
              hire_date,
              DECODE (department_id / 10, 1, 6, 2, 12, 3, 18, 9)
           ),
           salary +
           LEAST (rownum * 1000, 2500),
           NULL,
           USER,
           SYSDATE,
           USER,
           SYSDATE
      FROM employee;


/* Primary keys */

ALTER TABLE DEPARTMENT ADD CONSTRAINT DEPT_PK
   PRIMARY KEY (DEPARTMENT_ID);

ALTER TABLE EMPLOYEE ADD CONSTRAINT EMP_PK
   PRIMARY KEY (EMPLOYEE_ID);

ALTER TABLE JOB ADD CONSTRAINT JOB_PK
   PRIMARY KEY (JOB_ID);

ALTER TABLE loc ADD PRIMARY KEY (loc_ID);

ALTER TABLE locemp ADD CONSTRAINT LOCEMP_PK
   PRIMARY KEY (EMPLOYEE_ID, LOC_ID);

ALTER TABLE salhist ADD CONSTRAINT SALHIST_PK
   PRIMARY KEY (EMPLOYEE_ID, RAISE_DATE);

ALTER TABLE table_w_excessively_long_nm ADD CONSTRAINT table_w_excessively_long_pk
   PRIMARY KEY (sec_column_with_very_long_nm);

CREATE SEQUENCE employee_id_seq;

CREATE SEQUENCE loc_id_seq;

CREATE SEQUENCE department_id_seq;

CREATE SEQUENCE seq$job;


CREATE UNIQUE INDEX i_regional_group on loc (regional_group);

CREATE UNIQUE INDEX i_department_name on department (name);

CREATE UNIQUE INDEX i_job_function on job (function);

CREATE UNIQUE INDEX i_employee_name on employee (last_name, first_name, middle_initial);

CREATE INDEX very_long_index_name_again ON table_w_excessively_long_nm (
   first_column_with_very_long_nm, sec_column_with_very_long_nm);
   
ALTER TABLE employee ADD (
   CONSTRAINT emp_dept_fk FOREIGN KEY( department_id ) REFERENCES department( department_id )
  ,CONSTRAINT emp_job_fk FOREIGN KEY( job_id ) REFERENCES job( job_id )
  ,CONSTRAINT emp_mgr_fk FOREIGN KEY( manager_id ) REFERENCES employee( employee_id )
  );
