OPEN cur;
FETCH cur INTO rec;
WHILE cur%FOUND OR rec.sal < 0
LOOP
    process_data (rec);
    FETCH cur INTO rec;
END LOOP;


OPEN cur;
LOOP
    FETCH cur INTO rec;
    EXIT WHEN cur%NOTFOUND OR rec.sal >= 0;
    process_data (rec);
END LOOP;