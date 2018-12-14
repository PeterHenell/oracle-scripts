CREATE OR REPLACE PROCEDURE demohash (counter IN INTEGER)
IS
   v_row PLS_INTEGER;
   v_name VARCHAR2(30);
   names PLVtab.vc80_table;

   FUNCTION hashval (value IN VARCHAR2) RETURN NUMBER
   IS
   BEGIN
       RETURN DBMS_UTILITY.GET_HASH_VALUE 
          (value, 37, 1073741824);  /* POWER (2, 30) */
   END hashval;

   PROCEDURE addname (nm IN VARCHAR2) IS
   BEGIN
       v_row := hashval (nm);
       names (v_row) := nm;
   END;

   FUNCTION rowbyscan (nm IN VARCHAR2) RETURN PLS_INTEGER
   IS
      v_row PLS_INTEGER := names.FIRST;
      retval PLS_INTEGER;
   BEGIN
      LOOP
         EXIT WHEN v_row IS NULL;
         IF names(v_row) = nm
         THEN
            retval := v_row;
            EXIT;
         ELSE
            v_row := names.NEXT (v_row);
         END IF;
      END LOOP;
      RETURN retval;
   END;

   FUNCTION rowbyhash (nm IN VARCHAR2) RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN hashval (nm);
   END;

BEGIN
   /*
   v_row := PLVhash.keyval ('Steven');
   names (v_row) := 'Steven';
   */

   FOR i IN 1 .. counter
   LOOP
       addname ('Steven' || i);
       addname ('Veva' || i);
       addname ('Eli' || i);
       addname ('Chris' || i);
   END LOOP;

   p.l ('Count in names', names.COUNT);

   v_name := 'Eli' || TRUNC (counter/2);

   p.l ('scan',rowbyscan (v_name));
   p.l ('hash',rowbyhash (v_name));

   sf_timer.start_timer;
   FOR i IN 1 .. counter
   LOOP
      v_row := rowbyscan (v_name);
   END LOOP;
   sf_timer.show_elapsed_time ('scan');

   sf_timer.start_timer;
   FOR i IN 1 .. counter
   LOOP
      v_row := rowbyhash (v_name);
   END LOOP;
   sf_timer.show_elapsed_time ('hash');
END;


