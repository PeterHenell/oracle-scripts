ALTER SESSION SET PLSQL_WARNINGS = 'ENABLE:ALL'
/

create or replace PACKAGE salespkg
IS
   PROCEDURE calc_total (zone_in IN VARCHAR2);

   PROCEDURE calc_total (reg_in IN VARCHAR2);

END salespkg; 
/

create or replace PACKAGE BODY salespkg
IS
   PROCEDURE calc_total (zone_in IN VARCHAR2)
   IS
   BEGIN p.l ('zone'); END;

   PROCEDURE calc_total (reg_in IN VARCHAR2)
   IS
   BEGIN p.l ('region'); END;

END salespkg; 
/

BEGIN
   salespkg.calc_total ('zone15');
END;
/

BEGIN
   salespkg.calc_total (zone_in => 'zone15');
END;
/

create or replace PACKAGE salespkg
IS
   PROCEDURE calc_total (reg_in IN CHAR);

   PROCEDURE calc_total (reg_in IN VARCHAR2);

END salespkg; 
/
create or replace PACKAGE BODY salespkg
IS
   PROCEDURE calc_total (reg_in IN CHAR)
   IS
   BEGIN p.l ('region'); END;

   PROCEDURE calc_total (reg_in IN VARCHAR2)
   IS
   BEGIN p.l ('region'); END;

END salespkg; 
/   

BEGIN
   salespkg.calc_total ('reg11');
END;
/

BEGIN
   salespkg.calc_total (reg_in => 'reg11');
END;
/

DECLARE
   l_char   CHAR (2) := 'ab';
BEGIN
   salespkg.calc_total (reg_in => l_char);
END;
/

create or replace PACKAGE salespkg
IS
   PROCEDURE calc_total (zone_in IN CHAR, date_in in DATE DEFAULT SYSDATE);

   PROCEDURE calc_total (zone_in IN VARCHAR2);

END salespkg; 
/
create or replace PACKAGE BODY salespkg
IS
   PROCEDURE calc_total (zone_in IN CHAR, date_in in DATE DEFAULT SYSDATE)
   IS
   BEGIN p.l ('zone with date'); END;

   PROCEDURE calc_total (zone_in IN VARCHAR2)
   IS
   BEGIN p.l ('zone'); END;

END salespkg; 
/  

BEGIN
   salespkg.calc_total ('reg11');
END;
/ 

BEGIN
   salespkg.calc_total ('reg11', sysdate);
END;
/ 
