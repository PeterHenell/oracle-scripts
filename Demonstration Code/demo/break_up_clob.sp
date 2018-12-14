CREATE OR REPLACE FUNCTION break_up_clob (
   clob_in IN CLOB
 , buffer_size_in IN PLS_INTEGER
)
   RETURN qu_config.maxvarchar2_aat
IS
   l_buffer qu_config.maxvarchar2;           -- Avoid value error on varchar2
   l_position PLS_INTEGER := 1;
   l_buffer_size PLS_INTEGER := buffer_size_in;
   l_return qu_config.maxvarchar2_aat;
BEGIN
   LOOP
      DBMS_LOB.READ (clob_in, l_buffer_size, l_position, l_buffer);
      l_return (l_return.COUNT + 1) := l_buffer;
      l_position := l_position + buffer_size_in;
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND OR VALUE_ERROR
   THEN
      RETURN l_return;
END;
/
