CREATE OR REPLACE PACKAGE BODY exttab
/*
SQLERRM

ORA-29913: error in executing ODCIEXTTABLEOPEN callout
ORA-29400: data cartridge error
KUP-04040: file info.dat in TEMP not found
ORA-06512: at "SYS.ORACLE_LOADER", line 19

DBMS_UTILITY.FORMAT_ERROR_STACK

ORA-29913: error in executing ODCIEXTTABLEOPEN callout
ORA-29400: data cartridge error
KUP-04040: file info.dat in TEMP not found

*/
IS
   c_kup_header_len CONSTANT PLS_INTEGER := 5;          /* CHR(10) || KUP- */
   c_kup_error_len CONSTANT PLS_INTEGER := 6;                 /* -99999 */
   c_kup_between_len CONSTANT PLS_INTEGER := 6;                    /* ": " */
   --
   g_message VARCHAR2 ( 32767 );

   FUNCTION kup_loc ( string_in IN VARCHAR2 )
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN INSTR ( string_in, CHR ( 10 ) || 'KUP-' );
   END kup_loc;

   PROCEDURE set_custom_error_message ( text_in IN VARCHAR2 )
   IS
   BEGIN
      g_message := text_in;
   END set_custom_error_message;

   FUNCTION ERROR_CODE ( sql_error_message_in IN VARCHAR2 )
      RETURN PLS_INTEGER
   IS
      l_kup_loc PLS_INTEGER := kup_loc ( sql_error_message_in );
   BEGIN
      IF l_kup_loc = 0
      THEN
         RETURN 0;
      ELSE
         RETURN SUBSTR ( sql_error_message_in
                       , l_kup_loc + c_kup_header_len - 1
                       , c_kup_error_len
                       );
      END IF;
   END ERROR_CODE;

   FUNCTION error_message (
      sql_error_message_in   IN   VARCHAR2
    , text_only_in           IN   BOOLEAN DEFAULT TRUE
   )
      RETURN VARCHAR2
   IS
      l_kup_loc PLS_INTEGER := kup_loc ( sql_error_message_in );
      l_start_loc PLS_INTEGER;
      l_end_loc PLS_INTEGER;
   BEGIN
      IF l_kup_loc = 0
      THEN
         RETURN NULL;
      ELSE
         -- There might be other entries after the kup one....
         l_end_loc :=
                    INSTR ( sql_error_message_in, CHR ( 10 ), l_kup_loc + 1 );

         IF l_end_loc = 0
         THEN
            l_end_loc := LENGTH ( sql_error_message_in );
         END IF;

         IF text_only_in
         THEN
            l_start_loc := l_kup_loc + c_kup_error_len + c_kup_between_len;
         ELSE
            l_start_loc := l_kup_loc + 1;
         END IF;

         RETURN SUBSTR ( sql_error_message_in
                       , l_start_loc
                       , l_end_loc - l_start_loc + 1
                       );
      END IF;
   END error_message;

   FUNCTION ERROR_CODE
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN ERROR_CODE ( NVL ( g_message, DBMS_UTILITY.format_error_stack ));
   END ERROR_CODE;

   FUNCTION error_message ( text_only_in IN BOOLEAN DEFAULT TRUE )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN error_message ( NVL ( g_message, DBMS_UTILITY.format_error_stack )
                           , text_only_in
                           );
   END error_message;
END exttab;
/
