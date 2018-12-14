DECLARE
   l_2d_grid   num2dim := num2dim ();
BEGIN
   l_2d_grid.EXTEND;
   l_2d_grid (1) := numarray ();
   l_2d_grid (1).EXTEND;
   l_2d_grid (1) (1) := 100;
END;
/