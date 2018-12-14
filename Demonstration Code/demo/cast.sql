CREATE TYPE cutbacks_for_taxcuts_tt AS TABLE OF VARCHAR2 (100);
/

CREATE TABLE lobbying_results (activity VARCHAR2 (200))
/

BEGIN
   INSERT INTO lobbying_results
   VALUES ('No tax on stock transactions');

   INSERT INTO lobbying_results
   VALUES ('Cut city income taxes');

   COMMIT;
END;
/

DECLARE
   nyc_devolution   cutbacks_for_taxcuts_tt
                       := cutbacks_for_taxcuts_tt (
                             'Stop rat extermination programs'
                           , 'Fire building inspectors'
                           , 'Close public hospitals'
                          );
BEGIN
   DBMS_OUTPUT.put_line ('How to Make the NYC Rich Much, Much Richer:');

   FOR rec IN (SELECT COLUMN_VALUE ohmy
                 FROM TABLE (nyc_devolution)
               UNION
               SELECT activity
                 FROM lobbying_results)
   LOOP
      DBMS_OUTPUT.put_line (rec.ohmy);
   END LOOP;
END;
/