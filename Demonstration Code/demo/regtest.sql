rem ======================================================
rem REGTEST.SQL
rem
rem  SQL*Plus script to demonstrate the use of package 
rem  REGISTER_APP for tracking performance statistics
rem
rem ======================================================

set serveroutput on size 100000

set feedback off
rem ======================================================
rem  register module first with display OFF to
rem  initialize stats, then set display ON 
rem ======================================================
execute register_app.set_display_TF(FALSE);
execute register_app.module('REGTEST.SQL');
execute register_app.set_display_TF(TRUE);

set feedback on

rem ======================================================
rem  create a table my_dictionary copied from dictionary
rem ======================================================
execute register_app.action('CREATE');

CREATE TABLE my_dictionary
   (id, table_name, comments) 
AS
   SELECT rownum,A.* 
     FROM dictionary A;


rem ======================================================
rem  update one third of my_dictionary rows
rem ======================================================
execute register_app.action('UPDATE');

UPDATE my_dictionary
   SET comments = RPAD(comments,2000,'*')
 WHERE MOD(id,3) = 0;


rem ======================================================
rem  delete one third of my_dictionary rows
rem ======================================================
execute register_app.action('DELETE');

DELETE FROM my_dictionary
 WHERE MOD(id,3) = 1;


rem ======================================================
rem  drop table my_dictionary 
rem ======================================================
execute register_app.action('DROP');

DROP TABLE my_dictionary;


rem ======================================================
rem  unregister and display previous step stats 
rem ======================================================
execute register_app.module(null,null);


