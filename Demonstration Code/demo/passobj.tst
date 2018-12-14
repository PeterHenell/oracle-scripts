CREATE OR REPLACE PROCEDURE bust_em_with (
   labor_source_in IN labor_source_t) 
AS LANGUAGE JAVA
   NAME 'UnionBuster.wageStrategy (oracle.sql.STRUCT)';
/

BEGIN
   bust_em_with (labor_source_t ('Workfare', 0));
   bust_em_with (labor_source_t ('Prisoners', '5'));
END;
/
            