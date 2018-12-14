/*
The original
*/

DECLARE
   TYPE rec_gv IS RECORD
   (
      gv_name    VARCHAR2 (100),
      gv_value   VARCHAR2 (500)
   );

   TYPE tab_gv IS TABLE OF rec_gv
      INDEX BY PLS_INTEGER;

   tbl_gv         tab_gv;
   tbl_gv_count   PLS_INTEGER;

   FUNCTION fn_gv_posn (pi_gv_name IN VARCHAR2)
      RETURN NUMBER
   IS
      v_name   VARCHAR2 (100) := UPPER (pi_gv_name);
      v_posn   tbl_gv_count%TYPE := 0;
   BEGIN
      FOR i IN 1 .. tbl_gv_count
      LOOP
         IF tbl_gv (i).gv_name = v_name
         THEN
            v_posn := i;
            EXIT;
         END IF;
      END LOOP;

      RETURN v_posn;
   END;
BEGIN
   tbl_gv (1).gv_name := 'ALPHA';
   tbl_gv (2).gv_name := 'BETA';
   tbl_gv (3).gv_name := 'OMEGA';
   DBMS_OUTPUT.put_line (fn_gv_posn ('beta'));
END;
/

/* Change one "_" to ".". */

DECLARE
   TYPE rec_gv IS RECORD
   (
      gv_name    VARCHAR2 (100),
      gv_value   VARCHAR2 (500)
   );

   TYPE tab_gv IS TABLE OF rec_gv
      INDEX BY PLS_INTEGER;

   tbl_gv         tab_gv;
   tbl_gv_count   PLS_INTEGER;

   FUNCTION fn_gv_posn (pi_gv_name IN VARCHAR2)
      RETURN NUMBER
   IS
      v_name   VARCHAR2 (100) := UPPER (pi_gv_name);
      v_posn   tbl_gv_count%TYPE := 0;
   BEGIN
      FOR i IN 1 .. tbl_gv.COUNT
      LOOP
         IF tbl_gv (i).gv_name = v_name
         THEN
            v_posn := i;
            EXIT;
         END IF;
      END LOOP;

      RETURN v_posn;
   END;
BEGIN
   tbl_gv (1).gv_name := 'ALPHA';
   tbl_gv (2).gv_name := 'BETA';
   tbl_gv (3).gv_name := 'OMEGA';
   DBMS_OUTPUT.put_line (fn_gv_posn ('beta'));
END;
/

/*
Add one default value to a declaration. Awful, but sure:

tbl_gv_count   PLS_INTEGER := 3;
*/

DECLARE
   TYPE rec_gv IS RECORD
   (
      gv_name    VARCHAR2 (100),
      gv_value   VARCHAR2 (500)
   );

   TYPE tab_gv IS TABLE OF rec_gv
      INDEX BY PLS_INTEGER;

   tbl_gv         tab_gv;
   tbl_gv_count   PLS_INTEGER := 3;

   FUNCTION fn_gv_posn (pi_gv_name IN VARCHAR2)
      RETURN NUMBER
   IS
      v_name   VARCHAR2 (100) := UPPER (pi_gv_name);
      v_posn   tbl_gv_count%TYPE := 0;
   BEGIN
      FOR i IN 1 .. tbl_gv_count
      LOOP
         IF tbl_gv (i).gv_name = v_name
         THEN
            v_posn := i;
            EXIT;
         END IF;
      END LOOP;

      RETURN v_posn;
   END;
BEGIN
   tbl_gv (1).gv_name := 'ALPHA';
   tbl_gv (2).gv_name := 'BETA';
   tbl_gv (3).gv_name := 'OMEGA';
   DBMS_OUTPUT.put_line (fn_gv_posn ('beta'));
END;
/

/*
Change one literal (0 to 2 for v_posn). No, still get VE.
And changing string literals won't matter.
*/

DECLARE
   TYPE rec_gv IS RECORD
   (
      gv_name    VARCHAR2 (100),
      gv_value   VARCHAR2 (500)
   );

   TYPE tab_gv IS TABLE OF rec_gv
      INDEX BY PLS_INTEGER;

   tbl_gv         tab_gv;
   tbl_gv_count   PLS_INTEGER;

   FUNCTION fn_gv_posn (pi_gv_name IN VARCHAR2)
      RETURN NUMBER
   IS
      v_name   VARCHAR2 (100) := UPPER (pi_gv_name);
      v_posn   tbl_gv_count%TYPE := 2;
   BEGIN
      FOR i IN 1 .. tbl_gv_count
      LOOP
         IF tbl_gv (i).gv_name = v_name
         THEN
            v_posn := i;
            EXIT;
         END IF;
      END LOOP;

      RETURN v_posn;
   END;
BEGIN
   tbl_gv (1).gv_name := 'ALPHA';
   tbl_gv (2).gv_name := 'BETA';
   tbl_gv (3).gv_name := 'OMEGA';
   DBMS_OUTPUT.put_line (fn_gv_posn ('beta'));
END;
/

/*
Add an exception handler with single WHEN clause.

Sure. 
*/

DECLARE
   TYPE rec_gv IS RECORD
   (
      gv_name    VARCHAR2 (100),
      gv_value   VARCHAR2 (500)
   );

   TYPE tab_gv IS TABLE OF rec_gv
      INDEX BY PLS_INTEGER;

   tbl_gv         tab_gv;
   tbl_gv_count   PLS_INTEGER;

   FUNCTION fn_gv_posn (pi_gv_name IN VARCHAR2)
      RETURN NUMBER
   IS
      v_name   VARCHAR2 (100) := UPPER (pi_gv_name);
      v_posn   tbl_gv_count%TYPE := 0;
   BEGIN
      FOR i IN 1 .. tbl_gv_count
      LOOP
         IF tbl_gv (i).gv_name = v_name
         THEN
            v_posn := i;
            EXIT;
         END IF;
      END LOOP;

      RETURN v_posn;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 2;
   /* or WHEN VALUE_ERROR THEN */
   END;
BEGIN
   tbl_gv (1).gv_name := 'ALPHA';
   tbl_gv (2).gv_name := 'BETA';
   tbl_gv (3).gv_name := 'OMEGA';
   DBMS_OUTPUT.put_line (fn_gv_posn ('beta'));
/*
Or add it here:
*/
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (2);
END;
/