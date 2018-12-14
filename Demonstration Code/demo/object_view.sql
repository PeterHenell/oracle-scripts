CREATE TABLE suppliers (
   ID INTEGER NOT NULL PRIMARY KEY,
   NAME VARCHAR2(400) NOT NULL
)
/

CREATE TABLE images (
   image_id INTEGER NOT NULL PRIMARY KEY,
   file_name VARCHAR2(512) NOT NULL,
   file_type VARCHAR2(12) NOT NULL,
   supplier_id INTEGER REFERENCES suppliers (ID),
   supplier_rights_descriptor VARCHAR2(256),
   BYTES INTEGER
)
/


CREATE TABLE keywords (
   image_id INTEGER NOT NULL REFERENCES images (image_id),
   keyword VARCHAR2(45) NOT NULL,
   CONSTRAINT keywords_pk PRIMARY KEY (image_id, keyword)
)
/

BEGIN
   INSERT INTO suppliers
        VALUES (101, 'Joe''s Graphics');

   INSERT INTO suppliers
        VALUES (102, 'Image Bar and Grill');

   INSERT INTO images
        VALUES (100001, '/files/web/60s/smiley_face.png', 'image/png', 101
              , 'fair use', 813);

   INSERT INTO images
        VALUES (100002, '/files/web/60s/peace_symbol.gif', 'image/gif', 101
              , 'fair use', 972);

   INSERT INTO images
        VALUES (100003, '/files/web/00s/towers.jpg', 'image/jpeg', NULL
              , NULL, 2104);

   INSERT INTO keywords
        VALUES (100001, 'SIXTIES');

   INSERT INTO keywords
        VALUES (100001, 'HAPPY FACE');

   INSERT INTO keywords
        VALUES (100002, 'SIXTIES');

   INSERT INTO keywords
        VALUES (100002, 'PEACE SYMBOL');

   INSERT INTO keywords
        VALUES (100002, 'JERRY RUBIN');

   COMMIT;
END;
/

CREATE TYPE keyword_tab_t AS TABLE OF VARCHAR2(45);
/

CREATE TYPE image_t AS OBJECT (
    image_id INTEGER,
    image_file BFILE,
    file_type VARCHAR2(12),
    bytes INTEGER,
    keywords keyword_tab_t
);
/

CREATE VIEW images_v 
   OF image_t
   WITH OBJECT IDENTIFIER (image_id)
AS
   SELECT i.image_id, BFILENAME('ROOTDIR', i.file_name), 
      i.file_type, i.bytes, 
      CAST (MULTISET (SELECT keyword
                        FROM keywords k
                       WHERE k.image_id = i.image_id)
        AS keyword_tab_t)
     FROM images i
/

SELECT image_id, keywords FROM images_v
/