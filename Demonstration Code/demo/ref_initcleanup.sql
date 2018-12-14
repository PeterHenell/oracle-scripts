Step 1 Move initialize and cleanup logic to local modules. (PL/SQL refactoring)

Step 1 in the refactoring of topic "Move initialize and cleanup logic to local 
 modules."

Identify startup logic and move that to an initialization program. Decide on wh
hether you want to return data through the parameter list or just treat them as
s globals within the program.

Universal ID = {AF78FA27-4E61-4A2F-801C-191C7FECA21B}

CREATE OR REPLACE FUNCTION eqfiles (
   check_this_in         IN   VARCHAR2
  ,check_this_dir_in     IN   VARCHAR2
  ,against_this_in       IN   VARCHAR2
  ,against_this_dir_in   IN   VARCHAR2 := NULL
)
   RETURN BOOLEAN
IS
   checkid       UTL_FILE.file_type;
   checkline     VARCHAR2 (32767);
   check_eof     BOOLEAN;
   againstid     UTL_FILE.file_type;
   againstline   VARCHAR2 (32767);
   against_eof   BOOLEAN;
   retval        BOOLEAN;
 
   PROCEDURE initialize
   IS
   BEGIN
      -- Open both files, read-only.
      checkid :=
         UTL_FILE.fopen (check_this_dir_in
                        ,check_this_in
                        ,'R'
                        ,max_linesize      => 32767
                        );
      againstid :=
         UTL_FILE.fopen (NVL (against_this_dir_in, check_this_dir_in)
                        ,against_this_in
                        ,'R'
                        ,max_linesize      => 32767
                        );
   END initialize;
BEGIN
   initialize;
 
   LOOP
      BEGIN
         UTL_FILE.get_line (checkid, checkline);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            check_eof := TRUE;
      END;
 
      BEGIN
         UTL_FILE.get_line (againstid, againstline);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            against_eof := TRUE;
      END;
 
      IF (check_eof AND against_eof)
      THEN
         retval := TRUE;
         EXIT;
      ELSIF (checkline != againstline) OR (check_eof OR against_eof)
      THEN
         retval := FALSE;
         EXIT;
      END IF;
   END LOOP;
 
   UTL_FILE.fclose (checkid);
   UTL_FILE.fclose (againstid);
   RETURN retval;
END eqfiles;
/
================================================================================
Step 3 Move initialize and cleanup logic to local modules. (PL/SQL refactoring)

Step 2 in the refactoring of topic "Move initialize and cleanup logic to local 
 modules."

Let's do a final sweep through the code, looking for additional opportunities t
to simplify the executable section, make the program more robust. I decide to..
..

* Replace the native GET_LINE code with a local procedure to hide the poor desi
ign of that built-in.

* I add a parameter to cleanup to pass the value that is to be returned. This c
consolidates my cleanup/termination logic a bit more tightly.

* Add END labels.

Universal ID = {083A0062-84AE-4036-B42D-2BC7D904186D}

CREATE OR REPLACE FUNCTION eqfiles (
   check_this_in         IN   VARCHAR2
  ,check_this_dir_in     IN   VARCHAR2
  ,against_this_in       IN   VARCHAR2
  ,against_this_dir_in   IN   VARCHAR2 := NULL
)
   RETURN BOOLEAN
IS
   checkid       UTL_FILE.file_type;
   checkline     VARCHAR2 (32767);
   check_eof     BOOLEAN;
   againstid     UTL_FILE.file_type;
   againstline   VARCHAR2 (32767);
   against_eof   BOOLEAN;
   retval        BOOLEAN;
 
   PROCEDURE initialize
   IS
   BEGIN
      -- Open both files, read-only.
      checkid :=
         UTL_FILE.fopen (check_this_dir_in
                        ,check_this_in
                        ,'R'
                        ,max_linesize      => 32767
                        );
      againstid :=
         UTL_FILE.fopen (NVL (against_this_dir_in, check_this_dir_in)
                        ,against_this_in
                        ,'R'
                        ,max_linesize      => 32767
                        );
   END initialize;
 
   PROCEDURE cleanup_and_return (return_value_in IN BOOLEAN)
   IS
   BEGIN
      UTL_FILE.fclose (checkid);
      UTL_FILE.fclose (againstid); 
      RETURN return_value_in;
   END cleanup_and_return;
 
   PROCEDURE get_next_line_from_file (
      file_in    IN       UTL_FILE.file_type
     ,line_out   OUT      VARCHAR2
     ,eof_out    OUT      BOOLEAN
   )
   IS
   BEGIN
      UTL_FILE.get_line (file_in, line_out);
      eof_out := FALSE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         line_out := NULL;
         eof_out := TRUE;
   END get_next_line_from_file;
BEGIN
   initialize;
 
   LOOP
      get_next_line_from_file (checkid, checkline, check_eof);
      get_next_line_from_file (againstid, againstline, against_eof);
 
      IF (check_eof AND against_eof)
      THEN
         retval := TRUE;
         EXIT;
      ELSIF (checkline != againstline) OR (check_eof OR against_eof)
      THEN
         retval := FALSE;
         EXIT;
      END IF;
   END LOOP;
 
   cleanup_and_return (retval);
