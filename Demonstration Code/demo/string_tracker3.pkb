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

   TYPE list_rt IS RECORD (case_sensitive BOOLEAN, list_of_values used_aat);

   TYPE list_of_lists_aat IS TABLE OF list_rt
                                INDEX BY list_name_t;

   g_list_of_lists   list_of_lists_aat;

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

   PROCEDURE create_list (list_name_in      IN list_name_t
                        , case_sensitive_in IN BOOLEAN DEFAULT FALSE
                        , overwrite_in      IN BOOLEAN DEFAULT TRUE
                         )
   IS
      l_create_list   BOOLEAN DEFAULT TRUE;
      l_new_list      list_rt;
   BEGIN
      IF g_list_of_lists.EXISTS (list_name_in)
      THEN
         l_create_list := overwrite_in;
      END IF;

      IF l_create_list
      THEN
         l_new_list.case_sensitive := case_sensitive_in;
         g_list_of_lists (list_name_in) := l_new_list;
      END IF;
   END create_list;

   FUNCTION sensitized_value (list_name_in    IN list_name_t
                            , value_string_in IN value_string_t
                             )
      RETURN value_string_t
   IS
   BEGIN
      RETURN CASE g_list_of_lists (list_name_in).case_sensitive
                WHEN TRUE THEN value_string_in
                ELSE UPPER (value_string_in)
             END;
   END sensitized_value;

   FUNCTION string_in_use (list_name_in    IN list_name_t
                         , value_string_in IN value_string_t
                          )
      RETURN BOOLEAN
   IS
      PROCEDURE initialize
      IS
      BEGIN
         assert.is_not_null (
            list_name_in
          , 'You must provide a non-NULL name for your list!'
         );
         assert.is_not_null (
            value_string_in
          , 'You must provide a non-NULL string for tracking!'
         );
         assert.is_true (
            g_list_of_lists.EXISTS (list_name_in)
          ,    'You must create your list named "'
            || list_name_in
            || '" before you can use it.'
         );
      END initialize;
   BEGIN
      initialize;
      RETURN g_list_of_lists(list_name_in).list_of_values.EXISTS (
                sensitized_value (list_name_in, value_string_in)
             );
   END string_in_use;

   PROCEDURE mark_as_used (list_name_in    IN list_name_t
                         , value_string_in IN value_string_t
                          )
   IS
      PROCEDURE initialize
      IS
      BEGIN
         assert.is_not_null (
            list_name_in
          , 'You must provide a non-NULL name for your list!'
         );
         assert.is_not_null (
            value_string_in
          , 'You must provide a non-NULL string for tracking!'
         );
         assert.is_true (
            g_list_of_lists.EXISTS (list_name_in)
          ,    'You must create your list named "'
            || list_name_in
            || '" before you can use it.'
         );
      END initialize;
   BEGIN
      initialize;
      g_list_of_lists (
         list_name_in
      ).list_of_values (sensitized_value (list_name_in, value_string_in)) :=
         c_doesnt_matter;
   END mark_as_used;

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