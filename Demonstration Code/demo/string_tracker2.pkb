CREATE OR REPLACE PACKAGE BODY string_tracker
/*
Overview: String_tracker allows you to keep track of whether a
certain name has already been used within a particular list.

Author: Steven Feuerstein

You are permitted to use this code in your own applications.

Requirements:
   * Oracle9i Database Release 2 and above

*/
IS
   c_implicit_list   CONSTANT CHAR (1) := CHR (5);
   c_doesnt_matter   CONSTANT BOOLEAN := NULL;

   SUBTYPE who_cares_t IS BOOLEAN;

   TYPE used_aat IS TABLE OF who_cares_t
                       INDEX BY value_string_t;

   TYPE list_rt IS RECORD
   (
      description      maxvarchar2_t
    ,  list_of_values   used_aat
   );

   TYPE list_of_lists_aat IS TABLE OF list_rt
                                INDEX BY list_name_t;

   g_list_of_lists            list_of_lists_aat;

   PROCEDURE clear_all_lists
   IS
   BEGIN
      g_list_of_lists.delete;
   END clear_all_lists;

   PROCEDURE CLEAR_LIST (list_name_in IN list_name_t)
   IS
   BEGIN
      g_list_of_lists.delete (list_name_in);
   END CLEAR_LIST;

   PROCEDURE create_list (
      list_name_in     IN list_name_t
    ,  description_in   IN maxvarchar2_t DEFAULT NULL)
   IS
   BEGIN
      g_list_of_lists (list_name_in).description :=
         description_in;
   END create_list;

   PROCEDURE mark_as_used (
      list_name_in      IN list_name_t
    ,  value_string_in   IN value_string_t)
   IS
   BEGIN
      g_list_of_lists (list_name_in).list_of_values (
         value_string_in) :=
         c_doesnt_matter;
   END mark_as_used;

   FUNCTION string_in_use (
      list_name_in      IN list_name_t
    ,  value_string_in   IN value_string_t)
      RETURN BOOLEAN
   IS
   BEGIN
      /* AMIS training Dec 2011 - Use CASE, no variable to RETURN */
      RETURN CASE
                WHEN g_list_of_lists.EXISTS (list_name_in)
                THEN
                   g_list_of_lists (list_name_in).list_of_values.EXISTS (
                      value_string_in)
                ELSE
                   FALSE
             END;

   /* Des Moines IFMC May 2008 - do not rely on exception for failure
   RETURN g_list_of_lists(
                           list_name_in
          ).list_of_values.EXISTS( value_string_in );
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN FALSE;*/
   END string_in_use;

   /* Backward compatibility (Prague 2009)*/
   PROCEDURE clear_used_list
   IS
   BEGIN
      CLEAR_LIST (c_implicit_list);
   END;

   PROCEDURE mark_as_used (value_in IN value_string_t)
   IS
   BEGIN
      mark_as_used (c_implicit_list, value_in);
   END;

   FUNCTION string_in_use (value_in IN value_string_t)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN string_in_use (c_implicit_list, value_in);
   END;
END string_tracker;
/