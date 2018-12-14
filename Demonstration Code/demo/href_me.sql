CREATE OR REPLACE FUNCTION href_me (
   url_in               IN VARCHAR2
 , NAME_IN              IN VARCHAR2 DEFAULT NULL
 , open_new_window_in   IN BOOLEAN DEFAULT TRUE)
   RETURN VARCHAR2
IS
BEGIN
   RETURN '<a href="' || url_in || '"'
          || CASE
                WHEN open_new_window_in THEN ' target="_blank"'
                ELSE NULL
             END
          || '>'
          || NVL (NAME_IN, url_in)
          || '</a>';
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      href_me (
         'http://en.wikipedia.org/wiki/English_numerals#Ordinal_numbers', 'here'));    
END;
/

/*
<a href="URL" target="_blank">here</a>
*/