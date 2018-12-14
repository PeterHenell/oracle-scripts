CREATE TABLE qu_template (
   ID VARCHAR2(100),
   name VARCHAR2(500),
   code CLOB
)
/
CREATE TABLE qu_assertion (
   ID VARCHAR2(100),
   name VARCHAR2(500),
   template_id VARCHAR2(100)
)
/

DECLARE
   l_guid1 qu_template.ID%TYPE;
   l_guid2 qu_template.ID%TYPE;
BEGIN
   INSERT INTO qu_template
        VALUES ( SYS_GUID, 'get_dataset_count'
               , 'BEGIN ... template code ... END;' )
     RETURNING ID
          INTO l_guid1;

   INSERT INTO qu_template
        VALUES ( SYS_GUID, 'elapsed_time_check'
               , 'BEGIN ... template code ... END;' )
     RETURNING ID
          INTO l_guid2;

   INSERT INTO qu_assertion
        VALUES ( SYS_GUID, 'Dataset contains at least one row?', l_guid1 );

   INSERT INTO qu_assertion
        VALUES ( SYS_GUID
               , '"	Elapsed time for the program is within your limit?'
               , l_guid2 );

   COMMIT;
END;
/

CREATE OR REPLACE PACKAGE qu_assertion_mgr
IS
   TYPE assertion_info_rt IS RECORD (
      assertion_row qu_assertion%ROWTYPE
    , template_row qu_template%ROWTYPE
   );

   TYPE assertions_aat IS TABLE OF assertion_info_rt
      INDEX BY qu_assertion.ID%TYPE;

   g_assertions assertions_aat;

   TYPE id_by_name_aat IS TABLE OF qu_assertion.ID%TYPE
      INDEX BY qu_assertion.name%TYPE;

   g_ids_by_name id_by_name_aat;

   PROCEDURE load_assertion_data;

   FUNCTION onerow_by_guid ( guid_in IN qu_assertion.ID%TYPE )
      RETURN assertion_info_rt;

   FUNCTION onerow_by_name ( NAME_IN IN qu_assertion.name%TYPE )
      RETURN assertion_info_rt;

   FUNCTION template_for_assertion ( guid_in IN qu_assertion.ID%TYPE )
      RETURN qu_template%ROWTYPE;
END qu_assertion_mgr;
/

CREATE OR REPLACE PACKAGE BODY qu_assertion_mgr
IS
   PROCEDURE load_assertion_data
   IS
      TYPE assertions_by_guid_aat IS TABLE OF qu_assertion%ROWTYPE
         INDEX BY PLS_INTEGER;

      l_assertions assertions_by_guid_aat;
   BEGIN
      SELECT *
      BULK COLLECT INTO l_assertions
        FROM qu_assertion;

      FOR indx IN 1 .. l_assertions.COUNT
      LOOP
         g_assertions ( l_assertions ( indx ).ID ).assertion_row :=
                                                          l_assertions ( indx );
         g_ids_by_name ( l_assertions ( indx ).name ) :=
                                                       l_assertions ( indx ).ID;

         SELECT *
           INTO g_assertions ( l_assertions ( indx ).ID ).template_row
           FROM qu_template
          WHERE id = l_assertions ( indx ).template_id;
      END LOOP;
   END load_assertion_data;

   FUNCTION onerow_by_guid ( guid_in IN qu_assertion.ID%TYPE )
      RETURN assertion_info_rt
   IS
   BEGIN
      RETURN g_assertions ( guid_in );
   END onerow_by_guid;

   FUNCTION onerow_by_name ( NAME_IN IN qu_assertion.name%TYPE )
      RETURN assertion_info_rt
   IS
   BEGIN
      RETURN g_assertions ( g_ids_by_name ( NAME_IN ));
   END onerow_by_name;

   FUNCTION template_for_assertion ( guid_in IN qu_assertion.ID%TYPE )
      RETURN qu_template%ROWTYPE
   IS
   BEGIN
      RETURN g_assertions ( guid_in ).template_row;
   END template_for_assertion;
BEGIN
   load_assertion_data;
END qu_assertion_mgr;
/
