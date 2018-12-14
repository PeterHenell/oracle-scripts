DROP TYPE numbers_t FORCE
/

CREATE OR REPLACE TYPE numbers_t IS TABLE OF NUMBER;
/

CREATE OR REPLACE PACKAGE pipeline
IS
   CURSOR refcur_c
   IS
      SELECT line FROM all_source;

   TYPE refcur_t IS REF CURSOR
      RETURN refcur_c%ROWTYPE;

   FUNCTION double_values (dataset refcur_t)
      RETURN numbers_t
      PIPELINED;
END pipeline;
/

CREATE OR REPLACE PACKAGE BODY pipeline
IS
   FUNCTION double_values (dataset refcur_t)
      RETURN numbers_t
      PIPELINED
   IS
      l_number   NUMBER;
   BEGIN
      LOOP
         FETCH dataset INTO l_number;

         EXIT WHEN dataset%NOTFOUND;

         PIPE ROW (l_number * 2);
      END LOOP;

      CLOSE dataset;

      RETURN;
   END;
END pipeline;
/

SELECT *
  FROM TABLE (pipeline.double_values (
                 CURSOR (SELECT line
                           FROM all_source
                          WHERE ROWNUM < 10)))
/

/* Make it autonomous with a DML operation. Error! 

From the Oracle documentation:
http://download.oracle.com/docs/cd/E11882_01/appdev.112/e10765/pipe_paral_tbl.htm#ADDCI4701%22%3EOracle%20documentation

Because table functions pass control back and forth to a calling routine as rows are produced, 
there is a restriction on combining table functions and PRAGMA AUTONOMOUS_TRANSACTIONs. 
If a table function is part of an autonomous transaction, it must COMMIT or ROLLBACK 
before each PIPE ROW statement, to avoid an error in the calling subprogram.
*/

CREATE OR REPLACE PACKAGE BODY pipeline
IS
   FUNCTION double_values (dataset refcur_t)
      RETURN numbers_t
      PIPELINED
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      l_number   NUMBER;
   BEGIN
      LOOP
         FETCH dataset INTO l_number;

         EXIT WHEN dataset%NOTFOUND;
         
         update plch_parts set partnum=partnum;

         PIPE ROW (l_number * 2);
      END LOOP;

      CLOSE dataset;

      RETURN;
   END;
END pipeline;
/

SELECT *
  FROM TABLE (pipeline.double_values (
                 CURSOR (SELECT line
                           FROM all_source
                          WHERE ROWNUM < 10)))
/