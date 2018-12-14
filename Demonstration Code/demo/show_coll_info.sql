DROP TYPE pet_t FORCE;
DROP TYPE zoo_t FORCE;
DROP TYPE numbers_t FORCE;

CREATE TYPE pet_t IS OBJECT (
   tag_no   INTEGER
  ,NAME     VARCHAR2 (60)
  ,breed    VARCHAR2 (100)
)
/

CREATE TYPE zoo_t IS TABLE OF pet_t
/

CREATE TYPE numbers_t IS TABLE OF NUMBER
/

DECLARE
-- Code to demonstrate retrieving information from the
-- data dictionary about collections
   my_cat    pet_t     := pet_t (50, 'Sister', 'Siamese');
   my_bird   pet_t     := pet_t (100, 'Mercury', 'African Grey Parrot');
   my_pets   zoo_t     := zoo_t (my_cat, my_bird);
   my_nums   numbers_t := numbers_t (1, 2, 3);

   TYPE coll_rt IS RECORD (
      owner                 all_coll_types.owner%TYPE
     ,NAME                  all_coll_types.type_name%TYPE
     ,TYPE                  all_coll_types.coll_type%TYPE
     ,datatype              all_types.typecode%TYPE
     ,is_nested_table_out   BOOLEAN
   );

   PROCEDURE show_coll_info (coll_in IN ANYDATA)
   IS
      l_dotloc      PLS_INTEGER;
      l_coll_info   coll_rt;
   BEGIN
      l_dotloc := INSTR (coll_in.gettypename, '.');
      l_coll_info.owner := SUBSTR (coll_in.gettypename, 1, l_dotloc - 1);
      l_coll_info.NAME := SUBSTR (coll_in.gettypename, l_dotloc + 1);

      SELECT coll_type, elem_type_name
        INTO l_coll_info.TYPE, l_coll_info.datatype
        FROM all_coll_types
       WHERE type_name = l_coll_info.NAME;

      DBMS_OUTPUT.put_line ('Owner = ' || l_coll_info.owner);
      DBMS_OUTPUT.put_line ('Name = ' || l_coll_info.NAME);
      DBMS_OUTPUT.put_line ('Type = ' || l_coll_info.TYPE);
      DBMS_OUTPUT.put_line ('DataType = ' || l_coll_info.datatype);
   END show_coll_info;
BEGIN
   show_coll_info (ANYDATA.convertcollection (my_pets));
   show_coll_info (ANYDATA.convertcollection (my_nums));
END;
/