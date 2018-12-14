COLUMN "source"        FORMAT A40
COLUMN "error/warning" FORMAT A30
COLUMN "attr"          FORMAT A8
COLUMN "#"             FORMAT 9999

SELECT   s.text "source", e.text "error/warning", e.ATTRIBUTE "attr"
       , e.message_number "#"
    FROM user_source s LEFT OUTER JOIN user_errors e USING (NAME, TYPE, line)
   WHERE NAME = UPPER ('&1')
ORDER BY line
/