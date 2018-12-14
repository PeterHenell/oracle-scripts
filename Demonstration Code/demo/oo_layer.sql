/*
Object Oriented  PL/SQL-Programming

A ROWTYPE is generated for each table to allow easy access to each 
entry of the table. This object oriented rowtype provides methods 
and constructors resembling the usual DML-operations.

Based on the famous SCOTT-schema we show how to build these oo-rowtypes 
and underline the strengths of OO - PL/SQL programming.

It takes just three steps to advance PL/SQL programming towards 
object orientation on a relational database model:

** Creating the Object Type TYPE_OBJECT as a root object for all 
derived type objects just like Java's class Object does.

** Introducing OO Rowtypes, derived from TYPE_OBJECT.

** Building a set of business object types (bo-types), describing 
   real world objects.

Andriy Terletskyy
Berenberg Bank
Neuer Jungfernstieg 20
20354 Hamburg

Telefon:     +49(0)40-35060209
Fax:    +49(0)40-35060398
E-Mail     andriy.terletskyy@berenbergbank.de
Internet:    www.berenbergbank.de

*/

CREATE OR REPLACE TYPE type_object AS OBJECT (
   -- Attributes
   object_type_name   VARCHAR2 (100)
 -- Member functions and procedures
   ,MEMBER PROCEDURE DBMS_OUTPUT
 , MEMBER FUNCTION to_string
      RETURN VARCHAR2
 , MEMBER FUNCTION compare (in_type1 type_object, in_type2 type_object)
      RETURN INTEGER
 , ORDER MEMBER FUNCTION compare2 (in_other type_object)
      RETURN INTEGER
)
NOT FINAL NOT INSTANTIABLE
/

CREATE OR REPLACE TYPE BODY type_object
IS
   MEMBER PROCEDURE DBMS_OUTPUT
   IS
      str   VARCHAR2 (32767) := SELF.to_string ();
      sub   VARCHAR2 (32767);
      len   PLS_INTEGER      := LENGTH (str);
      von   PLS_INTEGER      := 1;
      bis   PLS_INTEGER      := INSTR (str, CHR (10), von);
   BEGIN
      LOOP
         IF bis = 0
         THEN
            bis := len + 1;
         END IF;

         EXIT WHEN von > bis;
         sub := SUBSTR (str, von, bis - von);

         FOR j IN 0 .. (LENGTH (sub) / 255)
         LOOP
            SYS.DBMS_OUTPUT.put_line (SUBSTR (sub, j * 255 + 1, 255));
         END LOOP;

         von := bis + 1;
         bis := INSTR (str, CHR (10), von);
      END LOOP;
   END;
