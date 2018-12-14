BEGIN
   DBMS_OUTPUT.put_line (TRIM ('a' FROM 'abca'));
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      TRIM (LEADING AND TRAILING 'a' FROM 'abca'));
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      TRIM (BOTH 'a' FROM 'abca'));
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      TRIM (TRAILING 'a' 
         FROM (TRIM (LEADING 'a' FROM 'abca'))));
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      LTRIM (RTRIM ('abca', 'a'), 'a'));
END;
/