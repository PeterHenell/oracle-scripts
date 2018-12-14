Instead of this....

DECLARE
   l_full_name VARCHAR2(100) :=
      first_name_in || ' ' || last_name_in;
      
   l_big_string VARCHAR2(32767);
   
Write this....

DECLARE
   l_full_name employees_rp.full_name_t :=
      employees_rp.full_name (first_name_in, last_name_in);
      
   l_big_string plsql_limits.maxvarchar2_t;
   