------------------------------------------
   MEMBER FUNCTION to_string
      RETURN VARCHAR2
   IS
      res            VARCHAR2 (32767);

      TYPE anytype_info IS RECORD (
         prec          PLS_INTEGER
       , scale         PLS_INTEGER
       , len           PLS_INTEGER
       , csid          PLS_INTEGER
       , csfrm         PLS_INTEGER
       , schema_name   VARCHAR2 (35)
       , type_name     VARCHAR2 (35)
       , VERSION       VARCHAR2 (10)
       , COUNT         PLS_INTEGER
      );

      TYPE attribute_info IS RECORD (
         pos             PLS_INTEGER
       , prec            PLS_INTEGER
       , scale           PLS_INTEGER
       , len             PLS_INTEGER
       , csid            PLS_INTEGER
       , csfrm           PLS_INTEGER
       , attr_elt_type   ANYTYPE
       , aname           VARCHAR2 (50)
      );

      t_info         anytype_info;
      o_info         anytype_info;
      t_att          attribute_info;
      v_anydata      SYS.ANYDATA;
      v_anytype      SYS.ANYTYPE;
      v_typecode     PLS_INTEGER;
      v_objcode      PLS_INTEGER;
      v_maxattsize   PLS_INTEGER      := 0;
      v_char         CHAR (4000);
      v_varchar      VARCHAR (4000);
      v_raw          RAW (4000);
      v_varchar2     VARCHAR2 (4000);
      v_number       NUMBER;
      v_date         DATE;
      v_object       type_object;
      v_value        VARCHAR2 (4000);
      v_clob         CLOB;
      v_blob         BLOB;
   BEGIN
      v_anydata := ANYDATA.convertobject (SELF);
      v_typecode := v_anydata.gettype (v_anytype);
      v_typecode :=
         v_anytype.getinfo (t_info.prec
                          , t_info.scale
                          , t_info.len
                          , t_info.csid
                          , t_info.csfrm
                          , t_info.schema_name
                          , t_info.type_name
                          , t_info.VERSION
                          , t_info.COUNT
                           );
      res := v_anydata.gettypename ();
      res := res || CHR (10) || '(' || CHR (10);

      -- max Attribute size übermitteln
      FOR pos IN 1 .. t_info.COUNT
      LOOP
         v_typecode :=
            v_anytype.getattreleminfo (pos
                                     , t_att.prec
                                     , t_att.scale
                                     , t_att.len
                                     , t_att.csid
                                     , t_att.csfrm
                                     , t_att.attr_elt_type
                                     , t_att.aname
                                      );
         v_maxattsize := GREATEST (v_maxattsize, LENGTH (t_att.aname));
      END LOOP;

      --sets the mode of access of the current data value to be an attribute at a time
      v_anydata.piecewise;

      -- Attribute Name übermitteln
      FOR pos IN 1 .. t_info.COUNT
      LOOP
         v_typecode :=
            v_anytype.getattreleminfo (pos
                                     , t_att.prec
                                     , t_att.scale
                                     , t_att.len
                                     , t_att.csid
                                     , t_att.csfrm
                                     , t_att.attr_elt_type
                                     , t_att.aname
                                      );

         BEGIN
            -- Attribute Value übermitteln
            CASE v_typecode
               WHEN DBMS_TYPES.typecode_varchar2
               THEN                                               -- 2archar2
                  IF v_anydata.getvarchar2 (v_varchar2) = DBMS_TYPES.success
                  THEN
                     v_value := v_varchar2;
                  END IF;
               WHEN DBMS_TYPES.typecode_char
               THEN                                                    -- Char
                  IF v_anydata.getchar (v_char) = DBMS_TYPES.success
                  THEN
                     v_value := RTRIM (v_char);
                  END IF;
               WHEN DBMS_TYPES.typecode_raw
               THEN                                                     -- Raw
                  IF v_anydata.getraw (v_raw) = DBMS_TYPES.success
                  THEN
                     v_value := v_raw;
                  END IF;
               WHEN DBMS_TYPES.typecode_varchar
               THEN                                                 -- Varchar
                  IF v_anydata.getvarchar (v_varchar) = DBMS_TYPES.success
                  THEN
                     v_value := v_varchar;
                  END IF;
               WHEN DBMS_TYPES.typecode_number
               THEN                                                  -- Number
                  IF v_anydata.getnumber (v_number) = DBMS_TYPES.success
                  THEN
                     v_value := TO_CHAR (v_number);
                  END IF;
               WHEN DBMS_TYPES.typecode_date
               THEN                                                    -- Date
                  IF v_anydata.getdate (v_date) = DBMS_TYPES.success
                  THEN
                     v_value := TO_CHAR (v_date, 'DD.MM.YYYY HH24:MI:SS');
                  END IF;
               WHEN DBMS_TYPES.typecode_object
               THEN                                                  -- Object
                  IF v_anydata.getobject (v_object) = DBMS_TYPES.success
                  THEN
                     v_value :=
                        REPLACE (v_object.to_string ()
                               , CHR (10)
                               , RPAD (CHR (10), v_maxattsize + 5)
                                );
                  END IF;
               WHEN DBMS_TYPES.typecode_clob
               THEN                                                    -- CLOB
                  IF v_anydata.getclob (v_clob) = DBMS_TYPES.success
                  THEN
                     v_value :=
                              '<CLOB> size = ' || DBMS_LOB.getlength (v_clob);
                  END IF;
               WHEN DBMS_TYPES.typecode_blob
               THEN                                                    -- BLOB
                  IF v_anydata.getblob (v_blob) = DBMS_TYPES.success
                  THEN
                     v_value :=
                              '<BLOB> size = ' || DBMS_LOB.getlength (v_blob);
                  END IF;
               WHEN DBMS_TYPES.typecode_table
               THEN                                                   -- TABLE
                  v_value := '<NESTED TABLE>';
               WHEN DBMS_TYPES.typecode_varray
               THEN                                                  -- VARRAY
                  v_value := '<VARRAY>';
               WHEN DBMS_TYPES.typecode_namedcollection
               THEN                                         -- NAMEDCOLLECTION
                  v_objcode :=
                     t_att.attr_elt_type.getinfo (o_info.prec
                                                , o_info.scale
                                                , o_info.len
                                                , o_info.csid
                                                , o_info.csfrm
                                                , o_info.schema_name
                                                , o_info.type_name
                                                , o_info.VERSION
                                                , o_info.COUNT
                                                 );
                  v_value :=
                        '< '
                     || o_info.schema_name
                     || '.'
                     || o_info.type_name
                     || ' > ';
               -- v_AnyData.GetCollection Engpass !!! Abstract Collection Interface mangelt
            ELSE                                                     -- others
                  v_value :=
                        '!!! UNBEKANNTE DATEN TYP !!! DBMS_TYPES.TYPECODE = '
                     || v_typecode;
            END CASE;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_value := ' ERROR:' || SQLERRM;
         END;

         IF LENGTH (   res
                    || '  '
                    || RPAD (t_att.aname, v_maxattsize)
                    || ' = '
                    || v_value
                    || CHR (10)
                   ) < 32700
         THEN
            res :=
                  res
               || '  '
               || RPAD (t_att.aname, v_maxattsize)
               || ' = '
               || v_value
               || CHR (10);
         ELSE
            res :=
                  res
               || CHR (10)
               || 'ERROR : Maximale Größe VARCHAR2(32767) erreicht.';
         END IF;
      END LOOP;

      res := res || ')';
      RETURN res;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 'ERROR : ' || SQLERRM;
   END;
