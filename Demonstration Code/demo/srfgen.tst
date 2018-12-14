BEGIN
   DELETE FROM srf_repository;

   DELETE FROM srf_tab_repository
         WHERE table_name = 'EMPLOYEE';

   DELETE FROM srf_col_repository
         WHERE table_name = 'EMPLOYEE';

   INSERT INTO srf_repository
               (query_mechanism, cache_data, nrf_value, too_many_rows_code
               ,when_others_code
               )
        VALUES ('I', 'N', NULL, 'log.err'
               ,NULL
               );

   INSERT INTO srf_tab_repository
        VALUES ('SCOTT', 'EMPLOYEE', 'I', 'N', NULL, NULL, NULL);

   INSERT INTO srf_col_repository
               (owner, table_name, column_name, column_list, code, data_type
               ,nrf_value
               )
        VALUES ('SCOTT', 'EMPLOYEE', 'LAST_NAME', NULL, NULL, NULL
               ,NULL
               );

   INSERT INTO srf_col_repository
               (owner, table_name, column_name, column_list
               ,code
               ,data_type, nrf_value
               )
        VALUES ('SCOTT', 'EMPLOYEE', 'FULL_NAME', NULL
               ,'hr_employee_rules_pkg.fullname (last_name, first_name, 1)'
               ,'varchar2(500)', 'XXX'
               );

   COMMIT;
   srf.genpkgs ('employee');
END;
/

