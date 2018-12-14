REM Dependency: run bpl.sp to create Boolean Print Line procedure

@ssoo

DROP TYPE legal_bribe_t FORCE;
DROP TYPE legal_briber_t FORCE;
DROP TABLE legal_briber;
DROP TABLE legal_briber1;

CREATE OR REPLACE TYPE legal_bribe_t as TABLE OF NUMBER; 
/ 
 
CREATE OR REPLACE TYPE legal_briber_t AS OBJECT ( 
  source VARCHAR2(100), 
  legal_bribes legal_bribe_t ); 
/ 
 
CREATE TABLE legal_briber OF legal_briber_t 
      NESTED TABLE legal_bribes STORE AS nt_bribes; 

INSERT INTO legal_briber VALUES (
   'HORSE RACING INDUSTRY', 
   legal_bribe_t (632000/* Richard Duchossois */, 267000, 
      1000, 5000, 10000, 15000, 20000, 25000, 30000)
   ); 
INSERT INTO legal_briber VALUES (
   'RIVERBOAT CASINO INDUSTRY', 
   legal_bribe_t (284000 /* Empress Casino */, 415000, 
      1000, 5000, 10000, 15000, 20000, 25000, 30000)
   );  
 
CREATE TABLE legal_briber1 OF legal_briber_t 
      NESTED TABLE legal_bribes STORE AS nt_bribes1 RETURN LOCATOR; 
 
INSERT INTO legal_briber1 VALUES (
   'HORSE RACING INDUSTRY', 
   legal_bribe_t (632000 /* Richard Duchossois */, 267000, 
      1000, 5000, 10000, 15000, 20000, 25000, 30000)
   ); 
INSERT INTO legal_briber1 VALUES (
   'RIVERBOAT CASINO INDUSTRY', 
   legal_bribe_t (284000 /* Empress Casino */, 415000, 
      1000, 5000, 10000, 15000, 20000, 25000, 30000)
   );  
 
/* Demonstrate use of IS_LOCATOR function */
DECLARE
  pocket_liners legal_bribe_t; 
  pocket_liners1 legal_bribe_t; 
BEGIN 
  SELECT legal_bribes INTO pocket_liners 
    FROM legal_briber 
   WHERE source = 'RIVERBOAT CASINO INDUSTRY'; 
 
  SELECT legal_bribes INTO pocket_liners1 
    FROM legal_briber1 
   WHERE source = 'RIVERBOAT CASINO INDUSTRY'; 
 
  bpl (UTL_COLL.IS_LOCATOR (pocket_liners)); 
 
  bpl (UTL_COLL.IS_LOCATOR (pocket_liners1)); 
END;
/

/* Test performance impact */

CREATE OR REPLACE PROCEDURE test_utlcoll
IS
   locator_tmr tmr_t := tmr_t.make ('Is Locator', &&firstparm);
   not_locator_tmr tmr_t := tmr_t.make ('Is Not Locator', &&firstparm);
  pocket_liners legal_bribe_t; 
  pocket_liners1 legal_bribe_t; 
  var NUMBER;
  counter PLS_INTEGER := 1;
BEGIN
  /* Retrive the collections */ 
  SELECT legal_bribes INTO pocket_liners 
    FROM legal_briber 
   WHERE source = 'RIVERBOAT CASINO INDUSTRY'; 
 
  SELECT legal_bribes INTO pocket_liners1 
    FROM legal_briber1 
   WHERE source = 'RIVERBOAT CASINO INDUSTRY'; 
   
   locator_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      FOR theRec IN
         (SELECT VALUE(pocket_liners1) silver_linings
           FROM TABLE(CAST(pocket_liners1 AS legal_bribe_t)) pocket_liners1)
      LOOP
         var := theRec.silver_linings(counter);
         counter := counter + 1;
      END LOOP;
   END LOOP;
   locator_tmr.stop;
   
   not_locator_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      FOR tabindx IN 1 .. pocket_liners.COUNT
      LOOP
         var := pocket_liners(tabindx);
      END LOOP;
   END LOOP;
   not_locator_tmr.stop;
END;
/
