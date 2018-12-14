/* Formatted by PL/Formatter v3.1.2.1 on 2000/12/10 02:43 */
/*
Package Generator

Note:

They have the following structure
mk_<operation name>_dbproc   : Generates a standalone non packaged procedure
mk_<operation>_packhead      : Generates a procedure header for inclusion in a package header
mk_<operation>_proc          : Generates a standalone packaged procedure -- We had to do this to get around the
                               fact that Forte does not recognize the package.proc notation ( we use Forte as a
                               front-end )
mk_<operation>_packproc      : Generates a procedure body for inclusion in a package body
mk_one_package_header        : Generates a package header by using the information in package_table_map ( a separate
                               table that needs to be created ( owner, package_name, table_name )
mk_one_package_body          : Generates the corresponding package body
*/

DROP table package_table_map;

CREATE TABLE package_table_map
( owner varchar2(60), package_name varchar2(60), table_name  varchar2(60));

INSERT INTO package_table_map
     VALUES (USER, 'PERS', 'EMP');
INSERT INTO package_table_map
     VALUES (USER, 'PERS', 'DEPT');

CREATE OR REPLACE PROCEDURE mk_insert_dbproc (
   ownername_arg    IN   VARCHAR2,
   table_name_arg   IN   VARCHAR2
)
/*
||   Created on : June 8th 1997
||   Comments   : Standalone Insert Procedure Generator
*/
AS
   column_index   INTEGER;

   CURSOR colname_cur
   IS
      SELECT column_id, column_name
        FROM all_tab_columns
       WHERE owner = ownername_arg
         AND table_name = table_name_arg
       ORDER BY column_id;
BEGIN
   SELECT MAX (column_id)
     INTO column_index
     FROM all_tab_columns
    WHERE owner = ownername_arg
      AND table_name = table_name_arg;
   p.l (' CREATE OR REPLACE PROCEDURE INSERT' || table_name_arg || '(');
   p.l (' /* ');
   p.l (' ||   Name       : Insert' || table_name_arg);
   p.l (' ||   Created on', SYSDATE);
   p.l (' ||   Comments   : Standalone Insert Procedure ');
   p.l (' ||   automatically generated using the PL/Vision building blocks '
   );
   p.l (' */ ');

   FOR rowrec IN colname_cur
   LOOP
      p.l (rowrec.column_name || '_arg IN  ' || table_name_arg || '.' ||
              rowrec.column_name ||
              '%TYPE,'
      );
   END LOOP;

   p.l (' ReturnValue OUT INTEGER ');
   p.l (') ');
   p.l ('IS  ');
   p.l ('BEGIN');
   p.l ('INSERT INTO ' || table_name_arg || '(');

   FOR rowrec IN colname_cur
   LOOP
      IF rowrec.column_id < column_index
      THEN
         p.l (rowrec.column_name || ',');
      ELSE
         p.l (rowrec.column_name);
      END IF;
   END LOOP;

   p.l (')');
   p.l ('VALUES ');
   p.l ('(');

   FOR rowrec IN colname_cur
   LOOP
      IF rowrec.column_id < column_index
      THEN
         p.l (rowrec.column_name || '_arg,');
      ELSE
         p.l (rowrec.column_name || '_arg');
      END IF;
   END LOOP;

   p.l (');');
   p.l (' ReturnValue := 1 ;');
   p.l ('EXCEPTION -- Exception ');
   p.l ('WHEN OTHERS THEN');
   p.l ('    ReturnValue := 0; ');
   p.l ('END INSERT' || table_name_arg || ';');
   p.l ('/');
END;
/



CREATE OR REPLACE PROCEDURE mk_delete_dbproc (
   ownername_arg    IN   VARCHAR2,
   table_name_arg   IN   VARCHAR2
)
/*
||   Name       : mk_delete_dbproc
||   Created on : June 8th 1997
||   Comments   : Standalone Delete Procedure Generator
*/
AS
   arglist         VARCHAR2 (2000);
   colist          VARCHAR2 (2000);
   updatearglist   VARCHAR2 (2000);
   textline        VARCHAR2 (2000);
   pktextline      VARCHAR2 (2000);

   CURSOR pkcol_cur
   IS
      SELECT col.column_name
        FROM all_tab_columns col,
             all_cons_columns conscol,
             all_constraints cons
       WHERE col.table_name = table_name_arg
         AND col.owner = ownername_arg
         AND col.owner = conscol.owner
         AND conscol.owner = cons.owner
         AND col.table_name = conscol.table_name
         AND col.column_name = conscol.column_name
         AND conscol.table_name = cons.table_name
         AND cons.constraint_name = conscol.constraint_name
         AND cons.constraint_type = 'P'
       ORDER BY col.column_id;
