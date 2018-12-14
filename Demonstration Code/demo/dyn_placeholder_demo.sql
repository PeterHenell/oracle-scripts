SET SERVEROUTPUT ON

DECLARE
   c_dyn_block CONSTANT VARCHAR2 ( 32767 )
      := 'BEGIN DBMS_OUTPUT.PUT_LINE (:string1); DBMS_OUTPUT.PUT_LINE (:date1); END;';
   --
   l_placeholders dyn_placeholder.placeholder_aat;
   cur PLS_INTEGER := DBMS_SQL.open_cursor;
   fdbk PLS_INTEGER;
BEGIN
   l_placeholders := dyn_placeholder.all_in_string ( c_dyn_block );
   --
   DBMS_SQL.parse ( cur, c_dyn_block, DBMS_SQL.native );

   FOR indx IN 1 .. l_placeholders.COUNT
   LOOP
      IF l_placeholders ( indx ).NAME LIKE 'STRING%'
      THEN
         DBMS_SQL.bind_variable ( cur, l_placeholders ( indx ).NAME
                                , 'Steven' );
      ELSIF l_placeholders ( indx ).NAME LIKE 'DATE%'
      THEN
         DBMS_SQL.bind_variable ( cur, l_placeholders ( indx ).NAME, SYSDATE );
      END IF;
   END LOOP;

   fdbk := DBMS_SQL.EXECUTE ( cur );
   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/
