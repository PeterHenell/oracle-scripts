CREATE OR REPLACE PROCEDURE test_files_are_equal (version_in IN VARCHAR2)
IS
   l_result       qu_config.maxvarchar2;
   l_result_row   qu_result_xp.last_run_results_api_cur%ROWTYPE;
   my_results     qu_result_xp.last_run_results_api_rc;
BEGIN
   qu_test.run_test_for2 (owner_in                    => USER
                        , NAME_IN                     => 'FILES_ARE_EQUAL'
                        , result_out                  => l_result
                        , results_out                 => my_results
                        , unit_test_guid_list_in      => NULL
                        , test_case_guid_list_in      => NULL
                        , delimiter_in                => NULL
                         );
   DBMS_OUTPUT.put_line ('***********************************************');
   DBMS_OUTPUT.put_line (   'Overall result for "'
                         || version_in
                         || '": '
                         || l_result
                        );

   IF l_result <> qu_result_xp.c_success
   THEN
      LOOP
         FETCH my_results
          INTO l_result_row;

         EXIT WHEN my_results%NOTFOUND;
         DBMS_OUTPUT.put_line (   RPAD (' ', l_result_row.h_level * 2)
                               || ' '
                               || l_result_row.NAME
                               || '-Status: '
                               || l_result_row.result_status
                               || '-Description: '
                               || l_result_row.description
                              );
      END LOOP;
   END IF;
END;
/