BEGIN
   FOR rowrec IN pkcol_cur
   LOOP
      pktextline :=
         pktextline || rowrec.column_name || ' = ' ||
            rowrec.column_name ||
            '_arg AND ';
   END LOOP;

/* Now take of the dangling AND at the end of the column list */
   pktextline := SUBSTR (pktextline, 1, (LENGTH (pktextline) - 4));
   p.l (' CREATE OR REPLACE PROCEDURE DELETE' || table_name_arg || '(');
   p.l (' /* ');
   p.l (' ||   Name       : Delete' || table_name_arg);
   p.l (' ||   Created on', SYSDATE);
   p.l (' ||   Comments   : Standalone Delete Procedure ');
   p.l (' ||   automatically generated using the PL/Vision building blocks '
   );
   p.l (' */ ');

   FOR rowrec IN pkcol_cur
   LOOP
      p.l (rowrec.column_name || '_arg IN  ' || table_name_arg || '.' ||
              rowrec.column_name ||
              '%TYPE,'
      );
   END LOOP;

   p.l ('ReturnValue OUT INTEGER');
   p.l (') ');
   p.l ('AS  ');
   p.l (' CURSOR table_cur IS ');
   p.l (' SELECT * FROM ' || table_name_arg);
   p.l (' WHERE ');
   p.l (pktextline);
   p.l (' FOR UPDATE ; ');
   p.l (' CurrentRow ' || table_name_arg || '%ROWTYPE ;');
   p.l ('BEGIN');
   p.l (' OPEN table_cur ;');
   p.l (' FETCH table_cur INTO CurrentRow ;');
   p.l (' IF table_cur%NOTFOUND THEN ');
   p.l ('    RAISE CAD_DB_EXCEPTIONS.NODATADELETED ;');
   p.l ('END IF;');
   p.l ('DELETE FROM ' || table_name_arg ||
           ' WHERE CURRENT OF table_cur; '
   );
   p.l (' ReturnValue := 1 ;');
   p.l (' CLOSE table_cur ;');
   p.l ('EXCEPTION -- Exception ');
   p.l ('WHEN OTHERS THEN');
   p.l ('    ReturnValue := 0; ');
   p.l ('    CLOSE table_cur ;');
   p.l ('END DELETE' || table_name_arg || ';');
   p.l ('/');
END;
/



CREATE OR REPLACE PROCEDURE mk_update_dbproc (
   ownername_arg    IN   VARCHAR2,
   table_name_arg   IN   VARCHAR2
)
AS
   column_index    INTEGER;
   updatearglist   VARCHAR2 (2000);
   textline        VARCHAR2 (2000);
   pktextline      VARCHAR2 (2000);

   CURSOR colname_cur
   IS
      SELECT column_id, column_name
        FROM all_tab_columns
       WHERE owner = ownername_arg
         AND table_name = table_name_arg
       ORDER BY column_id;

   CURSOR pkcol_cur
   IS
      SELECT col.column_name
        FROM all_tab_columns col,
             all_cons_columns conscol,
             all_constraints cons
       WHERE col.table_name = table_name_arg
         AND col.owner = ownername_arg
         AND col.owner = conscol.owner
         AND conscol.owner = cons.owner
         AND col.table_name = conscol.table_name
         AND col.column_name = conscol.column_name
         AND conscol.table_name = cons.table_name
         AND cons.constraint_name = conscol.constraint_name
         AND cons.constraint_type = 'P'
       ORDER BY col.column_id;

   CURSOR nopk_cur
   IS
      SELECT col.column_name
        FROM all_tab_columns col
       WHERE col.table_name = table_name_arg
         AND col.owner = ownername_arg
         AND col.column_name NOT IN (SELECT conscol.column_name
                                       FROM all_cons_columns conscol,
                                            all_constraints cons
                                      WHERE col.owner = conscol.owner
                                        AND conscol.owner = cons.owner
                                        AND col.table_name =
                                                   conscol.table_name
                                        AND conscol.table_name =
                                                      cons.table_name
                                        AND cons.constraint_name =
                                               conscol.constraint_name
                                        AND cons.constraint_type = 'P')
       ORDER BY col.column_id;
