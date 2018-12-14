/* Formatted by PL/Formatter v2.0.8.0 on 2000/02/06 00:48  (12:48 PM) */
/*
--------------------------------------------------
In HTML pages, multiple spaces are displayed as a single space.
Using spaces to indent hierarcies is often required.
SQL CONNECT BY queries use space indentation to show levels of
recursive relations between records.
To preserve the correct indentation in HTML,
spaces can be replaced with the non-breaking space tag &nbsp
The functions below can be used in producing query results
that will display correctly when viewed by a browser.
-- Author: Mark Fredericks, PROSOFT
--------------------------------------------------
*/
CREATE OR REPLACE FUNCTION repeat_str (in_str IN VARCHAR2, in_nbr IN NUMBER)
   RETURN VARCHAR2
IS
   temp VARCHAR2(4000);
/* usage: conversation_elipsis := repeat_str('YaDa ',3);
   conversation_elipsis ==> 'Yada Yada Yada'
*/

BEGIN
   IF (  (in_str IS NULL)
      OR (in_nbr = 0))
   THEN
      temp := NULL;
   ELSE
      FOR i IN 1 .. TRUNC (ABS (in_nbr))
      LOOP
         temp := temp || in_str;
      END LOOP;
   END IF;
   RETURN temp;
END repeat_str;
/
CREATE OR REPLACE FUNCTION nbsp (in_nbr IN NUMBER DEFAULT 1)
   RETURN VARCHAR2
IS
-- return a specified number of non breaking space html tags
/* usage to create a string with three non-breaking spaces:
   my_string := nbsp(3);
*/

BEGIN
   RETURN repeat_str ('&nbsp;', in_nbr);   -- note semi-colon is required in some browsers
END nbsp;
/
CREATE OR REPLACE FUNCTION nbsp_indent (
   in_str IN VARCHAR,
   in_level IN NUMBER,
   in_offset IN NUMBER DEFAULT NULL)
   RETURN VARCHAR2
/* return an indented string, used in indented connect
by - html screens and reports
*/
/*
Usage:
SELECT nbsp_indent(ename,level,3)
FROM  emp
CONNECT BY PRIOR emp_id = mgr_id
START WITH job = 'PRESIDENT'
*/

IS
   offset CONSTANT NUMBER := NVL (in_level, 1);
BEGIN
   RETURN (nbsp (offset * (in_level - 1)) || in_str);
END nbsp_indent;
/
CREATE OR REPLACE FUNCTION html_indent (
   in_str IN VARCHAR2,
   multiplier NUMBER DEFAULT 1)
   RETURN VARCHAR2
-- return an html indented string,
-- replace leading spaces with nbsp's

IS
   trim_str VARCHAR2(256);
   offset NUMBER;
BEGIN
   --return replace(in_str,' ',nbsp(multiplier));
   IF in_str IS NULL
   THEN
      RETURN NULL;
   ELSE
      trim_str := LTRIM (in_str, ' ');
      offset := LENGTH (in_str) - LENGTH (trim_str);
      RETURN nbsp_indent (trim_str, offset + 1, multiplier);
   END IF;
END html_indent;
/


