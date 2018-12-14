/*

Why pick names from a box when we can use PL/SQL
to make sure that we choose in a truly random
fashion?

*/


BEGIN
   DBMS_OUTPUT.put_line (ROUND (DBMS_RANDOM.VALUE (1, 30)));
END;
/