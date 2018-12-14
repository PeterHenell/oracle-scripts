/* Show all source code for parse package */

  SELECT *
    FROM all_source
   WHERE owner = USER AND name = 'PARSE'
ORDER BY TYPE, line
/

/* Just package body code */

  SELECT *
    FROM all_source
   WHERE owner = USER AND name = 'PARSE' AND TYPE = 'PACKAGE BODY'
ORDER BY line
/

/* Show all lines of source that contain the word "string" */

  SELECT *
    FROM all_source
   WHERE owner = USER AND name = 'PARSE' AND INSTR (UPPER (text), 'STRING') > 0
ORDER BY TYPE, line
/

/* Check for standard header usage */

  SELECT DISTINCT name
    FROM all_source
   WHERE owner = USER AND UPPER (text) LIKE '%STDHDR*/'
ORDER BY TYPE, line
/