CREATE OR REPLACE PROCEDURE show_memory ( title_in IN VARCHAR2 )
/*
SELECT privileges required on: 
   SYS.v_$session
   SYS.v_$sesstat
   SYS.v_$statname

Here are the statements you should run:

GRANT SELECT ON SYS.v_$session TO schema;   
GRANT SELECT ON SYS.v_$sesstat TO schema;   
GRANT SELECT ON SYS.v_$statname TO schema;   
*/
IS
   CURSOR mem_cur
   IS
      SELECT nm.NAME, st.VALUE
        FROM SYS.v_$session se, SYS.v_$sesstat st, SYS.v_$statname nm
       WHERE se.audsid = USERENV ( 'SESSIONID' )
         AND st.statistic# = nm.statistic#
         AND se.SID = st.SID
         AND nm.NAME IN ( 'session uga memory', 'session pga memory' );
BEGIN
   DBMS_OUTPUT.put_line ( title_in );

   FOR rec IN mem_cur
   LOOP
      DBMS_OUTPUT.put_line ( '   ' || rec.NAME || ': '
                             || TO_CHAR ( rec.VALUE )
                           );
   END LOOP;
END show_memory;
/
