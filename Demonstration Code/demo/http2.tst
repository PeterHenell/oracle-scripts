DECLARE 
   postback VARCHAR2(500) :=
      'sbdev1/intelisys/login.jsp?' ||
      'OBIUSERNAME=15445&&' ||
      'OBIPASSWORD=9QI8sk&&' ||
      'OBIREQID=1&&' ||
      'OBIPOSTBACKURL=http://www.stevenfeuerstein.com/';
      
   sqlrequest VARCHAR2(500) :=
      '209.31.81.38:81/admin/httpquery.jsp?' ||
      'sql=select+table_name+from+user_tables';
BEGIN
   p.l (http.request ('www.starbelly.com'));
   
   p.l (http.request (postback, show_err_in => TRUE));
   
   p.l (http.request (sqlrequest, show_err_in => TRUE));
END;
/
         