BEGIN
   FOR rowrec IN nopk_cur
   LOOP
      updatearglist :=
         updatearglist || rowrec.column_name || ' = ' ||
            rowrec.column_name ||
            '_arg,';
   END LOOP;

   FOR rowrec IN pkcol_cur
   LOOP
      pktextline :=
         pktextline || rowrec.column_name || ' = ' ||
            rowrec.column_name ||
            '_arg AND ';
   END LOOP;

/* Now we have a dangling comma at the end of the colist and updatearg list ...so time to remove it */
   updatearglist :=
                SUBSTR (updatearglist, 1, (LENGTH (updatearglist) - 1));
/* Now take of the dangling AND at the end of the column list */
   pktextline := SUBSTR (pktextline, 1, (LENGTH (pktextline) - 4));
   p.l (' CREATE OR REPLACE PROCEDURE UPDATE' || table_name_arg || '(');
   p.l (' /* ');
   p.l (' ||   Name       : Update' || table_name_arg);
   p.l (' ||   Created on', SYSDATE);
   p.l (' ||   Comments   : Standalone Update Procedure ');
   p.l (' ||   automatically generated using the PL/Vision building blocks '
   );
   p.l (' */ ');

   FOR rowrec IN colname_cur
   LOOP
      p.l (rowrec.column_name || '_arg IN  ' || table_name_arg || '.' ||
              rowrec.column_name ||
              '%TYPE,'
      );
   END LOOP;

   p.l (' ReturnValue OUT INTEGER, SQLMessage OUT VARCHAR2, SQLStatus OUT INTEGER '
   );
   p.l (') ');
   p.l ('AS  ');
   p.l (' CURSOR table_cur IS ');
   p.l (' SELECT * FROM ' || table_name_arg);
   p.l (' WHERE ');
   p.l (pktextline);
   p.l (' FOR UPDATE ; ');
   p.l (' CurrentRow ' || table_name_arg || '%ROWTYPE ;');
   p.l ('BEGIN');
   p.l (' OPEN table_cur ;');
   p.l (' FETCH table_cur INTO CurrentRow ;');
   p.l (' IF table_cur%NOTFOUND THEN ');
   p.l ('    RAISE CAD_DB_EXCEPTIONS.NODATAUPDATED ;');
   p.l ('END IF;');
   p.l ('UPDATE ' || table_name_arg || ' SET ');
   p.l (updatearglist);
   p.l ('WHERE CURRENT OF table_cur ;');
   p.l (' ReturnValue := 1 ;');
   p.l (' CLOSE table_cur ;');
   p.l ('EXCEPTION -- Exception ');
   p.l ('WHEN OTHERS THEN');
   p.l ('    ReturnValue := 0; ');
   p.l ('    CLOSE table_cur ;');
   p.l ('END UPDATE' || table_name_arg || ';');
   p.l ('/');
END;
/



--=====Package header operations

CREATE OR REPLACE PROCEDURE mk_insert_packhead (
   ownername_arg    IN   VARCHAR2,
   table_name_arg   IN   VARCHAR2
)
/*
||   Name       : mk_insert_packhead
||   Created on : June 8th 1997
||   Comments   : Insert Procedure Header Generator ( for use with the package generator )
*/

AS
   CURSOR colname_cur
   IS
      SELECT column_name
        FROM all_tab_columns
       WHERE owner = ownername_arg
         AND table_name = table_name_arg
       ORDER BY column_id;
BEGIN
   p.l (' PROCEDURE INSERT' || table_name_arg || '( ');

   FOR rowrec IN colname_cur
   LOOP
      p.l (rowrec.column_name || '_arg IN  ' || table_name_arg || '.' ||
              rowrec.column_name ||
              '%TYPE,'
      );
   END LOOP;

   p.l (' ReturnValue OUT INTEGER, SQLMessage OUT VARCHAR2, SQLStatus OUT INTEGER '
   );
   p.l ('--');
   p.l ('); ');
   p.l ('--');
END;
/


CREATE OR REPLACE PROCEDURE mk_delete_packhead (
   ownername_arg    IN   VARCHAR2,
   table_name_arg   IN   VARCHAR2
)
/*
||   Name       : mk_delete_packhead
||   Created on : June 8th 1997
||   Comments   : Delete Procedure Header Generator ( for use with the package generator )
*/

