DECLARE
   i pls_integer;
   n binary_integer;
   s varchar2(100);
BEGIN
  n := dbms_utility.get_parameter_value('&&firstparm', i, s);
  p.l (n);
  p.l (i);
  p.l (s);
  END;
/
