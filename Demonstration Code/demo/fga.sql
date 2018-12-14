CREATE OR REPLACE PROCEDURE log_id (
   sch   IN   VARCHAR2,
   tab   IN   VARCHAR2,
   pol   IN   VARCHAR2
)
AS
BEGIN
   DBMS_OUTPUT.put_line (
      'Audit triggered for ' || sch || '.' || tab || '.' || pol
   );
END;
/

BEGIN
   log_id ('a', 'b', 'c');
END;
/

BEGIN
   DBMS_FGA.drop_policy (
      object_schema        => 'scott',
      object_name          => 'emp',
      policy_name          => 'dept10_policy');
END;
/

BEGIN
   DBMS_FGA.drop_policy (
      object_schema        => 'scott',
      object_name          => 'emp',
      policy_name          => 'dept20_policy');
END;
/

BEGIN	  	  
   DBMS_FGA.add_policy (
      object_schema        => 'scott',
      object_name          => 'emp',
      policy_name          => 'dept10_policy',
      audit_condition      => 'deptno = 10',
      audit_column         => 'salary'
   );
   
/* add the policy */ 
   DBMS_FGA.add_policy (
      object_schema        => 'scott',
      object_name          => 'emp',
      policy_name          => 'dept20_policy',
      audit_condition      => 'dept = 20',
      audit_column         => 'salary',
      handler_schema       => 'scott',
      handler_module       => 'log_id',
      ENABLE               => TRUE
   );
END;
/

set serveroutput on size 1000000

SELECT *
  FROM emp
 WHERE deptno = 10;

UPDATE emp
   SET sal = sal
 WHERE deptno = 20;
