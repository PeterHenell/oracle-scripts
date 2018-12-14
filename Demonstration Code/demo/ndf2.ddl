DROP TABLE ndf_column
/

DROP TABLE ndf_table
/

CREATE TABLE ndf_table (
   owner VARCHAR2(30),
   table_name VARCHAR2(30),
   ndf_value ANYDATA
)
/
 
ALTER TABLE ndf_table ADD CONSTRAINT ndf_table_pk
   PRIMARY KEY (owner, table_name)
/
 
CREATE TABLE ndf_column (
   owner VARCHAR2(30),
   table_name VARCHAR2(30),
   column_name VARCHAR2(30), 
   ndf_value ANYDATA
)
/
 
ALTER TABLE ndf_column ADD CONSTRAINT ndf_column_pk
   PRIMARY KEY (owner, table_name, column_name)
/
 
ALTER TABLE ndf_column ADD (
  CONSTRAINT ndf_column_fk
   FOREIGN KEY (owner, table_name)
   REFERENCES ndf_table (owner, table_name) ON DELETE CASCADE)
/   

