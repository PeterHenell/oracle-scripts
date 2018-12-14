/* Using a nested table as a column type */

DROP TABLE family
/

CREATE OR REPLACE TYPE parent_names_t IS TABLE OF VARCHAR2 (100);
/

CREATE OR REPLACE TYPE child_names_t IS TABLE OF VARCHAR2 (100);
/

CREATE TABLE family
(
   surname          VARCHAR2 (1000)
 , parent_names     parent_names_t
 , children_names   child_names_t
)
NESTED TABLE children_names
   STORE AS parent_names_tbl                             -- (TABLESPACE USERS)
NESTED TABLE parent_names
   STORE AS children_names_tbl                            -- (TABLESPACE TEMP)
/

DECLARE
   parents    parent_names_t := parent_names_t ('Steven', 'Veva');
   children   child_names_t := child_names_t ('Chris', 'Eli');
BEGIN
   INSERT INTO family (surname, parent_names, children_names)
        VALUES ('Feuerstein', parents, children);

   COMMIT;
END;
/

SELECT * FROM family
/

/* Now change the contents of the nested table */

UPDATE TABLE (SELECT children_names
                FROM family
               WHERE surname = 'Feuerstein')
   SET COLUMN_VALUE = 'Eli Silva'
 WHERE COLUMN_VALUE = 'Eli'
/

SELECT * FROM family
/