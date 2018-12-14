DECLARE
   ts   TIMESTAMP;
BEGIN
   ts := TIMESTAMP '2011-10-30 13:14:15';
   DBMS_OUTPUT.put_line (
      TO_CHAR (ts, 'YYYY-MM-DD HH24:MI:SS.FF'));
END;
/

DECLARE
   ts   TIMESTAMP;
BEGIN
   ts := TIMESTAMP '2011-10-30 13:14:15.0';
   DBMS_OUTPUT.put_line (
      TO_CHAR (ts, 'YYYY-MM-DD HH24:MI:SS.FF'));
END;
/

/* PLS-00166: 
   bad format for date, time, timestamp or interval literal */

DECLARE
   ts   TIMESTAMP;
BEGIN
   ts := TIMESTAMP '2011-10-30 13:14:15:0';
   DBMS_OUTPUT.put_line (
      TO_CHAR (ts, 'YYYY-MM-DD HH24:MI:SS.FF'));
END;
/

DECLARE
   ts   TIMESTAMP;
BEGIN
   ts := TIMESTAMP '2011-10-30 13:14:15.00000';
   DBMS_OUTPUT.put_line (
      TO_CHAR (ts, 'YYYY-MM-DD HH24:MI:SS.FF'));
END;
/

DECLARE
   ts   TIMESTAMP;
BEGIN
   ts := TIMESTAMP '2011-10-30 13:14:15.000000000';
   DBMS_OUTPUT.put_line (
      TO_CHAR (ts, 'YYYY-MM-DD HH24:MI:SS.FF'));
END;
/

/* PLS-00166: bad format for date, time, timestamp or interval literal */

DECLARE
   ts   TIMESTAMP;
BEGIN
   ts := TIMESTAMP '2011-10-30 13:14:15.0000000000';
   DBMS_OUTPUT.put_line (
      TO_CHAR (ts, 'YYYY-MM-DD HH24:MI:SS.FF'));
END;
/