SELECT code, text FROM log81tab;

BEGIN
    log81.myvar := 100;
    plvddd.tbl (USER, 'employee');
    log81.putline (1, 'Putline reverse engineered employee');
    ROLLBACK;
    log81.saveline (1, 'Saveline reverse engineered employee');
    ROLLBACK;
END;
/

SELECT code, text FROM log81tab;
