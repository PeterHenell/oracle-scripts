DECLARE
   l_string   VARCHAR2 (100) := '?taerg LQS/LP t''nsI';
BEGIN
   DBMS_OUTPUT.put_line (
      UTL_RAW.cast_to_varchar2 (
         UTL_RAW.reverse (UTL_RAW.cast_to_raw (l_string))));
END;