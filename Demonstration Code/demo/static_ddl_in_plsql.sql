/* Let's try a static DDL statement in PL/SQL */

BEGIN
   CREATE TABLE my_table (n NUMBER);
END;
/

/* You will see:

PLS-00103: Encountered the symbol "CREATE" when expecting one of the following:

*/