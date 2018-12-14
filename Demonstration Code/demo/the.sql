DROP TYPE action_list_t FORCE;
DROP TABLE inflation_beater;

CREATE TYPE action_list_t IS TABLE OF VARCHAR2(100);
/
CREATE TABLE inflation_beater (
   focus_area VARCHAR2(100),
   activities action_list_t)
   NESTED TABLE activities STORE AS activities_tab;

INSERT INTO inflation_beater VALUES (
   'FEDERAL RESERVE', 
   action_list_t (
      'RAISE RATES', 'MAKE SPEECHES', 'BURP AT WRONG TIME'));
   
INSERT INTO inflation_beater VALUES (
   'FORTUNE 100', 
   action_list_t (
      'STRIP PENSION', 'MUCHO OVERTIME', 'SIDESTEP OSHA'));

SELECT VALUE (act) 
  FROM THE (SELECT activities FROM inflation_beater
             WHERE focus_area = 'FORTUNE 100') act;
  
UPDATE THE (SELECT activities FROM inflation_beater
             WHERE focus_area = 'FORTUNE 100') 
   SET COLUMN_VALUE = 'DISBAND OSHA'
 WHERE COLUMN_VALUE = 'SIDESTEP OSHA';

SELECT VALUE (act) 
  FROM THE (SELECT activities FROM inflation_beater
             WHERE focus_area = 'FORTUNE 100') act;
  
     