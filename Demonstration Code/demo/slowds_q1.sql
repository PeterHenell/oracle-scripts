/* see slow_ds1.sql for the tuned version. */

ALTER TABLE employee ADD info VARCHAR2(2000);

CREATE OR REPLACE PACKAGE comm_pkg
IS
   TYPE reward_rt IS RECORD (
      nm VARCHAR2(2000),
      sal NUMBER,
      comm NUMBER);
      
   TYPE reward_tt IS TABLE OF reward_rt 
      INDEX BY BINARY_INTEGER;
END;
/      

CREATE OR REPLACE PROCEDURE fix_me (
   nmfilter IN VARCHAR2,
   comm_list IN OUT comm_pkg.reward_tt
   )
IS
   v_nmfilter VARCHAR2(2000) NOT NULL := nmfilter;
   v_info VARCHAR2(2000);
   v_nth INTEGER;
   indx INTEGER;
BEGIN   
   FOR indx IN comm_list.FIRST .. comm_list.LAST
   LOOP
      v_nth := v_nth + 1;
      /*
      || Record date on which increase occurred; time is not 
      || important. Job is run at noon and lasts 15 minutes.
      */
      v_info :=
         'Doubled ' || v_nth || 'th employee''s salary on ' || 
         SYSDATE || '  to ' || comm_list(indx).sal * 2;
         
      IF UPPER (comm_list(indx).nm) LIKE UPPER (v_nmfilter)
      THEN
         UPDATE employee
            SET salary := comm_list(indx).sal * 2,
                info :=  v_info,
                commission := comm_list(indx).comm
          WHERE last_name = UPPER (comm_list(indx).nm); 
         comm_list(indx).comm := 0;
      END IF;
      
   END LOOP;
END;
/
   