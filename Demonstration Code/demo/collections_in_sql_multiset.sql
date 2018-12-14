DROP TYPE color_array_t FORCE;
DROP TABLE bird_habitats;
DROP TABLE birds;
DROP TYPE country_tab_t FORCE;

CREATE TYPE color_array_t AS VARRAY (16) OF VARCHAR2 (30);
/

CREATE TABLE birds
(
   genus     VARCHAR2 (128)
 , species   VARCHAR2 (128)
 , colors    color_array_t
 , PRIMARY KEY (genus, species)
);

BEGIN
   INSERT INTO birds
        VALUES (
                  'spiro glockeel'
                , 'northern hamrall'
                , color_array_t ('RED', 'YELLOW', 'GREEN'));

   INSERT INTO birds
        VALUES (
                  'blouring tumswitch'
                , 'darkwing chilata'
                , color_array_t ('BROWN', 'ORANGE'));
END;
/

CREATE TABLE bird_habitats
(
   genus     VARCHAR2 (128)
 , species   VARCHAR2 (128)
 , country   VARCHAR2 (60)
 , FOREIGN KEY (genus, species) REFERENCES birds (genus, species)
)
/

BEGIN
   INSERT INTO bird_habitats
        VALUES ('spiro glockeel', 'northern hamrall', 'HOLBIND');

   INSERT INTO bird_habitats
        VALUES ('spiro glockeel', 'northern hamrall', 'NORTH OTAWANDIA');

   INSERT INTO bird_habitats
        VALUES ('spiro glockeel', 'northern hamrall', 'SPELACKER');

   COMMIT;
END;
/

CREATE TYPE country_tab_t AS TABLE OF VARCHAR2 (60);
/

DECLARE
   CURSOR bird_curs
   IS
      SELECT b.genus
           , b.species
           , CAST (
                MULTISET (
                   SELECT bh.country
                     FROM bird_habitats bh
                    WHERE bh.genus = b.genus AND bh.species = b.species) AS country_tab_t)
                countries
        FROM birds b
       WHERE genus = 'spiro glockeel';

   bird_row   bird_curs%ROWTYPE;

   v_row      PLS_INTEGER;
BEGIN
   OPEN bird_curs;

   FETCH bird_curs INTO bird_row;

   CLOSE bird_curs;

   DBMS_OUTPUT.put_line (
      'Countries in which the "' || bird_row.genus || '" is found:');

   v_row := bird_row.countries.FIRST;

   LOOP
      EXIT WHEN v_row IS NULL;
      DBMS_OUTPUT.put_line ('   ' || bird_row.countries (v_row));
      v_row := bird_row.countries.NEXT (v_row);
   END LOOP;
END;
/