------------------------------------------
   MEMBER FUNCTION compare (in_type1 type_object, in_type2 type_object)
      RETURN INTEGER
   IS
   BEGIN
      RETURN 1;                                     -- default immer ungleich
   END;
------------------------------------------
   ORDER MEMBER FUNCTION compare2 (in_other type_object)
      RETURN INTEGER
   IS
   BEGIN
      RETURN compare (SELF, in_other);
   END;
END;
/

CREATE OR REPLACE TYPE row_dept UNDER type_object (
   -- attributes
   deptno   NUMBER (2)
 , dname    VARCHAR2 (14)
 , loc      VARCHAR2 (13)
 -- constructors
   ,CONSTRUCTOR FUNCTION row_dept
      RETURN SELF AS RESULT
 , CONSTRUCTOR FUNCTION row_dept (
      in_deptno NUMBER
    , in_dname VARCHAR2
    , in_loc VARCHAR2
   )
      RETURN SELF AS RESULT
 , CONSTRUCTOR FUNCTION row_dept (in_deptno NUMBER)
      RETURN SELF AS RESULT
 -- member functions
   ,MEMBER FUNCTION row_exists (in_deptno NUMBER)
      RETURN BOOLEAN
 , OVERRIDING MEMBER FUNCTION compare (
      in_type1 type_object
    , in_type2 type_object
   )
      RETURN INTEGER
 -- member procedures
   ,MEMBER PROCEDURE row_insert
 , MEMBER PROCEDURE row_update
 , MEMBER PROCEDURE row_merge
 , MEMBER PROCEDURE row_save
 , MEMBER PROCEDURE row_delete
 , MEMBER PROCEDURE row_select (in_deptno NUMBER)
 , MEMBER PROCEDURE row_default
)
NOT FINAL
/

