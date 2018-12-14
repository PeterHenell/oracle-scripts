CREATE OR REPLACE PACKAGE exttab
/*
   Overview: Use exttab to extract errors specific to external table
             problems, that are embedded in the error stack and 
			 start with the prefix KUP-.
			 
   Author: Steven Feuerstein, steven@stevenfeuerstein.com
           Copyright 2006, Steven Feuerstein
   
   Permissions: you may use this code in your applications, and change
   it freely. You may not sell this software or otherwise market it as
   your own. 
   
*/
IS
   PROCEDURE set_custom_error_message ( text_in IN VARCHAR2 );

   FUNCTION ERROR_CODE ( sql_error_message_in IN VARCHAR2 )
      RETURN PLS_INTEGER;

   FUNCTION error_message (
      sql_error_message_in   IN   VARCHAR2
    , text_only_in           IN   BOOLEAN DEFAULT TRUE
   )
      RETURN VARCHAR2;

   FUNCTION ERROR_CODE
      RETURN PLS_INTEGER;

   FUNCTION error_message ( text_only_in IN BOOLEAN DEFAULT TRUE )
      RETURN VARCHAR2;
END exttab;
/
