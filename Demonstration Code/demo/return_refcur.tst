DECLARE
   l_record return_id_sal.employee_rt;
   l_dynamic return_id_sal.weak_rc;
   l_static return_id_sal.employee_rc;
BEGIN
   l_dynamic :=
      return_id_sal.allrows_by
                           ( ' where department_id = 10 order by salary desc' );

   LOOP
      FETCH l_dynamic
       INTO l_record;

      EXIT WHEN l_dynamic%NOTFOUND;
      DBMS_OUTPUT.put_line ( l_record.employee_id || '-' || l_record.salary );
   END LOOP;

   CLOSE l_dynamic;

   DBMS_OUTPUT.put_line ( '' );
   --
   l_static := return_id_sal.allrows_for_dept ( 10 );

   LOOP
      FETCH l_static
       INTO l_record;

      EXIT WHEN l_static%NOTFOUND;
      DBMS_OUTPUT.put_line ( l_record.employee_id || '-' || l_record.salary );
   END LOOP;

   CLOSE l_static;
END;
/
