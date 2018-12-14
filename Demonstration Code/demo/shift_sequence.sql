CREATE OR REPLACE PROCEDURE shift_sequence (
   table_name_in    IN VARCHAR2
 , column_name_in   IN VARCHAR2
 , sequence_name_in IN VARCHAR2 DEFAULT NULL
 , trace_in         IN BOOLEAN DEFAULT FALSE
)
IS
   c_sequence   VARCHAR2 (200)
                   := UPPER (NVL (sequence_name_in, table_name_in || '_SEQ'));
   l_currval    PLS_INTEGER;
   l_highval    PLS_INTEGER;

   FUNCTION current_value
      RETURN PLS_INTEGER
   IS
      retval   PLS_INTEGER;
   BEGIN
      EXECUTE IMMEDIATE 'SELECT ' || c_sequence || '.CURRVAL FROM dual'
         INTO retval;

      RETURN retval;
   END current_value;

   PROCEDURE increment_sequence
   IS
      l_dummy   PLS_INTEGER;
   BEGIN
      EXECUTE IMMEDIATE 'SELECT ' || c_sequence || '.NEXTVAL FROM dual'
         INTO l_dummy;

      IF trace_in
      THEN
         DBMS_OUTPUT.put_line (' Next value = ' || l_dummy);
      END IF;
   END increment_sequence;
BEGIN
   EXECUTE IMMEDIATE   'SELECT MAX ('
                    || column_name_in
                    || ') from '
                    || table_name_in
      INTO l_highval;

   IF trace_in
   THEN
      DBMS_OUTPUT.
      put_line ('Request to move ' || c_sequence || ' up to ' || l_highval);
   END IF;

   LOOP
      -- Have to increment to make sure CURRVAL
      increment_sequence;
      l_currval := current_value;

      IF trace_in
      THEN
         DBMS_OUTPUT.put_line (' Current value = ' || l_currval);
      END IF;

      EXIT WHEN l_currval >= l_highval;
   END LOOP;

   IF trace_in
   THEN
      DBMS_OUTPUT.put_line ('Moved ' || c_sequence || ' up to ' || l_currval);
   END IF;
END;
/