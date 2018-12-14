DECLARE
   l_old_date    DATE;
   l_curr_date   DATE := SYSDATE;
BEGIN
   BEGIN
      LOOP
         BEGIN
            l_old_date := l_curr_date;
            l_curr_date := l_curr_date + 1;
         END;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (   'Latest date: '
                               || TO_CHAR (l_old_date, 'YYYY-MM-DD')
                              );
   END;

   l_curr_date := SYSDATE;

   BEGIN
      LOOP
         BEGIN
            l_old_date := l_curr_date;
            l_curr_date := l_curr_date - 1;
         END;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (   'Earliest date: '
                               || TO_CHAR (l_old_date, 'YYYY-MM-DD')
                              );
   END;
END;
/