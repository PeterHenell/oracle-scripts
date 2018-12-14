DECLARE
  Str VARCHAR2(100);   
BEGIN
   priority.enqueue_low ('Cleaning the basement');
   priority.enqueue_high ('Cleaning the bathroom');
   priority.enqueue_high ('Helping Eli with his non-French homework');
   priority.enqueue_medium ('Washing the dishes');

   LOOP
      priority.dequeue (Str);
      EXIT WHEN Str IS NULL;
      DBMS_OUTPUT.PUT_LINE (Str);
   END LOOP;
END;
/

