DECLARE
   cumulative        PLS_INTEGER   := 0;

   TYPE employment_rt IS RECORD (
      description   VARCHAR2 (100)
     ,population    INTEGER
   );

   TYPE employment_tt IS TABLE OF employment_rt;

   -- Must initialize a nested table.
   ends_not_meeting   employment_tt := employment_tt();
   
   PROCEDURE addone (description_in IN VARCHAR2, population_in IN PLS_INTEGER)
   IS
   BEGIN
      -- Must explicitly extend a nested table before adding data.
      ends_not_meeting.EXTEND;
      ends_not_meeting (ends_not_meeting.LAST).description := description_in;
      ends_not_meeting (ends_not_meeting.LAST).population := population_in;
   END;
BEGIN
   addone ('UNEMPLOYED', 7500000);
   addone ('DISCOURAGED', 500000);
   addone ('LAID OFF', 500000);
   addone ('FORCED PART TIME', 4500000);
   addone ('12000 A YEAR', 2500000);
   
   p.l ('Number of types of economic misery', ends_not_meeting.COUNT);

   -- Usually "safe" to use a FOR loop with nested tables.
   FOR rowind IN ends_not_meeting.FIRST .. ends_not_meeting.LAST
   LOOP
      p.l ('(' || rowind || ')' || ends_not_meeting (rowind).description
          ,ends_not_meeting (rowind).population
          );
      cumulative := cumulative + ends_not_meeting (rowind).population;
   END LOOP;

   p.l (   'Miserable in the presence of concentrated wealth: '
        || TO_CHAR (cumulative, '999,999,999')
        || ' North Americans'
       );
END;
