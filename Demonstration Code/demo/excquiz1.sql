DECLARE
   aname   VARCHAR2 (5);
BEGIN
   BEGIN
      aname := 'Big String';
      DBMS_OUTPUT.put_line (aname);
   EXCEPTION
      WHEN VALUE_ERROR
      THEN
         DBMS_OUTPUT.put_line ('Inner block');
   END;

   DBMS_OUTPUT.put_line (SQLCODE);
   
   DBMS_OUTPUT.put_line ('What error?');
EXCEPTION
   WHEN VALUE_ERROR
   THEN
      DBMS_OUTPUT.put_line ('Outer block');
END;
/