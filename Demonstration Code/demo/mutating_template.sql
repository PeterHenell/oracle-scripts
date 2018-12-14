CREATE OR REPLACE PACKAGE employees_mp
IS
   PROCEDURE add_update_to_list (old_row_in   IN employees%ROWTYPE
                               , new_row_in   IN employees%ROWTYPE);

   PROCEDURE add_insert_to_list (new_row_in IN employees%ROWTYPE);

   PROCEDURE add_delete_to_list (old_row_in IN employees%ROWTYPE);

   PROCEDURE process_lists;

   PROCEDURE cleanup;
END employees_mp;
/

CREATE OR REPLACE PACKAGE BODY employees_mp
IS
   -- Information will not be added at the row level
   -- if the statement level trigger is already processing
   -- the list.

   in_process     BOOLEAN := FALSE;

   TYPE employee_aat IS TABLE OF employees%ROWTYPE
                           INDEX BY BINARY_INTEGER;

   g_insert_new   employee_aat;
   g_update_old   employee_aat;
   g_update_new   employee_aat;
   g_delete_old   employee_aat;

   PROCEDURE add_update_to_list (old_row_in   IN employees%ROWTYPE
                               , new_row_in   IN employees%ROWTYPE)
   IS
   BEGIN
      IF NOT in_process
      THEN
         g_update_old (g_update_old.COUNT + 1) := old_row_in;
         g_update_new (g_update_new.COUNT + 1) := new_row_in;
      END IF;
   END add_update_to_list;

   PROCEDURE add_insert_to_list (new_row_in IN employees%ROWTYPE)
   IS
   BEGIN
      IF NOT in_process
      THEN
         g_insert_new (g_insert_new.COUNT + 1) := new_row_in;
      END IF;
   END add_insert_to_list;

   PROCEDURE add_delete_to_list (old_row_in IN employees%ROWTYPE)
   IS
   BEGIN
      IF NOT in_process
      THEN
         g_delete_old (g_delete_old.COUNT + 1) := old_row_in;
      END IF;
   END add_delete_to_list;

   PROCEDURE cleanup
   IS
   BEGIN
      in_process := FALSE;
      g_update_old.delete;
      g_update_new.delete;
      g_delete_old.delete;
      g_insert_new.delete;
   END cleanup;

   PROCEDURE process_lists
   IS
      l_row   PLS_INTEGER;

      PROCEDURE process_insert (new_row_in IN employees%ROWTYPE)
      IS
      BEGIN
         NULL;
      END process_insert;

      PROCEDURE process_update (old_row_in   IN employees%ROWTYPE
                              , new_row_in   IN employees%ROWTYPE)
      IS
      BEGIN
         NULL;
      END process_update;

      PROCEDURE process_delete (old_row_in IN employees%ROWTYPE)
      IS
      BEGIN
         NULL;
      END process_delete;
   BEGIN
      IF NOT in_process
      THEN
         in_process := TRUE;

         -- Iterate through the contents of each list and
         -- take the appropriate action.

         -- Insert logic

         l_row := g_insert_new.FIRST;

         WHILE (l_row IS NOT NULL)
         LOOP
            process_insert (g_insert_new (l_row));

            -- Go to the next NEW row
            l_row := g_insert_new.NEXT (l_row);
         END LOOP;

         -- Update logic

         l_row := g_update_new.FIRST;

         WHILE (l_row IS NOT NULL)
         LOOP
            process_update (g_update_old (l_row), g_update_new (l_row));

            -- Go to the next NEW row
            l_row := g_update_new.NEXT (l_row);
         END LOOP;

         -- Delete logic

         l_row := g_delete_old.FIRST;

         WHILE (l_row IS NOT NULL)
         LOOP
            process_delete (g_delete_old (l_row));

            -- Go to the next NEW row
            l_row := g_delete_old.NEXT (l_row);
         END LOOP;
      END IF;

      cleanup;
   EXCEPTION
      -- Call cleanup; inside each exception handler
      WHEN NO_DATA_FOUND
      THEN
         cleanup;
      WHEN OTHERS
      THEN
         cleanup;
         RAISE;
   END process_lists;
END employees_mp;
/

CREATE OR REPLACE TRIGGER employee_rtrg
   AFTER INSERT OR UPDATE OR DELETE
   ON employees
   FOR EACH ROW
DECLARE
   l_old   employees%ROWTYPE;
   l_new   employees%ROWTYPE;
BEGIN
   -- Copy OLD and NEW pseudo-records to real records
   -- so they can be passed as arguments.
   IF UPDATING OR DELETING
   THEN
      -- Replace with your column names
      l_old.employee_id := :old.employee_id;
      l_old.last_name := :old.last_name;
   END IF;

   IF UPDATING OR INSERTING
   THEN
      -- Replace with your column names
      l_new.employee_id := :new.employee_id;
      l_new.last_name := :new.last_name;
   END IF;

   IF INSERTING
   THEN
      employees_mp.add_insert_to_list (l_new);
   ELSIF UPDATING
   THEN
      employees_mp.add_update_to_list (l_old, l_new);
   ELSIF DELETING
   THEN
      employees_mp.add_delete_to_list (l_old);
   END IF;
END;
/

CREATE OR REPLACE TRIGGER employee_strg
   AFTER INSERT OR UPDATE OR DELETE
   ON employees
BEGIN
   employees_mp.process_lists;
END;
/