BEGIN
  <<outer>>
   FOR outer_index IN 1 .. 5
   LOOP
      CONTINUE WHEN MOD (outer_index, 2) = 0;

      DBMS_OUTPUT.put_line ('O ' || outer_index);

      FOR inner_index IN 1 .. 3
      LOOP
         CONTINUE outer WHEN inner_index = 2;

         DBMS_OUTPUT.put_line ('I ' || inner_index);
      END LOOP;

      DBMS_OUTPUT.put_line ('Rest of outer loop');
   END LOOP outer;
END;
/