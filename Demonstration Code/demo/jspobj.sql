/* Show how to pass Oracle8 object to Java stored procedure
*/

SET ECHO OFF
SET FEEDBACK OFF
DROP TYPE Account_t FORCE;
DROP TABLE accounts;
SET ECHO ON FEEDBACK ON

CREATE TYPE Account_t AS OBJECT (
   account_no INTEGER,
   name VARCHAR2(50),
   open_date DATE
);
/

CREATE TABLE accounts OF Account_t;

PAUSE
HOST dojpub

PAUSE
REM CREATE JAVA SOURCE AND COMPILE
CREATE JAVA SOURCE
NAMED "AccountRuntime"
AS 
  import Account_t;
  import java.sql.*;
  public class AccountRuntime {
    static void save (Account_t theAccount) {
    // JDBC code to connect to database and insert the data
    // goes here
  }
}
/

PAUSE
CREATE OR REPLACE PROCEDURE account_save
   (new_acct IN Account_t)
IS LANGUAGE JAVA
   NAME 
      'AccountRuntime.save
         (Account_t)';
/

DECLARE
   myacct Account_t := Account_t (1, 'steven', sysdate);
BEGIN
   account_save (myacct);
END;
/
   
REM  Copyright (c) 1999 DataCraft, Inc. and William L. Pribyl
REM  All Rights Reserved
