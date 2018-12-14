CREATE OR REPLACE PROCEDURE gen_trace_call (
   pkg_or_prog_in VARCHAR2
 , pkg_subprog_in VARCHAR2 DEFAULT NULL
 , nest_tracing_in IN BOOLEAN DEFAULT TRUE
 , tracing_enabled_func_in IN VARCHAR2 DEFAULT 'qd_runtime.trace_enabled'
 , trace_func_in IN VARCHAR2 DEFAULT ' qd_runtime.trace'
)
IS
   CURSOR arg_info_cur (
      prog_in IN VARCHAR2
    , subprog_in IN VARCHAR2 DEFAULT NULL
   )
   IS
      SELECT argument_name, data_type
        FROM user_arguments
       WHERE (   (package_name = prog_in AND subprog_in IS NULL)
              OR (package_name IS NULL AND object_name = prog_in)
              OR (package_name = prog_in AND object_name = subprog_in)
             )
         AND data_level = 0
         AND in_out IN ('IN', 'IN OUT');

   l_parmlist   VARCHAR2 (32767);
BEGIN
   FOR rec IN arg_info_cur (pkg_or_prog_in, pkg_subprog_in)
   LOOP
      l_parmlist :=
            l_parmlist
         || '|| '' - '
         || rec.argument_name
         || '='' || '
         || rec.argument_name
         || CHR (10)
         || '      ';
   END LOOP;

   DBMS_OUTPUT.put_line (   'BEGIN '
                         || CHR (10)
                         || '   IF '
                         || tracing_enabled_func_in
                         || ' THEN '
                         || CHR (10)
                         || '      '
                         || trace_func_in
                         || ' ('''
                         || pkg_or_prog_in
                         || CASE
                               WHEN pkg_subprog_in IS NULL
                                  THEN NULL
                               ELSE '.' || pkg_subprog_in
                            END
                         || ''', '
                         || LTRIM (RTRIM (RTRIM (LTRIM (l_parmlist, '|| ')
                                               , '='' || '
                                                )
                                        , '- '
                                         )
                                 , ' - '
                                  )
                         || '      );'
                         || CHR (10)
                         || '   END IF;'
                         || CHR (10)
                         || 'END;'
                        );
END gen_trace_call;
/

BEGIN
   /* Compile betwnstr.sf files. */
   gen_trace_call ('BETWNSTR');
   /* Compile dyn_placeholder.pks/pkb files. */
   gen_trace_call ('DYN_PLACEHOLDER', 'ALL_IN_STRING');
   gen_trace_call (pkg_or_prog_in               => 'DYN_PLACEHOLDER'
                 , pkg_subprog_in               => 'ALL_IN_STRING'
                 , tracing_enabled_func_in      => 'mypkg.tracing_on ()'
                 , trace_func_in                => 'mupkg.show_action'
                  );
END;
/