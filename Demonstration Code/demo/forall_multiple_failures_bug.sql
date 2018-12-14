CREATE TABLE fk_table
(
   fk_id      NUMBER
 , fk_descr   VARCHAR2 (255)
 , CONSTRAINT fk_table_pk PRIMARY KEY (fk_id)
);

CREATE TABLE source_table
(
   u_id      NUMBER NOT NULL
 , dt        DATE NOT NULL
 , fk_id     NUMBER NOT NULL
 , notes     VARCHAR2 (200)
 , err_msg   VARCHAR2 (500)
);

CREATE TABLE target_table
(
   u_id    NUMBER NOT NULL
 , dt      DATE NOT NULL
 , fk_id   NUMBER NOT NULL
 , notes   VARCHAR2 (200)
 , CONSTRAINT target_table_pk PRIMARY KEY (u_id, dt, fk_id)
)
PARTITION BY RANGE (dt) (PARTITION p_2005_01_01
                            VALUES LESS THAN
                               (TO_DATE ('2005-01-01', 'yyyy-mm-dd'))
                       , PARTITION p_2005_02_01
                            VALUES LESS THAN
                               (TO_DATE ('2005-02-01', 'yyyy-mm-dd'))
                       , PARTITION records_max
                            VALUES LESS THAN (maxvalue)
                        );

ALTER TABLE target_table ADD CONSTRAINT target_table_fk FOREIGN KEY( fk_id )
  REFERENCES fk_table( fk_id );

INSERT INTO source_table (u_id, dt, fk_id, notes
                         )
    VALUES (1, TO_DATE ('2005-01-02', 'yyyy-mm-dd'), 1, 'aaaa'
           );

INSERT INTO source_table (u_id, dt, fk_id, notes
                         )
    VALUES (2, TO_DATE ('2005-01-02', 'yyyy-mm-dd'), 4, 'bbbbb'
           );

INSERT INTO source_table (u_id, dt, fk_id, notes
                         )
    VALUES (3, TO_DATE ('2005-01-02', 'yyyy-mm-dd'), 2, 'cccc'
           );

INSERT INTO source_table (u_id, dt, fk_id, notes
                         )
    VALUES (1, TO_DATE ('2005-01-02', 'yyyy-mm-dd'), 1, 'fffff'
           );

INSERT INTO source_table (u_id, dt, fk_id, notes
                         )
    VALUES (1, TO_DATE ('2005-01-02', 'yyyy-mm-dd'), 1, 'wwwww'
           );

COMMIT;

/*
the following PL/SQL will generate seven errors -
ORA-02291 on all rows and ORA-00001 on rows 4 and 5:
*/

set serveroutput on size 1000000

DECLARE
   TYPE u_id_tabtype IS TABLE OF source_table.u_id%TYPE;

   TYPE dt_tabtype IS TABLE OF source_table.dt%TYPE;

   TYPE fk_id_tabtype IS TABLE OF source_table.fk_id%TYPE;

   TYPE notes_tabtype IS TABLE OF source_table.notes%TYPE;

   v_u_id    u_id_tabtype;
   v_dt      dt_tabtype;
   v_fk_id   fk_id_tabtype;
   v_notes   notes_tabtype;
   v_bulk_errors EXCEPTION;
   PRAGMA EXCEPTION_INIT (v_bulk_errors, -24381);
BEGIN
   SELECT u_id, dt, fk_id, notes
     BULK COLLECT
     INTO v_u_id, v_dt, v_fk_id, v_notes
     FROM source_table;

   IF v_u_id.COUNT > 0
   THEN
      BEGIN
         FORALL ii IN v_u_id.FIRST .. v_u_id.LAST
         SAVE EXCEPTIONS
            INSERT INTO target_table (u_id, dt, fk_id, notes
                                     )
                VALUES (v_u_id (ii), v_dt (ii), v_fk_id (ii), v_notes (ii)
                       );
      EXCEPTION
         WHEN v_bulk_errors
         THEN
            FOR jj IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
            LOOP
               DBMS_OUTPUT.put_line(   'An error '
                                    || jj
                                    || ' was occured on '
                                    || SQL%BULK_EXCEPTIONS (jj).ERROR_INDEX
                                    || ' row. Oracle error: '
                                    || SQLERRM(-1
                                               * SQL%BULK_EXCEPTIONS (jj).ERROR_CODE));
            END LOOP;
      END;
   END IF;
END;
/

show errors