CREATE SEQUENCE type_table_seq
/
CREATE TABLE type_table (
  ID          INTEGER      NOT NULL,
  CATEGORY    VARCHAR2(500) NOT NULL,
  NAME        VARCHAR2(500) NOT NULL,
  description VARCHAR2(4000),
  is_default  CHAR(1) DEFAULT 'N',
  created_on  DATE,
  created_by  VARCHAR2(100),
  changed_on  DATE,
  changed_by  VARCHAR2(100)
)
/
ALTER TABLE type_table ADD (
  CONSTRAINT pk_type_table PRIMARY KEY (ID),
  CONSTRAINT un_type_table UNIQUE (CATEGORY, NAME))
/
CREATE OR REPLACE TRIGGER type_table_bir
   BEFORE INSERT
   ON type_table
   FOR EACH ROW
DECLARE
BEGIN
   IF :NEW.ID IS NULL
   THEN
      SELECT type_table_seq.NEXT
        INTO :NEW.ID
        FROM DUAL;
   END IF;

   :NEW.created_on := SYSDATE;
   :NEW.created_by := USER;
   :NEW.changed_on := SYSDATE;
   :NEW.changed_by := USER;
END type_table_bir;
/
CREATE OR REPLACE TRIGGER type_table_bur
   BEFORE UPDATE
   ON type_table
   FOR EACH ROW
DECLARE
BEGIN
   :NEW.changed_on := SYSDATE;
   :NEW.changed_by := USER;
END type_table_bur;
/