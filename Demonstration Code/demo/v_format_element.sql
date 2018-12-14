CREATE OR REPLACE PROCEDURE plch_show_stocks_sold (units_in IN INTEGER)
IS
BEGIN
   DBMS_OUTPUT.put_line (TO_CHAR (units_in, 'FM999G9V99'));
END;
/

BEGIN
   plch_show_stocks_sold (123);
END;
/

CREATE OR REPLACE PROCEDURE plch_show_stocks_sold (units_in IN INTEGER)
IS
BEGIN
   DBMS_OUTPUT.put_line (TO_CHAR (units_in * 100, 'FM999G999'));
END;
/

BEGIN
   plch_show_stocks_sold (123);
END;
/

CREATE OR REPLACE PROCEDURE plch_show_stocks_sold (units_in IN INTEGER)
IS
BEGIN
   DBMS_OUTPUT.put_line (TO_CHAR (units_in * 100, 'FM999999'));
END;
/

BEGIN
   plch_show_stocks_sold (123);
END;
/

CREATE OR REPLACE PROCEDURE plch_show_stocks_sold (units_in IN INTEGER)
IS
BEGIN
   DBMS_OUTPUT.put_line (TO_CHAR (units_in, 'FM999G999'));
END;
/

BEGIN
   plch_show_stocks_sold (123);
END;
/