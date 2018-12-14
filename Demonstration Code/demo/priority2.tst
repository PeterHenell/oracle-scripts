DECLARE
  Str VARCHAR2(100);   
BEGIN
   LOOP
      priority.dequeue (Str);
      EXIT WHEN Str IS NULL;
      DBMS_OUTPUT.PUT_LINE (Str);
   END LOOP;
END;
/

