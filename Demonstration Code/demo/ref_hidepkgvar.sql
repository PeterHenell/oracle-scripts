Step 1 Hide references to package variables. (PL/SQL refactoring)

Step 1 in the refactoring of topic "Hide references to package variables."

Universal ID = {45F6EC0E-0A04-4348-8650-675410B8AB83}

================================================================================
Step 2 Hide references to package variables. (PL/SQL refactoring)

Step 2 in the refactoring of topic "Hide references to package variables."

Universal ID = {0208F062-53C6-40E0-95D0-A5631311E07B}

================================================================================
Step 0: Problematic code for  Hide references to package variables. (PL/SQL refactoring) 

The problematic code for that demonstrates "Hide references to package variable
es. (PL/SQL refactoring)"

Universal ID = {2434EE43-1052-491F-AB65-ADD863E4594B}

CREATE OR REPLACE PACKAGE analysis_pkg
IS          
   -- Dates must be in the past.
   g_maxdate   DATE := SYSDATE;
 
   PROCEDURE do_stuff (date_in IN DATE);
END analysis_pkg;
/
 
CREATE OR REPLACE PACKAGE BODY analysis_pkg
IS
   g_maxdate   DATE := SYSDATE;
 
   PROCEDURE do_stuff (date_in IN DATE)
   IS
   BEGIN
      IF date_in < g_maxdate
      THEN
         -- I can proceed with my work.
         NULL;
      ELSE
         -- Invalid date. Must stop, raise error.
         NULL;
      END IF;
   END do_stuff;
END analysis_pkg;
/    
 
BEGIN
   analysis_pkg.g_maxdate := sysdate + 10000;
   analysis_pkg.do_stuff (sysdate + 10);
END;
/
 
================================================================================
