CREATE OR REPLACE PROCEDURE chgext (
   dir IN VARCHAR2,
   newext IN VARCHAR2,
   filter IN VARCHAR2 := '%',
   sep IN VARCHAR2 := '\',
   delim IN VARCHAR2 := '.')
IS   
   files PLVtab.vc2000_table;
   filenum PLS_INTEGER;
   v_file VARCHAR2(1000);
   renamed BOOLEAN;
BEGIN
   xfile.getdirContents (dir, filter, files, FALSE);
   filenum := files.FIRST;
   LOOP
      EXIT WHEN filenum IS NULL;
      v_file := 
         SUBSTR (files(filenum), 1, 
            INSTR (files(filenum), delim, -1));
      renamed := xfile.rename (
         dir || sep || files(filenum),
         dir || sep || v_file || newext,
         showme => TRUE
         );
      filenum := files.NEXT (filenum);
   END LOOP;
END;
/