CREATE OR REPLACE TYPE field_names_t IS TABLE OF VARCHAR2 (30)
/

CREATE OR REPLACE TYPE field_values_t IS TABLE OF VARCHAR2 (32767)
/

CREATE OR REPLACE PACKAGE record_to_array
IS
   PROCEDURE move_record_to_arrays (
      table_in          IN     VARCHAR2
    , row_identifier_in IN     VARCHAR2
    , date_mask_in      IN     VARCHAR2 DEFAULT NULL
    , field_names_out      OUT field_names_t
    , values_out           OUT field_values_t
    , trace_in          IN     BOOLEAN DEFAULT FALSE
   );

   PROCEDURE display_record (table_in          IN VARCHAR2
                           , row_identifier_in IN VARCHAR2
                           , trace_in          IN BOOLEAN DEFAULT FALSE
                            );
END record_to_array;
/

CREATE OR REPLACE PACKAGE BODY record_to_array
IS
   PROCEDURE move_record_to_arrays (
      table_in          IN     VARCHAR2
    , row_identifier_in IN     VARCHAR2
    , date_mask_in      IN     VARCHAR2 DEFAULT NULL
    , field_names_out      OUT field_names_t
    , values_out           OUT field_values_t
    , trace_in          IN     BOOLEAN DEFAULT FALSE
   )
   IS
      c_assign_placeholder   CONSTANT VARCHAR2 (100) := 'ASSIGN-VALUES-HERE';
      c_field_retrieval_block CONSTANT VARCHAR2 (32767)
            :=    'DECLARE
   l_row            '
               || table_in
               || '%ROWTYPE;
   v_column_name    VARCHAR2 (30);
   v_column_value   VARCHAR2 (200);
   l_names    field_names_t := field_names_t();
   l_values   field_values_t := field_values_t();
BEGIN
   SELECT *
     INTO l_row
     FROM '
               || table_in
               || '
    WHERE '
               || row_identifier_in
               || ';'
               || c_assign_placeholder
               || ':field_names := l_names;
   :field_values := l_values;
END;' ;
      l_names                field_names_t := field_names_t ();
      l_values               field_values_t := field_values_t ();

      FUNCTION column_assignments (table_in IN VARCHAR2)
         RETURN VARCHAR2
      IS
         l_return   VARCHAR2 (32767);
      BEGIN
         FOR columns_rec IN (SELECT column_name, data_type
                               FROM user_tab_columns
                              WHERE table_name = table_in)
         LOOP
            l_return :=
                  l_return
               || 'l_values.EXTEND; l_names.EXTEND;'
               || 'l_names(l_values.count) := '''
               || columns_rec.column_name
               || '''; l_values(l_values.count) := '
               || CASE columns_rec.data_type
                     WHEN 'DATE'
                     THEN
                        'TO_CHAR (l_row.' || columns_rec.column_name
                        || CASE
                              WHEN date_mask_in IS NULL THEN NULL
                              ELSE ', ''' || date_mask_in || ''''
                           END
                        || ')'
                     ELSE
                        'l_row.' || columns_rec.column_name
                  END
               || ';'
               || CHR (10);
         END LOOP;

         RETURN l_return;
      END column_assignments;
   BEGIN
      IF trace_in
      THEN
         DBMS_OUTPUT.
         put_line (
            REPLACE (c_field_retrieval_block
                   , c_assign_placeholder
                   , column_assignments (table_in)
                    )
         );
      END IF;

      EXECUTE IMMEDIATE REPLACE (c_field_retrieval_block
                               , c_assign_placeholder
                               , column_assignments (table_in)
                                )
         USING OUT l_names, OUT l_values;

      field_names_out := l_names;
      values_out := l_values;
   END move_record_to_arrays;

   PROCEDURE display_record (table_in          IN VARCHAR2
                           , row_identifier_in IN VARCHAR2
                           , trace_in          IN BOOLEAN DEFAULT FALSE
                            )
   IS
      l_names    field_names_t := field_names_t ();
      l_values   field_values_t := field_values_t ();
   BEGIN
      DBMS_OUTPUT.
      put_line (
            'Contents of row from '
         || table_in
         || ' WHERE '
         || row_identifier_in
      );
      move_record_to_arrays (table_in
                           , row_identifier_in
                           , 'YYYY MON DD'
                           , l_names
                           , l_values
                           , trace_in
                            );

      FOR indx IN 1 .. l_names.COUNT
      LOOP
         DBMS_OUTPUT.put_line (l_names (indx) || ' = ' || l_values (indx));
      END LOOP;
   END display_record;
END record_to_array;
/

BEGIN
   record_to_array.display_record ('EMPLOYEES', 'EMPLOYEE_ID = 100', FALSE);
   record_to_array.display_record ('DEPARTMENTS', 'DEPARTMENT_ID = 90', FALSE);
END;
/