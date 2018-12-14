/* 1. Move collection out of parameter list and into package spec */

CREATE OR REPLACE PACKAGE comm_pkg
IS
   TYPE reward_rt IS RECORD (
      nm VARCHAR2(2000),
      sal NUMBER,
      comm NUMBER);
      
   TYPE reward_tt IS TABLE OF reward_rt 
      INDEX BY BINARY_INTEGER;
      
   rewards reward_tt;
END;
/      

CREATE OR REPLACE PROCEDURE fix_me (
   nmfilter IN VARCHAR2
   )
IS
/* 2. Use %TYPE whenever appropriate to reduce memory requirements
      and improve robustness of code. */
      
/* 3. UPPER the name filter here and not in the loop. Remove NOT NULL constraint. */
      
   v_nmfilter CONSTANT employee.last_name%TYPE := UPPER (nmfilter);
   v_name employee.last_name%TYPE;
   v_sal employee.salary%TYPE;
   
/* 4. Use PLS_INTEGER */   

/* 5. Grab first row in table to do optimal scanning code. */

   indx PLS_INTEGER := comm_pkg.rewards.FIRST;
   
/* 7. Date is not going to change, so capture and convert once. */
   
   v_date CONSTANT VARCHAR2(10) := TO_CHAR (SYSDATE, 'MM/DD/YYYY');
   
/* 8. Use PLS_INTEGER */   
   v_first PLS_INTEGER;
BEGIN  

/* 9. Do explicit NOT NULL check here */

   IF nmfilter IS NOT NULL
   THEN
      v_first := indx - 1; 
      LOOP
         EXIT WHEN indx IS NULL;

/* 10. Move repeated operations to local variables. */
            
         v_name := UPPER (comm_pkg.rewards(indx).nm);
         v_sal := comm_pkg.rewards(indx).sal * 2;

         IF v_name LIKE v_nmfilter
         THEN

/* 11. Skip assignment to v_info; put in SQL directly. */

            UPDATE employee
               SET salary = v_sal,
                   info =  'Doubled ' || TO_CHAR (indx - v_first) || 
                           'th employee''s salary on ' || 
                            v_date || ' to ' || TO_CHAR (v_sal),
                   commission = comm_pkg.rewards(indx).comm
             WHERE last_name = v_name; 
            comm_pkg.rewards(indx).comm := 0;
         END IF;
      END LOOP;
   END IF;
END;
/
   