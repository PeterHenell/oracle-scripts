SET SERVEROUTPUT ON
SET TIMING ON
DECLARE
   TYPE vc2000_tabtype IS TABLE OF VARCHAR2(2000) 
      INDEX BY BINARY_INTEGER;

   vdata vc2000_tabtype;

   v_ifirst INTEGER;
   v_ilast INTEGER;
BEGIN
   vdata (-2147483099) := 'abc';
   vdata (-2139833100) := 'def';
   v_ifirst := -2142383099;
   v_ilast  := -2142383099;
   vdata.DELETE (v_ifirst, v_ilast); 
END;    
/ 
