CREATE OR REPLACE PACKAGE utl_file_constants
IS
   c_read_only      CONSTANT VARCHAR2 (1) := 'R';
   c_write_only     CONSTANT VARCHAR2 (1) := 'W';
   c_append         CONSTANT VARCHAR2 (1) := 'A';
   c_min_linesize   CONSTANT PLS_INTEGER  := 1;
   c_def_linesize   CONSTANT PLS_INTEGER  := 1024;
   c_max_linesize   CONSTANT PLS_INTEGER  := 32767;

   SUBTYPE max_linesize_t IS VARCHAR2 (32767);
   SUBTYPE def_linesize_t IS VARCHAR2 (1024);
   
END utl_file_constants;
/