DROP TABLE all_supported
/
DROP TABLE err$_all_supported
/
DROP TABLE not_all_supported
/
DROP TABLE err$_not_all_supported
/

CREATE TABLE all_supported
(
   n   NUMBER
 , v   VARCHAR2 (100)
 , d   DATE
)
/


CREATE TABLE not_all_supported
(
   n   NUMBER
 , v   VARCHAR2 (100)
 , c   CLOB
)
/

BEGIN
   DBMS_ERRLOG.create_error_log ('ALL_SUPPORTED', skip_unsupported => FALSE);
END;
/

SELECT column_name
  FROM user_tab_columns
 WHERE table_name = 'ERR$_ALL_SUPPORTED'
/

BEGIN
   DBMS_ERRLOG.
    create_error_log ('NOT_ALL_SUPPORTED', skip_unsupported => FALSE);
END;
/

SELECT column_name
  FROM user_tab_columns
 WHERE table_name = 'ERR$_NOT ALL_SUPPORTED'
/

BEGIN
   DBMS_ERRLOG.
    create_error_log ('NOT_ALL_SUPPORTED', skip_unsupported => TRUE);
END;
/

SELECT *
  FROM user_objects
 WHERE object_name = 'ERR$_NOT_ALL_SUPPORTED'
/

SELECT column_name
  FROM user_tab_columns
 WHERE table_name = 'ERR$_NOT_ALL_SUPPORTED'
/

/* Can I use the error log table? */

INSERT INTO not_all_supported (n, v)
     VALUES (1, RPAD ('abc', 4000, 'def')) LOG ERRORS REJECT LIMIT UNLIMITED
/

SELECT * FROM err$_not_all_supported
/