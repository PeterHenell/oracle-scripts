DECLARE 
   itab PLVtab.integer_table;
BEGIN
   FOR rowind IN itab.FIRST .. itab.LAST
   LOOP
      NULL;
   END LOOP;
END;
/
DECLARE
   lowval INTEGER;
   hival INTEGER;
BEGIN
   FOR rowind IN lowval .. hival
   LOOP
      NULL;
   END LOOP;
END;
/
