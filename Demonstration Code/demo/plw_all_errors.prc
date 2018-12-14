ALTER SESSION SET plsql_warnings = 'error:all'
/

CREATE OR REPLACE PROCEDURE plch_procedure
AS
BEGIN
   NULL;
END;
/

CREATE OR REPLACE PROCEDURE plch_procedure
   AUTHID CURRENT_USER
AS
   l_checking   BOOLEAN := FALSE;
BEGIN
   IF l_checking
   THEN
      DBMS_OUTPUT.put_line ('Checking');
   ELSE
      DBMS_OUTPUT.put_line ('Not checking');
   END IF;
END;
/

CREATE OR REPLACE PROCEDURE plch_procedure
   AUTHID DEFINER
AS
BEGIN
   DBMS_OUTPUT.put_line (1 / 0);
END;
/

CREATE OR REPLACE PROCEDURE plch_procedure (
   n IN OUT DBMS_SQL.varchar2a)
   AUTHID DEFINER
AS
BEGIN
   DBMS_OUTPUT.put_line (n.COUNT);
END;
/

CREATE OR REPLACE PROCEDURE plch_procedure
   AUTHID CURRENT_USER
AS
   l_name VARCHAR2(5) := 'Steven';
BEGIN
   DBMS_OUTPUT.put_line (l_name);
END;
/