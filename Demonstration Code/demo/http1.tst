DROP TABLE www_domains;

CREATE TABLE www_domains (
   name VARCHAR2(100),
   ext VARCHAR2(10)
   );
   
INSERT INTO www_domains VALUES ('stevenfeuerstein', 'com');   
INSERT INTO www_domains VALUES ('plsolutions', 'com');   
INSERT INTO www_domains VALUES ('starbelly', 'com');   
INSERT INTO www_domains VALUES ('revealnet', 'com');

COLUMN http_info FORMAT A60
SET PAGESIZE 0

SELECT 
  'Up to first &&firstparm characters from ' || 
      name || '.' || ext header,
  TRANSLATE (
   SUBSTR (
     UTL_HTTP.REQUEST ('http://www.' || 
        name || '.' || ext),
     1, &&firstparm), 'A'||CHR(10)||CHR(13)||CHR(9), 'A')
    http_info
  FROM www_domains;
  
DECLARE
   -- Let's get the title information...
   title_loc PLS_INTEGER;
   end_title_loc PLS_INTEGER;
BEGIN
   FOR rec IN (   
      SELECT name,
             UTL_HTTP.REQUEST (
                'http://www.' || 
                name || '.' || ext) info
        FROM www_domains)
   LOOP
      title_loc := 
         INSTR (UPPER (rec.info), '<TITLE>');
         
      IF title_loc > 0
      THEN
         title_loc := title_loc + 7;
         end_title_loc := 
            INSTR (
               UPPER (rec.info), 
               '</TITLE>', 
               title_loc);

         DBMS_OUTPUT.PUT_LINE (
            'Title for "' || rec.name || '":');
            
         DBMS_OUTPUT.PUT_LINE (
            '   ' || 
            SUBSTR (
               rec.info, 
               title_loc, 
               end_title_loc - title_loc));
      END IF;
   END LOOP;
END;
/
   
  
   