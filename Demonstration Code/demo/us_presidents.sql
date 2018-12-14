DROP TABLE us_presidents
/

CREATE TABLE us_presidents (name VARCHAR2 (100))
/

BEGIN
   INSERT INTO us_presidents (name)
        VALUES ('George Washington');

   INSERT INTO us_presidents (name)
        VALUES ('John Adams');

   INSERT INTO us_presidents (name)
        VALUES ('Thomas Jefferson');

   INSERT INTO us_presidents (name)
        VALUES ('James Madison');

   INSERT INTO us_presidents (name)
        VALUES ('James Monroe');

   INSERT INTO us_presidents (name)
        VALUES ('John Quincy Adams');

   INSERT INTO us_presidents (name)
        VALUES ('Andrew Jackson');

   INSERT INTO us_presidents (name)
        VALUES ('Martin Van Buren');

   INSERT INTO us_presidents (name)
        VALUES ('William Henry Harrison');

   INSERT INTO us_presidents (name)
        VALUES ('John Tyler');

   INSERT INTO us_presidents (name)
        VALUES ('James Knox Polk');

   INSERT INTO us_presidents (name)
        VALUES ('Zachary Taylor');

   INSERT INTO us_presidents (name)
        VALUES ('Millard Fillmore');

   INSERT INTO us_presidents (name)
        VALUES ('Franklin Pierce');

   INSERT INTO us_presidents (name)
        VALUES ('James Buchanan');

   INSERT INTO us_presidents (name)
        VALUES ('Abraham Lincoln');

   INSERT INTO us_presidents (name)
        VALUES ('Andrew Johnson');

   INSERT INTO us_presidents (name)
        VALUES ('Ulysses Simpson Grant1');

   INSERT INTO us_presidents (name)
        VALUES ('Rutherford Birchard Hayes');

   INSERT INTO us_presidents (name)
        VALUES ('James Abram Garfield');

   INSERT INTO us_presidents (name)
        VALUES ('Chester Alan Arthur');

   INSERT INTO us_presidents (name)
        VALUES ('(Stephen) Grover Cleveland');

   INSERT INTO us_presidents (name)
        VALUES ('Benjamin Harrison');

   INSERT INTO us_presidents (name)
        VALUES ('(Stephen) Grover Cleveland');

   INSERT INTO us_presidents (name)
        VALUES ('William McKinley');

   INSERT INTO us_presidents (name)
        VALUES ('Theodore Roosevelt');

   INSERT INTO us_presidents (name)
        VALUES ('William Howard Taft');

   INSERT INTO us_presidents (name)
        VALUES ('(Thomas) Woodrow Wilson');

   INSERT INTO us_presidents (name)
        VALUES ('Warren Gamaliel Harding');

   INSERT INTO us_presidents (name)
        VALUES ('(John) Calvin Coolidge');

   INSERT INTO us_presidents (name)
        VALUES ('Herbert Clark Hoover');

   INSERT INTO us_presidents (name)
        VALUES ('Franklin Delano Roosevelt');

   INSERT INTO us_presidents (name)
        VALUES ('Harry S. Truman2');

   INSERT INTO us_presidents (name)
        VALUES ('Dwight David Eisenhower3');

   INSERT INTO us_presidents (name)
        VALUES ('John Fitzgerald Kennedy');

   INSERT INTO us_presidents (name)
        VALUES ('Lyndon Baines Johnson');

   INSERT INTO us_presidents (name)
        VALUES ('Richard Milhous Nixon');

   INSERT INTO us_presidents (name)
        VALUES ('Gerald Rudolph Ford4');

   INSERT INTO us_presidents (name)
        VALUES ('James Earl Carter');

   INSERT INTO us_presidents (name)
        VALUES ('Ronald Wilson Reagan');

   INSERT INTO us_presidents (name)
        VALUES ('George Herbert Walker Bush');

   INSERT INTO us_presidents (name)
        VALUES ('William Jefferson Clinton5');

   INSERT INTO us_presidents (name)
        VALUES ('George Walker Bush');

   INSERT INTO us_presidents (name)
        VALUES ('Barack Hussein Obama');

   COMMIT;
END;
/

CREATE OR REPLACE PACKAGE us_presidents_pkg
IS
   CURSOR us_presidents_cur
   IS
      SELECT * FROM us_presidents;

   TYPE us_presidents_aat IS TABLE OF us_presidents%ROWTYPE
                                INDEX BY PLS_INTEGER;

   PROCEDURE show_presidents (presidents_in IN us_presidents_aat);
END;
/

CREATE OR REPLACE PACKAGE BODY us_presidents_pkg
IS
   PROCEDURE show_presidents (presidents_in IN us_presidents_aat)
   IS
   BEGIN
      FOR indx IN 1 .. presidents_in.COUNT
      LOOP
         DBMS_OUTPUT.put_line (presidents_in (indx).name);
      END LOOP;
   END show_presidents;
END;
/

DECLARE
   c_limit   CONSTANT PLS_INTEGER := 10;
   l_us_presidents    us_presidents_pkg.us_presidents_aat;
BEGIN
   OPEN us_presidents_pkg.us_presidents_cur;

   LOOP
      FETCH us_presidents_pkg.us_presidents_cur
      BULK COLLECT INTO l_us_presidents
      LIMIT c_limit;

      EXIT WHEN l_us_presidents.COUNT = 0;

      us_presidents_pkg.show_presidents (l_us_presidents);
   END LOOP;

   CLOSE us_presidents_pkg.us_presidents_cur;
END;
/