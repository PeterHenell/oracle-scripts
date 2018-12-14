DROP TYPE object_type;

CREATE TYPE object_type AS OBJECT (
   NAME   VARCHAR2 (100)
)
/

CREATE OR REPLACE PACKAGE all_types
IS
   TYPE nested_table_type IS TABLE OF INTEGER;

   TYPE VARRAY_type IS VARRAY (1) OF INTEGER;

   TYPE RECORD_type IS RECORD (
      d   DATE
   );

   TYPE indexby_table_type IS TABLE OF INTEGER
      INDEX BY BINARY_INTEGER;

   PROCEDURE all_types_proc (
      c1    VARCHAR2
     ,c2    NVARCHAR2
     ,c3    NUMBER
     ,c4    INTEGER
     ,c5    LONG
     ,c6    VARCHAR
     ,c7    ROWID
     ,c8    DATE
     ,c9    RAW
     ,c10   LONG RAW
     ,c11   BINARY_INTEGER
     ,c12   PLS_INTEGER
     ,c13   ROWID
     ,c14   CHAR
     ,c15   NCHAR
     ,c16   sys_refcursor
     ,c17   MLSLABEL
     ,c19   CLOB
     ,c20   NCLOB
     ,c21   BLOB
     ,c22   BFILE
     -- Not recognized ,c23   CFILE
     ,c24   object_type
     ,c25   nested_table_type
     ,c26   VARRAY_type
     ,c27   record_type
     ,c28   indexby_table_type
     ,c29   BOOLEAN
   );
END;
/

SELECT argument_name
      ,data_type
  FROM all_arguments
 WHERE owner = USER
   AND package_name = 'ALL_TYPES';