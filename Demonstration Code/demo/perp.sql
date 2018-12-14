@pl.sp

/*
|| Demonstration of AUTHID/Invoker functionality in which 
|| I blend shared access to perpetrator table with individualized
|| schema tables for stolen_lives.
||
|| This script assumes that you have already built the chicago, new york and
|| HQ schemas, along with their tables and procedures.
||
|| Author: Steven Feuerstein
||   Date: 4/99
*/
SPOOL authid.log

CONNECT hq/hq

@pl.sp

/* Create the perpetrator table. This is not directly accessible from any
   other schema but HQ. */

DROP TABLE perpetrator;

CREATE TABLE perpetrator (
   dob DATE,
   location VARCHAR2(100),
   name VARCHAR2(100),
   rank VARCHAR2(100),
   number_of_complaints INTEGER);

INSERT INTO perpetrator VALUES (
   '15-JAN-55', 'CHICAGO', 'Tim "BigBoy" Cop', 'Sergeant ', 42);
INSERT INTO perpetrator VALUES (
   '15-JAN-55', 'CHICAGO', 'John Burge', 'Commander ', 42);
INSERT INTO perpetrator VALUES (
   '23-SEP-58', 'NEWYORK', 'Sammy Oscar', 'Lieutenant ', 16);
   
/* Create a function to retrieve all perpetrators in a city. 
   Must be DEFINER cause local groups don't have direct access. */
CREATE OR REPLACE PROCEDURE show_perps (loc IN VARCHAR2)
  AUTHID DEFINER
AS
BEGIN
   pl ('**** PERPETRATORS ****');
   pl ('');
   FOR rec IN (SELECT * FROM perpetrator WHERE location = loc)
   LOOP
      pl (rec.location || ' perpetrator is ' || rec.rank || ' ' || rec.name);
   END LOOP;
END;
/
SHOW ERRORS
GRANT EXECUTE ON show_perps TO PUBLIC;


/* Redefine central analysis program, run as INVOKER, to include
   perpetrator information. */
   
CREATE OR REPLACE PROCEDURE show_descriptions
  AUTHID CURRENT_USER
AS
BEGIN
  show_perps (USER);
  
  pl ('');
  
  FOR lifestolen IN (SELECT * FROM stolen_life)
  LOOP
     show_victim (lifestolen);
  END LOOP;
END;
/
SHOW ERRORS

CONNECT newyork/newyork
@ssoo
@pl.sp

CREATE OR REPLACE PROCEDURE show_perps (loc IN VARCHAR2)
AS
BEGIN
   pl ('SHOULD NEVER BE CALLED!');
END;
/
 
exec show_descriptions

CONNECT chicago/chicago
@ssoo
@pl.sp

CREATE OR REPLACE PROCEDURE show_perps (loc IN VARCHAR2)
AS
BEGIN
   pl ('SHOULD NEVER BE CALLED!');
END;
/
exec show_descriptions

SPOOL OFF