AS
   CURSOR pkcol_cur
   IS
      SELECT col.column_name
        FROM all_tab_columns col,
             all_cons_columns conscol,
             all_constraints cons
       WHERE col.table_name = table_name_arg
         AND col.owner = ownername_arg
         AND col.owner = conscol.owner
         AND conscol.owner = cons.owner
         AND col.table_name = conscol.table_name
         AND col.column_name = conscol.column_name
         AND conscol.table_name = cons.table_name
         AND cons.constraint_name = conscol.constraint_name
         AND cons.constraint_type = 'P'
       ORDER BY col.column_id;
BEGIN
   p.l (' PROCEDURE DELETE' || table_name_arg || '( ');

   FOR rowrec IN pkcol_cur
   LOOP
      p.l (rowrec.column_name || '_arg IN  ' || table_name_arg || '.' ||
              rowrec.column_name ||
              '%TYPE,'
      );
   END LOOP;

   p.l ('  ReturnValue OUT INTEGER, SQLMessage OUT VARCHAR2, SQLStatus OUT INTEGER '
   );
   p.l ('); ');
   p.l ('--');
END;
/



CREATE OR REPLACE PROCEDURE mk_update_packhead (
   ownername_arg    IN   VARCHAR2,
   table_name_arg   IN   VARCHAR2
)
AS
   CURSOR colname_cur
   IS
      SELECT column_name
        FROM all_tab_columns
       WHERE owner = ownername_arg
         AND table_name = table_name_arg
       ORDER BY column_id;
BEGIN
   p.l ('PROCEDURE UPDATE' || table_name_arg || '( ');

   FOR rowrec IN colname_cur
   LOOP
      p.l (rowrec.column_name || '_arg IN  ' || table_name_arg || '.' ||
              rowrec.column_name ||
              '%TYPE,'
      );
   END LOOP;

   p.l ('  ReturnValue OUT INTEGER, SQLMessage OUT VARCHAR2, SQLStatus OUT INTEGER '
   );
   p.l ('--');
   p.l ('); ');
   p.l (' ');
END;
/
-- ============Packaged procedure body 


CREATE OR REPLACE PROCEDURE mk_insert_packproc (
   ownername_arg    IN   VARCHAR2,
   table_name_arg   IN   VARCHAR2
)
/*
||   Name       : mk_insert_packproc
||   Created on : June 8th 1997
||   Comments   : Insert Packaged Procedure Body Generator
*/

AS
   column_index   INTEGER;

   CURSOR colname_cur
   IS
      SELECT column_id, column_name
        FROM all_tab_columns
       WHERE owner = ownername_arg
         AND table_name = table_name_arg
       ORDER BY column_id;
BEGIN
   SELECT MAX (column_id)
     INTO column_index
     FROM all_tab_columns
    WHERE owner = ownername_arg
      AND table_name = table_name_arg;
   p.l ('PROCEDURE INSERT' || table_name_arg || '( ');

   FOR rowrec IN colname_cur
   LOOP
      p.l (rowrec.column_name || '_arg IN  ' || table_name_arg || '.' ||
              rowrec.column_name ||
              '%TYPE,'
      );
   END LOOP;

   p.l (' ReturnValue OUT INTEGER, SQLMessage OUT VARCHAR2, SQLStatus OUT INTEGER '
   );
   p.l ('--');
   p.l (') ');
   p.l ('IS  ');
   p.l ('BEGIN');
   p.l ('INSERT INTO ' || table_name_arg || '(');

   FOR rowrec IN colname_cur
   LOOP
      IF rowrec.column_id < column_index
      THEN
         p.l (rowrec.column_name || ',');
      ELSE
         p.l (rowrec.column_name);
      END IF;
   END LOOP;

   p.l (')');
   p.l ('VALUES ');
   p.l ('(');

   FOR rowrec IN colname_cur
   LOOP
      IF rowrec.column_id < column_index
      THEN
         p.l (rowrec.column_name || '_arg,');
      ELSE
         p.l (rowrec.column_name || '_arg');
      END IF;
   END LOOP;

   p.l (');');
   p.l (' ReturnValue := 1 ;');
   p.l (' SQLStatus := SQLCODE ; ');
   p.l (' SQLMesage := SQLERRM ; ');
   p.l ('EXCEPTION -- Exception ');
   p.l ('WHEN OTHERS THEN');
   p.l ('    SQLStatus  := SQLCODE; ');
   p.l ('    SQLMessage := SQLERRM; ');
   p.l ('    ReturnValue := 0; ');
   p.l ('END INSERT' || table_name_arg || ';');
END;
/



