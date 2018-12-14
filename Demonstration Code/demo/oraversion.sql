DECLARE
   l_full_version VARCHAR2 ( 100 );
BEGIN
   SELECT SUBSTR ( t.banner
                 , INSTR ( t.banner, 'Release' ) + 8
                 ,   INSTR ( t.banner, ' ', INSTR ( t.banner, 'Release' ) + 8 )
                   - INSTR ( t.banner, 'Release' )
                   - 8
                 ) AS cfull_version
     INTO l_full_version
     FROM SYS.v_$version t
    WHERE UPPER ( t.banner ) LIKE '%ORACLE%';

   DBMS_OUTPUT.put_line ( l_full_version );
END;
/
