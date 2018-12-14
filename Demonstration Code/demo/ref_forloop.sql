Step 1 Ensure both range values in numeric FOR loop are not null. (PL/SQL refactoring)

Step 1 in the refactoring of topic "Ensure both range values in numeric FOR loo
op are not null."

I have protected my code against a VALUE_ERROR exception by putting the FOR loo
op inside an IF statement. It will not run if there are no rows in the collecti
ions.

Yet this code also assumes the collection is sequentially filled. If it is not,
, Oracle will raise a NO_DATA_FOUND error.

Universal ID = {89269768-C63C-4748-8EB4-E359DC10007D}

CREATE OR REPLACE PROCEDURE process_collection (
   mylist IN my_nested_table_type
   ) 
IS
BEGIN        
   IF mylist.COUNT > 0
   THEN
      FOR indx IN mylist.FIRST .. mylist.LAST
      LOOP
         process_list_value (mylist (indx));
      END LOOP;
   END IF;
END;
/
================================================================================
Step 2 Ensure both range values in numeric FOR loop are not null. (PL/SQL refactoring)

The best approach to take is to use a WHILE loop with the NEXT method to move f
forward through the loop. Use either of these scripts to help you generate such
h code:

Scan forward {91879C86-D4B4-4675-81A4-C10C7676CACB}
Scan backward {E5014770-2AC5-4BC6-9585-CFA8FC2FDD60}

Universal ID = {3EA7F576-1971-40ED-ADEF-7489DC1E196D}

CREATE OR REPLACE PROCEDURE process_collection (
   mylist IN my_nested_table_type
   ) 
IS
   l_row PLS_INTEGER;
BEGIN                
   l_row := mylist.FIRST;
   WHILE (l_row IS NOT NULL)
   LOOP
      process_list_value (mylist (l_row)); 
      l_row := mylist.NEXT (l_row);
   END LOOP;
END;
/
================================================================================
Step 0: Problematic code for  Ensure both range values in numeric FOR loop are not null (PL/SQL refactoring)

This procedure executes a simple FOR loop against the incoming collection. But 
 if the collection is empty, Oracle will raise a VALUE_ERROR exception. 

Universal ID = {FAEA0B75-5D13-455E-91BC-6969DC08CC9A}

CREATE OR REPLACE PROCEDURE process_collection (
   mylist IN my_nested_table_type
   )  
IS
BEGIN
   FOR indx IN mylist.FIRST .. mylist.LAST
   LOOP
     process_list_value (mylist (indx));
   END LOOP;
END;
/
 
================================================================================