CREATE OR REPLACE PROCEDURE mk_update_packproc (
   ownername_arg    IN   VARCHAR2,
   table_name_arg   IN   VARCHAR2
)
AS
   column_index    INTEGER;
   updatearglist   VARCHAR2 (2000);
   textline        VARCHAR2 (2000);
   pktextline      VARCHAR2 (2000);

   CURSOR colname_cur
   IS
      SELECT column_id, column_name
        FROM all_tab_columns
       WHERE owner = ownername_arg
         AND table_name = table_name_arg
       ORDER BY column_id;

   CURSOR pkcol_cur
   IS
      SELECT col.column_name
        FROM all_tab_columns col,
             all_cons_columns conscol,
             all_constraints cons
       WHERE col.table_name = table_name_arg
         AND col.owner = ownername_arg
         AND col.owner = conscol.owner
         AND conscol.owner = cons.owner
         AND col.table_name = conscol.table_name
         AND col.column_name = conscol.column_name
         AND conscol.table_name = cons.table_name
         AND cons.constraint_name = conscol.constraint_name
         AND cons.constraint_type = 'P'
       ORDER BY col.column_id;

   CURSOR nopk_cur
   IS
      SELECT col.column_name
        FROM all_tab_columns col
       WHERE col.table_name = table_name_arg
         AND col.owner = ownername_arg
         AND col.column_name NOT IN (SELECT conscol.column_name
                                       FROM all_cons_columns conscol,
                                            all_constraints cons
                                      WHERE col.owner = conscol.owner
                                        AND conscol.owner = cons.owner
                                        AND col.table_name =
                                                   conscol.table_name
                                        AND conscol.table_name =
                                                      cons.table_name
                                        AND cons.constraint_name =
                                               conscol.constraint_name
                                        AND cons.constraint_type = 'P')
       ORDER BY col.column_id;
BEGIN
   FOR rowrec IN nopk_cur
   LOOP
      updatearglist :=
         updatearglist || rowrec.column_name || ' = ' ||
            rowrec.column_name ||
            '_arg,';
   END LOOP;

   FOR rowrec IN pkcol_cur
   LOOP
      pktextline :=
         pktextline || rowrec.column_name || ' = ' ||
            rowrec.column_name ||
            '_arg AND ';
   END LOOP;

/* Now we have a dangling comma at the end of the colist and updatearg list ...so time to remove it */
   updatearglist :=
                SUBSTR (updatearglist, 1, (LENGTH (updatearglist) - 1));
/* Now take of the dangling AND at the end of the column list */
   pktextline := SUBSTR (pktextline, 1, (LENGTH (pktextline) - 4));
   p.l ('PROCEDURE UPDATE' || table_name_arg || '( ');

   FOR rowrec IN colname_cur
   LOOP
      p.l (rowrec.column_name || '_arg IN  ' || table_name_arg || '.' ||
              rowrec.column_name ||
              '%TYPE,'
      );
   END LOOP;

   p.l (' ReturnValue OUT INTEGER, SQLMessage OUT VARCHAR2, SQLStatus OUT INTEGER '
   );
   p.l (') ');
   p.l ('AS  ');
   p.l (' CURSOR table_cur IS ');
   p.l (' SELECT * FROM ' || table_name_arg);
   p.l (' WHERE ');
   p.l (pktextline);
   p.l (' FOR UPDATE ; ');
   p.l (' CurrentRow ' || table_name_arg || '%ROWTYPE ;');
   p.l ('BEGIN');
   p.l (' OPEN table_cur ;');
   p.l (' FETCH table_cur INTO CurrentRow ;');
   p.l (' IF table_cur%NOTFOUND THEN ');
   p.l ('    RAISE CAD_DB_EXCEPTIONS.NODATAUPDATED ;');
   p.l ('END IF;');
   p.l ('UPDATE ' || table_name_arg || ' SET ');
   p.l (updatearglist);
   p.l ('WHERE CURRENT OF table_cur ;');
   p.l (' ReturnValue := 1 ;');
   p.l (' SQLStatus := SQLCODE ; ');
   p.l (' SQLMesage := SQLERRM ; ');
   p.l (' CLOSE table_cur ;');
   p.l ('EXCEPTION -- Exception ');
   p.l ('WHEN OTHERS THEN');
   p.l ('    SQLStatus  := SQLCODE; ');
   p.l ('    SQLMessage := SQLERRM; ');
   p.l ('    ReturnValue := 0; ');
   p.l ('    CLOSE table_cur ;');
   p.l ('END UPDATE' || table_name_arg || ';');
