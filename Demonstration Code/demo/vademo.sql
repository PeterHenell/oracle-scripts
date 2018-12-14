CREATE OR REPLACE TYPE glitches_va IS VARRAY (3) OF VARCHAR2(30);
/

DECLARE  
   uk_trip glitches_va := glitches_va ();
   
   PROCEDURE add_glitch (glitch_in IN VARCHAR2) IS
   BEGIN
      uk_trip.EXTEND;
      uk_trip (uk_trip.LAST) := glitch_in;
	  p.l (uk_trip (uk_trip.LAST));
   END;
BEGIN
   add_glitch ('Ripped bag');
   add_glitch ('Washed contact lens');
   add_glitch ('Hertz post it notes');
   add_glitch ('No gate available');
   add_glitch ('Sent to wrong room at Hilton');
END;
/
      
