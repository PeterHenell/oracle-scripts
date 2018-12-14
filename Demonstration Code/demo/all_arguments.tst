CREATE TABLE account 
   (account_no number, 
    person_id number,
    balance number(7,2));

CREATE TABLE person 
   (person_id number(4), 
    person_nm varchar2(10));

CREATE TYPE anobject_t AS OBJECT (keyno NUMBER, name VARCHAR2(100));
/

CREATE TYPE varray_t AS VARRAY(100) OF anobject_t;
/

CREATE OR REPLACE PACKAGE allargs_test
IS
   TYPE number_table IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;

   TYPE nested_table IS TABLE OF emp%ROWTYPE;

   TYPE indexby_table_of_records IS TABLE OF emp%ROWTYPE
      INDEX BY BINARY_INTEGER;

   TYPE myrec1 IS RECORD (
      empno    NUMBER,
      indsal   NUMBER
   );

   TYPE myrec2 IS RECORD (
      ename        VARCHAR2 (20),
      empno_info   myrec1,
      hiredate     DATE
   );

   TYPE myrec3 IS RECORD (
      deptno         NUMBER,
      totsal         NUMBER,
      all_emp_info   myrec2,
      allemps        indexby_table_of_records
   );

   TYPE myrec_table IS TABLE OF myrec1
      INDEX BY BINARY_INTEGER;

   TYPE collection2_t IS TABLE OF myrec3
      INDEX BY BINARY_INTEGER; 

   TYPE collection1_t IS TABLE OF collection2_t
      INDEX BY /*BINARY_INTEGER; --*/ all_arguments.object_name%type;

   PROCEDURE valid_diffnum (arg1 IN INTEGER, arg2 IN VARCHAR2);

   PROCEDURE valid_diffnum (arg1 IN INTEGER, arg2 IN VARCHAR2, arg3 IN VARCHAR2);

   PROCEDURE valid_difftypes (arg1 IN INTEGER, arg2 IN VARCHAR2);

   PROCEDURE valid_difftypes (arg1 IN DATE, arg2 IN NUMBER);

   PROCEDURE namednot (arg1a IN INTEGER, arg2a IN VARCHAR2);

   PROCEDURE namednot (arg1b IN INTEGER, arg2b IN VARCHAR2);

   FUNCTION samefamily1 (arg1 IN INTEGER)
      RETURN VARCHAR2;

   FUNCTION samefamily1 (arg1 IN NUMBER)
      RETURN VARCHAR2;

   PROCEDURE samefamily2 (arg1 IN VARCHAR2, arg2 OUT NUMBER);
   PROCEDURE samefamily2 (arg1 IN CHAR, arg2 OUT NUMBER);
   
   PROCEDURE noparms;

   FUNCTION noparms
      RETURN VARCHAR2;

   PROCEDURE noparms (arg IN VARCHAR2 := NULL);

   PROCEDURE noparms (arg1 IN VARCHAR2 := NULL, arg2 IN VARCHAR2 := NULL);

   PROCEDURE noparms (
      arg1   IN   VARCHAR2 := NULL,
      arg2   IN   VARCHAR2,
      arg3   IN   VARCHAR2 := NULL
   );

   PROCEDURE noparms1;

   PROCEDURE noparms1 (arg IN VARCHAR2 := NULL);

   PROCEDURE noparms2 (arg1 IN VARCHAR2 := NULL, arg2 IN VARCHAR2 := NULL);

   PROCEDURE noparms2 (
      arg1   IN   VARCHAR2 := NULL,
      arg2   IN   VARCHAR2 := NULL,
      arg3   IN   VARCHAR2 := NULL
   );

   PROCEDURE noparms3 (arg1 IN VARCHAR2 := NULL, arg2 IN VARCHAR2);

   PROCEDURE noparms3 (
      arg1   IN   VARCHAR2,
      arg2   IN   VARCHAR2 := NULL,
      arg3   IN   VARCHAR2 := NULL
   );

   PROCEDURE noparms4 (arg1 IN VARCHAR2);

   PROCEDURE noparms4 (
      arg1   IN   VARCHAR2,
      arg2   IN   VARCHAR2 := NULL
   );
   
   PROCEDURE oneargdef (onearg IN VARCHAR2 := NULL);

   PROCEDURE oneargdef (onearg IN CHAR := 'abc');

   PROCEDURE difftype1;

   FUNCTION difftype1
      RETURN VARCHAR2;

   FUNCTION upd (
      account_in   NUMBER,
      person       person%ROWTYPE,
      amounts      number_table,
      trans_date   INTEGER /*DATE*/
   )
      RETURN ACCOUNT.balance%TYPE;

   FUNCTION upd (
      account_in   NUMBER,
      person       person%ROWTYPE,
      amounts      number_table,
      trans_no     NUMBER
   )
      RETURN ACCOUNT.balance%TYPE;

   FUNCTION upd (
      account_in   POSITIVE,
      person       person%ROWTYPE,
      amounts      number_table,
      trans_date   INTEGER := 0
   )
      RETURN NUMBER;

   FUNCTION upd (
      account_in   NUMBER,
      person       person%ROWTYPE,
      amounts      number_table,
      trans_no     NUMBER := 15,
      bad_arg      CHAR := 'A',
      maxsal       NUMBER := NULL
   )
      RETURN myrec3;

   PROCEDURE bad_datatypes (
      varchar2_in         IN   VARCHAR2,
      varchar_in               VARCHAR,
      nvarchar2_in             NVARCHAR2,
      --nvarchar_in NVARCHAR,
      char_in                  CHAR,
      nchar_in                 NCHAR,
      binary_integer_in        BINARY_INTEGER,
      long_in                  LONG,
      longraw_in               LONG RAW
   );

   PROCEDURE composites (
      account_in   NUMBER,
      person       person%ROWTYPE,
      multirec     myrec3,
      num_table    number_table,
      recs_table   myrec_table,
      myobject     anobject_t,
      myvarray     varray_t
   );

   PROCEDURE composites2 (
      account_in   NUMBER,
      person       person%ROWTYPE,
      multirec     myrec2,
      myobject     anobject_t
   );

   PROCEDURE countem (
      account_in     NUMBER,
      person         person%ROWTYPE,
      amounts        number_table,
      nested_emps    nested_table,
      indexby_emps   indexby_table_of_records,
      myrectable     myrec_table,
      person_type    anobject_t,
      anarray        varray_t,
      trans_no       NUMBER
   );

   PROCEDURE nested_composites (coll_in IN collection1_t);

   PROCEDURE difftabs1 (tab_in IN number_table);

   PROCEDURE difftabs1 (tab1_in IN number_table);

   PROCEDURE difftabs1 (tab_in IN varray_t);

   PROCEDURE difftabs1 (tab_in IN nested_table);

   PROCEDURE difftabs1 (tab_in IN indexby_table_of_records);