END;
/



CREATE OR REPLACE PROCEDURE mk_delete_packproc (
   ownername_arg    IN   VARCHAR2,
   table_name_arg   IN   VARCHAR2
)
AS
   pktextline   VARCHAR2 (2000);

   CURSOR pkcol_cur
   IS
      SELECT col.column_name
        FROM all_tab_columns col,
             all_cons_columns conscol,
             all_constraints cons
       WHERE col.table_name = table_name_arg
         AND col.owner = ownername_arg
         AND col.owner = conscol.owner
         AND conscol.owner = cons.owner
         AND col.table_name = conscol.table_name
         AND col.column_name = conscol.column_name
         AND conscol.table_name = cons.table_name
         AND cons.constraint_name = conscol.constraint_name
         AND cons.constraint_type = 'P'
       ORDER BY col.column_id;
BEGIN
   FOR rowrec IN pkcol_cur
   LOOP
      pktextline :=
         pktextline || rowrec.column_name || ' = ' ||
            rowrec.column_name ||
            '_arg AND ';
   END LOOP;

/* Now take of the dangling AND at the end of the column list */
   pktextline := SUBSTR (pktextline, 1, (LENGTH (pktextline) - 4));
   p.l (' PROCEDURE DELETE' || table_name_arg || '( ');

   FOR rowrec IN pkcol_cur
   LOOP
      p.l (rowrec.column_name || '_arg IN  ' || table_name_arg || '.' ||
              rowrec.column_name ||
              '%TYPE,'
      );
   END LOOP;

   p.l ('ReturnValue OUT INTEGER, SQLMessage OUT VARCHAR2, SQLStatus OUT INTEGER '
   );
   p.l (') ');
   p.l ('AS  ');
   p.l (' CURSOR table_cur IS ');
   p.l (' SELECT * FROM ' || table_name_arg);
   p.l (' WHERE ');
   p.l (pktextline);
   p.l (' FOR UPDATE ; ');
   p.l (' CurrentRow ' || table_name_arg || '%ROWTYPE ;');
   p.l ('BEGIN');
   p.l (' OPEN table_cur ;');
   p.l (' FETCH table_cur INTO CurrentRow ;');
   p.l (' IF table_cur%NOTFOUND THEN ');
   p.l ('    RAISE CAD_DB_EXCEPTIONS.NODATADELETED ;');
   p.l ('END IF;');
   p.l ('DELETE FROM ' || table_name_arg ||
           ' WHERE CURRENT OF table_cur; '
   );
   p.l (' ReturnValue := 1 ;');
   p.l (' SQLStatus := SQLCODE ; ');
   p.l (' SQLMesage := SQLERRM ; ');
   p.l (' CLOSE table_cur ;');
   p.l ('EXCEPTION -- Exception ');
   p.l ('WHEN OTHERS THEN');
   p.l ('    SQLStatus  := SQLCODE; ');
   p.l ('    SQLMessage := SQLERRM; ');
   p.l ('    ReturnValue := 0; ');
   p.l ('    CLOSE table_cur ;');
   p.l ('END DELETE' || table_name_arg || ';');
   p.l ('--');
END;
/












-- ============Packaged procedures

CREATE OR REPLACE PROCEDURE mk_insert_proc (
   ownername_arg      IN   VARCHAR2,
   package_name_arg   IN   VARCHAR2,
   table_name_arg     IN   VARCHAR2
)
/*
||   Name       : mk_insert_proc
||   Created on : June 8th 1997
||   Comments   : Packaged Insert Procedure Generator
*/

AS
   CURSOR colname_cur
   IS
      SELECT column_name
        FROM all_tab_columns
       WHERE owner = ownername_arg
         AND table_name = table_name_arg
       ORDER BY column_id;