EXCEPTION
   WHEN OTHERS
   THEN
      cleanup_and_return (FALSE);
END eqfiles;
/
================================================================================
Step 0: Problematic code for  Move initialize and cleanup logic to local modules. (PL/SQL refactoring) 

The problematic code for that demonstrates "Move initialize and cleanup logic t
to local modules. (PL/SQL refactoring)"

You should especially be on the lookout for this refactoring if you work with f
files (UTL_FILE) or perform dynamic SQL with DBMS_SQL. In both cases, you will 
 want to be sure to clean up with care for both successful and error terminatio
ons of the program.

This program compares two files to see if they are equal. All the logic is in t
the executable section and there is no exception section.

Universal ID = {3F2AA75D-0139-4042-9681-C523ED022FB4}

CREATE OR REPLACE FUNCTION eqfiles (
   check_this_in         IN   VARCHAR2
  ,check_this_dir_in     IN   VARCHAR2
  ,against_this_in       IN   VARCHAR2
  ,against_this_dir_in   IN   VARCHAR2 := NULL
)
   RETURN BOOLEAN
IS
   checkid       UTL_FILE.file_type;
   checkline     VARCHAR2 (32767);
   check_eof     BOOLEAN;
   againstid     UTL_FILE.file_type;
   againstline   VARCHAR2 (32767);
   against_eof   BOOLEAN;
   retval        BOOLEAN;
BEGIN
   -- Open both files, read-only.
   checkid :=
      UTL_FILE.fopen (check_this_dir_in
                     ,check_this_in
                     ,'R'
                     ,max_linesize      => 32767
                     );
 
   againstid :=
      UTL_FILE.fopen (NVL (against_this_dir_in, check_this_dir_in)
                     ,against_this_in
                     ,'R'
                     ,max_linesize      => 32767
                     );
 
   LOOP
      BEGIN
         UTL_FILE.get_line (checkid, checkline);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            check_eof := TRUE;
      END;
 
      BEGIN
         UTL_FILE.get_line (againstid, againstline);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            against_eof := TRUE;
      END;
 
      IF (check_eof AND against_eof)
      THEN
         retval := TRUE;
         EXIT;
      ELSIF (checkline != againstline) OR 
            (check_eof OR against_eof)
      THEN
         retval := FALSE;
         EXIT;
      END IF;
   END LOOP;
 
   UTL_FILE.fclose (checkid);
   UTL_FILE.fclose (againstid);
   RETURN retval;
END eqfiles;
/
================================================================================
Step 2 Move initialize and cleanup logic to local modules. (PL/SQL refactoring)

Step 2 in the refactoring of topic "Move initialize and cleanup logic to local 
 modules."

Identify the code that needs to be run when the program ends. Does it need to b
be run both for successful completion and failure? Is there a difference in wha
at needs to be run? Then move the logic to a local procedure, and call that pro
ocedure as needed.

Universal ID = {1153266D-6926-4EB7-A50F-8BFDCA715904}

CREATE OR REPLACE FUNCTION eqfiles (
   check_this_in         IN   VARCHAR2
  ,check_this_dir_in     IN   VARCHAR2
  ,against_this_in       IN   VARCHAR2
  ,against_this_dir_in   IN   VARCHAR2 := NULL
)
   RETURN BOOLEAN
IS
   checkid       UTL_FILE.file_type;
   checkline     VARCHAR2 (32767);
   check_eof     BOOLEAN;
   againstid     UTL_FILE.file_type;
   againstline   VARCHAR2 (32767);
   against_eof   BOOLEAN;
   retval        BOOLEAN;
 
   PROCEDURE initialize
   IS
   BEGIN
      -- Open both files, read-only.
      checkid :=
         UTL_FILE.fopen (check_this_dir_in
                        ,check_this_in
                        ,'R'
                        ,max_linesize      => 32767
                        );
      againstid :=
         UTL_FILE.fopen (NVL (against_this_dir_in, check_this_dir_in)
                        ,against_this_in
                        ,'R'
                        ,max_linesize      => 32767
                        );
   END initialize;
 
   PROCEDURE cleanup
   IS
   BEGIN
      UTL_FILE.fclose (checkid);
      UTL_FILE.fclose (againstid);
   END;
BEGIN
   initialize;
 
   LOOP
      BEGIN
         UTL_FILE.get_line (
            checkid,
            checkline
         );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            check_eof := TRUE;
      END;
 
      BEGIN
         UTL_FILE.get_line (
            againstid,
            againstline
         );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            against_eof := TRUE;
      END;
 
      IF (check_eof AND against_eof)
      THEN
         retval := TRUE;
         EXIT;
      ELSIF (checkline != againstline) OR (check_eof OR against_eof)
      THEN
         retval := FALSE;
         EXIT;
      END IF;
   END LOOP;
 
   cleanup;
   RETURN retval;
EXCEPTION
   WHEN OTHERS
   THEN
      cleanup;
      RETURN FALSE;
END eqfiles;
/
================================================================================
