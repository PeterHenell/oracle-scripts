BEGIN
   DBMS_OUTPUT.put_line (
      REPLACE (
         TO_CHAR (TO_DATE ('01-10-2011 12:01:01'
                         , 'dd-mm-yyyy hh24:mi:ss')
                ,  'fmDD Month yyyy fxhh24 mi ss')
       ,  ' '
       ,  '*'));
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      REPLACE (
         TO_CHAR (TO_DATE ('01-10-2011 12:01:01'
                         , 'dd-mm-yyyy hh24:mi:ss')
                ,  'fxDD Month yyyy fmhh24 mi ss')
       ,  ' '
       ,  '*'));
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      REPLACE (
         TO_CHAR (TO_DATE ('01-10-2011 12:01:01'
                         , 'dd-mm-yyyy hh24:mi:ss')
                ,  'fxDD Month yyyy fxhh24 mi ss')
       ,  ' '
       ,  '*'));
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      REPLACE (
         TO_CHAR (TO_DATE ('01-10-2011 12:01:01'
                         , 'dd-mm-yyyy hh24:mi:ss')
                ,  'fmDD Month yyyy fmhh24 mi ss')
       ,  ' '
       ,  '*'));
END;
/




