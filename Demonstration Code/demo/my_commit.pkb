CREATE OR REPLACE PACKAGE BODY my_commit
/*----------------------------------------------------------------
||  Adapted from PL/Vision
||----------------------------------------------------------------
||  Author: Steven Feuerstein
||  Copyright (C) 1996-2007 Quest Software
||  All rights reserved.
||
||  This is freeware software. You are welcome to use in your
||  own applications. This software is NOT supported by Quest.
||
----------------------------------------------------------------*/
IS
   g_do_commit      BOOLEAN := TRUE;
   g_commit_after   INTEGER := 1;
   g_counter        INTEGER := 0;
   g_trc            BOOLEAN := FALSE;

   PROCEDURE commit_after (count_in IN INTEGER)
   IS
   BEGIN
      g_commit_after := NVL (count_in, 1);
   END;

   PROCEDURE turn_on
   IS
   BEGIN
      g_do_commit := TRUE;
   END;

   PROCEDURE turn_off
   IS
   BEGIN
      g_do_commit := FALSE;
   END;

   FUNCTION committing
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN g_do_commit;
   END;

   PROCEDURE trace_on
   IS
   BEGIN
      g_trc := TRUE;
   END;

   PROCEDURE trace_off
   IS
   BEGIN
      g_trc := FALSE;
   END;

   FUNCTION tracing
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN g_trc;
   END;

   PROCEDURE trace_action (context_in IN VARCHAR2, message_in IN VARCHAR2)
   IS
   BEGIN
      IF tracing ()
      THEN
         DBMS_OUTPUT.put_line (
            'my_commit trace: ' || context_in || ' - ' || message_in
         );
      END IF;
   END trace_action;

   /* my_commit version of COMMIT */
   PROCEDURE perform_commit (context_in IN VARCHAR2 := NULL)
   IS
   BEGIN
      trace_action (
         'perform_commit'
       , CASE
            WHEN committing () THEN '*COMMIT ENABLED*'
            ELSE '*COMMIT DISABLED*'
         END
         || ' '
         || context_in
      );

      IF committing ()
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE init_counter
   IS
   BEGIN
      g_counter := 0;
   END;

   PROCEDURE increment_and_commit (context_in IN VARCHAR2 := NULL)
   IS
   BEGIN
      trace_action ('increment_and_commit', context_in);

      IF g_commit_after <= g_counter AND g_commit_after > 0
      THEN
         perform_commit (context_in);
         init_counter;
      ELSE
         g_counter := g_counter + 1;
      END IF;
   END;
END my_commit;
/