DROP TYPE labor_source_t FORCE;
DROP TYPE union_busters FORCE;

CREATE TYPE labor_source_t AS OBJECT (
   labor_type VARCHAR2 ( 30 )
 , hourly_rate NUMBER
);
/

CREATE TYPE union_busters AS TABLE OF labor_source_t;
/

DECLARE
   low_wage_pressure union_busters
      := union_busters ( labor_source_t ( 'Workfare', 0 )
                       , labor_source_t ( 'Prisoner', '5' )
                       );
BEGIN
   FOR rec IN ( SELECT  labor_type, hourly_rate
                   FROM TABLE ( low_wage_pressure )
               ORDER BY labor_type )
   LOOP
      DBMS_OUTPUT.put_line ( rec.labor_type || '-$' || rec.hourly_rate );
   END LOOP;
END;
/
