DECLARE
   l_index            PLS_INTEGER;
   cumulative        PLS_INTEGER   := 0;

   TYPE employment_rt IS RECORD (
      description   VARCHAR2 (100)
     ,population    INTEGER
   );

   TYPE employment_tt IS TABLE OF employment_rt
      INDEX BY BINARY_INTEGER;

   ends_not_meeting   employment_tt;

   PROCEDURE addone (description_in IN VARCHAR2, population_in IN PLS_INTEGER)
   IS
      -- Demonstration of sparseness of associative arrays
      l_row   PLS_INTEGER := NVL (ends_not_meeting.LAST, 0) + 1876;
   BEGIN
      ends_not_meeting (l_row).description := description_in;
      ends_not_meeting (l_row).population := population_in;
   END;
BEGIN
   addone ('UNEMPLOYED', 7500000);
   addone ('DISCOURAGED', 500000);
   addone ('LAID OFF', 500000);
   addone ('FORCED PART TIME', 4500000);
   addone ('12000 A YEAR', 2500000);
   
   p.l ('Number of types of economic misery', ends_not_meeting.COUNT);
   
   -- Best to use simple loop with sparse associative arrays
   l_index := ends_not_meeting.FIRST;

   LOOP
      EXIT WHEN l_index IS NULL;
      p.l ('(' || l_index || ')' || ends_not_meeting (l_index).description
          ,ends_not_meeting (l_index).population
          );
      cumulative := cumulative + ends_not_meeting (l_index).population;
      l_index := ends_not_meeting.NEXT (l_index);
   END LOOP;

   p.l (   'Miserable in the presence of concentrated wealth: '
        || TO_CHAR (cumulative, '999,999,999')
        || ' North Americans'
       );
END;