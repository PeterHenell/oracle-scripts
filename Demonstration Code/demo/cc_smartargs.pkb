CREATE OR REPLACE PACKAGE BODY cc_smartargs
/*
Codecheck: the QA utility for PL/SQL code
Copyright (C) 2002, Steven Feuerstein
All rights reserved

cc_smartargs: Enhanced ("smart") argument information
*/
IS
   -- Store program-level information.
   g_names           cc_names.names_rt;
   --
   -- "Raw" argument data
   g_all_arguments   cc_arguments.arguments_tt;
   --
   -- "Smart" array of arguments
   g_programs        programs_t;

   PROCEDURE initialize (program_in IN VARCHAR2, show_in IN BOOLEAN)
   IS
   BEGIN
      g_programs.DELETE;
      g_all_arguments.DELETE;
      g_names := cc_names.for_program (program_in);
   END;

-- Manage names
   PROCEDURE show_names
   IS
   BEGIN
      cc_util.pl ('Object name = ' || g_names.object_name);
      cc_util.pl ('Program name = ' || g_names.package_name);
      cc_util.pl ('object name = ' || g_names.object_name);
   END;

   FUNCTION object_name
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_names.object_name;
   END;

   FUNCTION package_name
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_names.package_name;
   END;

   FUNCTION owner_name
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_names.owner;
   END;

   FUNCTION full_arg_spec (arg_in IN cc_arguments.one_argument_rt)
      RETURN VARCHAR2
   IS
      l_datatype_name   VARCHAR2 (100);
      retval            VARCHAR2 (100);
   BEGIN
      l_datatype_name := cc_types.NAME (arg_in.datatype);

      IF cc_types.is_rowtype (arg_in.datatype, arg_in.type_subname)
      THEN
         -- If subname is NULL, we have a %ROWTYPE declaration
         -- and nothing more can be known about this type -- without
         -- exporing below level 0 of the parameters.
         retval := cc_types.NAME (arg_in.datatype);
      ELSIF cc_types.is_composite_type (arg_in.datatype)
      THEN
         IF arg_in.type_subname IS NOT NULL
         THEN
            retval :=
                  arg_in.type_owner
               || '.'
               || LOWER (arg_in.type_name || '.' || arg_in.type_subname);
         ELSE
            retval := arg_in.type_owner || '.' || LOWER (arg_in.type_name);
         END IF;
      ELSE
         -- Use the actual datatype name.
         retval := cc_types.NAME (arg_in.datatype);
      END IF;

      IF cc_arguments.has_default (arg_in.DEFAULT_VALUE)
      THEN
         retval := retval || ' WITH DEFAULT';
      END IF;

      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         -- No name for this data type. What is it?
         raise_application_error (-20000
                                 ,    'No description for datatype # '
                                   || arg_in.datatype
                                 );
   END;

   FUNCTION has_no_parameters (
      program_in    IN   VARCHAR2
     ,overload_in   IN   PLS_INTEGER
   )
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN g_programs (program_in) (overload_in).PARAMETERS.COUNT = 0;
   END;

   FUNCTION parameter_count (
      program_in    IN   VARCHAR2
     ,overload_in   IN   PLS_INTEGER
   )
      RETURN INTEGER
   IS
   BEGIN
      RETURN g_programs (program_in) (overload_in).PARAMETERS.COUNT;
   END;

   FUNCTION ovld_header (
      program_in    IN   VARCHAR2
     ,overload_in   IN   PLS_INTEGER
     ,startarg_in   IN   PLS_INTEGER := NULL
     ,endarg_in     IN   PLS_INTEGER := NULL
   )
      RETURN VARCHAR2
   IS
      l_header    VARCHAR2 (2000);
      l_oneovld   one_overloading_rt
                                  := g_programs (program_in) (overload_in);
      l_onearg    VARCHAR2 (500);
      l_start     PLS_INTEGER;
      l_end       PLS_INTEGER;

      FUNCTION oneargdesc (
         arg_in         IN   cc_arguments.one_argument_rt
        ,is_return_in   IN   BOOLEAN := FALSE
      )
         RETURN VARCHAR2
      IS
      BEGIN
         IF is_return_in
         THEN
            RETURN cc_types.NAME (arg_in.datatype);
         ELSE
            RETURN    LOWER (arg_in.argument_name)
                   || ' '
                   || cc_arguments.mode_name (arg_in.in_out)
                   || ' '
                   || full_arg_spec (arg_in);
         END IF;
      END oneargdesc;
   BEGIN
      -- Construct the header for this program
      IF is_function (program_in, overload_in)
      THEN
         l_header := 'FUNCTION ' || program_in;
      ELSE
         l_header := 'PROCEDURE ' || program_in;
      END IF;

      -- Add overloading number
      l_header := l_header || '-' || overload_in;

      IF    has_no_parameters (program_in, overload_in)
         OR (startarg_in = 0 AND endarg_in = 0)
      THEN
         -- No arguments to process. We are done.
         NULL;
      ELSE
         -- More to do! For each argument, put together NAME MODE TYPE
         l_header := l_header || ' (';
         l_start := NVL (startarg_in, l_oneovld.PARAMETERS.FIRST);
         l_end := NVL (endarg_in, l_oneovld.PARAMETERS.LAST);

         FOR argindx IN l_start .. l_end
         LOOP
            l_onearg :=
                      oneargdesc (l_oneovld.PARAMETERS (argindx).toplevel);

            IF argindx = l_oneovld.PARAMETERS.FIRST
            THEN
               l_header := l_header || l_onearg;
            ELSE
               l_header := l_header || ', ' || l_onearg;
            END IF;
         END LOOP;

         l_header := l_header || ')';

         -- If a function, add a RETURN clause
         IF is_function (program_in, overload_in)
         THEN
            l_header :=
                  l_header
               || ' RETURN '
               || oneargdesc (l_oneovld.return_clause.toplevel);
         END IF;
      END IF;

      RETURN l_header || ';';
   END ovld_header;

   FUNCTION ispackage
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN g_names.ispackage;
   END;

   -- Programs to access contents of g_programs
   FUNCTION first_program
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_programs.FIRST;
   END;

   FUNCTION last_program
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_programs.LAST;
   END;

   FUNCTION next_program (program_in IN VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_programs.NEXT (program_in);
   END;

   FUNCTION prior_program (program_in IN VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_programs.PRIOR (program_in);
   END;

   FUNCTION num_programs
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN g_programs.COUNT;
   END;

-- Programs to access contents of g_programs(overloading)
   FUNCTION first_overloading (program_in IN VARCHAR2)
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN g_programs (program_in).FIRST;
   END;

   FUNCTION last_overloading (program_in IN VARCHAR2)
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN g_programs (program_in).LAST;
   END;

   FUNCTION next_overloading (
      program_in       IN   VARCHAR2
     ,overloading_in   IN   PLS_INTEGER
   )
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN g_programs (program_in).NEXT (overloading_in);
   END;

   FUNCTION prior_overloading (
      program_in       IN   VARCHAR2
     ,overloading_in   IN   PLS_INTEGER
   )
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN g_programs (program_in).PRIOR (overloading_in);
   END;

   FUNCTION num_overloadings (program_in IN VARCHAR2)
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN g_programs (program_in).COUNT;
   END;

   FUNCTION has_overloadings (program_in IN VARCHAR2)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN g_programs (program_in).COUNT > 1;
   END;

   FUNCTION is_function (program_in IN VARCHAR2, overload_in IN PLS_INTEGER)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN g_programs (program_in) (overload_in).return_clause.toplevel.object_name IS NOT NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN FALSE;
   END;

   FUNCTION first_invocation (
      program_in    IN   VARCHAR2
     ,overload_in   IN   PLS_INTEGER
   )
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN NVL (g_programs (program_in) (overload_in).last_nondefault_parm
                 ,0
                 );
   END;

   FUNCTION last_invocation (
      program_in    IN   VARCHAR2
     ,overload_in   IN   PLS_INTEGER
   )
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN g_programs (program_in) (overload_in).PARAMETERS.COUNT;
   END;

   FUNCTION full_parameter_list (
      program_in    IN   VARCHAR2
     ,overload_in   IN   PLS_INTEGER
   )
      RETURN parameters_tt
   IS
      empty_parm_list   parameters_tt;
   BEGIN
      RETURN g_programs (program_in) (overload_in).PARAMETERS;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN empty_parm_list;
   END;

   FUNCTION parameter_list (
      program_in     IN   VARCHAR2
     ,overload_in    IN   PLS_INTEGER
     ,startparm_in   IN   PLS_INTEGER := 1
     ,endparm_in     IN   PLS_INTEGER := NULL
   )
      RETURN cc_arguments.arguments_tt
   IS
      l_start        PLS_INTEGER    := GREATEST (1, NVL (startparm_in, 1));
      l_end          PLS_INTEGER;
      l_parameters   parameters_tt;
      retval         cc_arguments.arguments_tt;
      empty_list     cc_arguments.arguments_tt;
   BEGIN
      l_parameters := g_programs (program_in) (overload_in).PARAMETERS;
      l_end :=
          LEAST (l_parameters.COUNT, NVL (endparm_in, l_parameters.COUNT));

      FOR parm_indx IN l_start .. l_end
      LOOP
         retval (NVL (retval.COUNT, 0) + 1) :=
                                         l_parameters (parm_indx).toplevel;
      END LOOP;

      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN empty_list;
   END;

   FUNCTION last_non_default (
      NAME_IN       IN   VARCHAR2
     ,overload_in   IN   PLS_INTEGER
   )
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN g_programs (NAME_IN) (overload_in).last_nondefault_parm;
   EXCEPTION
      WHEN NO_DATA_FOUND OR VALUE_ERROR
      THEN
         RETURN NULL;
   END;

   PROCEDURE load_arguments (
      program_in   IN   VARCHAR2 := NULL
     ,show_in      IN   BOOLEAN := FALSE
   )
   IS
      PROCEDURE compute_derived_information
      IS
         l_argindx   PLS_INTEGER;

         PROCEDURE record_the_procedure (argindx_inout IN OUT PLS_INTEGER)
         IS
         BEGIN
            g_programs (g_all_arguments (argindx_inout).object_name)
                            (NVL (g_all_arguments (argindx_inout).overload
                                 ,0
                                 )
                            ).last_nondefault_parm := 0;
            argindx_inout := g_all_arguments.NEXT (argindx_inout);
         END record_the_procedure;

         PROCEDURE separate_return_clause_rows (
            argindx_inout   IN OUT   PLS_INTEGER
         )
         IS
            c_program    CONSTANT all_arguments.object_name%TYPE
                            := g_all_arguments (argindx_inout).object_name;
            c_overload   CONSTANT PLS_INTEGER
                      := NVL (g_all_arguments (argindx_inout).overload, 0);
            l_breakout            PLS_INTEGER                      := 1;

            PROCEDURE set_top_level_return_clause
            IS
            BEGIN
               g_programs (c_program) (c_overload).return_clause.toplevel :=
                                           g_all_arguments (argindx_inout);
            END;
         BEGIN
            set_top_level_return_clause;

            -- All the following rows in the g_all_arguments array up until
            -- the next row with a level = 0 are PART of the return clause.
            LOOP
               argindx_inout := g_all_arguments.NEXT (argindx_inout);
               EXIT WHEN (   argindx_inout IS NULL
                          OR cc_arguments.is_toplevel_parameter
                                            (g_all_arguments (argindx_inout)
                                            )
                         );
               g_programs (g_all_arguments (argindx_inout).object_name)
                                                                (c_overload).return_clause.breakouts
                                                                (l_breakout) :=
                                            g_all_arguments (argindx_inout);
               l_breakout := l_breakout + 1;
            END LOOP;
         END separate_return_clause_rows;

         PROCEDURE add_new_parameter (argindx_inout IN OUT PLS_INTEGER)
         IS
            c_program    CONSTANT all_arguments.object_name%TYPE
                            := g_all_arguments (argindx_inout).object_name;
            c_overload   CONSTANT PLS_INTEGER
                      := NVL (g_all_arguments (argindx_inout).overload, 0);
            c_position   CONSTANT PLS_INTEGER
                               := g_all_arguments (argindx_inout).POSITION;
            l_breakout_pos        PLS_INTEGER                      := 1;

            PROCEDURE set_top_level_parameter (argindx_in IN PLS_INTEGER)
            IS
            BEGIN
               g_programs (c_program) (c_overload).PARAMETERS (c_position).toplevel :=
                                              g_all_arguments (argindx_in);

               IF cc_arguments.not_defaulted (g_all_arguments (argindx_in))
               THEN
                  g_programs (c_program) (c_overload).last_nondefault_parm :=
                                                                c_position;
               END IF;
            END set_top_level_parameter;

            PROCEDURE add_breakout (argindx_in IN PLS_INTEGER)
            IS
            BEGIN
               g_programs 
                  (c_program) 
                     (c_overload)
                        .PARAMETERS 
                           (c_position)
                              .breakouts
                                  (l_breakout_pos) :=
                                       g_all_arguments (argindx_in);
            END add_breakout;
         BEGIN
            set_top_level_parameter (argindx_inout);

            LOOP
               argindx_inout := g_all_arguments.NEXT (argindx_inout);
               EXIT WHEN (   argindx_inout IS NULL
                          OR cc_arguments.is_toplevel_parameter
                                            (g_all_arguments (argindx_inout)
                                            )
                         );
               add_breakout (argindx_inout);
               l_breakout_pos := l_breakout_pos + 1;
            END LOOP;
         END add_new_parameter;
      BEGIN                             -- main compute_derived_information
         l_argindx := g_all_arguments.FIRST;

         LOOP
            EXIT WHEN l_argindx IS NULL;

            IF cc_arguments.procedure_without_parameters
                                               (g_all_arguments (l_argindx)
                                               )
            THEN
               record_the_procedure (l_argindx);
            --
            ELSIF cc_arguments.is_return_clause (g_all_arguments (l_argindx)
                                                )
            THEN
               separate_return_clause_rows (l_argindx);
            --
            ELSIF cc_arguments.is_toplevel_parameter
                                                (g_all_arguments (l_argindx)
                                                )
            THEN
               add_new_parameter (l_argindx);
            END IF;
         END LOOP;
      END compute_derived_information;
   BEGIN
      initialize (program_in, show_in);
      g_all_arguments := cc_arguments.fullset (program_in);

      IF g_all_arguments.COUNT = 0
      THEN
         cc_util.pl ('');
         cc_util.pl ('No arguments found for "' || program_in || '".');
         cc_util.pl ('');
      ELSE
         compute_derived_information;
      END IF;
   END load_arguments;

-- Show contents of arrays in various formats
   PROCEDURE pl (text_in IN VARCHAR2, indent_in IN PLS_INTEGER := 0)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (RPAD (' ', indent_in) || text_in);
   END;

   PROCEDURE pl (
      title_in         IN   VARCHAR2
     ,context_in       IN   VARCHAR2
     ,count_label_in   IN   VARCHAR2
     ,value_in         IN   VARCHAR2
     ,indent_in        IN   PLS_INTEGER := 0
   )
   IS
   BEGIN
      DBMS_OUTPUT.put_line (   RPAD (' ', indent_in)
                            || title_in
                            || ' '
                            || context_in
                            || ' - # of '
                            || count_label_in
                            || ' = '
                            || value_in
                           );
   END;

   PROCEDURE show_args (
      program_in           IN   VARCHAR2 := NULL
     ,start_in             IN   PLS_INTEGER := NULL
     ,end_in               IN   PLS_INTEGER := NULL
     ,multilevel_only_in   IN   BOOLEAN := TRUE
   )
   IS
      v_onearg          cc_arguments.one_argument_rt;
      v_last_overload   all_arguments.overload%TYPE;
      l_start           PLS_INTEGER
                                  := NVL (start_in, g_all_arguments.FIRST);
      l_end             PLS_INTEGER  := NVL (end_in, g_all_arguments.LAST);

      FUNCTION strval (num IN INTEGER, padto IN INTEGER)
         RETURN VARCHAR2
      IS
      BEGIN
         RETURN LPAD (NVL (TO_CHAR (num), 'N/A'), padto) || ' ';
      END;

      PROCEDURE show_multilevel_data
      IS
         l_program   all_arguments.object_name%TYPE;

         PROCEDURE show_overloadings (
            object_name_in   IN   all_arguments.object_name%TYPE
         )
         IS
            overloadings_for_name   overloadings_t
                                            := g_programs (object_name_in);
            overloading_index       PLS_INTEGER;
           /* Implement later as needed...
         PROCEDURE show_parameters (top_level_parms_in IN parameters_t)
           IS
              breakouts       breakouts_t;
              parm_sequence   PLS_INTEGER;

              PROCEDURE show_breakouts (breakouts_in IN breakouts_t)
              IS
                 one_argument        all_arguments%ROWTYPE;
                 breakout_position   PLS_INTEGER;
              BEGIN -- main show_breakouts
                 breakout_position := breakouts_in.FIRST;

                 LOOP
                    EXIT WHEN breakout_position IS NULL;
                    one_argument := breakouts_in (breakout_position);
                    cc_util.pl (   NVL (one_argument.argument_name, 'Anonymous')
                        || '('
                        || one_argument.data_type
                        || ') Lvl-Pos: '
                        || one_argument.data_level
                        || '-'
                        || one_argument.POSITION,
                        10
                       );
                    breakout_position := breakouts_in.NEXT (breakout_position);
                 END LOOP;
              END show_breakouts;
           BEGIN -- main show_parameters
              parm_sequence := top_level_parms_in.FIRST;

              LOOP
                 EXIT WHEN parm_sequence IS NULL;
                 breakouts := top_level_parms_in (parm_sequence);
                 cc_util.pl ('Parameter',
                     parm_sequence,
                     'Breakouts',
                     breakouts.COUNT,
                     6
                    );
              show_breakouts (breakouts);
                 parm_sequence := top_level_parms_in.NEXT (parm_sequence);
              END LOOP;
           END show_parameters;
         */
         BEGIN                                    -- main show_overloadings
            overloading_index := overloadings_for_name.FIRST;

            LOOP
               EXIT WHEN overloading_index IS NULL;
               pl
                  (   'Overloading '
                   || overloading_index
                   || ' Argument Count = '
                   || overloadings_for_name (overloading_index).PARAMETERS.COUNT
                   || ' Last Non-def pos = '
                   || overloadings_for_name (overloading_index).last_nondefault_parm
                  ,4
                  );
               --show_parameters (top_level_parms);
               overloading_index :=
                             overloadings_for_name.NEXT (overloading_index);
            END LOOP;
         END show_overloadings;
      BEGIN                                   -- main dump_multilevel_array
         IF (g_all_arguments.COUNT > 0)
         THEN
            pl ('Dump of Codecheck arrays for  "' || program_in || '"');
            pl (' ');
            pl ('Package'
               ,cc_names.combined (g_names)
               ,'Distinct Programs'
               ,g_programs.COUNT
               );
            l_program := g_programs.FIRST;

            LOOP
               EXIT WHEN l_program IS NULL;
               pl ('Name'
                  ,l_program
                  ,'Overloadings'
                  ,g_programs (l_program).COUNT
                  ,2
                  );
               show_overloadings (l_program);
               l_program := g_programs.NEXT (l_program);
            END LOOP;
         END IF;
      END show_multilevel_data;
   BEGIN
      IF program_in IS NOT NULL
      THEN
         load_arguments (program_in);
      ELSE
         -- Assume you want to see what is already loaded.
         NULL;
      END IF;

      IF g_all_arguments.COUNT > 0
      THEN
         show_multilevel_data;

         IF NOT multilevel_only_in
         THEN
            cc_util.pl
               ('OvLd Pos Lev Type         Name                               Mode  Def Len'
               );
            cc_util.pl
               ('---- --- --- ------------ --------------------------------- ------ --- ----'
               );

            FOR argrow IN
               NVL (start_in, g_all_arguments.FIRST) .. NVL
                                                          (end_in
                                                          ,g_all_arguments.LAST
                                                          )
            LOOP
               v_onearg := g_all_arguments (argrow);

               IF v_last_overload != v_onearg.overload
               THEN
                  cc_util.pl ('----');
                  v_last_overload := v_onearg.overload;
               ELSIF v_last_overload IS NULL
               THEN
                  v_last_overload := v_onearg.overload;
               END IF;

               cc_util.pl (   strval (v_onearg.overload, 4)
                           || strval (v_onearg.POSITION, 4)
                           || strval (v_onearg.data_level, 3)
                           || strval (v_onearg.datatype, 10)
                           || RPAD (   LPAD (' '
                                            , 2 * v_onearg.data_level
                                            ,' '
                                            )
                                    || NVL (v_onearg.argument_name
                                           ,'RETURN Value'
                                           )
                                   ,35
                                   )
                           || RPAD
                                  (cc_arguments.mode_name (v_onearg.in_out)
                                  ,6
                                  )
                           || strval (v_onearg.DEFAULT_VALUE, 4)
                          );
            END LOOP;
         END IF;
      END IF;
   END show_args;

   PROCEDURE show_headers (program_in IN VARCHAR2 := NULL)
   IS
      nm   all_arguments.object_name%TYPE;
   BEGIN
      IF program_in IS NOT NULL
      THEN
         load_arguments (program_in);
      ELSE
         -- Assume you want to see what is already loaded.
         NULL;
      END IF;

      IF g_programs.COUNT > 0
      THEN
         nm := g_programs.FIRST;

         LOOP
            EXIT WHEN nm IS NULL;

            FOR ovld IN g_programs (nm).FIRST .. g_programs (nm).LAST
            LOOP
               cc_util.pl (ovld_header (nm, ovld));
            END LOOP;

            cc_util.pl ('-');
            nm := g_programs.NEXT (nm);
         END LOOP;
      END IF;
   END show_headers;
END cc_smartargs;
/