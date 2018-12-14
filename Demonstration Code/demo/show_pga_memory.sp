CREATE OR REPLACE PROCEDURE show_pga_memory (
   context_in   IN   VARCHAR2 DEFAULT NULL
)
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
   l_memory   NUMBER;
BEGIN
   SELECT st.VALUE
     INTO l_memory
     FROM SYS.v_$session se, SYS.v_$sesstat st, SYS.v_$statname nm
    WHERE se.audsid = USERENV ('SESSIONID')
      AND st.statistic# = nm.statistic#
      AND se.SID = st.SID
      AND nm.NAME = 'session pga memory';

   DBMS_OUTPUT.put_line (   CASE
                               WHEN context_in IS NULL
                                  THEN NULL
                               ELSE context_in || ' - '
                            END
                         || 'PGA memory used in session = '
                         || TO_CHAR (l_memory)
                        );
END show_pga_memory;
/