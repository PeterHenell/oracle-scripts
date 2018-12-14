DROP TABLE account;

CREATE TABLE account 
   (account_no number, 
    person_id number,
    balance number(7,2));

DROP TABLE person;

CREATE TABLE person 
   (person_id number(4), 
    person_nm varchar2(10));
  
CREATE TYPE anobject_t AS OBJECT (keyno NUMBER, name VARCHAR2(100));

CREATE TYPE varray_t AS VARRAY(100) OF anobject_t;

CREATE OR REPLACE PACKAGE desctest
IS
   TYPE number_table IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

   TYPE nested_table IS TABLE OF emp%ROWTYPE;

   TYPE indexby_table_of_records IS TABLE OF emp%ROWTYPE INDEX BY BINARY_INTEGER;

   TYPE myrec1 IS RECORD (empno NUMBER, indsal NUMBER);
   TYPE myrec2 IS RECORD (ename VARCHAR2(20), hiredate DATE, empno_info myrec1);
   TYPE myrec3 IS RECORD (deptno NUMBER, totsal NUMBER, all_emp_info myrec2, 
       allemps indexby_table_of_records);

   TYPE myrec_table IS TABLE OF myrec1 INDEX BY BINARY_INTEGER;
	  
   TYPE collection2_t IS TABLE OF myrec3
      INDEX BY BINARY_INTEGER; -- The overloading
	  	  
   TYPE collection1_t IS TABLE OF collection2_t 
      INDEX BY --BINARY_INTEGER;
      all_arguments.object_name%type; 

   FUNCTION upd (account_in NUMBER, 
     person person%ROWTYPE, 
     amounts number_table,
     trans_date integer /*DATE*/) RETURN account.balance%TYPE;
     
   FUNCTION upd (account_in NUMBER, 
     person person%ROWTYPE, 
     amounts number_table,
     trans_no NUMBER) RETURN account.balance%TYPE;

   FUNCTION upd (account_in positive, 
     person person%ROWTYPE, 
     amounts number_table,
     trans_date integer := 0) RETURN account.balance%TYPE;
	 
   FUNCTION upd (account_in NUMBER, 
     person person%ROWTYPE, 
     amounts number_table,
     trans_no NUMBER := 15,
	 bad_arg CHAR := 'A',
     maxsal OUT NUMBER := null) RETURN account.balance%TYPE;

   PROCEDURE composites (account_in NUMBER,
     person person%ROWTYPE,
     multirec myrec3, 
     num_table number_table,
     recs_table myrec_table);

   PROCEDURE countem (account_in NUMBER, 
     person person%ROWTYPE, 
     amounts number_table,
     nested_emps nested_table,
     indexby_emps indexby_table_of_records,
     myrectable myrec_table,
     person_type anobject_t,
     anarray varray_t,
     trans_no NUMBER);
	 
   PROCEDURE nested_composites (coll_in in collection1_t
   );	 
END;
/

BEGIN
   args_analysis.showargs ('desctest', 'upd');
   args_analysis.showargs ('desctest', 'composites');
   args_analysis.showargs ('desctest', 'countem');
   args_analysis.showargs ('desctest', 'nested_composites');
END;
/
