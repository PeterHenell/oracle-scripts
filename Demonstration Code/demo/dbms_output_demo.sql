DECLARE
   PROCEDURE show_lines (add_newline_in IN BOOLEAN)
   IS
   BEGIN
      display_header (
         CASE
            WHEN add_newline_in THEN 'With NEW_LINE after PUTs'
            ELSE 'Without NEW_LINE after PUTs'
         END);
      DBMS_OUTPUT.put_line ('abc1');
      DBMS_OUTPUT.put_line ('abc2');
      DBMS_OUTPUT.put_line ('abc3');

      DBMS_OUTPUT.put ('abc4');

      IF add_newline_in
      THEN
         DBMS_OUTPUT.new_line;
      END IF;

      DBMS_OUTPUT.put ('abc5');

      IF add_newline_in
      THEN
         DBMS_OUTPUT.new_line;
      END IF;

      DBMS_OUTPUT.put_line (RPAD ('*', 80, '*'));
   END;
BEGIN
   DBMS_OUTPUT.put_line ('abc before disable');
   /* Disable output inside PL/SQL block */
   DBMS_OUTPUT.disable ();
   /* Turn out put back on */
   DBMS_OUTPUT.enable (1000000);

   show_lines (add_newline_in => FALSE);
   show_lines (add_newline_in => TRUE);
END;
/