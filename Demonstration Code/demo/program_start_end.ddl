DROP TABLE program_start_end;

CREATE TABLE program_start_end (
   owner VARCHAR2(100),
   PACKAGE_name VARCHAR2(100),
   program_name VARCHAR2(100),
   start_line INTEGER,
   end_line INTEGER);
