DECLARE
   TYPE varray_t IS VARRAY (100000) OF NUMBER;

   va   varray_t := varray_t ();

   TYPE ntable_t IS TABLE OF NUMBER;

   nt   ntable_t := ntable_t ();

   TYPE assocarray_t IS TABLE OF NUMBER
                           INDEX BY PLS_INTEGER;

   aa   assocarray_t;
BEGIN
   /* You must have at least 1000 rows of code in user_source */
   DBMS_SESSION.free_unused_user_memory;
   sf_timer.start_timer;

   SELECT  u2.line
     BULK COLLECT INTO va
     FROM user_source, user_source u2
    WHERE ROWNUM <= 100000;

   sf_timer.show_elapsed_time ('VARRAY');
   va.delete;
   DBMS_SESSION.free_unused_user_memory;
   sf_timer.start_timer;

   SELECT  u2.line
     BULK COLLECT INTO nt
     FROM user_source, user_source u2
    WHERE ROWNUM <= 100000;

   sf_timer.show_elapsed_time ('NT');
   nt.delete;
   DBMS_SESSION.free_unused_user_memory;
   sf_timer.start_timer;

   SELECT  u2.line
     BULK COLLECT INTO aa
     FROM user_source, user_source u2
    WHERE ROWNUM <= 100000;

   sf_timer.show_elapsed_time ('AA');
END;
/