DROP TYPE names_nt
/

CREATE OR REPLACE TYPE names_nt IS TABLE OF VARCHAR2 ( 1000 );
/

CREATE OR REPLACE FUNCTION lotsa_names (
   base_name_in   IN   VARCHAR2
 , count_in       IN   INTEGER
)
   RETURN names_nt
IS
   retval names_nt := names_nt ( );
BEGIN
   retval.EXTEND ( count_in );

   FOR indx IN 1 .. count_in
   LOOP
      retval ( indx ) := base_name_in || ' ' || indx;
   END LOOP;

   RETURN retval;
END lotsa_names;
/

REM Call the table function within a SELECT statement.

SELECT COLUMN_VALUE
  FROM TABLE ( lotsa_names ( 'Steven', 100 )) names
/

SELECT COLUMN_VALUE my_alias
  FROM employees, TABLE ( lotsa_names ( 'Steven', 10 )) names
/
  
CREATE OR REPLACE FUNCTION lotsa_names_cv (
   base_name_in   IN   VARCHAR2
 , count_in       IN   INTEGER
)
   RETURN sys_refcursor
IS
   retval sys_refcursor;
BEGIN
   OPEN retval FOR
      SELECT COLUMN_VALUE
        FROM TABLE ( lotsa_names ( base_name_in, count_in )) names;

   RETURN retval;
END lotsa_names_cv;
/

DECLARE
   l_names_cur sys_refcursor;
   l_name VARCHAR2 ( 32767 );
BEGIN
   l_names_cur := lotsa_names_cv ( 'Steven', 100 );

   LOOP
      FETCH l_names_cur INTO l_name;

      EXIT WHEN l_names_cur%NOTFOUND;
      DBMS_OUTPUT.put_line ( 'Name = ' || l_name );
   END LOOP;

   CLOSE l_names_cur;
END;
/

/* Example of multiple transformations */

BEGIN
   INSERT INTO tickertable
      SELECT *
        FROM TABLE
                ( transformation_2
                       ( CURSOR
                               ( SELECT *
                                   FROM TABLE
                                           ( stockpivot
                                                       ( CURSOR
                                                               ( SELECT *
                                                                   FROM stocktable )
                                                       )
                                           )
                               )
                       )
                );
END;
/