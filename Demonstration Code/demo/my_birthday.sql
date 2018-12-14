/* The puzzle */

DECLARE
   l_start PLS_INTEGER;
   l_timing PLS_INTEGER;
   piece1 VARCHAR2 (2) := SUBSTR ('<CLUE1>', 1, 2);
   piece2 VARCHAR2 (2) := <CLUE2>(80) || <CLUE2>(84);
   piece3 VARCHAR2 (2) := SUBSTR ('<CLUE3>', 1, 2);
   piece4 VARCHAR2 (1) := SUBSTR ('<CLUE4>', 1, 1);
   piece5 VARCHAR2 (2) := 'ER';
   piece6 VARCHAR2 (2);
BEGIN
   l_start := DBMS_UTILITY.get_time ();
   
   DBMS_LOCK.sleep (30);
   
   l_timing :=
         FLOOR ((DBMS_UTILITY.get_time () - l_start - POWER (10, 2) * 7)
                / 100);
                
   piece6 := TO_CHAR (l_timing);
   --
   DBMS_OUTPUT.put_line (   'Steven''s birthday is: '
                         || piece1
                         || piece2
                         || piece3
                         || piece4
                         || piece5
                         || ' '
                         || piece6
                        );
END;
/

/* The "solution" */

DECLARE
   l_start PLS_INTEGER;
   l_timing PLS_INTEGER;
   piece1 VARCHAR2 (2) := SUBSTR ('SELECT', 1, 2);
   piece2 VARCHAR2 (2) := CHR (80) || CHR (84);
   piece3 VARCHAR2 (2) := SUBSTR ('EMPLOYEE', 1, 2);
   piece4 VARCHAR2 (1) := SUBSTR ('BOOLEAN', 1, 1);
   piece5 VARCHAR2 (2) := 'ER';
   piece6 VARCHAR2 (2) := 'ER';
BEGIN
   l_start := DBMS_UTILITY.get_time ();
   DBMS_LOCK.sleep (30);
   l_timing :=
         FLOOR ((DBMS_UTILITY.get_time () - l_start - POWER (10, 2) * 7)
                / 100);
   piece6 := TO_CHAR (l_timing);
   DBMS_OUTPUT.put_line (   piece1
                         || piece2
                         || piece3
                         || piece4
                         || piece5
                         || ' '
                         || piece6
                        );
END;
/

