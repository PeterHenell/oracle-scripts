CREATE OR REPLACE TYPE plch_glass_type IS OBJECT
(
   name VARCHAR2 (100),
   shape VARCHAR2 (100),
   is_transparent CHAR (1)
)
/

CREATE TABLE plch_windows
(
   glass_type   plch_glass_type,
   location     VARCHAR2 (100)
)
/

/* ORA-02303: cannot drop or replace a type with type or table dependents */

DROP TYPE plch_glass_type
/

SELECT COUNT(*)
  FROM USER_OBJECTS
 WHERE object_name = 'PLCH_GLASS_TYPE'
/

/* Drop table first, then type */

DROP TABLE plch_windows
/

DROP TYPE plch_glass_type
/

SELECT COUNT(*)
  FROM USER_OBJECTS
 WHERE object_name = 'PLCH_GLASS_TYPE'
/

/* First, recreate objects, then use FORCE */

CREATE OR REPLACE TYPE plch_glass_type IS OBJECT
(
   name VARCHAR2 (100),
   shape VARCHAR2 (100),
   is_transparent CHAR (1)
)
/

CREATE TABLE plch_windows
(
   glass_type   plch_glass_type,
   location     VARCHAR2 (100)
)
/

DROP TYPE plch_glass_type FORCE
/

SELECT COUNT(*)
  FROM USER_OBJECTS
 WHERE object_name = 'PLCH_GLASS_TYPE'
/

/* Recreate objects and then try to use unsupported syntax:

ORA-00933: SQL command not properly ended 

*/

DROP TABLE plch_windows
/

CREATE OR REPLACE TYPE plch_glass_type IS OBJECT
(
   name VARCHAR2 (100),
   shape VARCHAR2 (100),
   is_transparent CHAR (1)
)
/

CREATE TABLE plch_windows
(
   glass_type   plch_glass_type,
   location     VARCHAR2 (100)
)
/

DROP TYPE plch_glass_type CASCADE DROP
/

SELECT COUNT(*)
  FROM USER_OBJECTS
 WHERE object_name = 'PLCH_GLASS_TYPE'
/

/* Clean up */

DROP TABLE plch_windows
/

DROP TYPE plch_glass_type
/