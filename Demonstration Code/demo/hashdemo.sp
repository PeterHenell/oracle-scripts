CREATE OR REPLACE PROCEDURE hashdemo (counter IN INTEGER)
IS
   v_row PLS_INTEGER;
   v_name VARCHAR2(30);
   hashing_failure EXCEPTION;

   /* Define the PL/SQL table */
   names PLVtab.vc60_table;

   /* Assertion routine for this procedure */
   PROCEDURE assert (bool IN BOOLEAN, msg IN VARCHAR2)
   IS
   BEGIN
      IF NOT bool OR bool IS NULL
      THEN
         p.l (msg);
         RAISE hashing_failure;
      END IF;
   END;

   /* Add a name to the table, using the hash function to 
      determine the row in which the value is placed. Ah, 
      the beauty of sparse PL/SQL tables! */
   PROCEDURE addname (nm IN VARCHAR2) IS
   BEGIN
       v_row := hash.val (nm);
       assert (NOT names.EXISTS (v_row),
          'Hash conflict for ' || nm);
       names (v_row) := nm;
   END;

   /* Obtain the row for a name by scanning the table. */
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

   /* Obtain the row for a name by hashing the string. */
   FUNCTION rowbyhash (nm IN VARCHAR2) RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN hash.val (nm);
   END;

BEGIN
   /* This is what I first started to write to set up values in the
      table. Then I stopped. Don't write code like this. Instead,
      encapsulate into a procedure. 
   v_row := hash.val ('Steven');
   names (v_row) := 'Steven';

   v_row := hash.val ('Veva');
   names (v_row) := 'Veva';
    
   etc.
   */

   /* Load up the table with a set of strings based on the number
      of iterations requested. This allows us to easily test the
      scalability of the two algorithms. */
   FOR i IN 1 .. counter
   LOOP
       addname ('Steven' || i);
       addname ('Veva' || i);
       addname ('Eli' || i);
       addname ('Chris' || i);
   END LOOP;

   /* Verify that there were no hashing conflicts (the COUNT should
      be 4 x counter. */
   p.l ('Count in names', names.COUNT);

   assert (
      names.COUNT = 4 * counter, 
      'Hashing conflict! Test suspended...'
      );

   /* Verify that the two scans return matching values. */
   v_name := 'Eli' || TRUNC (counter/2);
   p.l ('scan',rowbyscan (v_name));
   p.l ('hash',rowbyhash (v_name));
   assert (
      rowbyscan (v_name) = rowbyhash (v_name),
      'Row by scan does not equal row by hash');

   plvtmr.set_factor (counter);

   /* Time performance of retrieval via scan. */
   sf_timer.start_timer;
   FOR i IN 1 .. counter
   LOOP
      v_row := rowbyscan (v_name);
   END LOOP;
   sf_timer.show_elapsed_time ('scan');

   /* Time performance of retrieval via hashed value. */
   sf_timer.start_timer;
   FOR i IN 1 .. counter
   LOOP
      v_row := rowbyhash (v_name);
   END LOOP;
   sf_timer.show_elapsed_time ('hash');

EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
END;
/


