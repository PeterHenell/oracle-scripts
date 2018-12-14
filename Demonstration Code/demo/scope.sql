DECLARE
   l_name   VARCHAR2 (6) := 'PL/SQL';
BEGIN
   DECLARE
      l_name   VARCHAR2 (6) := 'Oracle';
   BEGIN
      DBMS_OUTPUT.put_line (l_name);
   END;

   DBMS_OUTPUT.put_line (l_name);
END;
/

DECLARE
   l_name   VARCHAR2 (6) := 'PL/SQL';
BEGIN
   <<inner>>
   DECLARE
      l_name   VARCHAR2 (6) := 'Oracle';
   BEGIN
      DBMS_OUTPUT.put_line (l_name);
      DBMS_OUTPUT.put_line (inner.l_name);
   END;
END;
/

DECLARE
   l_name1   VARCHAR2 (6) := 'Oracle';
   l_name2   VARCHAR2 (6) := 'PL/SQL';
BEGIN
      DBMS_OUTPUT.put_line (l_name1);
      DBMS_OUTPUT.put_line (l_name2);
END;
/

DECLARE
   l_name   VARCHAR2 (6) := 'PL/SQL';
BEGIN
   DECLARE
      l_name   VARCHAR2 (6) := 'Oracle';
   BEGIN
      DBMS_OUTPUT.put_line (l_name);
   END;

   BEGIN
      DBMS_OUTPUT.put_line (l_name);
   END;
END;
/