BEGIN
   p.l (' CREATE OR REPLACE PROCEDURE INSERT' || table_name_arg || '( '
   );

   FOR rowrec IN colname_cur
   LOOP
      p.l (rowrec.column_name || '_arg IN  ' || table_name_arg || '.' ||
              rowrec.column_name ||
              '%TYPE,'
      );
   END LOOP;

   p.l (' ReturnValue OUT INTEGER ');
   p.l (') ');
   p.l (' /* ');
   p.l (' ||   Name       : INSERT' || table_name_arg);
   p.l (' ||   Created on ', SYSDATE);
   p.l (' ||   Comments   : Packaged procedure automatically generated  '
   );
   p.l (' ||   using the PL/Vision building blocks ');
   p.l (' */ ');
   p.l ('IS  ');
   p.l (' SQLMessage VARCHAR2(80) ; ');
   p.l (' SQLStatus  INTEGER      ; ');
   p.l ('BEGIN');
   p.l (package_name_arg || '.INSERT' || table_name_arg || '(');

   FOR rowrec IN colname_cur
   LOOP
      p.l (rowrec.column_name || '_arg ,');
   END LOOP;

   p.l (' ReturnValue, SQLMessage , SQLStatus ');
   p.l (');');
   p.l (' ReturnValue := 1 ;');
   p.l (' SQLStatus := SQLCODE ; ');
   p.l (' SQLMessage := SQLERRM ; ');
   p.l ('EXCEPTION -- Exception ');
   p.l ('WHEN OTHERS THEN');
   p.l ('    SQLStatus  := SQLCODE; ');
   p.l ('    SQLMessage := SQLERRM; ');
   p.l ('    ReturnValue := 0; ');
   p.l ('END INSERT' || table_name_arg || ';');
   p.l ('/');
END;
/


CREATE OR REPLACE PROCEDURE mk_update_proc (
   ownername_arg      IN   VARCHAR2,
   package_name_arg   IN   VARCHAR2,
   table_name_arg     IN   VARCHAR2
)
AS
   CURSOR colname_cur
   IS
      SELECT column_name
        FROM all_tab_columns
       WHERE owner = ownername_arg
         AND table_name = table_name_arg
       ORDER BY column_id;
BEGIN
   p.l (' CREATE OR REPLACE PROCEDURE UPDATE' || table_name_arg || '( '
   );

   FOR rowrec IN colname_cur
   LOOP
      p.l (rowrec.column_name || '_arg IN  ' || table_name_arg || '.' ||
              rowrec.column_name ||
              '%TYPE,'
      );
   END LOOP;

   p.l (' ReturnValue OUT INTEGER ');
   p.l (') ');
   p.l (' /* ');
   p.l (' ||   Name       : INSERT' || table_name_arg);
   p.l (' ||   Filename   : ');
   p.l (' ||   Created on ', SYSDATE);
   p.l (' ||   Comments   : Packaged procedure automatically generated  '
   );
   p.l (' ||   using the PL/Vision building blocks ');
   p.l (' */ ');
   p.l ('IS  ');
   p.l (' SQLMessage VARCHAR2(80) ; ');
   p.l (' SQLStatus  INTEGER      ; ');
   p.l ('BEGIN');
   p.l (package_name_arg || '.UPDATE' || table_name_arg || '(');

   FOR rowrec IN colname_cur
   LOOP
      p.l (rowrec.column_name || '_arg ,');
   END LOOP;

   p.l (' ReturnValue, SQLMessage , SQLStatus ');
   p.l (');');
   p.l ('EXCEPTION -- Exception ');
   p.l ('WHEN OTHERS THEN');
   p.l ('    SQLStatus  := SQLCODE; ');
   p.l ('    SQLMessage := SQLERRM; ');
   p.l ('    ReturnValue := 0; ');
   p.l ('END UPDATE' || table_name_arg || ';');
   p.l ('/');
END;
/


CREATE OR REPLACE PROCEDURE mk_delete_proc (
   ownername_arg      IN   VARCHAR2,
   package_name_arg   IN   VARCHAR2,
   table_name_arg     IN   VARCHAR2
)
/*
||   Name       : mk_delete_proc
||   Comments   : Packaged Delete Procedure Generator - since FORTE does not recognize the
||   package.object notation, we encapsulate it in a standalone procedure
*/

AS
   CURSOR pkcol_cur
   IS
      SELECT col.column_name
        FROM all_tab_columns col,
             all_cons_columns conscol,
             all_constraints cons
       WHERE col.table_name = table_name_arg
         AND col.owner = ownername_arg
         AND col.owner = conscol.owner
         AND conscol.owner = cons.owner
         AND col.table_name = conscol.table_name
         AND col.column_name = conscol.column_name
         AND conscol.table_name = cons.table_name
         AND cons.constraint_name = conscol.constraint_name
         AND cons.constraint_type = 'P'
       ORDER BY col.column_id;
