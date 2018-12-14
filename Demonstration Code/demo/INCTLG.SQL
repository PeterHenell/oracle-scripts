TTITLE 'Elements Catalogued in &&firstparm'
SET VERIFY OFF
SET PAGESIZE 999
SET LINESIZE 120
COLUMN element FORMAT A120
SELECT /*DECODE (idatatype, NULL, NULL, idatatype || ' ') ||*/
       itype || ' ' || owner || '.' ||  
       name1 || '.' || iname  || ' ' ||
       DECODE (itype, 'FUNCTION', 'RETURN ' || idatatype || ' ', NULL) || 
       DECODE (overload, 1, NULL, 
               '(' || TO_CHAR(overload) || ')') element
  FROM PLVctlg
 WHERE name1 like '&&firstparm'
 ORDER BY owner, type, name1, itype, iname;

