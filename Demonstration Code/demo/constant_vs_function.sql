/* Exposed values */

BEGIN
   CASE l_order.status
      WHEN 'OPEN'
      THEN
         fill_order;
      WHEN 'CLOSED'
      THEN
         close_order;
   END CASE;
END;
/

/* Hide behind constant or function */

CREATE OR REPLACE PACKAGE app_config_pkg
IS
   /* MPLS 3/2013 - Don't use DEFAULT, it's not going to change */
   c_open     CONSTANT VARCHAR2 (4) := 'OPEN';
   c_closed   CONSTANT VARCHAR2 (6) := 'CLOSED';
END;
/

/* No more magic values */

BEGIN
   CASE l_order.status
      WHEN app_config_pkg.c_open
      THEN
         fill_order;
      WHEN app_config_pkg.c_closed
      THEN
         close_order;
   END CASE;
END;
/

CREATE OR REPLACE PACKAGE app_config_pkg
IS
   FUNCTION open_status
      RETURN VARCHAR2
      DETERMINISTIC;

   FUNCTION closed_status
      RETURN VARCHAR2
      DETERMINISTIC;
END;
/

CREATE OR REPLACE PACKAGE BODY app_config_pkg
IS
   c_private_open     CONSTANT VARCHAR2 (4) DEFAULT 'OPEN';
   c_private_closed   CONSTANT VARCHAR2 (6) DEFAULT 'CLOSED';

   FUNCTION open_status
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN c_private_open;
   END;

   FUNCTION closed_status
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN c_private_closed;
   END;
END;
/

BEGIN
   CASE l_order.status
      WHEN app_config_pkg.open_status ()
      THEN
         fill_order;
      WHEN app_config_pkg.closed_status ()
      THEN
         close_order;
   END CASE;
END;
/

/* Define package with both constants and functions */

CREATE OR REPLACE PACKAGE app_config_pkg
IS
   c_open     CONSTANT VARCHAR2 (4) DEFAULT 'OPEN';
   c_closed   CONSTANT VARCHAR2 (6) DEFAULT 'CLOSED';

   FUNCTION open_status
      RETURN VARCHAR2
      DETERMINISTIC
      RESULT_CACHE;

   FUNCTION closed_status
      RETURN VARCHAR2
      DETERMINISTIC
      RESULT_CACHE;
END;
/

CREATE OR REPLACE PACKAGE BODY app_config_pkg
IS
   c_private_open     CONSTANT VARCHAR2 (4) DEFAULT 'OPEN';
   c_private_closed   CONSTANT VARCHAR2 (6) DEFAULT 'CLOSED';

   FUNCTION open_status
      RETURN VARCHAR2
      RESULT_CACHE
   IS
   BEGIN
      RETURN c_private_open;
   END;

   FUNCTION closed_status
      RETURN VARCHAR2
      RESULT_CACHE
   IS
   BEGIN
      RETURN c_private_closed;
   END;
END;
/

DECLARE
   l_value   VARCHAR2 (100);
BEGIN
   sf_timer.start_timer;

   FOR i IN 1 .. 10000000
   LOOP
      l_value := app_config_pkg.c_open;
   END LOOP;

   sf_timer.show_elapsed_time ('Public constant');
   --
   sf_timer.start_timer;

   FOR i IN 1 .. 10000000
   LOOP
      l_value := app_config_pkg.open_status ();
   END LOOP;

   sf_timer.show_elapsed_time ('Inside function');
END;
/

/* 10,000,000 iterations without result cache
Public constant - Elapsed CPU : 0 seconds.
Inside function - Elapsed CPU : 3.33 seconds.

With result cache:

Public constant - Elapsed CPU : 0 seconds.
Inside function - Elapsed CPU : 1.13 seconds.
*/