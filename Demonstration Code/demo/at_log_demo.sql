SELECT code, text
  FROM logtab;

BEGIN
   DBMS_OUTPUT.put_line (SYSDATE);
   logpkg.putline (1, 'Putline the date');
   logpkg.saveline (1, 'Saveline the date');
   ROLLBACK;
END;
/

SELECT code, text
  FROM logtab;