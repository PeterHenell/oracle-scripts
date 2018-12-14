DECLARE
  n varchar2(100);   
BEGIN
   aqstk.push ('a');
   aqstk.push ('b');
   aqstk.pop (n); 
   dbms_output.put_line (n);
   aqstk.pop (n); 
   dbms_output.put_line (n);
END;
/

