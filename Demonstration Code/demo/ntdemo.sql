CREATE TYPE glitches_nt IS TABLE OF VARCHAR2(30);
/

DECLARE  
   uk_trip glitches_nt := glitches_nt ();
BEGIN
   uk_trip.EXTEND;
   uk_trip (1) := 'Ripped bag';
   
   p.l (uk_trip(1));
   
   uk_trip.EXTEND;
   uk_trip (2) := 'Washed contact lens';

   p.l (uk_trip(2));
   
   uk_trip.EXTEND;
   uk_trip (3) := 'Hertz post it notes';
   uk_trip.EXTEND;
   uk_trip (4) := 'No gate available';
   uk_trip.EXTEND;
   uk_trip (5) := 'Sent to wrong room at Hilton';
END;
/
      