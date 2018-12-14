/*
Requires the tmr_t object type.
Run @tmr.lot
*/

CREATE TABLE unionbuster
(
   ub_id         INTEGER
 ,  labor_type    VARCHAR2 (100)
 ,  hourly_wage   INTEGER
);

CREATE INDEX ub_lt
   ON unionbuster (labor_type);

CREATE SEQUENCE ub_seq;

DECLARE
   rec             unionbuster%ROWTYPE;
   ins_sel_tmr     tmr_t := tmr_t.make ('INSERT-SELECT', 10000);
   returning_tmr   tmr_t := tmr_t.make ('RETURNING', 10000);
BEGIN
   ins_sel_tmr.go;

   FOR indx IN 1 .. 10000
   LOOP
      INSERT INTO unionbuster
           VALUES (ub_seq.NEXTVAL, 'Prison' || indx, 5);

      SELECT ub_id, hourly_wage
        INTO rec.ub_id, rec.hourly_wage
        FROM unionbuster
       WHERE labor_type = 'Prison' || indx;
   END LOOP;

   ins_sel_tmr.stop;

   ROLLBACK;

   returning_tmr.go;

   FOR indx IN 1 .. 10000
   LOOP
      INSERT INTO unionbuster
           VALUES (ub_seq.NEXTVAL, 'Prison' || indx, 5)
        RETURNING ub_id, hourly_wage
             INTO rec.ub_id, rec.hourly_wage;
   END LOOP;

   returning_tmr.stop;

   ROLLBACK;
END;
/

DROP TABLE unionbuster;
DROP SEQUENCE ub_seq;

/* On 11.2

Timings in seconds for "INSERT-SELECT":
Elapsed = 3.87 - per rep .000387
CPU     = 2.68 - per rep .000268
Timings in seconds for "RETURNING":
Elapsed = 2.4 - per rep .00024
CPU     = 1.76 - per rep .000176

*/