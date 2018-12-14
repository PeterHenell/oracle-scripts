BEGIN
   FOR rec IN (SELECT *
                 FROM user_constraints
                WHERE constraint_type = 'R')
   LOOP
      EXECUTE IMMEDIATE   'ALTER TABLE '
                       || rec.table_name
                       || ' DISABLE CONSTRAINT '
                       || rec.constraint_name;
   END LOOP;
END;
/