CREATE OR REPLACE PACKAGE lib_custom
IS
   PROCEDURE set_context (NAME_IN IN VARCHAR2, value_in IN VARCHAR2);

   PROCEDURE set_context (NAME_IN IN VARCHAR2, value_in IN BOOLEAN);

   PROCEDURE clear_context;

   PROCEDURE pre_action (context_in IN VARCHAR2);

   FUNCTION use_alt_action (context_in IN VARCHAR2)
      RETURN BOOLEAN;

   PROCEDURE alt_action (context_in IN VARCHAR2);

   PROCEDURE post_action (
      context_in IN VARCHAR2
    , clear_context_in IN BOOLEAN DEFAULT TRUE
   );
END lib_custom;
/

CREATE OR REPLACE PACKAGE BODY lib_custom
IS
   TYPE context_aat IS TABLE OF VARCHAR2 (32767)
      INDEX BY VARCHAR2 (32767);

   g_contexts   context_aat;

   PROCEDURE set_context (NAME_IN IN VARCHAR2, value_in IN VARCHAR2)
   IS
   BEGIN
      g_contexts (NAME_IN) := value_in;
   END set_context;

   PROCEDURE set_context (NAME_IN IN VARCHAR2, value_in IN BOOLEAN)
   IS
   BEGIN
      g_contexts (NAME_IN) :=
         CASE
            WHEN value_in
               THEN 'TRUE'
            WHEN NOT value_in
               THEN 'FALSE'
            ELSE 'NULL'
         END;
   END set_context;

   PROCEDURE clear_context
   IS
   BEGIN
      g_contexts.DELETE;
   END clear_context;

   PROCEDURE pre_action (context_in IN VARCHAR2)
   IS
   BEGIN
      NULL;
   END pre_action;

   FUNCTION use_alt_action (context_in IN VARCHAR2)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN FALSE;
   END use_alt_action;

   PROCEDURE alt_action (context_in IN VARCHAR2)
   IS
   BEGIN
      NULL;
   END alt_action;

   PROCEDURE post_action (
      context_in IN VARCHAR2
    , clear_context_in IN BOOLEAN DEFAULT TRUE
   )
   IS
   BEGIN
      IF clear_context_in
      THEN
         clear_context;
      END IF;
   END post_action;
END lib_custom;
/

BEGIN
   lib_custom.set_context (NAME_IN => 'BRANCH', value_in => l_branch);
   lib_custom.set_context (NAME_IN => 'ISBN', value_in => l_isbn);
   --
   lib_custom.pre_action ('book_is_available');

   IF lib_custom.use_alt_action ('book_is_available')
   THEN
      lib_custom.alt_action ('book_is_available');
   ELSE
      l_book_is_available := lib_status.book_is_available (l_branch, l_isbn);
   END IF;

   lib_custom.post_action ('book_is_available');

   IF l_book_is_available
   THEN
      IF lib_reserve.book_is_reserved (l_branch, l_isbn)
      THEN
         l_check_out := FALSE;
      ELSE
         process_check_out (l_branch, l_isbn, l_check_out);
      END IF;
   END IF;
END;
/

CREATE OR REPLACE PACKAGE BODY lib_custom
IS
   TYPE context_aat IS TABLE OF VARCHAR2 (32767)
      INDEX BY VARCHAR2 (32767);

   g_contexts   context_aat;

   PROCEDURE set_context (NAME_IN IN VARCHAR2, value_in IN VARCHAR2)
   IS
   BEGIN
      g_contexts (NAME_IN) := value_in;
   END set_context;

   PROCEDURE set_context (NAME_IN IN VARCHAR2, value_in IN BOOLEAN)
   IS
   BEGIN
      g_contexts (NAME_IN) :=
         CASE
            WHEN value_in
               THEN 'TRUE'
            WHEN NOT value_in
               THEN 'FALSE'
            ELSE 'NULL'
         END;
   END set_context;

   PROCEDURE clear_context
   IS
   BEGIN
      g_contexts.DELETE;
   END clear_context;

   PROCEDURE pre_action (context_in IN VARCHAR2)
   IS
   BEGIN
      CASE context_in
         WHEN 'book_is_available'
         THEN
            /*
            If the author of the book is Steven Feuerstein then
            immediately order five additional copies of the book!
            */
            IF lib_lookup.author_from_isbn (g_contexts ('ISBN')) =
                                                          'Feuerstein,Steven'
            THEN
               lib_order.submit_order (g_contexts ('BRANCH')
                                     , g_contexts ('ISBN')
                                     , quantity      => 5
                                      );
            END IF;
         ELSE
            NULL;
      END CASE;
   END pre_action;

   FUNCTION use_alt_action (context_in IN VARCHAR2)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN FALSE;
   END use_alt_action;

   PROCEDURE alt_action (context_in IN VARCHAR2)
   IS
   BEGIN
      NULL;
   END alt_action;

   PROCEDURE post_action (
      context_in IN VARCHAR2
    , clear_context_in IN BOOLEAN DEFAULT TRUE
   )
   IS
   BEGIN
      IF clear_context_in
      THEN
         clear_context;
      END IF;
   END post_action;
END lib_custom;
/