BEGIN
   p.l ('CREATE OR REPLACE  PROCEDURE DELETE' || table_name_arg || '( '
   );

   FOR rowrec IN pkcol_cur
   LOOP
      p.l (rowrec.column_name || '_arg IN  ' || table_name_arg || '.' ||
              rowrec.column_name ||
              '%TYPE,'
      );
   END LOOP;

   p.l (' ReturnValue OUT INTEGER ');
   p.l (') ');
   p.l (' /* ');
   p.l (' ||   Name       : DELETE' || table_name_arg);
   p.l (' ||   Created on ', SYSDATE);
   p.l (' ||   Comments   : Packaged procedure automatically generated using the '
   );
   p.l (' ||                PL/Vision building blocks ');
   p.l (' */ ');
   p.l ('AS  ');
   p.l (' SQLMessage VARCHAR2(80) ; ');
   p.l (' SQLStatus  INTEGER      ; ');
   p.l ('BEGIN');
   p.l (package_name_arg || '.DELETE' || table_name_arg || '(');

   FOR rowrec IN pkcol_cur
   LOOP
      p.l (rowrec.column_name || '_arg ,');
   END LOOP;

   p.l (' ReturnValue, SQLMessage , SQLStatus ');
   p.l (') ; ');
   p.l ('EXCEPTION -- Exception ');
   p.l ('WHEN OTHERS THEN');
   p.l ('    SQLStatus  := SQLCODE; ');
   p.l ('    SQLMessage := SQLERRM; ');
   p.l ('    ReturnValue := 0; ');
   p.l ('END DELETE' || table_name_arg || ';');
   p.l ('/');
END;
/

-- ==Package header generator

CREATE OR REPLACE PROCEDURE mk_one_package_header (
   ownername_arg      IN   VARCHAR2,
   package_name_arg   IN   VARCHAR2
)
AS
   CURSOR tablename_cur
   IS
      SELECT table_name
        FROM package_table_map
       WHERE owner = ownername_arg
         AND package_name = package_name_arg
       ORDER BY table_name;
BEGIN
   p.l (' CREATE OR REPLACE PACKAGE ' || package_name_arg);
   p.l (' /* ');
   p.l (' ||   Name       : ' || package_name_arg);
   p.l (' ||   Comments   : Package Body automatically generated using the PL/Vision building blocks '
   );
   p.l (' */ ');
   p.l (' IS ');
   p.l (' /*HELP ');
   p.l ('   Overview of ' || package_name_arg);
   p.l ('   HELP*/ ');
   p.l (' ');
   p.l (' /*EXAMPLES ');
   p.l ('   Examples of test ');
   p.l ('   EXAMPLES*/ ');
   p.l (' ');
   p.l (' /* Constants */ ');
   p.l (' ');
   p.l ('  /* Exceptions */ ');
   p.l (' ');
   p.l (' /* Variables */ ');
   p.l (' ');
   p.l (' /* Toggles */ ');
   p.l (' ');
   p.l ('/* Windows */ ');
   p.l (' ');
   p.l ('/* Programs */ ');
   p.l (' ');
   p.l (' PROCEDURE help (context_in IN VARCHAR2 := NULL); ');

   FOR maprec IN tablename_cur
   LOOP
      mk_insert_packhead (ownername_arg, maprec.table_name);
      p.l ('--');
      mk_update_packhead (ownername_arg, maprec.table_name);
      p.l ('--');
      mk_delete_packhead (ownername_arg, maprec.table_name);
      p.l ('--');
   END LOOP;

   p.l ('END ' || package_name_arg);
   p.l ('/');
END;
/




-- =======Package body generator

CREATE OR REPLACE PROCEDURE mk_one_package_body (
   ownername_arg      IN   VARCHAR2,
   package_name_arg   IN   VARCHAR2
)
AS
   CURSOR tablename_cur
   IS
      SELECT table_name
        FROM package_table_map
       WHERE owner = ownername_arg
         AND package_name = package_name_arg
       ORDER BY table_name;
BEGIN
   p.l (' CREATE OR REPLACE PACKAGE BODY ' || package_name_arg);
   p.l (' /* ');
   p.l (' ||   Name       : ' || package_name_arg);
   p.l (' ||   Comments   : Package Body automatically generated using the PL/Vision building blocks '
   );
   p.l (' */ ');
   p.l (' IS ');

   FOR maprec IN tablename_cur
   LOOP
      mk_insert_packproc (ownername_arg, maprec.table_name);
      p.l (' ');
      mk_update_packproc (ownername_arg, maprec.table_name);
      p.l (' ');
      mk_delete_packproc (ownername_arg, maprec.table_name);
   END LOOP;

   p.l ('END ' || package_name_arg);
   p.l ('/');
END;
/
    
   
    
    
    

    

