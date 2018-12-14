--@@DISPLAY_CLOB.SP

DECLARE
   n NUMBER;
   x XMLTYPE;                                  -- Oracle9i Only!
   c CLOB;
   DDL SYS.ku$_ddls;
BEGIN
   n := DBMS_METADATA.OPEN ('PROCEDURE');
   DBMS_METADATA.set_filter (n
                           , 'NAME_EXPR'
                           , '= ''DISPLAY_CLOB'''
                            );
   x := DBMS_METADATA.fetch_xml (n);
   --p.l (x.getstringval ());
   p.l (x);
 --   c := DBMS_METADATA.fetch_clob (n);
-- display_clob (c);

--ddl := dbms_metadata.fetch_ddl (n);
--p.l (ddl.count);
END;
/