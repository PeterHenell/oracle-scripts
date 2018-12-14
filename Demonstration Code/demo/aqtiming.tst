/* Clear out the queue for the test. */
exec aq.stop_and_drop ('sale_qtable');

/* Rebuild the queues. */
@aqtiming.ins

/*
|| NOTE: To run this script you must have execute authority on DBMS_LOCK.
||       If you do not will see this error:
||
||       PLS-00201: identifier 'SYS.DBMS_LOCK' must be declared
||
||       You or your DBA will need to connect to SYS and issue this command:
||
||       GRANT EXECUTE ON DBMS_LOCK TO PUBLIC;
*/
DECLARE
   FUNCTION seconds_from_now (num IN INTEGER) RETURN DATE
   IS
   BEGIN
      RETURN SYSDATE + num / (24 * 60 * 60);
   END;

   PROCEDURE show_sales_status (product_in IN VARCHAR2)
   IS
      v_onsale BOOLEAN := sale.onsale (product_in);
      v_qualifier VARCHAR2(5) := NULL;
   BEGIN
      IF NOT v_onsale
      THEN
         v_qualifier := ' not';
      END IF;

      DBMS_OUTPUT.PUT_LINE (product_in || 
         ' is' || v_qualifier || ' on sale at ' ||
         TO_CHAR (SYSDATE, 'HH:MI:SS'));
   END;
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Start test at ' || TO_CHAR (SYSDATE, 'HH:MI:SS'));

   sale.mark_for_sale ('Captain Planet', 15.95, 
      seconds_from_now (30), seconds_from_now (50));
   
   sale.mark_for_sale ('Mr. Math', 12.95, 
      seconds_from_now (120), seconds_from_now (180));

   show_sales_status ('Captain Planet');
   show_sales_status ('Mr. Math');
   
   DBMS_LOCK.SLEEP (30);
   DBMS_OUTPUT.PUT_LINE ('Slept for 30 seconds.');
   show_sales_status ('Captain Planet');
   show_sales_status ('Mr. Math');

   sale.show_expired_sales;

   DBMS_LOCK.SLEEP (100);
   DBMS_OUTPUT.PUT_LINE ('Slept for 100 seconds.');
   show_sales_status ('Captain Planet');
   show_sales_status ('Mr. Math');

   sale.show_expired_sales;

   DBMS_LOCK.SLEEP (70);
   DBMS_OUTPUT.PUT_LINE ('Slept for 70 seconds.');
   show_sales_status ('Captain Planet');
   show_sales_status ('Mr. Math');

   sale.show_expired_sales; 
END;
/