END allargs_test;
/

CREATE OR REPLACE PACKAGE BODY allargs_test
IS
   PROCEDURE valid_diffnum (arg1 IN INTEGER, arg2 IN VARCHAR2)
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE valid_diffnum (arg1 IN INTEGER, arg2 IN VARCHAR2, arg3 IN VARCHAR2)
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE valid_difftypes (arg1 IN INTEGER, arg2 IN VARCHAR2)
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE valid_difftypes (arg1 IN DATE, arg2 IN NUMBER)
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE namednot (arg1a IN INTEGER, arg2a IN VARCHAR2)
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE namednot (arg1b IN INTEGER, arg2b IN VARCHAR2)
   IS
   BEGIN
      NULL;
   END;

   FUNCTION samefamily1 (arg1 IN INTEGER, arg2 IN DATE)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN NULL;
   END;

   FUNCTION samefamily1 (arg1 IN NUMBER, arg2 IN TIMESTAMP)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN NULL;
   END;

      PROCEDURE samefamily2 (arg1 IN VARCHAR2)
   IS
   BEGIN
      dbms_output.put_line ('samefamily2 varchar2');
   END;
   PROCEDURE samefamily2 (arg1 IN LONG)
   IS
   BEGIN
      dbms_output.put_line ('samefamily2 long');

   END;
   
   PROCEDURE noparms
   IS
   BEGIN
      NULL;
   END;

   FUNCTION noparms
      RETURN VARCHAR2
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE noparms (arg IN VARCHAR2 := NULL)
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE noparms (arg1 IN VARCHAR2 := NULL, arg2 IN VARCHAR2 := NULL)
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE noparms (
      arg1   IN   VARCHAR2 := NULL,
      arg2   IN   VARCHAR2,
      arg3   IN   VARCHAR2 := NULL
   )
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE noparms1
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE noparms1 (arg IN VARCHAR2 := NULL)
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE noparms2 (arg1 IN VARCHAR2 := NULL, arg2 IN VARCHAR2 := NULL)
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE noparms2 (
      arg1   IN   VARCHAR2 := NULL,
      arg2   IN   VARCHAR2 := NULL,
      arg3   IN   VARCHAR2 := NULL
   )
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE noparms3 (arg1 IN VARCHAR2 := NULL, arg2 IN VARCHAR2)
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE noparms3 (
      arg1   IN   VARCHAR2,
      arg2   IN   VARCHAR2 := NULL,
      arg3   IN   VARCHAR2 := NULL
   )
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE oneargdef (onearg IN VARCHAR2 := NULL)
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE oneargdef (onearg IN CHAR := 'abc')
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE difftype1
   IS
   BEGIN
      NULL;
   END;

   FUNCTION difftype1
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN NULL;
   END;

   FUNCTION upd (
      account_in   NUMBER,
      person       person%ROWTYPE,
      amounts      number_table,
      trans_date   INTEGER                                             /*DATE*/
   )
      RETURN ACCOUNT.balance%TYPE
   IS
   BEGIN
      RETURN NULL;
   END;

   FUNCTION upd (
      account_in   NUMBER,
      person       person%ROWTYPE,
      amounts      number_table,
      trans_no     NUMBER
   )
      RETURN ACCOUNT.balance%TYPE
   IS
   BEGIN
      RETURN NULL;
   END;

   FUNCTION upd (
      account_in   POSITIVE,
      person       person%ROWTYPE,
      amounts      number_table,
      trans_date   INTEGER := 0
   )
      RETURN NUMBER
   IS
   BEGIN
      RETURN NULL;
   END;

   FUNCTION upd (
      account_in   NUMBER,
      person       person%ROWTYPE,
      amounts      number_table,
      trans_no     NUMBER := 15,
      bad_arg      CHAR := 'A',
      maxsal       NUMBER := NULL
   )
      RETURN myrec3
   IS
   BEGIN
      RETURN NULL;
   END;

   PROCEDURE bad_datatypes (
      varchar2_in         IN   VARCHAR2,
      varchar_in               VARCHAR,
      nvarchar2_in             NVARCHAR2,
      --nvarchar_in NVARCHAR,
      char_in                  CHAR,
      nchar_in                 NCHAR,
      binary_integer_in        BINARY_INTEGER,
      long_in                  LONG,
      longraw_in               LONG RAW
   )
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE composites (
      account_in   NUMBER,
      person       person%ROWTYPE,
      multirec     myrec3,
      num_table    number_table,
      recs_table   myrec_table,
      myobject     anobject_t,
      myvarray     varray_t
   )
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE composites2 (
      account_in   NUMBER,
      person       person%ROWTYPE,
      multirec     myrec2,
      myobject     anobject_t
   )
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE countem (
      account_in     NUMBER,
      person         person%ROWTYPE,
      amounts        number_table,
      nested_emps    nested_table,
      indexby_emps   indexby_table_of_records,
      myrectable     myrec_table,
      person_type    anobject_t,
      anarray        varray_t,
      trans_no       NUMBER
   )
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE nested_composites (coll_in IN collection1_t)
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE difftabs1 (tab_in IN number_table)
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE difftabs1 (tab1_in IN number_table)
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE difftabs1 (tab_in IN varray_t)
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE difftabs1 (tab_in IN nested_table)
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE difftabs1 (tab_in IN indexby_table_of_records)
   IS
   BEGIN
      NULL;
   END;
END allargs_test;
/
