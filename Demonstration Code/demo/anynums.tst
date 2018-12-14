@@wildside.sql
@@anynums.pkg

DECLARE
   mynums   anynums_pkg.numbers_t;
BEGIN
   mynums := anynums_pkg.getvals;
   DBMS_OUTPUT.PUT_LINE (mynums.count);
   mynums := anynums_pkg.getvals ('> 100');
   DBMS_OUTPUT.PUT_LINE (mynums.count);
END;
/
