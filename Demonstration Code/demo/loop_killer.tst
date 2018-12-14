BEGIN
   loop_killer.kill_after (100);

   LOOP
      DBMS_OUTPUT.put_line (loop_killer.current_count);
      loop_killer.increment_or_kill;
   END LOOP;
END;
/