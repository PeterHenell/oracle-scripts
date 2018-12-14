CREATE OR REPLACE PROCEDURE post_processed
IS
BEGIN
   $IF $$plsql_optimize_level = 1
   $THEN
      -- Slow and easy
      NULL;
   $ELSE
      -- Fast and modern and easy
      NULL;
   $END
END post_processed;
/

BEGIN
   DBMS_PREPROCESSOR.print_post_processed_source ('PROCEDURE'
                                                , USER
                                                , 'POST_PROCESSED'
                                                 );
END;
/

ALTER PROCEDURE post_processed COMPILE plsql_optimize_level = 1
/

DECLARE
   l_postproc_code   DBMS_PREPROCESSOR.source_lines_t;
   l_row             PLS_INTEGER;
BEGIN
   l_postproc_code :=
      DBMS_PREPROCESSOR.get_post_processed_source ('PROCEDURE'
                                                 , USER
                                                 , 'POST_PROCESSED'
                                                  );
   l_row := l_postproc_code.FIRST;

   WHILE (l_row IS NOT NULL)
   LOOP
      DBMS_OUTPUT.put_line(   LPAD (l_row, 3)
                           || ' - '
                           || RTRIM (l_postproc_code (l_row), CHR (10)));
      l_row := l_postproc_code.NEXT (l_row);
   END LOOP;
END;
/

DECLARE
   l_code     DBMS_SQL.varchar2a;
   l_source   VARCHAR2 (32767);
BEGIN
     SELECT text
       BULK COLLECT
       INTO l_code
       FROM user_source
      WHERE name = 'POST_PROCESSED' AND TYPE = 'PROCEDURE'
   ORDER BY line;

   FOR indx IN 1 .. l_code.COUNT
   LOOP
      l_source := l_source || l_code (indx);
   END LOOP;

   DBMS_PREPROCESSOR.print_post_processed_source (l_source);
END;
/