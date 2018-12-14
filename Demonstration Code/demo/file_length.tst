/* need create any directory privilege to use */
CREATE OR REPLACE directory demodir AS 'd:\demo';

CREATE OR REPLACE PROCEDURE Test_File_Length (
   file_in         IN   VARCHAR2,
   oradir_in IN VARCHAR2,
   iterations_in   IN   INTEGER,
   delim_in        IN   VARCHAR2 := '\'
)
IS
   len             PLS_INTEGER;
   lfile           VARCHAR2 (100);
   delim_loc       PLS_INTEGER    := INSTR (file_in, delim_in, -1);
   loblength_tmr   tmr_t          := tmr_t.make ('Dbms_Lob', iterations_in);
   jlength_tmr     tmr_t          := tmr_t.make ('JFILE', iterations_in);
BEGIN
   lfile := SUBSTR (file_in, delim_loc + 1);
   loblength_tmr.GO;

   FOR indx IN 1 .. iterations_in
   LOOP
      len := Xfile.loblength (oradir_in, lfile);
   END LOOP;

   loblength_tmr.STOP;
   jlength_tmr.GO;

   FOR indx IN 1 .. iterations_in
   LOOP
      len := Xfile.LENGTH (file_in);
   END LOOP;

   jlength_tmr.STOP;
END;
/
