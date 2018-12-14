DECLARE
   v_str PLV.dbmaxvc2 :=
     'this is a really long string which I have concatenated ' ||
     'so that it will be readable in the file, but in actuality ' ||
     'it is so long that if you use the wrong utility to display ' ||
     'this line it will actually generate an error. If you use the ' ||
     'right utility then you can set the line length and set the ' ||
     'to preserve leading blanks and in general have a much easier ' ||
     'time displaying information from within your PL/SQL programs.';
BEGIN
   BEGIN
      DBMS_OUTPUT.PUT_LINE (v_str);
   EXCEPTION
      WHEN OTHERS 
      THEN
         p.l ('whoops with DBMS_OUTPUT.PUT_LINE!');
   END;
   p.l (v_str);
END;
/
