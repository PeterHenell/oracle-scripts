CREATE TABLE one_value (col VARCHAR2 (100))
/

BEGIN
   INSERT INTO one_value
        VALUES (DBMS_UTILITY.get_time);
END;
/

BEGIN
   INSERT INTO one_value
        VALUES (SQLERRM);
END;
/

BEGIN
   INSERT INTO one_value
        VALUES (SQLCODE);
END;
/