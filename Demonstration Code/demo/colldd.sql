SET PAGESIZE 80

DROP TYPE names_t FORCE;
DROP TYPE names_vt FORCE;
DROP TYPE tmrs_vt FORCE;

@tmr81.ot

CREATE TYPE names_t IS TABLE OF VARCHAR2(30);
/
CREATE TYPE names_vt IS VARRAY(10) OF VARCHAR2(30);
/
CREATE TYPE tmrs_vt IS TABLE OF tmr_t;
/
REM Show the defined collections for my schema

TTITLE "Collections Defined in Schema"

SELECT coll_type || ' - ' || type_name Collection
  FROM all_coll_types
 WHERE owner = USER
 ORDER BY coll_type, type_name;

REM Show datatypes of specific types

TTITLE "Collection Types and Names"

SELECT owner || '.' ||type_name type, elem_type_name
  FROM all_coll_types
 WHERE owner = USER
   AND type_name IN ('NAMES_VT', 'TMRS_VT');

REM Show attribute information for these types.

TTITLE "Collection Attribute Information"

REM You will only see attribute information if the collection is based
REM on an object type...

SELECT T.type_name || '-' || A.attr_name || ' - ' || A.attr_type_name Attributes
  FROM all_coll_types T, all_type_attrs A
 WHERE T.owner = USER
   AND T.owner = A.owner
   AND T.type_name IN ('NAMES_VT', 'TMRS_VT')
   AND T.elem_type_name = A.type_name;

TTITLE OFF
SET PAGESIZE 120