CREATE OR REPLACE TYPE BODY row_dept
IS
   -- constructors
   CONSTRUCTOR FUNCTION row_dept
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.object_type_name := 'ROW_DEPT';
      row_default ();
      RETURN;
   END;
---------------------------------------------------------------
   CONSTRUCTOR FUNCTION row_dept (
      in_deptno NUMBER
    , in_dname VARCHAR2
    , in_loc VARCHAR2
   )
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.object_type_name := 'ROW_DEPT';
      SELF.deptno := in_deptno;
      SELF.dname := in_dname;
      SELF.loc := in_loc;
      RETURN;
   END;
---------------------------------------------------------------
   CONSTRUCTOR FUNCTION row_dept (in_deptno NUMBER)
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.object_type_name := 'ROW_DEPT';
      row_select (in_deptno => in_deptno);
      RETURN;
   END;
---------------------------------------------------------------
   MEMBER FUNCTION row_exists (in_deptno NUMBER)
      RETURN BOOLEAN
   IS
      v_count   PLS_INTEGER;
   BEGIN
      SELECT COUNT (*)
        INTO v_count
        FROM scott.dept
       WHERE deptno = in_deptno;

      RETURN (v_count <> 0);
   END;
---------------------------------------------------------------
-- member functions
   OVERRIDING MEMBER FUNCTION compare (
      in_type1 type_object
    , in_type2 type_object
   )
      RETURN INTEGER
   IS
      type1   row_dept := TREAT (in_type1 AS row_dept);
      type2   row_dept := TREAT (in_type2 AS row_dept);
   BEGIN
      IF     type1.deptno = type2.deptno
         AND (   type1.dname = type2.dname
              OR (type1.dname IS NULL AND type2.dname IS NULL)
             )
         AND (   type1.loc = type2.loc
              OR (type1.loc IS NULL AND type2.loc IS NULL)
             )
      THEN
         RETURN 0;                                                   --gleich
      ELSE
         RETURN 1;                                                 --ungleich
      END IF;
   END;
---------------------------------------------------------------
-- member procedures
   MEMBER PROCEDURE row_insert
   IS
   BEGIN
      INSERT INTO scott.dept
                  (deptno, dname, loc
                  )
           VALUES (SELF.deptno, SELF.dname, SELF.loc
                  )
        RETURNING deptno, dname, loc
             INTO SELF.deptno, SELF.dname, SELF.loc;
   END;
---------------------------------------------------------------
   MEMBER PROCEDURE row_update
   IS
   BEGIN
      UPDATE    scott.dept
            SET dname = SELF.dname
              , loc = SELF.loc
          WHERE deptno = SELF.deptno
      RETURNING deptno, dname, loc
           INTO SELF.deptno, SELF.dname, SELF.loc;

      IF SQL%ROWCOUNT <> 1
      THEN
         RAISE NO_DATA_FOUND;
      END IF;
   END;
---------------------------------------------------------------
   MEMBER PROCEDURE row_merge
   IS
   BEGIN
      MERGE INTO scott.dept a
         USING (SELECT SELF.deptno AS deptno, SELF.dname AS dname
                     , SELF.loc AS loc
                  FROM DUAL) b
         ON (a.deptno = b.deptno)
         WHEN MATCHED THEN
            UPDATE
               SET dname = b.dname, loc = b.loc
         WHEN NOT MATCHED THEN
            INSERT (deptno, dname, loc)
            VALUES (b.deptno, b.dname, b.loc);
   END;
