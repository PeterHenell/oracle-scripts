
CREATE TABLE multiple_triggers (id NUMBER)
/

CREATE OR REPLACE TRIGGER increment_by_one
BEFORE INSERT ON multiple_triggers
FOR EACH ROW
BEGIN
  :new.id := :new.id + 1;
END;
/

CREATE OR REPLACE TRIGGER increment_by_two
BEFORE INSERT ON multiple_triggers
FOR EACH ROW
BEGIN
  IF :new.id > 1 THEN
    :new.id := :new.id + 2;
  END IF;
END;
/

INSERT INTO multiple_triggers VALUES(1)
/

SELECT *
  FROM multiple_triggers
/  

/*
Here is an example of the Oracle 11g FOLLOWS syntax to force
execution of triggers in a certain order:
*/

CREATE OR REPLACE TRIGGER increment_by_two
BEFORE INSERT ON multiple_triggers
FOR EACH ROW
FOLLOWS increment_by_one
BEGIN
  IF :new.id > 1 THEN
    :new.id := :new.id + 2;
  END IF;
END;
/

ROLLBACK
/

/* Cleanup */

DROP TABLE multiple_triggers
/
