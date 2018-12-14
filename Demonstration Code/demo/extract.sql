
DECLARE
   age        INTERVAL YEAR (3)TO MONTH   := INTERVAL '47-3' YEAR TO MONTH;
   rightnow   TIMESTAMP ( 3 ) WITH TIME ZONE
      := TO_TIMESTAMP_TZ
                        ('29-JAN-2002 12:08:12.0778   US/Pacific     PST'
                        ,'DD-MON-YYYY HH24:MI:SSXFF   TZR            TZD'
                        );
BEGIN
-- Pre-Oracle9i
   p.l (TO_CHAR (SYSDATE, 'yyyy'));
-- With Oracle9i Extract
   p.l (EXTRACT (YEAR FROM SYSDATE));
   p.l (EXTRACT (MONTH FROM SYSDATE));
   --p.l (EXTRACT (SECOND FROM SYSDATE));
   p.l (EXTRACT (YEAR FROM age));
   p.l (EXTRACT (TIMEZONE_ABBR FROM rightnow));
   p.l (EXTRACT (TIMEZONE_REGION FROM rightnow));
   p.l (EXTRACT (SECOND FROM rightnow));
END;