---------------------------------------------------------------
   MEMBER PROCEDURE row_save
   IS
   BEGIN
      IF row_exists (in_deptno => SELF.deptno)
      THEN
         row_update;
      ELSE
         row_insert;
      END IF;
   END;
---------------------------------------------------------------
   MEMBER PROCEDURE row_delete
   IS
   BEGIN
      DELETE FROM scott.dept
            WHERE deptno = SELF.deptno;

      IF SQL%ROWCOUNT <> 1
      THEN
         RAISE NO_DATA_FOUND;
      END IF;
   END;
---------------------------------------------------------------
   MEMBER PROCEDURE row_select (in_deptno NUMBER)
   IS
   BEGIN
      SELECT deptno, dname, loc
        INTO SELF.deptno, SELF.dname, SELF.loc
        FROM scott.dept
       WHERE deptno = in_deptno;
   END;
---------------------------------------------------------------
   MEMBER PROCEDURE row_default
   IS
   BEGIN
      NULL;
   END;
END;
/

CREATE OR REPLACE TYPE row_emp UNDER scott.type_object (
   -- attributes
   empno      NUMBER (4)
 , ename      VARCHAR2 (10)
 , job        VARCHAR2 (9)
 , mgr        NUMBER (4)
 , hiredate   DATE
 , sal        NUMBER (7, 2)
 , comm       NUMBER (7, 2)
 , deptno     NUMBER (2)
 -- constructors
   ,CONSTRUCTOR FUNCTION row_emp
      RETURN SELF AS RESULT
 , CONSTRUCTOR FUNCTION row_emp (
      in_empno NUMBER
    , in_ename VARCHAR2
    , in_job VARCHAR2
    , in_mgr NUMBER
    , in_hiredate DATE
    , in_sal NUMBER
    , in_comm NUMBER
    , in_deptno NUMBER
   )
      RETURN SELF AS RESULT
 , CONSTRUCTOR FUNCTION row_emp (in_empno NUMBER)
      RETURN SELF AS RESULT
 -- member functions
   ,MEMBER FUNCTION row_exists (in_empno NUMBER)
      RETURN BOOLEAN
 , OVERRIDING MEMBER FUNCTION compare (
      in_type1 type_object
    , in_type2 type_object
   )
      RETURN INTEGER
 -- member procedures
   ,MEMBER PROCEDURE row_insert
 , MEMBER PROCEDURE row_update
 , MEMBER PROCEDURE row_merge
 , MEMBER PROCEDURE row_save
 , MEMBER PROCEDURE row_delete
 , MEMBER PROCEDURE row_select (in_empno NUMBER)
 , MEMBER PROCEDURE row_default
)
NOT FINAL
/

CREATE OR REPLACE TYPE BODY row_emp
IS
   -- constructors
   CONSTRUCTOR FUNCTION row_emp
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.object_type_name := 'ROW_EMP';
      row_default ();
      RETURN;
   END;
---------------------------------------------------------------
   CONSTRUCTOR FUNCTION row_emp (
      in_empno NUMBER
    , in_ename VARCHAR2
    , in_job VARCHAR2
    , in_mgr NUMBER
    , in_hiredate DATE
    , in_sal NUMBER
    , in_comm NUMBER
    , in_deptno NUMBER
   )
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.object_type_name := 'ROW_EMP';
      SELF.empno := empno;
      SELF.ename := ename;
      SELF.job := job;
      SELF.mgr := mgr;
      SELF.hiredate := hiredate;
      SELF.sal := sal;
      SELF.comm := comm;
      SELF.deptno := deptno;
      RETURN;
   END;
---------------------------------------------------------------
   CONSTRUCTOR FUNCTION row_emp (in_empno NUMBER)
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.object_type_name := 'ROW_EMP';
      row_select (in_empno => in_empno);
      RETURN;
   END;
