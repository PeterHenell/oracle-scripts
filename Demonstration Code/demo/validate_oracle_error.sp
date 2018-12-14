CREATE OR REPLACE PROCEDURE validate_oracle_error (
   code_in        IN       PLS_INTEGER
 , message_out    OUT      VARCHAR2
 , is_valid_out   OUT      BOOLEAN
)
IS
   l_message   VARCHAR2(32767);
BEGIN
   l_message := SQLERRM (code_in);

   -- If SQLERRM does not find an entry, it return a string like this:
   -- ORA-NNNNN: Message NNNN not found;  product=RDBMS; facility=ORA
   IF l_message LIKE 'ORA-_____: Message%not found;%'
   THEN
      message_out := NULL;
      is_valid_out := FALSE;
   ELSE
      message_out := l_message;
      is_valid_out := TRUE;
   END IF;
END validate_oracle_error;
/