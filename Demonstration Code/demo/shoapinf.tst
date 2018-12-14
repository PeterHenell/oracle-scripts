BEGIN
   FOR timing IN 1 .. 10
   LOOP
      showapinfo;
      DBMS_OUTPUT.PUT_LINE ('...Sleeping...');
      DBMS_LOCK.SLEEP (3);
   END LOOP;
END;
/