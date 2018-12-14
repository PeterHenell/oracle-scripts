BEGIN
$IF DBMS_DB_VERSION.VER_le_10_1 $THEN
  $ERROR 'Unsupported database release or feature!' $END
$ELSE
  DBMS_OUTPUT.PUT_LINE ('Release ' || DBMS_DB_VERSION.VERSION || '.' ||
                        DBMS_DB_VERSION.RELEASE || ' is supported.');
  -- Note that this COMMIT syntax is newly supported in 10.2
  COMMIT WRITE IMMEDIATE NOWAIT;
$END
END;
/
