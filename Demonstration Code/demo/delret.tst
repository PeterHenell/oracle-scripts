DECLARE
   enametab DBMS_SQL.VARCHAR2_TABLE;
BEGIN
   enametab(1) := 'S%';
   enametab(2) := 'T%';
   delemps (enametab);
END;
/