---------------------------------------------------------------
   MEMBER FUNCTION row_exists (in_empno NUMBER)
      RETURN BOOLEAN
   IS
      v_count   PLS_INTEGER;
   BEGIN
      SELECT COUNT (*)
        INTO v_count
        FROM scott.emp
       WHERE empno = in_empno;

      RETURN (v_count <> 0);
   END;
---------------------------------------------------------------
-- member functions
   OVERRIDING MEMBER FUNCTION compare (
      in_type1 type_object
    , in_type2 type_object
   )
      RETURN INTEGER
   IS
      type1   row_emp := TREAT (in_type1 AS row_emp);
      type2   row_emp := TREAT (in_type2 AS row_emp);
   BEGIN
      IF     type1.empno = type2.empno
         AND (   type1.ename = type2.ename
              OR (type1.ename IS NULL AND type2.ename IS NULL)
             )
         AND (   type1.job = type2.job
              OR (type1.job IS NULL AND type2.job IS NULL)
             )
         AND (   type1.mgr = type2.mgr
              OR (type1.mgr IS NULL AND type2.mgr IS NULL)
             )
         AND (   type1.hiredate = type2.hiredate
              OR (type1.hiredate IS NULL AND type2.hiredate IS NULL)
             )
         AND (   type1.sal = type2.sal
              OR (type1.sal IS NULL AND type2.sal IS NULL)
             )
         AND (   type1.comm = type2.comm
              OR (type1.comm IS NULL AND type2.comm IS NULL)
             )
         AND (   type1.deptno = type2.deptno
              OR (type1.deptno IS NULL AND type2.deptno IS NULL)
             )
      THEN
         RETURN 0;                                                   --gleich
      ELSE
         RETURN 1;                                                 --ungleich
      END IF;
   END;
---------------------------------------------------------------
-- member procedures
   MEMBER PROCEDURE row_insert
   IS
   BEGIN
      INSERT INTO scott.emp
                  (empno, ename, job, mgr
                 , hiredate, sal, comm, deptno
                  )
           VALUES (SELF.empno, SELF.ename, SELF.job, SELF.mgr
                 , SELF.hiredate, SELF.sal, SELF.comm, SELF.deptno
                  )
        RETURNING empno, ename, job, mgr, hiredate
                , sal, comm, deptno
             INTO SELF.empno, SELF.ename, SELF.job, SELF.mgr, SELF.hiredate
                , SELF.sal, SELF.comm, SELF.deptno;
   END;
---------------------------------------------------------------
   MEMBER PROCEDURE row_update
   IS
   BEGIN
      UPDATE    scott.emp
            SET ename = SELF.ename
              , job = SELF.job
              , mgr = SELF.mgr
              , hiredate = SELF.hiredate
              , sal = SELF.sal
              , comm = SELF.comm
              , deptno = SELF.deptno
          WHERE empno = SELF.empno
      RETURNING empno, ename, job, mgr, hiredate
              , sal, comm, deptno
           INTO SELF.empno, SELF.ename, SELF.job, SELF.mgr, SELF.hiredate
              , SELF.sal, SELF.comm, SELF.deptno;

      IF SQL%ROWCOUNT <> 1
      THEN
         RAISE NO_DATA_FOUND;
      END IF;
   END;
---------------------------------------------------------------
   MEMBER PROCEDURE row_merge
   IS
   BEGIN
      MERGE INTO scott.emp a
         USING (SELECT SELF.empno AS empno, SELF.ename AS ename
                     , SELF.job AS job, SELF.mgr AS mgr
                     , SELF.hiredate AS hiredate, SELF.sal AS sal
                     , SELF.comm AS comm, SELF.deptno AS deptno
                  FROM DUAL) b
         ON (a.empno = b.empno)
         WHEN MATCHED THEN
            UPDATE
               SET ename = b.ename, job = b.job, mgr = b.mgr
                 , hiredate = b.hiredate, sal = b.sal, comm = b.comm
                 , deptno = b.deptno
         WHEN NOT MATCHED THEN
            INSERT (empno, ename, job, mgr, hiredate, sal, comm, deptno)
            VALUES (b.empno, b.ename, b.job, b.mgr, b.hiredate, b.sal
                  , b.comm, b.deptno);
   END;
