alter system flush shared_pool;

SELECT VALUE, name
  FROM v$sesstat NATURAL JOIN v$statname
 WHERE     sid = SYS_CONTEXT ('userenv', 'sid')
       AND name IN ('parse count (total)', 'parse count (hard)');