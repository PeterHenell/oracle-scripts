/* Part of Aqvanced Queueing demo, called by aq.sql
*/

ALTER SESSION SET NLS_DATE_FORMAT = 'DD MON HH24:MI:SS';

/* First dequeued message will be the connect from this session
*/
EXEC oraevent.shownext

/* Next message will be from a connection by system in the
|| session that started this window
*/
EXEC oraevent.shownext

/* Next message will be from a SCOTT/TIGER connection
*/
EXEC oraevent.shownext

/* Exit this window before running "noaq" to release [DDL?] lock */


REM  Copyright (c) 1999 DataCraft, Inc. and William L. Pribyl
REM  All Rights Reserved
