DECLARE
   myargs dyn.args_tabtype;
BEGIN
   myargs(1000) := '''steven feuerstein''';
   myargs(1002) := '''e''';
   myargs(60877) := 3;
   myargs (6666666) := 2;
   p.l (dyn.calc ('instr', myargs));
END;
/
   