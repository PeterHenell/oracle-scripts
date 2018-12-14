ALTER TABLE employee ADD info VARCHAR2(2000);

CREATE OR REPLACE PACKAGE comm_pkg
IS
   TYPE reward_rt IS RECORD (
      nm VARCHAR2(2000),
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
   v_sal NUMBER;
   indx INTEGER
BEGIN   
   FOR indx IN comm_list.FIRST .. comm_list.LAST
   LOOP
      v_sal := v_sal * 2;
      v_nth := v_nth + 1;
      v_info :=
         'Doubled ' || v_nth || 'th employee''s salary on ' || 
         SYSDATE || '  to ' || v_sal;
         
      IF UPPER (comm_list.nm) LIKE UPPER (v_nmfilter)
      THEN
         UPDATE employee
            SET salary := v_sal,
                info :=  v_info,
                commission := comm_list.comm
          WHERE last_name = UPPER (comm_list.nm); 
         comm_list.comm := 0;
      END IF;
      
   END LOOP;
END;
/
   
