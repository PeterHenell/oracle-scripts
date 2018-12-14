DECLARE
   dir CONSTANT VARCHAR2(100) := 'e:\photos\childhouse';
   files PLVtab.vc2000_table;
   filenum PLS_INTEGER;
   renamed BOOLEAN;
BEGIN
   xfile.getdirContents (dir, files);
   filenum := files.FIRST;
   LOOP
      EXIT WHEN filenum IS NULL;
      IF UPPER (files(filenum)) LIKE 'PIC000%'
      THEN
         p.l ('renaming ' ||
            dir || '\' || files(filenum) || 
            ' to ' ||
            dir || '\' || 'before' || SUBSTR (files(filenum), 7, 2)
               || '.jpg'
            );
            
         renamed := xfile.rename (
            dir || '\' || files(filenum),
            dir || '\' || 'before' || SUBSTR (files(filenum), 7, 2)
            );
         
      END IF;
      filenum := files.NEXT (filenum);
   END LOOP;
END;
/