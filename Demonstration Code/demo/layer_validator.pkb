CREATE OR REPLACE PACKAGE BODY layer_validator
IS
   TYPE flat_pattern_rt IS RECORD (
      layer     PLS_INTEGER
    , pattern   VARCHAR2 (100)
   );

   TYPE flat_patterns_aat IS TABLE OF flat_pattern_rt
      INDEX BY PLS_INTEGER;

   TYPE dependencies_aat IS TABLE OF all_dependencies%ROWTYPE
      INDEX BY PLS_INTEGER;

   g_trc   BOOLEAN DEFAULT FALSE;

   PROCEDURE set_trace (on_in IN BOOLEAN DEFAULT TRUE)
   IS
   BEGIN
      g_trc := on_in;
   END set_trace;

   PROCEDURE copy_patterns_to_list (
      layer_patterns_in IN layer_patterns_aat
    , flat_patterns_out IN OUT flat_patterns_aat
   )
   IS
      l_layer_index     PLS_INTEGER;
      l_pattern_index   PLS_INTEGER;
   BEGIN
      l_layer_index := layer_patterns_in.FIRST;

      WHILE (l_layer_index IS NOT NULL)
      LOOP
         IF g_trc
         THEN
            DBMS_OUTPUT.put_line (   '** copy_patterns_to_list from layer '
                                  || l_layer_index
                                 );
         END IF;

         l_pattern_index := layer_patterns_in (l_layer_index).FIRST;

         WHILE (l_pattern_index IS NOT NULL)
         LOOP
            IF g_trc
            THEN
               DBMS_OUTPUT.put_line
                            (   '** copy_patterns_to_list add pattern '
                             || layer_patterns_in (l_layer_index)
                                                              (l_pattern_index)
                            );
            END IF;

            flat_patterns_out (flat_patterns_out.COUNT + 1).layer :=
                                                                 l_layer_index;
            flat_patterns_out (flat_patterns_out.LAST).pattern :=
                           layer_patterns_in (l_layer_index) (l_pattern_index);
            l_pattern_index :=
                      layer_patterns_in (l_layer_index).NEXT (l_pattern_index);
         END LOOP;

         l_layer_index := layer_patterns_in.NEXT (l_layer_index);
      END LOOP;
   END copy_patterns_to_list;

   FUNCTION matching_pattern (
      flat_patterns_in flat_patterns_aat
    , program_in IN VARCHAR2
   )
      RETURN flat_pattern_rt
   IS
      l_pattern_index   PLS_INTEGER;
      l_match_found     BOOLEAN         DEFAULT FALSE;
      l_return          flat_pattern_rt;
   BEGIN
      IF g_trc
      THEN
         DBMS_OUTPUT.put_line ('** matching_pattern check for ' || program_in);
      END IF;

      /*
      Scan through the patterns until I can apply LIKE successful to it for the program.
      */
      l_pattern_index := flat_patterns_in.FIRST;

      WHILE (l_pattern_index IS NOT NULL AND NOT l_match_found)
      LOOP
         IF g_trc
         THEN
            DBMS_OUTPUT.put_line
                                (   '** matching_pattern checking against "'
                                 || flat_patterns_in (l_pattern_index).pattern
                                 || '"'
                                );
         END IF;

         l_match_found :=
                    program_in LIKE flat_patterns_in (l_pattern_index).pattern;

         IF l_match_found
         THEN
            IF g_trc
            THEN
               DBMS_OUTPUT.put_line ('** matching_pattern match found! ');
            END IF;

            l_return := flat_patterns_in (l_pattern_index);
         END IF;

         l_pattern_index := flat_patterns_in.NEXT (l_pattern_index);
      END LOOP;

      RETURN l_return;
   END matching_pattern;

   PROCEDURE validate_program (
      schema_in IN VARCHAR2
    , program_in IN VARCHAR2
    , layer_patterns_in IN layer_patterns_aat
    , only_show_matches_in IN BOOLEAN DEFAULT FALSE
   )
   IS
      g_all_patterns   flat_patterns_aat;
      g_dependencies   dependencies_aat;
      l_pattern        flat_pattern_rt;

      PROCEDURE extract_all_dependencies (
         dependencies_out IN OUT dependencies_aat
      )
      IS
      BEGIN
         SELECT *
         BULK COLLECT INTO dependencies_out
           FROM all_dependencies ad
          WHERE ad.NAME = program_in AND ad.owner = schema_in;

         IF g_trc
         THEN
            DBMS_OUTPUT.put_line
                             (   '** extract_all_dependencies; COUNT found: '
                              || dependencies_out.COUNT
                             );
         END IF;
      END extract_all_dependencies;

      PROCEDURE validate_dependencies (
         dependencies_in IN dependencies_aat
       , program_layer_in IN PLS_INTEGER
      )
      IS
         c_referenced   CONSTANT tb_string_tracker.list_name_t
                                                              := 'referenced';
         l_dep_pattern           flat_pattern_rt;
         l_violation_found       BOOLEAN                       DEFAULT FALSE;
      BEGIN
         IF g_trc
         THEN
            DBMS_OUTPUT.put_line (   '** validate_dependencies at layer '
                                  || program_layer_in
                                 );
         END IF;

         tb_string_tracker.create_list (c_referenced);

         /* For each dependency, get its parent and see if its layer number
            exceeds the program's layer.*/
         FOR indx IN 1 .. dependencies_in.COUNT
         LOOP
            l_dep_pattern :=
               matching_pattern (g_all_patterns
                               , dependencies_in (indx).referenced_name
                                );

            IF g_trc
            THEN
               DBMS_OUTPUT.put_line (   '** validate_dependencies program "'
                                     || dependencies_in (indx).referenced_name
                                     || '" matches pattern "'
                                     || l_dep_pattern.pattern
                                     || '" at layer '
                                     || l_dep_pattern.layer
                                    );
            END IF;

            IF     l_dep_pattern.layer > program_layer_in
               AND NOT tb_string_tracker.string_in_use
                                        (c_referenced
                                       ,    dependencies_in (indx).owner
                                         || '.'
                                         || dependencies_in (indx).referenced_name
                                        )
            THEN
               DBMS_OUTPUT.put_line (   '> VIOLATION! Object "'
                                     || dependencies_in (indx).owner
                                     || '.'
                                     || dependencies_in (indx).referenced_name
                                     || '" is in layer '
                                     || l_dep_pattern.layer
                                     || '.'
                                    );
               l_violation_found := TRUE;
               tb_string_tracker.mark_as_used
                                        (c_referenced
                                       ,    dependencies_in (indx).owner
                                         || '.'
                                         || dependencies_in (indx).referenced_name
                                        );
            END IF;
         END LOOP;

         IF NOT l_violation_found
         THEN
            DBMS_OUTPUT.put_line ('> NO VIOLATIONS FOUND!');
         END IF;
      END validate_dependencies;

      PROCEDURE show_header
      IS
      BEGIN
         DBMS_OUTPUT.put_line (   RPAD ('=', 60, '=')
                               || CHR (10)
                               || 'Validating layer usage for "'
                               || schema_in
                               || '.'
                               || program_in
                               || '"'
                              );
      END show_header;
   BEGIN
      copy_patterns_to_list (layer_patterns_in, g_all_patterns);
      /*
      For a single program, the questions are:

      * Does this program name fit one of the layer patterns?
      * If not, there is nothing to validate.
      * If yes, then we want to make sure that all programs it uses
        must reside in a lower layer.
      */
      l_pattern := matching_pattern (g_all_patterns, program_in);

      IF l_pattern.pattern IS NULL
      THEN
         IF NOT only_show_matches_in
         THEN
            show_header;
            /* This program does not fit into any of the layers. */
            DBMS_OUTPUT.put_line
                  (   '> Program "'
                   || program_in
                   || '" does not match any of the layers '
                   || 'you specified. Remember: the analysis is case sensitive!'
                  );
         END IF;
      ELSE
         show_header;
         DBMS_OUTPUT.put_line (   '> Program "'
                               || program_in
                               || '" has been found in layer '
                               || l_pattern.layer
                               || ', which is associated with filter "'
                               || l_pattern.pattern
                               || '".'
                              );
         extract_all_dependencies (g_dependencies);
         validate_dependencies (g_dependencies, l_pattern.layer);
      END IF;
   END validate_program;

   PROCEDURE validate_schema (
      schema_in IN VARCHAR2
    , layer_patterns_in IN layer_patterns_aat
   )
   IS
   BEGIN
      FOR object_rec IN (SELECT *
                           FROM user_objects
                          WHERE object_type IN
                                   ('PACKAGE'
                                  , 'PROCEDURE'
                                  , 'FUNCTION'
                                  , 'TRIGGER'
                                  , 'TYPE'
                                   ))
      LOOP
         validate_program (USER
                         , object_rec.object_name
                         , layer_patterns_in
                         , only_show_matches_in      => TRUE
                          );
      END LOOP;
   END validate_schema;
END layer_validator;
/