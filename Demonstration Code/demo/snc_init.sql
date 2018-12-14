CONNECT SYSTEM/SYSTEM;

DROP USER u1 CASCADE;

CREATE USER u1 IDENTIFIED BY u1;

GRANT RESOURCE, CONNECT TO u1;

GRANT CREATE PUBLIC SYNONYM, DROP PUBLIC SYNONYM TO u1;
GRANT SELECT ON SCOTT.EMP to u1;
GRANT SELECT ON SCOTT.DEPT TO u1;

connect u1/u1;

CREATE TABLE u1.emp
AS SELECT * FROM scott.emp;

CREATE TABLE u1.dept
AS SELECT * FROM scott.dept;

ALTER TABLE u1.dept
ADD
( CONSTRAINT pk_dept PRIMARY KEY( deptno ) );

ALTER TABLE u1.emp
ADD
( CONSTRAINT pk_emp PRIMARY KEY( empno ),
  CONSTRAINT fk_deptno FOREIGN KEY( deptno ) REFERENCES u1.dept( deptno )
);

CREATE OR REPLACE VIEW u1.vemp( department, empqty )
AS
SELECT d.dname, COUNT( e.empno )
FROM u1.dept d, emp e
WHERE d.deptno = e.deptno
GROUP BY d.dname;

CREATE OR REPLACE PACKAGE u1.pack1 
IS
  FUNCTION FMult( a NUMBER, b NUMBER ) RETURN NUMBER;
  procedure PMult( a NUMBER, b NUMBER );

END pack1;
/

CREATE OR REPLACE PACKAGE BODY u1.pack1 
IS
  PROCEDURE PMult( a NUMBER, b NUMBER )
  IS
    res NUMBER;
  BEGIN
       res := a * b;
       DBMS_OUTPUT.PUT_LINE( 'PMult:  ' || a || '*' || b || '=' || res );
  END;
  FUNCTION FMult( a NUMBER, b NUMBER ) RETURN NUMBER
  IS
    retval NUMBER;
  BEGIN
    retval := a * b;
    return(retval);
  END;
END pack1;
/

CREATE OR REPLACE FUNCTION u1.FSum(a NUMBER, b NUMBER) RETURN NUMBER 
IS
  Result NUMBER;
BEGIN
  Result := a + b;
  RETURN(Result);
END FSum;
/

CREATE OR REPLACE PROCEDURE u1.PSum( a NUMBER, b NUMBER ) 
IS
  res NUMBER;
BEGIN
  res := a + b;
  DBMS_OUTPUT.PUT_LINE( 'PSum:     ' || a || '+' || b || '=' || res );
END PSum;
/

CREATE OR REPLACE TYPE u1.Rect AS OBJECT
(
 -- The type has 3 attributes.
 length NUMBER,
 width NUMBER,
 area NUMBER,
 -- Define a constructor that has only 2 parameters.
 CONSTRUCTOR FUNCTION Rect(length NUMBER, width NUMBER)
 RETURN SELF AS RESULT
);
/

CREATE OR REPLACE TYPE BODY u1.Rect AS
       CONSTRUCTOR FUNCTION Rect(length NUMBER, width NUMBER)
       RETURN SELF AS RESULT
       AS
       BEGIN
            SELF.length := length;
            SELF.width := width;
            -- We compute the area rather than accepting it as a parameter.
            SELF.area := length * width;
            RETURN;
       END;
END;
/

-- synonyms

CREATE SYNONYM u1.ls_emp FOR u1.emp; 

CREATE SYNONYM u1.ls_dept FOR u1.dept; 

CREATE SYNONYM u1.ls_pack1 FOR u1.pack1;

CREATE SYNONYM u1.ls_PSum FOR u1.PSum;

CREATE SYNONYM u1.ls_FSum FOR u1.FSum;

CREATE SYNONYM u1.ls_Rect FOR u1.Rect;

-- PUBLIC synonyms

CREATE OR REPLACE PUBLIC SYNONYM gs_emp FOR u1.emp; 

CREATE OR REPLACE PUBLIC SYNONYM gs_dept FOR u1.dept; 

