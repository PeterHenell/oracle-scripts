WITH data
     AS (SELECT (   '^.*PRAGMA\s+EXCEPTION_INIT\s*\(\s*' -- PRAGMA EXCPETION_INIT(
                 || '([A-Z0-9_$#]{1,30}|"[^"]{1,30}")'         -- Exception-Name
                 -- comment the following line out, if the exception_name
                 -- and the exception code are on different lines
                 || '\s*,\s*''?(-?\d{1,5})''?'                 -- Exception-Code
                 -------
                 || '.*$'                                         -- End-of-Line
                         )
                   AS rx
              ,  (' ' || CHR (10) || CHR (13) || CHR (9)) AS trimset
           FROM DUAL)
   ,  data_source
     AS (SELECT s.owner
              ,  s.TYPE
              ,  s.name
              ,  s.line
              ,  UPPER (RTRIM (s.text, (' ' || CHR (10) || CHR (13)))) AS text
           FROM data d, dba_source s
          WHERE REGEXP_LIKE (s.text, d.rx, 'i'))
   ,  data_prepared
     AS (SELECT ds.owner
              ,  ds.TYPE
              ,  ds.name
              ,  ds.line
              ,  ds.text
              ,  REGEXP_REPLACE (ds.text, d.rx, '\1') AS exname
              ,  REGEXP_REPLACE (ds.text, d.rx, '\2') AS excode
           FROM data d, data_source ds)
  SELECT dp.excode
       ,  dp.owner
       ,  dp.TYPE
       ,  dp.name
       ,  dp.exname
       ,  dp.line
       ,  dp.text
    FROM data_prepared dp
   WHERE     (TO_NUMBER (dp.excode) BETWEEN -20999 AND -20000)
         AND dp.owner IN ('SYS', 'SYSMAN')
ORDER BY TO_NUMBER (dp.excode) DESC
       ,  dp.owner
       ,  dp.TYPE
       ,  dp.name;