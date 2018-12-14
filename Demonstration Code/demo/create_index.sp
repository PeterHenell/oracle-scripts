CREATE OR REPLACE PROCEDURE create_index (
   index_in     IN   VARCHAR2
 , tab_in       IN   VARCHAR2
 , collist_in   IN   VARCHAR2
)
IS
BEGIN
   EXECUTE IMMEDIATE    'CREATE INDEX '
                     || index_in
                     || ' ON '
                     || tab_in
                     || ' ( '
                     || collist_in
                     || ')';
END;
/