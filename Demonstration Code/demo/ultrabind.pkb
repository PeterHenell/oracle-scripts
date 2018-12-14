CREATE OR REPLACE PACKAGE BODY ultrabind
/*
   Author: Steven Feuerstein, steven@stevenfeuerstein.com
           Copyright 2006, Steven Feuerstein
   
   Permissions: you may use this code in your applications, and change
   it freely. You may not sell this software or otherwise market it as
   your own. 
   
*/
IS
   SUBTYPE maxvarchar2_t IS VARCHAR2 ( 32767 );

   TYPE g_bindings_tt IS TABLE OF maxvarchar2_t
      INDEX BY maxvarchar2_t;

   g_bindings g_bindings_tt;
   g_start_delimiter maxvarchar2_t;
   g_end_delimiter maxvarchar2_t;

   PROCEDURE clear_settings
   IS
   BEGIN
      g_bindings.DELETE;
      g_start_delimiter := NULL;
      g_end_delimiter := NULL;
   END clear_settings;

   PROCEDURE set_delimiters ( start_in IN VARCHAR2, end_in IN VARCHAR2 )
   IS
   BEGIN
      g_start_delimiter := start_in;
      g_end_delimiter := end_in;
   END set_delimiters;

   PROCEDURE bind_text ( placeholder_in IN VARCHAR2, text_in IN VARCHAR2 )
   IS
   BEGIN
      g_bindings ( placeholder_in ) := text_in;
   END bind_text;

   FUNCTION substituted_string ( string_in IN VARCHAR2 )
      RETURN VARCHAR2
   IS
      l_name maxvarchar2_t;
      l_return maxvarchar2_t := string_in;
   BEGIN
      -- For each binding in the list, perform the replacement. 
      l_name := g_bindings.FIRST;

      WHILE ( l_name IS NOT NULL )
      LOOP
         l_return :=
            REPLACE ( l_return
                    , g_start_delimiter || l_name || g_end_delimiter
                    , g_bindings ( l_name )
                    );
         l_name := g_bindings.NEXT ( l_name );
      END LOOP;

      RETURN l_return;
   END substituted_string;
END ultrabind;
/
