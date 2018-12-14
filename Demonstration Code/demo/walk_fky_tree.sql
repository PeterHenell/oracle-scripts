/*
Not used....we can have tables that have looped foreign keys
and so the connect by start with approach with not work.

Search for *+/ if you want to restore original comments.

TYPE tree_rt IS RECORD (
   LEVEL                    PLS_INTEGER
 , universal_id             VARCHAR2 (100)
 , child_owner              VARCHAR2 (100)
 , child_table_name         VARCHAR2 (100)
 , child_dblink             VARCHAR2 (100)
 , child_constraint_name    VARCHAR2 (100)
 , parent_owner             VARCHAR2 (100)
 , parent_table_name        VARCHAR2 (100)
 , parent_dblink            VARCHAR2 (100)
 , parent_constraint_name   VARCHAR2 (100)
);

TYPE fkys_aat IS TABLE OF all_constraints%ROWTYPE
   INDEX BY PLS_INTEGER;

TYPE table_info_rt IS RECORD (
   contains_self_ref     BOOLEAN
 , child_selfref_name    VARCHAR2 (100)
 , parent_selfref_name   VARCHAR2 (100)
);

TYPE table_info_aat IS TABLE OF table_info_rt
   INDEX BY VARCHAR2 (100);

g_tables_processed   table_info_aat;
PROCEDURE build_fky_tree (
   owner_in    IN   VARCHAR2
 , table_in    IN   VARCHAR2
 , dblink_in   IN   VARCHAR2 DEFAULT NULL
)
IS
   PROCEDURE build_fky_tree_rec (
      owner_in    IN   VARCHAR2
    , table_in    IN   VARCHAR2
    , dblink_in   IN   VARCHAR2 DEFAULT NULL
   )
   IS
      l_owners                 DBMS_SQL.varchar2s;
      l_tables                 DBMS_SQL.varchar2s;
      l_fky_constraint_names   DBMS_SQL.varchar2s;
      l_pky_constraint_names   DBMS_SQL.varchar2s;

      PROCEDURE add_table (
         owner_in                 IN   VARCHAR2
       , table_in                 IN   VARCHAR2
       , pky_owner_in             IN   VARCHAR2 DEFAULT NULL
       , pky_table_in             IN   VARCHAR2 DEFAULT NULL
       , fky_constraint_name_in   IN   VARCHAR2 DEFAULT NULL
       , pky_constraint_name_in   IN   VARCHAR2 DEFAULT NULL
      )
      IS
         PRAGMA AUTONOMOUS_TRANSACTION;
         l_count   PLS_INTEGER;
      BEGIN
         IF qu_runtime.trace_enabled
         THEN
            qu_runtime.TRACE ('build_fky_tree add_table'
                            ,    owner_in
                              || '-'
                              || table_in
                              || '-'
                              || pky_owner_in
                              || '-'
                              || pky_table_in
                             );
         END IF;

         IF pky_owner_in IS NULL
         THEN
            /*

            CURRENT: Delete everything from table at the start. We may
                     want to change this in the future.

            The starting point, so get rid of any rows that exist for
            this table. Then insert with parent NULL information.
            DELETE FROM qu_dbc_fky_tree
                  WHERE child_owner = owner_in
                    AND child_table_name = table_in;
            *+/
            INSERT INTO qu_dbc_fky_tree
                        (universal_id, child_owner, child_table_name
                       , child_dblink, child_constraint_name
                       , parent_owner, parent_table_name, parent_dblink
                       , parent_constraint_name, created_on, created_by
                       , changed_on, changed_by
                        )
                 VALUES (qu_config.standard_guid, owner_in, table_in
                       , NULL, fky_constraint_name_in
                       , NULL, NULL, NULL
                       , NULL, SYSDATE, USER
                       , SYSDATE, USER
                        );

            IF qu_runtime.trace_enabled
            THEN
               qu_runtime.TRACE ('build_fky_tree add null sql%rowcount'
                               , SQL%ROWCOUNT
                                );
            END IF;
         ELSE
            DECLARE
               l_dummy   CHAR (1);
            BEGIN
               /* If this particular combination already exists, skip it. *+/
               SELECT 'x'
                 INTO l_dummy
                 FROM qu_dbc_fky_tree
                WHERE child_owner = owner_in
                  AND child_table_name = table_in
                  AND parent_owner = pky_owner_in
                  AND parent_table_name = pky_table_in;

               NULL;
            EXCEPTION
               WHEN OTHERS
               THEN
                  /* No match. If child = parent info, then we have a
                     self-ref, so mark that in the appropriate column.
                  *+/
                  IF owner_in = pky_owner_in AND table_in = pky_table_in
                  THEN
                     g_tables_processed (key_value (owner_in, table_in)).contains_self_ref :=
                                                                      TRUE;
                     g_tables_processed (key_value (owner_in, table_in)).child_selfref_name :=
                                                    fky_constraint_name_in;
                     g_tables_processed (key_value (owner_in, table_in)).parent_selfref_name :=
                                                    pky_constraint_name_in;
                  /*UPDATE qu_dbc_fky_tree
                     SET contains_self_ref = qu_config.c_yes
                       , child_constraint_name = fky_constraint_name_in
                       , parent_constraint_name = pky_constraint_name_in
                   WHERE child_owner = owner_in
                     AND child_table_name = table_in;*+/
                  ELSE
                     /* If current parent info if null, fill it.
                        Otherwise time to insert a new one.
                     *+/
                     UPDATE qu_dbc_fky_tree
                        SET parent_owner = pky_owner_in
                          , parent_table_name = pky_table_in
                          , child_constraint_name = fky_constraint_name_in
                          , parent_constraint_name = pky_constraint_name_in
                      WHERE child_owner = owner_in
                        AND child_table_name = table_in
                        AND parent_owner IS NULL;

                     IF qu_runtime.trace_enabled
                     THEN
                        qu_runtime.TRACE
                           ('build_fky_tree update w/parent sql%rowcount'
                          , SQL%ROWCOUNT
                           );
                     END IF;

                     IF SQL%ROWCOUNT = 0
                     THEN
                        INSERT INTO qu_dbc_fky_tree
                                    (universal_id, child_owner
                                   , child_table_name, child_dblink
                                   , child_constraint_name
                                   , parent_owner, parent_table_name
                                   , parent_dblink
                                   , parent_constraint_name, created_on
                                   , created_by, changed_on, changed_by
                                    )
                             VALUES (qu_config.standard_guid, owner_in
                                   , table_in, NULL
                                   , fky_constraint_name_in
                                   , pky_owner_in, pky_table_in
                                   , NULL
                                   , pky_constraint_name_in, SYSDATE
                                   , USER, SYSDATE, USER
                                    );

                        IF qu_runtime.trace_enabled
                        THEN
                           qu_runtime.TRACE
                              ('build_fky_tree add w/parent sql%rowcount'
                             , SQL%ROWCOUNT
                              );
                        END IF;
                     END IF;
                  END IF;
            END;
         END IF;

         COMMIT;
      END add_table;
   BEGIN
      IF g_tables_processed.EXISTS (key_value (owner_in, table_in))
      THEN
         /* Already did this; so do not go down this route again. *+/
         NULL;
      ELSE
         /* Initialize entry, as not having a selfref FKY. *+/
         g_tables_processed (key_value (owner_in, table_in)).contains_self_ref :=
                                                                     FALSE;
         /*
         Insert the starting point: no foreign key found yet.
         *+/
         add_table (owner_in, table_in);

         SELECT pkys.owner, pkys.table_name, pkys.constraint_name
              , fkys.constraint_name
         BULK COLLECT INTO l_owners, l_tables, l_pky_constraint_names
              , l_fky_constraint_names
           FROM all_constraints fkys, all_constraints pkys
          WHERE pkys.constraint_type = 'P'
            AND fkys.constraint_type = 'R'
            AND fkys.r_owner = pkys.owner
            AND fkys.r_constraint_name = pkys.constraint_name
            AND fkys.owner = owner_in
            AND fkys.table_name = table_in;

         FOR indx IN 1 .. l_owners.COUNT
         LOOP
            add_table (owner_in
                     , table_in
                     , l_owners (indx)
                     , l_tables (indx)
                     , l_fky_constraint_names (indx)
                     , l_pky_constraint_names (indx)
                      );

            /* Do not recurse if a self-ref FKY. *+/
            IF owner_in = l_owners (indx) AND table_in = l_tables (indx)
            THEN
               NULL;
            ELSE
               build_fky_tree_rec (l_owners (indx), l_tables (indx));
            END IF;
         END LOOP;
      END IF;
   END build_fky_tree_rec;
BEGIN
   DELETE FROM qu_dbc_fky_tree;

   COMMIT;
   build_fky_tree_rec (owner_in       => owner_in
                     , table_in       => table_in
                     , dblink_in      => dblink_in
                      );
END build_fky_tree;

FUNCTION table_tree_cv
   RETURN sys_refcursor
IS
   CV   sys_refcursor;
BEGIN
   OPEN CV FOR
      SELECT     LEVEL, universal_id, child_owner, child_table_name
               , child_dblink, child_constraint_name, parent_owner
               , parent_table_name, parent_dblink, parent_constraint_name
            FROM qu_dbc_fky_tree t
      START WITH t.parent_table_name IS NULL
      CONNECT BY PRIOR t.child_table_name = t.parent_table_name
             AND t.child_owner = t.parent_owner;

   RETURN CV;
END table_tree_cv;
*/