DROP TABLE bush_funds;
DROP TABLE gore_funds;
DROP TABLE nader_funds;

CREATE TABLE bush_funds (
   amount NUMBER,
   source VARCHAR2(200)
   );

CREATE TABLE gore_funds (
   amount NUMBER,
   source VARCHAR2(200)
   );

CREATE TABLE nader_funds (
   amount NUMBER,
   source VARCHAR2(200)
   );

INSERT INTO gore_funds VALUES (127125, 'Ernst and Young International');
INSERT INTO gore_funds VALUES (98750, 'Citigroup');
INSERT INTO gore_funds VALUES (95175, 'Viacom International');
INSERT INTO gore_funds VALUES (84250, 'Goldman Sachs Group');
INSERT INTO gore_funds VALUES (72125, 'Time Warner');
INSERT INTO gore_funds VALUES (71250, 'BellSouth');
INSERT INTO gore_funds VALUES (48700, 'Cablevision');
INSERT INTO gore_funds VALUES (47150, 'Holland and Knight');
INSERT INTO gore_funds VALUES (43750, 'Akin Gump');
INSERT INTO gore_funds VALUES (43750, 'Jenner and Block');
INSERT INTO gore_funds VALUES (41550, 'Morgan Staneley Dean Witter');
INSERT INTO gore_funds VALUES (36250, 'Patton Boggs');
INSERT INTO gore_funds VALUES (36000, 'Anheuser-Busch');
INSERT INTO gore_funds VALUES (35150, 'Verner, Liipfert');
INSERT INTO gore_funds VALUES (95175, 'ATT');

INSERT INTO bush_funds VALUES (213400, 'MBNA America Bank');
INSERT INTO bush_funds VALUES (196350, 'Vinson and Elkins');
INSERT INTO bush_funds VALUES (179800, 'AXA Financial');
INSERT INTO bush_funds VALUES (171500, 'Arthur Anderson');
INSERT INTO bush_funds VALUES (161999, 'Ernst and Young International');
INSERT INTO bush_funds VALUES (123800, 'Morgan Staneley Dean Witter');
INSERT INTO bush_funds VALUES (120100, 'Merrill Lynch');
INSERT INTO bush_funds VALUES (113798, 'PricewaterhouseCoopers');
INSERT INTO bush_funds VALUES (104750, 'Enron');
INSERT INTO bush_funds VALUES (104149, 'Goldman Sachs Group');
INSERT INTO bush_funds VALUES (102450, 'Jenkens and Gilchrist');
INSERT INTO bush_funds VALUES (99819, 'KPMG');
INSERT INTO bush_funds VALUES (99650, 'Citigroup');
INSERT INTO bush_funds VALUES (99521, 'Baker Botts');


INSERT INTO nader_funds VALUES (4000, 'Jack H Olender and Assoc');
INSERT INTO nader_funds VALUES (4000, 'Kayline Enterprises');
INSERT INTO nader_funds VALUES (3150, 'University of California');
INSERT INTO nader_funds VALUES (3000, 'Ben and Jerry''s');
INSERT INTO nader_funds VALUES (3000, 'Gelfand, Rennert and Feldman');
INSERT INTO nader_funds VALUES (3000, 'University of Illinois');
INSERT INTO nader_funds VALUES (2500, 'East Egg Entertainment');
INSERT INTO nader_funds VALUES (2500, 'Environmental Systems Research Inst');

CREATE OR REPLACE PROCEDURE show_me_the_money (
   candidate_in IN VARCHAR2)
IS
   TYPE refCur IS REF CURSOR;
   money_cv refCur;
   money_rec bush_funds%ROWTYPE;
BEGIN
   OPEN money_cv FOR 
      'SELECT amount, source ' || 
        'FROM ' ||candidate_in || '_funds ' ||
       'ORDER BY amount DESC';

   LOOP
      FETCH money_cv INTO money_rec;
      EXIT WHEN money_cv%NOTFOUND;
      
      DBMS_OUTPUT.put_line (
         money_rec.source || ': $' ||
         TO_CHAR (money_rec.amount)
      );
   END LOOP;

   CLOSE money_cv;
END;
/
SHO ERR