---------------------------------------------------------------
   MEMBER PROCEDURE row_save
   IS
   BEGIN
      IF row_exists (in_empno => SELF.empno)
      THEN
         row_update;
      ELSE
         row_insert;
      END IF;
   END;
---------------------------------------------------------------
   MEMBER PROCEDURE row_delete
   IS
   BEGIN
      DELETE FROM scott.emp
            WHERE empno = SELF.empno;

      IF SQL%ROWCOUNT <> 1
      THEN
         RAISE NO_DATA_FOUND;
      END IF;
   END;
---------------------------------------------------------------
   MEMBER PROCEDURE row_select (in_empno NUMBER)
   IS
   BEGIN
      SELECT empno, ename, job, mgr, hiredate
           , sal, comm, deptno
        INTO SELF.empno, SELF.ename, SELF.job, SELF.mgr, SELF.hiredate
           , SELF.sal, SELF.comm, SELF.deptno
        FROM scott.emp
       WHERE empno = in_empno;
   END;
---------------------------------------------------------------
   MEMBER PROCEDURE row_default
   IS
   BEGIN
      NULL;
   END;
END;
/

CREATE OR REPLACE TYPE table_dept AS TABLE OF scott.row_dept;
/

CREATE OR REPLACE TYPE table_emp AS TABLE OF scott.row_emp;
/

CREATE OR REPLACE PACKAGE pa_emp
IS
   FUNCTION fu_select
      RETURN table_emp;

   FUNCTION fs_deptno (in_deptno IN emp.deptno%TYPE)
      RETURN table_emp;

   FUNCTION fs_mgr (in_mgr IN emp.mgr%TYPE)
      RETURN table_emp;
END;
/

CREATE OR REPLACE PACKAGE BODY pa_emp
IS
   FUNCTION fu_select
      RETURN table_emp
   IS
      RESULT   table_emp;
   BEGIN
      SELECT row_emp ('ROW_EMP'
                    , empno
                    , ename
                    , job
                    , mgr
                    , hiredate
                    , sal
                    , comm
                    , deptno
                     )
      BULK COLLECT INTO RESULT
        FROM scott.emp;

      RETURN RESULT;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN table_emp ();
      WHEN OTHERS
      THEN
         RAISE;
   END;

-------------------------------------------------------
   FUNCTION fs_deptno (in_deptno IN emp.deptno%TYPE)
      RETURN table_emp
   IS
      RESULT   table_emp;
   BEGIN
      SELECT row_emp ('ROW_EMP'
                    , empno
                    , ename
                    , job
                    , mgr
                    , hiredate
                    , sal
                    , comm
                    , deptno
                     )
      BULK COLLECT INTO RESULT
        FROM scott.emp
       WHERE (deptno = in_deptno OR (deptno IS NULL AND in_deptno IS NULL));

      RETURN RESULT;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN table_emp ();
      WHEN OTHERS
      THEN
         RAISE;
   END;

-------------------------------------------------------
   FUNCTION fs_mgr (in_mgr IN emp.mgr%TYPE)
      RETURN table_emp
   IS
      RESULT   table_emp;
   BEGIN
      SELECT row_emp ('ROW_EMP'
                    , empno
                    , ename
                    , job
                    , mgr
                    , hiredate
                    , sal
                    , comm
                    , deptno
                     )
      BULK COLLECT INTO RESULT
        FROM scott.emp
       WHERE (mgr = in_mgr OR (mgr IS NULL AND in_mgr IS NULL));

      RETURN RESULT;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN table_emp ();
      WHEN OTHERS
      THEN
         RAISE;
   END;
