CREATE OR REPLACE PACKAGE my_commit
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
||  Overview: use my_commit.perform_commit in place of a direct
||            call to the COMMIT; statement. This will give you
||            more flexibility when testing your code, since
||            you can disable your commit processing with a
||            call to my_commit.turn_off.
||
||            You can also turn on tracing so that whenever you
||            call perform_commit, a trace of that action will
||            be displayed with DBMS_OUTPUT.PUT_LINE.
||
----------------------------------------------------------------*/
IS
   /* Control committing; turned ON by default. */
   PROCEDURE turn_on;

   PROCEDURE turn_off;

   FUNCTION committing
      RETURN BOOLEAN;

   /* Commit substitute */
   PROCEDURE perform_commit (context_in IN VARCHAR2 := NULL);

   /* Incremental commit processing */
   PROCEDURE init_counter;

   PROCEDURE increment_and_commit (context_in IN VARCHAR2 := NULL);

   PROCEDURE commit_after (count_in IN INTEGER);

   /* Tracing commit execution */
   PROCEDURE trace_on;

   PROCEDURE trace_off;

   FUNCTION tracing
      RETURN BOOLEAN;
END my_commit;
/