DROP TYPE names_vat FORCE
/

CREATE OR REPLACE TYPE names_vat AS VARRAY (10) OF VARCHAR2 (80);
/

DECLARE
   l_list   names_vat := names_vat ();
BEGIN
   DBMS_OUTPUT.put_line ('Limit of names_vat = ' || l_list.LIMIT);
END;
/

ALTER TYPE names_vat MODIFY LIMIT 100 INVALIDATE
/

DECLARE
   l_list   names_vat := names_vat ();
BEGIN
   DBMS_OUTPUT.put_line ('Limit of names_vat = ' || l_list.LIMIT);
END;
/

/* Invalid all database objects dependent on the type */

BEGIN
   EXECUTE IMMEDIATE 'ALTER TYPE names_vat MODIFY LIMIT 200 INVALIDATE';
END;
/

DECLARE
   l_list   names_vat := names_vat ();
BEGIN
   DBMS_OUTPUT.put_line ('Limit of names_vat = ' || l_list.LIMIT);
END;
/

/* Cascade or propagate the varray size change to dependent objects 

From the Oracle documentation:

The CASCADE option in the ALTER TYPE statement propagates the VARRAY size change 
to its dependent types and tables. A new version is generated for each valid dependent 
type and dependent tables metadata are updated accordingly based on the different 
case scenarios described previously. If the VARRAY column is in a cluster table, 
an ALTER TYPE statement with the CASCADE option fails because a cluster table 
does not support a LOB.

*/

BEGIN
   EXECUTE IMMEDIATE 'ALTER TYPE names_vat MODIFY LIMIT 100 CASCADE';
END;
/

/* Example of checking count against limit before extending.
   Unfortunately, the change in limit does not take immediate effect 
   in that block of code, even for a newly declared varray. */

DROP TYPE names_vat
/

CREATE OR REPLACE TYPE names_vat AS VARRAY (10) OF VARCHAR2 (80);
/

CREATE OR REPLACE PROCEDURE expand_varray
IS
   l_list   names_vat := names_vat ();
BEGIN
   l_list.EXTEND (l_list.LIMIT);

   FOR indx IN 1 .. l_list.LIMIT
   LOOP
      l_list (indx) := 'abc';
   END LOOP;

   DBMS_OUTPUT.put_line ('Count in names_vat = ' || l_list.COUNT);
   DBMS_OUTPUT.put_line ('Limit in names_vat = ' || l_list.LIMIT);

   IF l_list.COUNT = l_list.LIMIT
   THEN
      EXECUTE IMMEDIATE
            'ALTER TYPE names_vat MODIFY LIMIT '
         || l_list.LIMIT * 2
         || ' INVALIDATE';

      DBMS_OUTPUT.put_line ('Enlarged varray to ' || l_list.LIMIT);
   END IF;

   l_list.EXTEND;
   l_list (l_list.COUNT) := 'new name';
   DBMS_OUTPUT.put_line ('New count ' || l_list.COUNT);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack ());

      DECLARE
         l_list2   names_vat := names_vat ();
      BEGIN
         DBMS_OUTPUT.put_line (
            'Limit of newly declared collection = ' || l_list2.LIMIT);
      END;
END;
/

DECLARE
   l_list   names_vat := names_vat ();
BEGIN
   DBMS_OUTPUT.put_line (
      'Limit of names_vat before expansion = ' || l_list.LIMIT);
END;
/

BEGIN
   expand_varray;
END;
/

DECLARE
   l_list   names_vat := names_vat ();
BEGIN
   DBMS_OUTPUT.put_line (
      'Limit of names_vat after expansion = ' || l_list.LIMIT);
END;
/

BEGIN
   expand_varray;
END;
/

/* Perhaps inside a dynamic block...yes! */

DROP TYPE names_vat FORCE
/

CREATE OR REPLACE TYPE names_vat AS VARRAY (10) OF VARCHAR2 (80);
/

BEGIN
   EXECUTE IMMEDIATE 'ALTER TYPE names_vat MODIFY LIMIT 100 INVALIDATE';

   EXECUTE IMMEDIATE
      'DECLARE
      l_list   names_vat := names_vat ();
   BEGIN
      DBMS_OUTPUT.put_line (
         ''Limit of names_vat after expansion = '' || l_list.LIMIT);
   END;';
END;
/