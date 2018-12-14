DECLARE
   l_the_type   ANYTYPE;
BEGIN
   FOR rec IN (SELECT *
                 FROM wild_side)
   LOOP
      CASE rec.DATA.gettype (l_the_type)
         WHEN DBMS_TYPES.typecode_number
         THEN
            DBMS_OUTPUT.put_line
                   (   'Row '
                    || rec.ID
                    || ' contains number = '
                    || rec.DATA.accessnumber
                   );
         WHEN DBMS_TYPES.typecode_varchar2
         THEN
            DBMS_OUTPUT.put_line
                    (   'Row '
                     || rec.ID
                     || ' varchar2 = '
                     || rec.DATA.accessvarchar2
                    );
         WHEN DBMS_TYPES.typecode_date
         THEN
            DBMS_OUTPUT.put_line
                        (   'Row '
                         || rec.ID
                         || ' date = '
                         || rec.DATA.accessdate
                        );
         ELSE
            DBMS_OUTPUT.put_line
               (   'Row '
                || rec.ID
                || ' contains data of type = '
                || rec.DATA.gettype
                                  (l_the_type)
               );
      END CASE;
   END LOOP;
END;
/