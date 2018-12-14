CREATE OR REPLACE PROCEDURE show_nametoke (NAME_IN IN VARCHAR2)
IS
   a         VARCHAR2 (100);
   b         VARCHAR2 (100);
   c         VARCHAR2 (100);
   d         VARCHAR2 (100);
   nextpos   INTEGER;
BEGIN
   DBMS_UTILITY.name_tokenize (NAME         => NAME_IN
                              ,a            => a
                              ,b            => b
                              ,c            => c
                              ,dblink       => d
                              ,nextpos      => nextpos
                              );
   DBMS_OUTPUT.put_line ('Name = ' || NAME_IN);
   DBMS_OUTPUT.put_line ('a = ' || a);
   DBMS_OUTPUT.put_line ('b = ' || b);
   DBMS_OUTPUT.put_line ('c = ' || c);
END;
/

BEGIN
   show_nametoke ('emp');
/* Raises error   show_nametoke ('hr.'); */
/* This next one just ignores invalid chars, and returnS ABC. */
   show_nametoke ('abc        123');
   show_nametoke ('pkg.proc');
   show_nametoke ('scott.emp');
   show_nametoke ('scott.pkg.proc');
   show_nametoke ('"sco.tt"."pkg"."proc"');
END;
/