1. All variables allocated at instantiation of block.

DECLARE
   TYPE list_tabtype IS TABLE 
      OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;

   names list_tabtype;

   v_name VARCHAR2(2000) := min_balance_account_name (SYSDATE);
   v_first_name VARCHAR2(2000);
BEGIN
    
   IF balance_too_low (1056)
   THEN
      v_first_name := v_name;
        
      /* Fill up the table and use it. */
      LOOP
         EXIT WHEN v_name IS NULL;

         names (NVL (names.LAST, 0) + 1) := v_name;
         ...
      END LOOP;
   ELSE
      /* Normal processing, no usage of names or v_name. */
      ...
   END IF;
END;

1. Data structures allocated as needed.

BEGIN
    
   IF balance_too_low (1056)
   THEN  
      DECLARE  
         TYPE list_tabtype IS TABLE 
            OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;

         names list_tabtype;

         v_name VARCHAR2(2000) := min_balance_account (SYSDATE);
         v_first_name VARCHAR2(2000);
         
      BEGIN
         v_first_name := v_name;
           
         /* Fill up the table and use it. */
         LOOP
            EXIT WHEN v_name IS NULL;

            names (NVL (names.LAST, 0) + 1) := v_name;
            ...
         END LOOP;
      END;
   ELSE
      /* Normal processing, no usage of names or v_name. */
      ...
   END IF;
END;