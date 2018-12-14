CREATE OR REPLACE PROCEDURE who_did_that (emp_in IN emp.empno%TYPE)
IS
   l_string        VARCHAR2 (32767);
   fid             UTL_FILE.file_type;
   list_of_names   DBMS_SQL.varchar2s;

   PROCEDURE get_lines
   IS
      l_string   VARCHAR2 (32767);
   BEGIN
      DBMS_OUTPUT.put_line (l_string);
      fid := UTL_FILE.fopen ('c:\temp', 'notme.sql', 'R');
      UTL_FILE.get_line (fid, l_string);
      UTL_FILE.get_line (fid, l_string);
   END get_lines;
BEGIN
   SELECT ename
     INTO l_string
     FROM emp
    WHERE empno = emp_in;

   get_lines;
   
   display_name (l_string);
   l_string := list_of_names (100);

   IF l_string LIKE 'Steven%'
   THEN
      DBMS_OUTPUT.put_line ('Same first name!');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('No data found, which means what?');
END who_did_that;
/