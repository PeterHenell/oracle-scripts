BEGIN
   DBMS_OUTPUT.put_line('Test 1: '
                        || CASE betwnstr (NULL, 3, 5, TRUE)
                              WHEN NULL THEN 'GOOD'
                              ELSE 'BAD'
                           END);
   DBMS_OUTPUT.put_line ('Test 2: ' || betwnstr ('abcdefgh', 0, 5, TRUE));
   DBMS_OUTPUT.put_line ('Test 3: ' || betwnstr ('abcdefgh', 3, 5, TRUE));
   DBMS_OUTPUT.put_line ('Test 4: ' || betwnstr ('abcdefgh', -3, -5, TRUE));
   DBMS_OUTPUT.put_line ('Test 5: ' || betwnstr ('abcdefgh', NULL, 5, TRUE));
   DBMS_OUTPUT.put_line ('Test 6: ' || betwnstr ('abcdefgh', 3, NULL, TRUE));
   DBMS_OUTPUT.put_line ('Test 7: ' || betwnstr ('abcdefgh', 3, 100, TRUE));
END;
/