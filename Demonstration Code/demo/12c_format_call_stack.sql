CREATE OR REPLACE PROCEDURE format_call_stack_12c
IS
BEGIN
   DBMS_OUTPUT.put_line (
      'LexDepth Depth LineNo Name');
   DBMS_OUTPUT.put_line (
      '-------- ----- ------ ----');

   FOR the_depth IN REVERSE 1 ..
                        utl_call_stack.dynamic_depth ()
   LOOP
      DBMS_OUTPUT.put_line (
            RPAD (
               utl_call_stack.lexical_depth (
                  the_depth),
               9)
         || RPAD (the_depth, 5)
         || RPAD (
               TO_CHAR (
                  utl_call_stack.unit_line (
                     the_depth),
                  '99'),
               8)
         || utl_call_stack.concatenate_subprogram (
               utl_call_stack.subprogram (
                  the_depth)));
   END LOOP;
END;
/

CREATE OR REPLACE PACKAGE pkg
IS
   PROCEDURE do_stuff;
END;
/

CREATE OR REPLACE PACKAGE BODY pkg
IS
   PROCEDURE do_stuff
   IS
      PROCEDURE np1
      IS
         PROCEDURE np2
         IS
            PROCEDURE np3
            IS
            BEGIN
               format_call_stack_12c;
            END;
         BEGIN
            np3;
         END;
      BEGIN
         np2;
      END;
   BEGIN
      np1;
   END;
END;
/

BEGIN
   pkg.do_stuff;
END;
/

/*
LexDepth Depth LineNo Name
-------- ----- ------ ----
0         6        2      __anonymous_block
1         5       21      PKG.DO_STUFF
2         4       18      PKG.DO_STUFF.NP1
3         3       15      PKG.DO_STUFF.NP1.NP2
4         2       12      PKG.DO_STUFF.NP1.NP2.NP3
0         1       12      FORMAT_CALL_STACK_12C
*/