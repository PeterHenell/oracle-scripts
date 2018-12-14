BEGIN
   /* Setup first */
   DBMS_OUTPUT.put_line (NVL (betwnstr ('abcdefg', 3, 5, TRUE)
                            , '**Really NULL**'
                             )
                        );
END;
/