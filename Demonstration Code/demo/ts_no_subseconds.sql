SPOOL testcase_milliseconds.log

ALTER SESSION SET nls_timestamp_format='YYYY-MM-DD HH24:MI:SS.FF';

ALTER SESSION SET nls_language='AMERICAN';

SET head on
SET feedback on
SET echo on

SELECT VERSION
  FROM v$instance;

DROP TABLE test_timestamp;

DROP TYPE test_event_typ;


CREATE OR REPLACE TYPE test_event_typ AS OBJECT (
   evt_id               NUMBER (10)
 , occurred_timestamp   TIMESTAMP ( 9 )
)
NOT FINAL;
/

CREATE TABLE test_timestamp OF test_event_typ;

DROP TABLE test_timestamp_no_type;

CREATE TABLE test_timestamp_no_type
(
evt_id    NUMBER(10),
occurred_timestamp    TIMESTAMP(3),
inserted_mode VARCHAR2(200)
);



DESC test_timestamp

CREATE OR REPLACE TRIGGER tg_tst_bef_ins
   BEFORE INSERT
   ON test_timestamp
   FOR EACH ROW
BEGIN
   DBMS_OUTPUT.put_line (   'Before Trigger.OCCURRED_TIMESTAMP='
                         || TO_CHAR (:NEW.occurred_timestamp
                                   , 'YYYY-MM-DD HH24:MI:SS.FF'
                                    )
                        );

   INSERT INTO test_timestamp_no_type
        VALUES (:NEW.evt_id + 100, :NEW.occurred_timestamp, 'before trigger');
END;
/
CREATE OR REPLACE TRIGGER tg_tst_aft_ins
   AFTER INSERT
   ON test_timestamp
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   ots   TIMESTAMP ( 3 ) := :NEW.occurred_timestamp;
BEGIN
   DBMS_OUTPUT.put_line (   'After Trigger.OCCURRED_TIMESTAMP='
                         || TO_CHAR (:NEW.occurred_timestamp
                                   , 'YYYY-MM-DD HH24:MI:SS.FF'
                                    )
                        );

   INSERT INTO test_timestamp_no_type
        VALUES (:NEW.evt_id + 1000, :NEW.occurred_timestamp, 'after trigger');
END tg_tst_aft_ins;
/

SELECT TO_CHAR (SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF') AS now
  FROM DUAL;

INSERT INTO test_timestamp
     VALUES (1, SYSTIMESTAMP);

INSERT INTO test_timestamp
     VALUES (2, SYSTIMESTAMP);

COMMIT ;


SELECT   *
    FROM test_timestamp
ORDER BY evt_id;


INSERT INTO test_timestamp_no_type
     VALUES (1, SYSTIMESTAMP, 'normal inserted');

INSERT INTO test_timestamp_no_type
     VALUES (2, SYSTIMESTAMP, 'normal inserted');

COMMIT ;


SELECT   TO_CHAR (occurred_timestamp, 'YYYY-MM-DD HH24:MI:SS.FF')
    FROM test_timestamp_no_type
ORDER BY evt_id;

SPOOL off