END;
/

CREATE OR REPLACE PACKAGE pa_dept
IS
   FUNCTION fu_select
      RETURN table_dept;
END;
/

CREATE OR REPLACE PACKAGE BODY pa_dept
IS
   FUNCTION fu_select
      RETURN table_dept
   IS
      RESULT   table_dept;
   BEGIN
      SELECT row_dept ('ROW_DEPT', deptno, dname, loc)
      BULK COLLECT INTO RESULT
        FROM scott.dept;

      RETURN RESULT;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN table_dept ();
      WHEN OTHERS
      THEN
         RAISE;
   END;
END;
/

CREATE OR REPLACE TYPE type_manager UNDER row_emp (
   -- attributes
   employees   table_emp
 -- constructors
   ,CONSTRUCTOR FUNCTION type_manager
      RETURN SELF AS RESULT
 , CONSTRUCTOR FUNCTION type_manager (in_empno NUMBER)
      RETURN SELF AS RESULT
)
NOT FINAL
/

CREATE OR REPLACE TYPE BODY type_manager
IS
   -- constructors
   CONSTRUCTOR FUNCTION type_manager
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.object_type_name := 'TYPE_MANAGER';
      SELF.row_default ();
      SELF.employees := table_emp ();
      RETURN;
   END;
---------------------------------------------------------------
   CONSTRUCTOR FUNCTION type_manager (in_empno NUMBER)
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.object_type_name := 'TYPE_MANAGER';
      SELF.row_select (in_empno => in_empno);
      SELF.employees := pa_emp.fs_mgr (in_empno);
      RETURN;
   END;
END;
/

CREATE OR REPLACE TYPE type_department UNDER row_dept (
   -- attributes
   employees   table_emp
 -- constructors
   ,CONSTRUCTOR FUNCTION type_department
      RETURN SELF AS RESULT
 , CONSTRUCTOR FUNCTION type_department (in_deptno NUMBER)
      RETURN SELF AS RESULT
 -- member functions
   ,MEMBER FUNCTION get_manager
      RETURN type_manager
)
NOT FINAL
/

CREATE OR REPLACE TYPE BODY type_department
IS
   -- constructors
   CONSTRUCTOR FUNCTION type_department
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.object_type_name := 'TYPE_DEPARTMENT';
      SELF.row_default ();
      SELF.employees := table_emp ();
      RETURN;
   END;
---------------------------------------------------------------
   CONSTRUCTOR FUNCTION type_department (in_deptno NUMBER)
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.object_type_name := 'TYPE_DEPARTMENT';
      SELF.row_select (in_deptno => in_deptno);
      SELF.employees := pa_emp.fs_deptno (in_deptno);
      RETURN;
   END;
   -- member functions
   MEMBER FUNCTION get_manager
      RETURN type_manager
   IS
      t_manager   type_manager;
   BEGIN
      SELECT type_manager (e.empno)
        INTO t_manager
        FROM emp e
       WHERE e.deptno = SELF.deptno AND e.job = 'MANAGER';

      RETURN t_manager;
   END;
END;
/

CREATE OR REPLACE TYPE type_enterprise UNDER type_object (
   -- attributes
   NAME          VARCHAR2 (100)
 , president     type_manager
 , departments   table_dept
 , employees     table_emp
 -- constructors
   ,CONSTRUCTOR FUNCTION type_enterprise
      RETURN SELF AS RESULT
)
NOT FINAL
/

CREATE OR REPLACE TYPE BODY type_enterprise
IS
   -- constructors
   CONSTRUCTOR FUNCTION type_enterprise
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.object_type_name := 'TYPE_ENTERPRISE';
      SELF.NAME := 'King Corporation';
      SELF.president := type_manager (7839);
      SELF.departments := pa_dept.fu_select;
      SELF.employees := pa_emp.fu_select;
      RETURN;
   END;
END;
/