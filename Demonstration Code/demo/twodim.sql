CREATE OR REPLACE PACKAGE twodim
IS
   TYPE dim1_t IS TABLE OF NUMBER
      INDEX BY PLS_INTEGER;

   TYPE dim2_t IS TABLE OF dim1_t
      INDEX BY PLS_INTEGER;
END twodim;
/

DECLARE
   l_2d_grid   twodim.dim2_t;
BEGIN
   l_2d_grid (1) (1) := 100;
   l_2d_grid (2) (1) := 120;
   l_2d_grid (2) (2) := 200;
END;
/