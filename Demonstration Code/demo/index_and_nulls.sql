CREATE TABLE plch_table
AS
   SELECT owner,
          CASE WHEN MOD (ROWNUM, 100) > 1 THEN object_type END
             object_type
     FROM all_objects a
/


BEGIN
   DBMS_STATS.gather_table_stats (USER, 'PLCH_TABLE');
END;
/

CREATE INDEX i_plch_table
   ON plch_table (object_type, owner)
/

SET AUTOTRACE TRACEONLY EXPLAIN

SELECT *
  FROM plch_table
 WHERE object_type IS NULL
/

DROP INDEX i_plch_table
/

CREATE INDEX i_plch_table
   ON plch_table (object_type)
/

SELECT *
  FROM plch_table
 WHERE object_type IS NULL
/