CONNECT sys/sys AS SYSDBA

DROP USER u1 CASCADE
/
GRANT RESOURCE, CONNECT TO u1 IDENTIFIED BY p
/
DROP USER u2 CASCADE
/
GRANT RESOURCE, CONNECT TO u2 IDENTIFIED BY p
/
DROP USER view_owner CASCADE
/
GRANT RESOURCE, CONNECT TO view_owner IDENTIFIED BY p
/
CONNECT view_owner/p
CREATE TABLE tbl (c VARCHAR2(30))
/
INSERT INTO tbl
     VALUES ('This is view_owner')
/
CREATE OR REPLACE VIEW vw
AS
   SELECT *
     FROM tbl
/
GRANT SELECT ON view_owner.vw TO PUBLIC
/

CONNECT u1/p
CREATE TABLE tbl (c VARCHAR2(30))
/

CREATE OR REPLACE PROCEDURE authid_with_view_test
AUTHID CURRENT_USER
IS
   s   view_owner.vw.c%TYPE;
   d   view_owner.vw.c%TYPE;
BEGIN
   SELECT c
     INTO s
     FROM view_owner.vw;

   EXECUTE IMMEDIATE 'select c from view_owner.vw'
                INTO d;

   DBMS_OUTPUT.put_line ('Static: ' || s || ' / Dynamic: ' || d);
END authid_with_view_test;
/

GRANT EXECUTE ON authid_with_view_test TO PUBLIC
/
INSERT INTO tbl
     VALUES ('this is u1')
/
CONNECT u2/p
CREATE TABLE tbl (c VARCHAR2(30))
/

CREATE OR REPLACE PROCEDURE authid_with_view_test
AUTHID CURRENT_USER
IS
   s   view_owner.vw.c%TYPE;
   d   view_owner.vw.c%TYPE;
BEGIN
   SELECT c
     INTO s
     FROM view_owner.vw;

   EXECUTE IMMEDIATE 'select c from view_owner.vw'
                INTO d;

   DBMS_OUTPUT.put_line ('Static: ' || s || ' / Dynamic: ' || d);
END authid_with_view_test;
/

GRANT EXECUTE ON authid_with_view_test TO PUBLIC
/
INSERT INTO tbl
     VALUES ('this is u2')
/
