CREATE OR REPLACE TYPE dates_nt IS TABLE OF DATE;
/

a.

CREATE OR REPLACE PROCEDURE happy_birthday (
   birthdays_in IN dates_nt
 , NAME_IN IN VARCHAR2
)
IS
BEGIN
   FOR indx IN birthdays_in.FIRST .. birthdays_in.LAST
   LOOP
      IF TRUNC (SYSDATE) = TRUNC (birthdays_in (indx))
      THEN
         DBMS_OUTPUT.put_line ('Happy Birthday, ' || NAME_IN || '!');
      END IF;
   END LOOP;
END happy_birthday;

b.

CREATE OR REPLACE PROCEDURE happy_birthday (
   birthdays_in IN dates_nt
 , NAME_IN IN VARCHAR2
)
IS
   l_index PLS_INTEGER := birthdays_in.FIRST;
BEGIN
   WHILE (l_index IS NOT NULL)
   LOOP
      IF TRUNC (SYSDATE) = TRUNC (birthdays_in (indx))
      THEN
         DBMS_OUTPUT.put_line ('Happy Birthday, ' || NAME_IN || '!');
      END IF;
      l_index := l_index + 1;
   END LOOP;
END happy_birthday;

c.

CREATE OR REPLACE PROCEDURE happy_birthday (
   birthdays_in IN dates_nt
 , NAME_IN IN VARCHAR2
)
IS
   l_index PLS_INTEGER := birthdays_in.LAST;
BEGIN
   WHILE (l_index IS NOT NULL)
   LOOP
      IF TRUNC (SYSDATE) = TRUNC (birthdays_in (indx))
      THEN
         DBMS_OUTPUT.put_line ('Happy Birthday, ' || NAME_IN || '!');
      END IF;

      l_index := birthdays_in.PRIOR (l_index);
   END LOOP;
END happy_birthday;

DECLARE
   kids_birthdays dates_nt := dates_nt ();
BEGIN
   kids_birthdays.EXTEND (3);
   -- My twenty year old...
   kids_birthdays (1) := ADD_MONTHS (SYSDATE, -1 * 20 * 12);
   -- My twenty-seven year old
   kids_birthdays (1) := ADD_MONTHS (SYSDATE, -1 * 27 * 12);
   -- My thirty-four year old...
   kids_birthdays (3) := ADD_MONTHS (SYSDATE, -1 * 34 * 12);
   -- Wait a minute! I don't have a 27 year old child!
   kids_birthdays.DELETE;
   happy_birthday (birthdays_in, 'Son of Mine');
END;

   

