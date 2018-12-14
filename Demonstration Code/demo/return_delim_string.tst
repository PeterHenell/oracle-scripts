DECLARE
   l_string   VARCHAR2 (32767);
BEGIN
   l_string := allrows_by;
   
   DBMS_OUTPUT.put_line (l_string);
   --
   l_string :=
      allrows_by (append_to_from_in        => 'where department_id = 10'
                , row_delimiter_in         => '*'
                , column_delimiter_in      => '#'
                 );
   DBMS_OUTPUT.put_line (l_string);
END;
/
