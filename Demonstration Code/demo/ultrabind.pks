CREATE OR REPLACE PACKAGE ultrabind
/*
   Overview:
   
   The ultrabind package performs a process similar to  binding
   of values to placeholders in a string. The limitation on binding
   with dynamic SQL is that you can only bind variable values. So if
   you want to include chunks of SQL syntax or the name of a table,
   you must use concatenation, which can result in very hard to read
   and maintain code. With ultrabind, you can write a single literal
   string and include placeholders for *anything*. You can then bind
   one or more placeholders with the text as desired, and finally
   call the replaced_string function to do all the replacements you 
   have requested and return the fully-expanded string.
   
   If you plan to use delimiters to identify all of your placeholders,
   such as < and >, you can set those delimiters as the default so that
   you don't have to include them in every call to bind_text.
   
   Requirements: Oracle9i Database Release 2 and above (relies on
      INDEX BY VARCHAR2 associative arrays)
	  
   Example:
   
   DECLARE
      c_template VARCHAR2(32767) :=
	     'BEGIN
		    <varname> := <expression>;
		  END;';
      new_string VARCHAR2(32767);		  
   BEGIN
      ultrabind.clear_settings;
	  ultrabind.set_delimiters ('<', '>');
	  ultrabind.bind_text ('varname', 'my_package.global_variable');
	  ultrabind.bind_text ('expression', 'USER || USER');
	  new_string := ultrabind.substituted_string (c_template);
   END;	  
   
   Author: Steven Feuerstein, steven@stevenfeuerstein.com
           Copyright 2006, Steven Feuerstein
   
   Permissions: you may use this code in your applications, and change
   it freely. You may not sell this software or otherwise market it as
   your own. 
   
*/
IS
   -- Clear out delimiters and any bindings.
   PROCEDURE clear_settings;

   -- Set the default delimiters for use in this binding.
   PROCEDURE set_delimiters ( start_in IN VARCHAR2, end_in IN VARCHAR2 );

   -- Bind a placeholder to a text value.
   PROCEDURE bind_text ( placeholder_in IN VARCHAR2, text_in IN VARCHAR2 );

   -- Replace all placeholders in the specified string with their text 
   -- and return the expanded string.
   FUNCTION substituted_string ( string_in IN VARCHAR2 )
      RETURN VARCHAR2;
END ultrabind;
/
