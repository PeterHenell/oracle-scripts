SET SERVEROUTPUT ON
SET VERIFY OFF
PROMPT A)ll or J)ava only? 
ACCEPT x CHAR PROMPT 'Choice: '

DECLARE
  choice CHAR(1) := UPPER('&&x');
  printable BOOLEAN;
  bad_choice EXCEPTION;
BEGIN
  IF choice NOT IN ('A', 'J') THEN RAISE bad_choice; END IF;
  DBMS_OUTPUT.PUT_LINE(CHR(0));
  DBMS_OUTPUT.PUT_LINE('Object Name                    ' ||
    'Object Type   Status  Timestamp');
  DBMS_OUTPUT.PUT_LINE('------------------------------ ' ||
    '------------- ------- ----------------');
  FOR i IN (SELECT object_name, object_type, status, timestamp
    FROM user_objects ORDER BY object_type, object_name)
  LOOP
    /* Exclude objects generated for LoadJava and DropJava. */
    printable := i.object_name NOT LIKE 'SYS_%'
      AND i.object_name NOT LIKE 'CREATE$%'
      AND i.object_name NOT LIKE 'JAVA$%'
      AND i.object_name NOT LIKE 'LOADLOBS';
    IF choice = 'J' THEN
      printable := i.object_type LIKE 'JAVA %';
    END IF;
    IF printable THEN
      DBMS_OUTPUT.PUT_LINE(RPAD(i.object_name,31) || 
        RPAD(i.object_type,14) || 
        RPAD(i.status,8) || SUBSTR(i.timestamp,1,16));
    END IF;
  END LOOP;
EXCEPTION
  WHEN bad_choice THEN
    DBMS_OUTPUT.PUT_LINE('Bad choice');
END;
/