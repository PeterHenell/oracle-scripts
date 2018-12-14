DECLARE
   v1 VARCHAR2 (32767);
   v2 VARCHAR2 (32767);
   v3 VARCHAR2 (32767);

   PROCEDURE droptab (tab_in IN VARCHAR2)
   IS
   BEGIN
      EXECUTE IMMEDIATE 'drop table ' || tab_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   PROCEDURE maketab (str_in IN VARCHAR2)
   IS
   BEGIN
      EXECUTE IMMEDIATE str_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         p.l (LENGTH (str_in));
   END;
BEGIN
   droptab ('xyzxyz');
   droptab ('abcabc');
   droptab ('defdef');
   v1 := RPAD ('create table ', 32750) || 'xyzxyz (d date)';

   EXECUTE IMMEDIATE v1;

   v1 := RPAD ('create ', 32755) || 'table abcabc';
   v2 := RPAD ('( ', 32760) || 'd date)';
   p.l (LENGTH (v1 || v2));

   EXECUTE IMMEDIATE v1 || v2;

   v1 := RPAD ('create ', 32755) || 'table defdef';
   v2 := RPAD ('( ', 32760) || 'd date,';
   v3 := 'e date)';
   --v3 := RPAD ('e ', 32760) || 'date)';
   --p.l (LENGTH (v1 || v2 || v3));

   EXECUTE IMMEDIATE v1 || v2 || v3;
END;