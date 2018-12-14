CREATE OR REPLACE PROCEDURE chgtime (
   dt IN OUT DATE, 
   newtime IN VARCHAR2,
   timemask IN VARCHAR2 := 'HH24:MI:SS')
IS
BEGIN
   dt := 
   TO_DATE (
         TO_CHAR (TRUNC (dt), 'MMDDYYYY') || 
         newtime,
         'MMDDYYYY' || timemask
         );   
END;
/					
declare
   dt DATE := SYSDATE;
begin
   DBMS_OUTPUT.PUT_LINE (TO_CHAR (dt, 'MM/DD/YY HH24:MI:SS'));
   chgtime (dt, '13:13:13');
   DBMS_OUTPUT.PUT_LINE (TO_CHAR (dt, 'MM/DD/YY HH24:MI:SS'));
end;
/   
   