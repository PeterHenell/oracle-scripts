DROP TABLE names
/
CREATE TABLE names (
   NAME VARCHAR2(100)
)
/

BEGIN
   INSERT INTO names
        VALUES ('Robert');

   INSERT INTO names
        VALUES ('Theresa');

   INSERT INTO names
        VALUES ('Sally');

   INSERT INTO names
        VALUES ('Pedro');

   INSERT INTO names
        VALUES ('Christopher');

   INSERT INTO names
        VALUES ('Humberto');

   INSERT INTO names
        VALUES ('Orphelia');

/*
Next:
The name of a 1 year old girl, daughter of the owner
of the Lazy Parrot, a restaurant we visited on Dec 30.
Her mother came by the table to deliver flowers and
India (in her arms) immediately reached out her arms
to me. And her mom even let me hold her. I was overjoyed!
*/
   INSERT INTO names
        VALUES ('India');

   COMMIT;
END;
/

CREATE OR REPLACE FUNCTION first_word
   RETURN VARCHAR2
IS
   TYPE names_t IS TABLE OF names.NAME%TYPE;

   l_names    names_t;
   l_return   VARCHAR2 (4);
BEGIN
   SELECT   NAME
   BULK COLLECT INTO l_names
       FROM names
   ORDER BY CASE ASCII (SUBSTR (NAME, 1, 1))
               WHEN 82
                  THEN 1
               WHEN 73
                  THEN 2
               WHEN 67
                  THEN 3
               WHEN 72
                  THEN 4
               ELSE 5
            END;

   FOR indx IN 1 .. 4
   LOOP
      l_return := l_return || SUBSTR (l_names (indx), 1, 1);
   END LOOP;

   RETURN l_return;
END first_word;
/

CREATE OR REPLACE FUNCTION second_word
   RETURN VARCHAR2
IS
   cv1        sys_refcursor;
   cv2        sys_refcursor;
   l_name     names.NAME%TYPE;
   l_return   VARCHAR2 (4);
BEGIN
   OPEN cv1 FOR
      SELECT   NAME
          FROM names
      ORDER BY CASE ASCII (SUBSTR (NAME, 1, 1))
                  WHEN 80
                     THEN 1
                  WHEN 79
                     THEN 2
                  WHEN 82
                     THEN 3
                  WHEN 84
                     THEN 4
                  ELSE 5
               END;

   cv2 := cv1;

   LOOP
      FETCH cv1
       INTO l_name;
      EXIT WHEN cv1%ROWCOUNT = 5;
      l_return := l_return || SUBSTR (l_name, 1, 1);
   END LOOP;

   CLOSE cv1;

   LOOP
      FETCH cv2
       INTO l_name;

      EXIT WHEN cv2%NOTFOUND;
      l_return := l_return || l_name;
   END LOOP;

   RETURN 'NICE PLACE!';
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN l_return;
END second_word;
/

BEGIN
   DBMS_OUTPUT.put_line (first_word () || ' ' || second_word ());
END;
/