/* Formatted by PL/Formatter v3.1.2.1 on 2001/01/27 19:15 */

SELECT SUBSTR (dbms_java.longname (object_name), 1, 30) AS class, status
  FROM all_objects
 WHERE object_type = 'JAVA CLASS'
   AND object_name = dbms_java.shortname ('oracle/xml/parse/v2/DOMParser');

