/* Formatted on 2002/05/22 12:54 (Formatter Plus v4.6.5) */

CREATE OR REPLACE FUNCTION dir_available (
   dir_in         IN   VARCHAR2,
   uppercase_in   IN   BOOLEAN := TRUE
)
   RETURN BOOLEAN
IS 
   v_dir    VARCHAR2 (100) := dir_in;
   retval   BOOLEAN;
   dummy    CHAR (1);
BEGIN
   IF uppercase_in
   THEN
      v_dir := UPPER (v_dir);
   END IF;

   SELECT 'x'
     INTO dummy
     FROM all_directories
    WHERE directory_name = l_dir;

   RETURN TRUE ;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN FALSE ;
END;

