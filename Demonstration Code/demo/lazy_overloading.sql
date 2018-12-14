/* Version 1 - no overloading */

CREATE OR REPLACE PACKAGE BODY qdb_thread_mgr
/*
===========================
PL/SQL Challenge
===========================

Copyright 2010 Feuerstein and Associates
               www.feuersteinandassociates.com

Manage commentary (threads).

$Revision: 1.0 $
*/
IS
   PROCEDURE insert_thread (
      user_id_in               IN PLS_INTEGER
    ,  parent_thread_id_in      IN PLS_INTEGER
    ,  thread_type_in           IN VARCHAR2
    ,  subject_in               IN VARCHAR2
    ,  body_in                  IN CLOB
    ,  thread_status_in         IN VARCHAR2
    ,  approved_by_user_id_in   IN PLS_INTEGER)
   IS
   BEGIN
      INSERT INTO qdb_threads (user_id
                             ,  parent_thread_id
                             ,  thread_type
                             ,  subject
                             ,  body
                             ,  thread_status
                             ,  approved_by_user_id)
           VALUES (user_id_in
                 ,  parent_thread_id_in
                 ,  thread_type_in
                 ,  subject_in
                 ,  body_in
                 ,  thread_status_in
                 ,  approved_by_user_id_in);
   END;
END qdb_thread_mgr;
/

/* Version 2 - I need to return the new primary key! */

CREATE OR REPLACE PACKAGE BODY qdb_thread_mgr
IS
   PROCEDURE insert_thread (
      user_id_in               IN PLS_INTEGER
    ,  parent_thread_id_in      IN PLS_INTEGER
    ,  thread_type_in           IN VARCHAR2
    ,  subject_in               IN VARCHAR2
    ,  body_in                  IN CLOB
    ,  thread_status_in         IN VARCHAR2
    ,  approved_by_user_id_in   IN PLS_INTEGER)
   IS
   BEGIN
      INSERT INTO qdb_threads (user_id
                             ,  parent_thread_id
                             ,  thread_type
                             ,  subject
                             ,  body
                             ,  thread_status
                             ,  approved_by_user_id)
           VALUES (user_id_in
                 ,  parent_thread_id_in
                 ,  thread_type_in
                 ,  subject_in
                 ,  body_in
                 ,  thread_status_in
                 ,  approved_by_user_id_in);
   END;

   PROCEDURE insert_thread (
      user_id_in               IN     PLS_INTEGER
    ,  parent_thread_id_in      IN     PLS_INTEGER
    ,  thread_type_in           IN     VARCHAR2
    ,  subject_in               IN     VARCHAR2
    ,  body_in                  IN     CLOB
    ,  thread_status_in         IN     VARCHAR2
    ,  approved_by_user_id_in   IN     PLS_INTEGER
    ,  thread_id_out               OUT PLS_INTEGER)
   IS
   BEGIN
      INSERT INTO qdb_threads (user_id
                             ,  parent_thread_id
                             ,  thread_type
                             ,  subject
                             ,  body
                             ,  thread_status
                             ,  approved_by_user_id)
           VALUES (user_id_in
                 ,  parent_thread_id_in
                 ,  thread_type_in
                 ,  subject_in
                 ,  body_in
                 ,  thread_status_in
                 ,  approved_by_user_id_in)
        RETURNING thread_id
             INTO thread_id_out;
   END;
END qdb_thread_mgr;
/

/* Version 3:
   And then I needed to add recording of points for a thread submission */


