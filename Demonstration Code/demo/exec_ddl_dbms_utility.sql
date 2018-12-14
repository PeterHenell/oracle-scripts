BEGIN
   DBMS_UTILITY.exec_ddl_statement ('CREATE TABLE temptable');
   DBMS_UTILITY.exec_ddl_statement ('DROP TABLE temptable');
END;