/*
** The DT_sync table is used to synchronize
** a specific value of V$TIMER.HESCS to an 
** Oracle SYSDATE value
*/
DROP TABLE DT_sync;
CREATE TABLE DT_sync
   (Instance_Start_Date   DATE
   ,DateX                 DATE
   ,Hsecs                 INTEGER
   ,CONSTRAINT DT_sync_PK PRIMARY KEY (Instance_Start_Date)
   );


CREATE OR REPLACE PACKAGE DT
AS

TYPE DateTime_rectype IS RECORD
   (DateX     DATE
   ,Hsecs     INTEGER
   );

FUNCTION DateTime RETURN DateTime_rectype;
FUNCTION DateTimeVC RETURN VARCHAR2;

END DT;
/

CREATE OR REPLACE PACKAGE BODY DT
AS
   /*
   ** Package: DT
   **
   ** created by:  John Beresniewicz, Savant Corporation
   **              12/10/1999
   **
   ** requirements:  SELECT on SYS.V_$TIMER
   **                SELECT on SYS.V_$INSTANCE 
   */

   hsecs_per_day   INTEGER := 60*60*24*100;

   /*
   ** pkg global rec of current time sync row
   */
   Sync_rec  DT_sync%ROWTYPE;

   /*
   ** cursor to fetch sysdate and hsecs past the 
   ** current second sync'ed with baseline
   */
   CURSOR DateTime_cur
   IS
   SELECT
          SYSDATE
         ,(T.hsecs - Sync_rec.Hsecs) - ( (SYSDATE - Sync_rec.DateX) * hsecs_per_day)
     FROM
          sys.v_$timer       T;

   /*
   ** function to return current sync'ed date and hsecs past second
   */
   FUNCTION DateTime RETURN DateTime_rectype
   IS
      DateTime_rec   DateTime_rectype;
   BEGIN
      OPEN DateTime_cur;
      FETCH DateTime_cur INTO DateTime_rec.DateX,DateTime_rec.hsecs;
      CLOSE DateTime_cur;
      RETURN DateTime_rec;
   END DateTime;

   FUNCTION DateTimeVC RETURN VARCHAR2
   IS
      DateTime_rec   DateTime_rectype := DateTime;
   BEGIN
      RETURN TO_CHAR(DateTime_rec.DateX,'YYYY:MM:DD:HH:MI:SS:')||TO_CHAR(DateTime_rec.Hsecs);
   END DateTimeVC;

   /*
   ** procedure to initialize pkg global rec and also
   ** sync table if not done already for this instance start
   */
   PROCEDURE load_sync_rec
   IS
   BEGIN
      WHILE Sync_rec.Instance_Start_Date IS NULL
      LOOP
         BEGIN
            SELECT D.*
              INTO Sync_rec
              FROM
                   DT_sync            D
                  ,sys.v_$instance    I 
             WHERE
                   I.startup_time   = D.Instance_Start_Date;
         EXCEPTION
            WHEN NO_DATA_FOUND
               THEN
               /*
               ** the real magic is buried here
               */
                  DECLARE
                     prev_date      DATE;
                     prev_hsecs     INTEGER;
                  BEGIN             
                     SELECT SYSDATE, hsecs
                       INTO prev_date, prev_hsecs
                       FROM sys.v_$timer;

                     /*
                     ** loop ends on first new datestamp beyond prev_date
                     */
                     WHILE NVL(Sync_rec.DateX,prev_date) = prev_date
                     LOOP
                        DBMS_LOCK.SLEEP(.01);

                        SELECT SYSDATE, hsecs
                          INTO Sync_rec.DateX, Sync_rec.Hsecs
                          FROM sys.v_$timer;
                     END LOOP;

                     /*
                     ** now we should have an hsecs value synced
                     ** to changing of a second in SYSDATE
                     */
                     INSERT INTO DT_sync
                        (Instance_Start_Date, DateX, Hsecs)
                     SELECT
                            I.startup_time
                           ,Sync_rec.DateX
                           ,Sync_rec.Hsecs
                       FROM
                            sys.v_$instance   I;

                  END;
         END;
         COMMIT WORK;
      END LOOP;
   END load_sync_rec;


/*
** package initialization
*/
BEGIN
   load_sync_rec;
END DT;
/

select * from user_errors;

set serveroutput on size 1000000

BEGIN
   FOR i IN 1..110
   LOOP
      DBMS_OUTPUT.PUT_LINE('iter: '||TO_CHAR(i)||' DT: '||DT.DateTimeVC);
      DBMS_LOCK.SLEEP(.01);
   END LOOP;
END;
/

