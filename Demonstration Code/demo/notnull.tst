@ssoo
DECLARE
   declval VARCHAR2(30) NOT NULL := 'abc';
   ifval VARCHAR2(30) := 'abc';

   TYPE rectype1 IS RECORD (
      num PLS_INTEGER NOT NULL := 0,
      name VARCHAR2(2000) NOT NULL := 'steven');

   TYPE rectype2 IS RECORD (
      num PLS_INTEGER := 0,
      name VARCHAR2(2000));

   decl_rec rectype1;
   if_rec rectype2;

   if_tmr tmr_t := tmr_t.make ('IF', &&firstparm);
   decl_tmr tmr_t := tmr_t.make ('DECLARATION', &&firstparm);
BEGIN
   if_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      BEGIN
         ifval := '';
         IF ifval IS NULL
         THEN
            RAISE VALUE_ERROR;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN NULL;
      END;
      ifval := 'abc';
   END LOOP;
   if_tmr.stop;

   decl_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      BEGIN
         declval := '';
      EXCEPTION
         WHEN OTHERS THEN NULL;
      END;
      declval := 'abc';
   END LOOP;
   decl_tmr.stop;

   if_tmr.reset;
   if_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      BEGIN
         if_rec.num := 100 + 200;
         IF if_rec.num IS NULL
         THEN
            RAISE VALUE_ERROR;
         END IF;
         if_rec.num := if_rec.num * 2;
         IF if_rec.num IS NULL
         THEN
            RAISE VALUE_ERROR;
         END IF;
         if_rec.num := if_rec.num * if_rec.num;
         IF if_rec.num IS NULL
         THEN
            RAISE VALUE_ERROR;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN NULL;
      END;
   END LOOP;
   if_tmr.stop;

   decl_tmr.reset;
   decl_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      BEGIN
         decl_rec.num := 100 + 200;
         decl_rec.num := decl_rec.num * 2;
         decl_rec.num := decl_rec.num * decl_rec.num;
      EXCEPTION
         WHEN OTHERS THEN NULL;
      END;
   END LOOP;
   decl_tmr.stop;

END;
/
