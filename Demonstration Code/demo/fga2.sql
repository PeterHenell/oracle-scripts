BEGIN
   DBMS_FGA.drop_policy (
      object_schema        => 'scott',
      object_name          => 'emp',
      policy_name          => 'dept10_policy');
	  	  
   DBMS_FGA.add_policy (
      object_schema        => 'scott',
      object_name          => 'emp',
      policy_name          => 'dept10_policy',
      audit_condition      => 'deptno = 10',
      audit_column         => 'sal',
      ENABLE               => TRUE
   );
 
END;
/

SELECT *
  FROM emp
 WHERE deptno = 10;