CREATE OR REPLACE PUBLIC SYNONYM gs_pack1 FOR u1.pack1;

CREATE OR REPLACE PUBLIC SYNONYM gs_PSum FOR u1.PSum;

CREATE OR REPLACE PUBLIC SYNONYM gs_FSum FOR u1.FSum;

CREATE OR REPLACE PUBLIC SYNONYM gs_Rect FOR u1.Rect;

-- synonyms for synonyms

CREATE SYNONYM u1.ls_emp_ls_emp FOR u1.ls_emp; 

CREATE SYNONYM u1.ls_dept_ls_dept FOR u1.ls_dept; 

CREATE SYNONYM u1.ls_pack1_ls_pack1 FOR u1.ls_pack1;

CREATE SYNONYM u1.ls_PSum_ls_PSum FOR u1.ls_PSum;

CREATE SYNONYM u1.ls_FSum_ls_FSum FOR u1.ls_FSum;

CREATE SYNONYM u1.ls_Rect_ls_Rect FOR u1.ls_Rect;

-- PUBLIC synonyms for PUBLIC synonyms

CREATE OR REPLACE PUBLIC SYNONYM gs_gs_emp FOR gs_emp; 

CREATE OR REPLACE PUBLIC SYNONYM gs_gs_dept FOR gs_dept; 

CREATE OR REPLACE PUBLIC SYNONYM gs_gs_pack1 FOR gs_pack1;

CREATE OR REPLACE PUBLIC SYNONYM gs_gs_PSum FOR gs_PSum;

CREATE OR REPLACE PUBLIC SYNONYM gs_gs_FSum FOR gs_FSum;

CREATE OR REPLACE PUBLIC SYNONYM gs_gs_Rect FOR gs_Rect;

-- synonyms for PUBLIC synonyms

CREATE SYNONYM u1.ls_emp_gs_emp FOR gs_emp; 

CREATE SYNONYM u1.ls_dept_gs_dept FOR gs_dept; 

CREATE SYNONYM u1.ls_pack1_gs_pack1 FOR gs_pack1;

CREATE SYNONYM u1.ls_PSum_gs_PSum FOR gs_PSum;

CREATE SYNONYM u1.ls_FSum_gs_FSum FOR gs_FSum;

CREATE SYNONYM u1.ls_Rect_gs_Rect FOR gs_Rect;

-- PUBLIC synonyms for synonyms

CREATE OR REPLACE PUBLIC SYNONYM gs_emp_u1_ls_emp FOR u1.ls_emp; 

CREATE OR REPLACE PUBLIC SYNONYM gs_dept_u1_ls_dept FOR u1.ls_dept; 

CREATE OR REPLACE PUBLIC SYNONYM gs_pack1_u1_ls_pack1 FOR u1.ls_pack1;

CREATE OR REPLACE PUBLIC SYNONYM gs_PSum_u1_ls_PSum FOR u1.ls_PSum;

CREATE OR REPLACE PUBLIC SYNONYM gs_FSum_u1_ls_FSum FOR u1.ls_FSum;

CREATE OR REPLACE PUBLIC SYNONYM gs_Rect_u1_ls_Rect FOR u1.ls_Rect;

CREATE OR REPLACE PROCEDURE main1( objname VARCHAR2 )
IS
  ctext PLS_INTEGER;
  fnd BOOLEAN := FALSE;
BEGIN
     FOR ctext IN 0..8
     LOOP
         BEGIN
              snc( objname, ctext );
              DBMS_OUTPUT.PUT_LINE( objname || ' was resolved in context ' || ctext );
              DBMS_OUTPUT.PUT_LINE( '----------------------------------------' );
              fnd := TRUE;
         EXCEPTION
                  WHEN OTHERS THEN
                       NULL;
--                       DBMS_OUTPUT.PUT_LINE( 'Exception with object type : ' || i );

         END;
     END LOOP;
     IF NOT fnd THEN
        DBMS_OUTPUT.PUT_LINE( objname || ' was not resolved at all !!!' );
        DBMS_OUTPUT.PUT_LINE( '----------------------------------------' );
     END IF;
end;
/