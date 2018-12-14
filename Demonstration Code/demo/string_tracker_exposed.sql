DECLARE
   TYPE variables_needed_t
   IS
      TABLE OF VARCHAR2 (30)
         INDEX BY PLS_INTEGER;

   TYPE programs_needed_t
   IS
      TABLE OF variables_needed_t
         INDEX BY VARCHAR2 (30);

   g_programs        programs_needed_t;

   TYPE used_aat
   IS
      TABLE OF BOOLEAN
         INDEX BY VARCHAR2 (30);

   TYPE list_rt
   IS
      RECORD (description   VARCHAR2 (32767)
            , list_of_values used_aat);

   TYPE list_of_lists_aat
   IS
      TABLE OF list_rt
         INDEX BY VARCHAR2 (30);

   g_list_of_lists   list_of_lists_aat;

   progname_index    VARCHAR2 (30);
BEGIN
   /*
   initialize_prog_list (g_programs);
   */
   progname_index := g_programs.FIRST;

   WHILE (progname_index IS NOT NULL)
   LOOP
      IF g_list_of_lists.EXISTS (progname_index)
      THEN
         /* Already did this program. */
         NULL;
      ELSE
         FOR arg_index IN 1 .. g_programs (progname_index).COUNT
         LOOP
            /* If first argument for this program OR not a duplicate argument
               for this program... */
            IF NOT g_list_of_lists.EXISTS (progname_index)
               OR NOT g_list_of_lists(progname_index).list_of_values.EXISTS (
                         g_programs (progname_index) (arg_index)
                      )
            THEN
               gen_declaration (g_programs (progname_index) (arg_index));
               /* Mark it as used. */
               g_list_of_lists (
                  progname_index
               ).list_of_values (g_programs (progname_index) (arg_index)) :=
                  TRUE;
            ELSE
               /* Already did this variable. */
               NULL;
            END IF;
         END LOOP;
      END IF;

      progname_index := g_programs.NEXT (progname_index);
   END LOOP;
END;


/* And here is the encapsulated approach */

DECLARE
   c_program_list   CONSTANT string_tracker.list_name_t := 'PROGRAMS';

   TYPE variables_needed_t
   IS
      TABLE OF string_tracker.value_string_t
         INDEX BY PLS_INTEGER;

   TYPE programs_needed_t
   IS
      TABLE OF variables_needed_t
         INDEX BY string_tracker.list_name_t;

   g_programs       programs_needed_t;
   progname_index   string_tracker.list_name_t;
   l_argname        string_tracker.value_string_t;
BEGIN
   /*
   initialize_prog_list (g_programs);
   */
   progname_index := g_programs.FIRST;

   WHILE (progname_index IS NOT NULL)
   LOOP
      IF NOT string_tracker.string_in_use (c_program_list, progname_index)
      THEN
         FOR arg_index IN 1 .. g_programs (progname_index).COUNT
         LOOP
            l_argname := g_programs (progname_index) (arg_index);

            IF NOT string_tracker.string_in_use (progname_index, l_argname)
            THEN
               string_tracker.mark_as_used (progname_index, l_argname);
            END IF;
         END LOOP;
      END IF;

      progname_index := g_programs.NEXT (progname_index);
   END LOOP;
END;