CREATE OR REPLACE PACKAGE BODY qdb_thread_mgr
IS
   PROCEDURE insert_thread (
      user_id_in               IN     PLS_INTEGER
    ,  parent_thread_id_in      IN     PLS_INTEGER
    ,  thread_type_in           IN     VARCHAR2
    ,  subject_in               IN     VARCHAR2
    ,  body_in                  IN     CLOB
    ,  thread_status_in         IN     VARCHAR2
    ,  approved_by_user_id_in   IN     PLS_INTEGER
    ,  thread_id_out               OUT PLS_INTEGER)
   IS
      l_thread_id   PLS_INTEGER;
   BEGIN
      INSERT INTO qdb_threads (user_id
                             ,  parent_thread_id
                             ,  thread_type
                             ,  subject
                             ,  body
                             ,  thread_status
                             ,  approved_by_user_id)
           VALUES (user_id_in
                 ,  parent_thread_id_in
                 ,  thread_type_in
                 ,  subject_in
                 ,  body_in
                 ,  thread_status_in
                 ,  approved_by_user_id_in)
        RETURNING thread_id
             INTO l_thread_id;

      qdb_point_mgr.add_points (
         user_id_in        => l_thread.user_id
       ,  activity_id_in    => 
             qdb_point_mgr.activity_id_from_abbrev (
                    'THREAD'
                 || CASE
                       WHEN parent_thread_in
                               IS NULL
                       THEN
                          'NEW'
                       ELSE
                          'PUB'
                    END)
       ,  activity_key_in   => l_thread_id);

      thread_id_out := l_thread_id;
   END;

   PROCEDURE insert_thread (
      user_id_in               IN PLS_INTEGER
    ,  parent_thread_id_in      IN PLS_INTEGER
    ,  thread_type_in           IN VARCHAR2
    ,  subject_in               IN VARCHAR2
    ,  body_in                  IN CLOB
    ,  thread_status_in         IN VARCHAR2
    ,  approved_by_user_id_in   IN PLS_INTEGER)
   IS
      l_thread_id   PLS_INTEGER;
   BEGIN
      INSERT INTO qdb_threads (user_id
                             ,  parent_thread_id
                             ,  thread_type
                             ,  subject
                             ,  body
                             ,  thread_status
                             ,  approved_by_user_id)
           VALUES (user_id_in
                 ,  parent_thread_id_in
                 ,  thread_type_in
                 ,  subject_in
                 ,  body_in
                 ,  thread_status_in
                 ,  approved_by_user_id_in);

      SELECT thread_id
        INTO l_thread_id
        FROM qdb_threads
       WHERE 1 = 1 /* REALLY? AM I REALLY GOING TO DO THIS? */
                  ;

      qdb_point_mgr.add_points (
         user_id_in        => l_thread.user_id
       ,  activity_id_in    => qdb_point_mgr.activity_id_from_abbrev (
                                    'THREAD'
                                 || CASE
                                       WHEN parent_thread_in
                                               IS NULL
                                       THEN
                                          'NEW'
                                       ELSE
                                          'PUB'
                                    END)
       ,  activity_key_in   => thread_id_in);
   END;
END qdb_thread_mgr;
/

/* NO, DON'T DO THAT! Just ONE core implementation, 
   all others derived from that! */

CREATE OR REPLACE PACKAGE BODY qdb_thread_mgr
IS
   PROCEDURE insert_thread (
      user_id_in               IN     PLS_INTEGER
    ,  parent_thread_id_in      IN     PLS_INTEGER
    ,  thread_type_in           IN     VARCHAR2
    ,  subject_in               IN     VARCHAR2
    ,  body_in                  IN     CLOB
    ,  thread_status_in         IN     VARCHAR2
    ,  approved_by_user_id_in   IN     PLS_INTEGER
    ,  thread_id_out               OUT PLS_INTEGER)
   IS
      l_thread_id   PLS_INTEGER;
   BEGIN
      INSERT INTO qdb_threads (user_id
                             ,  parent_thread_id
                             ,  thread_type
                             ,  subject
                             ,  body
                             ,  thread_status
                             ,  approved_by_user_id)
           VALUES (user_id_in
                 ,  parent_thread_id_in
                 ,  thread_type_in
                 ,  subject_in
                 ,  body_in
                 ,  thread_status_in
                 ,  approved_by_user_id_in)
        RETURNING thread_id
             INTO l_thread_id;

      qdb_point_mgr.add_points (
         user_id_in        => l_thread.user_id
       ,  activity_id_in    => qdb_point_mgr.activity_id_from_abbrev (
                                    'THREAD'
                                 || CASE
                                       WHEN parent_thread_in
                                               IS NULL
                                       THEN
                                          'NEW'
                                       ELSE
                                          'PUB'
                                    END)
       ,  activity_key_in   => l_thread_id);

      thread_id_out := l_thread_id;
   END;

   PROCEDURE insert_thread (
      user_id_in               IN PLS_INTEGER
    ,  parent_thread_id_in      IN PLS_INTEGER
    ,  thread_type_in           IN VARCHAR2
    ,  subject_in               IN VARCHAR2
    ,  body_in                  IN CLOB
    ,  thread_status_in         IN VARCHAR2
    ,  approved_by_user_id_in   IN PLS_INTEGER)
   IS
      l_id   PLS_INTEGER;
   BEGIN
      insert_thread (
         user_id_in               => user_id_in
       ,  parent_thread_id_in      => parent_thread_id_in
       ,  thread_type_in           => thread_type_in
       ,  subject_in               => subject_in
       ,  body_in                  => body_in
       ,  thread_status_in         => thread_status_in
       ,  approved_by_user_id_in   => approved_by_user_id_in
       ,  thread_id_out            => l_id);
   END;
END qdb_thread_mgr;
/