CREATE OR REPLACE PACKAGE BODY ut_watch
IS
   PROCEDURE setup
   IS
   BEGIN
      -- For each program to test...
      utPLSQL.addtest ('ACTION1');
      utPLSQL.addtest ('ACTION2');
      utPLSQL.addtest ('ACTION3');
      utPLSQL.addtest ('ACTION4');
      utPLSQL.addtest ('ACTION5');
      utPLSQL.addtest ('FINISH');
      utPLSQL.addtest ('NOUSECS');
      utPLSQL.addtest ('SHOW');
      utPLSQL.addtest ('STARTUP');
      utPLSQL.addtest ('TOPIPE');
      utPLSQL.addtest ('TOSCREEN');
      utPLSQL.addtest ('USECS');
      utPLSQL.addtest ('USING_CS');
   END;
   
   PROCEDURE teardown
   IS
   BEGIN
      NULL;
   END;

   -- For each program to test...
   PROCEDURE ACTION1 IS
   BEGIN
            WATCH.ACTION (
            PROG => ''
            ,
            VAL => ''
       );

      utAssert.this (
         'Test of ACTION',
         '<boolean expression>'
         );
   END ACTION1;

   PROCEDURE ACTION2 IS
   BEGIN
            WATCH.ACTION (
            PROG => ''
            ,
            VAL => ''
       );

      utAssert.this (
         'Test of ACTION',
         '<boolean expression>'
         );
   END ACTION2;

   PROCEDURE ACTION3 IS
   BEGIN
            WATCH.ACTION (
            PROG => ''
            ,
            VAL => ''
       );

      utAssert.this (
         'Test of ACTION',
         '<boolean expression>'
         );
   END ACTION3;

   PROCEDURE ACTION4 IS
   BEGIN
            WATCH.ACTION (
            PROG => ''
            ,
            VAL => ''
       );

      utAssert.this (
         'Test of ACTION',
         '<boolean expression>'
         );
   END ACTION4;

   PROCEDURE ACTION5 IS
   BEGIN
            WATCH.ACTION (
            WATCHING => ''
            ,
            PROG => ''
            ,
            VAL => ''
       );

      utAssert.this (
         'Test of ACTION',
         '<boolean expression>'
         );
   END ACTION5;

   PROCEDURE FINISH IS
   BEGIN
            WATCH.FINISH (
            PROG => ''
            ,
            VAL => ''
       );

      utAssert.this (
         'Test of FINISH',
         '<boolean expression>'
         );
   END FINISH;

   PROCEDURE NOUSECS IS
   BEGIN
      WATCH.NOUSECS;

      utAssert.this (
         'Test of NOUSECS',
         '<boolean expression>'
         );
   END NOUSECS;

   PROCEDURE SHOW IS
   BEGIN
            WATCH.SHOW (
            PIPE_IN => ''
       );

      utAssert.this (
         'Test of SHOW',
         '<boolean expression>'
         );
   END SHOW;

   PROCEDURE STARTUP IS
   BEGIN
            WATCH.STARTUP (
            PROG => ''
            ,
            VAL => ''
       );

      utAssert.this (
         'Test of STARTUP',
         '<boolean expression>'
         );
   END STARTUP;

   PROCEDURE TOPIPE IS
   BEGIN
            WATCH.TOPIPE (
            PIPE_IN => ''
       );

      utAssert.this (
         'Test of TOPIPE',
         '<boolean expression>'
         );
   END TOPIPE;

   PROCEDURE TOSCREEN IS
   BEGIN
      WATCH.TOSCREEN;

      utAssert.this (
         'Test of TOSCREEN',
         '<boolean expression>'
         );
   END TOSCREEN;

   PROCEDURE USECS IS
   BEGIN
      WATCH.USECS;

      utAssert.this (
         'Test of USECS',
         '<boolean expression>'
         );
   END USECS;

   PROCEDURE USING_CS IS
   BEGIN
      utAssert.this (
         'Test of USING_CS',
               WATCH.USING_CS
         );
   END USING_CS;

END ut_watch;
/
