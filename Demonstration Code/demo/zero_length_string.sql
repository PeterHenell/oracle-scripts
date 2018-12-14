SET serveroutput on format wrapped

DECLARE
   TYPE by_string_t IS TABLE OF PLS_INTEGER
      INDEX BY VARCHAR2 (10);

   l_list    by_string_t;
   l_index   VARCHAR2 (10);
BEGIN
   l_list ('') := 1;
   DBMS_OUTPUT.put_line ('Index value of zero-length string is allowed!');
   DBMS_OUTPUT.put_line
           (   'I can read the element at a zero length string index value: '
            || l_list ('')
           );
   --
   l_list ('A') := 2;
   DBMS_OUTPUT.put_line ('First = ' || NVL (l_list.FIRST, '*NULL*'));
   DBMS_OUTPUT.put_line ('Last = ' || NVL (l_list.LAST, '*NULL*'));
   --
   DBMS_OUTPUT.put_line ('But I cannot navigate from first to last....');
   l_index := l_list.FIRST;

   WHILE (l_index IS NOT NULL)
   LOOP
      DBMS_OUTPUT.put_line (   'Integer at index = '
                            || NVL (l_list (l_index), '*NULL*')
                           );
      l_index := l_list.NEXT (l_index);
   END LOOP;

   DBMS_OUTPUT.put_line
                ('Nothing is displayed because the first index value IS NULL!');
END;
/