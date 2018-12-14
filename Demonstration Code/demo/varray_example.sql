CREATE OR REPLACE TYPE list_of_names_t IS VARRAY(10) OF VARCHAR2 (100);
/

GRANT EXECUTE ON list_of_names_t TO PUBLIC
/

DECLARE
   happyfamily   list_of_names_t := list_of_names_t ();
BEGIN
   happyfamily.EXTEND (4);
   happyfamily (1) := 'Eli';
   happyfamily (2) := 'Steven';
   happyfamily (3) := 'Chris';
   happyfamily (4) := 'Veva';
   
   FOR l_row IN 1 .. happyfamily.COUNT
   LOOP
      DBMS_OUTPUT.put_line (happyfamily (l_row));
   END LOOP;
END;
/

/* Try to delete an element */
   
DECLARE
   happyfamily   list_of_names_t := list_of_names_t ();
BEGIN
   happyfamily.EXTEND (4);
   happyfamily (1) := 'Eli';
   happyfamily (2) := 'Steven';
   happyfamily (3) := 'Chris';
   happyfamily (4) := 'Veva';
   
   happyfamily.delete (2);
END;
/

/* Referencing the varray inside a query */

DECLARE
   happyfamily   list_of_names_t := list_of_names_t ();
 BEGIN
   happyfamily.EXTEND (4);
   happyfamily (1) := 'Eli';
   happyfamily (2) := 'Steven';
   happyfamily (3) := 'Chris';
   happyfamily (4) := 'Veva';
  
   /* Use TABLE operator to apply SQL operations to
      a PL/SQL nested table */

   FOR rec IN (  SELECT COLUMN_VALUE family_name
                   FROM TABLE (happyfamily)
               ORDER BY family_name)
   LOOP
      DBMS_OUTPUT.put_line (rec.family_name);
   END LOOP;
END;
/

/* Using a nested table as a column type */

DROP TABLE family
/

CREATE OR REPLACE TYPE parent_names_t IS VARRAY (2) OF VARCHAR2 (100);
/

CREATE OR REPLACE TYPE child_names_t IS VARRAY (1) OF VARCHAR2 (100);
/

CREATE TABLE family
(
   surname          VARCHAR2 (1000)
 , parent_names     parent_names_t
 , children_names   child_names_t
)
/

DECLARE
   parents    parent_names_t := parent_names_t ();
   children   child_names_t := child_names_t ();
BEGIN
   DBMS_OUTPUT.put_line (parents.LIMIT);
   
   parents.EXTEND (2);
   parents (1) := 'Samuel';
   parents (2) := 'Charina';
   --
   children.EXTEND;
   children (1) := 'Feather';

   --
   INSERT INTO family (surname, parent_names, children_names)
        VALUES ('Assurty', parents, children);

   COMMIT;
END;
/

SELECT * FROM family
/