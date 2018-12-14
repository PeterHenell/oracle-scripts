SELECT n.name, s.VALUE
  FROM sys.v_$sesstat s
     , sys.v_$statname n
     , (SELECT *
          FROM sys.v_$session
         WHERE audsid = USERENV ('SESSIONID')) my_session
 WHERE     s.statistic# = n.statistic#
       AND s.sid = my_session.sid
       AND n.name IN ('session uga memory', 'session pga memory')