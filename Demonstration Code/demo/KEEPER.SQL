DROP TABLE keep_objects;

CREATE TABLE keep_objects
   (
    obj_schema    VARCHAR2(30)  NOT NULL
   ,obj_name      VARCHAR2(30)  NOT NULL
   ,CONSTRAINT ko_PK PRIMARY KEY 
                  (obj_schema, obj_name)
   )
STORAGE (INITIAL 2
         NEXT    2
         PCTINCREASE 0);


CREATE OR REPLACE PROCEDURE object_keeper
   /*
   || Procedure to pin objects into the shared pool
   || using DBMS_SHARED_POOL.KEEP procedure.  All 
   || objects found in the KEEP_OBJECTS table will
   || be KEEPed.
   ||
   || For best results, procedure should be created
   || in the SYS schema.
   ||
   || Author:  John Beresniewicz, Savant Corp
   || Created: 09/18/97
   ||
   || Compilation Requirements:
   ||
   || SELECT on SYS.DBA_OBJECTS
   || EXECUTE on SYS.DBMS_SHARED_POOL
   ||
   || Execution Requirements:
   ||
   || Some SYS objects may get ORA-1031 unless
   || the procedure is run by SYS
   ||
   */
IS
   CURSOR keep_objects_cur
   IS
   SELECT  DO.owner||'.'||DO.object_name  object
          ,DECODE(DO.object_type
                  ,'PACKAGE','P'
                  ,'PROCEDURE','P'
                  ,'FUNCTION','P'
                  ,'TRIGGER','R'
                  ,null
                 )                        type
     FROM  keep_objects  KO
          ,dba_objects   DO
    WHERE UPPER(KO.obj_schema) = DO.owner
      AND UPPER(KO.obj_name)   = DO.object_name
      AND DO.object_type IN 
            ('PACKAGE','PROCEDURE','FUNCTION','TRIGGER');
BEGIN
   FOR ko_rec IN keep_objects_cur
   LOOP
      BEGIN
         SYS.DBMS_SHARED_POOL.KEEP
            (ko_rec.object, ko_rec.type);
         DBMS_OUTPUT.PUT_LINE
            ('KEEPED:  '||ko_rec.object);

      EXCEPTION
         WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            DBMS_OUTPUT.PUT_LINE
               ('KEEP FAIL: '||ko_rec.object||' '||ko_rec.type);
      END;
   END LOOP;
END object_keeper;
/
