/* drop the AQ demo
*/

SET ECHO OFF FEEDBACK OFF

host svrmgrl @droptrig
disconnect
connect aqadmin/aqadmin

EXEC DBMS_AQADM.STOP_QUEUE('eventq');
EXEC DBMS_AQADM.DROP_QUEUE('eventq');
EXEC DBMS_AQADM.DROP_QUEUE_TABLE('aqadmin.eventqtab', FORCE=>TRUE);

CONNECT sys/sys;
DROP USER aqadmin CASCADE;

SET ECHO ON FEEDBACK ON


REM  Copyright (c) 1999 DataCraft, Inc. and William L. Pribyl
REM  All Rights Reserved
