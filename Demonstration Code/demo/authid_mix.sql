CONNECT scott/tiger

DROP TABLE authid_mix_table;

CREATE TABLE authid_mix_table (nm VARCHAR2(30));

INSERT INTO authid_mix_table
     VALUES ('SCOTT');

COMMIT ;

CREATE OR REPLACE PROCEDURE authid_mix_proc
AUTHID CURRENT_USER
IS
   l_nm      authid_mix_table.nm%TYPE;
   l_count   INTEGER;
BEGIN
   SELECT nm
     INTO l_nm
     FROM authid_mix_table;

   DBMS_OUTPUT.put_line (l_nm);

   SELECT COUNT (*)
     INTO l_count
     FROM all_source
    WHERE NAME = 'AUTHID_MIX_PROC'
	  AND OWNER = USER;

   DBMS_OUTPUT.put_line (l_count);
END;
/

GRANT EXECUTE ON authid_mix_proc TO demo;

CONNECT demo/demo

SET serveroutput on

CREATE OR REPLACE PROCEDURE authid_mix_proc
AUTHID CURRENT_USER
IS
BEGIN
   DBMS_OUTPUT.put_line ('DUMMY');
END;
/

DROP TABLE authid_mix_table;

CREATE TABLE authid_mix_table (nm VARCHAR2(30));

INSERT INTO authid_mix_table
     VALUES ('DEMO');
	 
EXEC scott.authid_mix_proc