DROP TABLE otn_question;

CREATE TABLE otn_question (
   title VARCHAR2(100),
   description VARCHAR2(2000));

INSERT INTO otn_question
     VALUES ('Use implicit?'
           , 'How can I access SQL% cursor attributes inside a cursor FOR loop with an implicit cursor');

INSERT INTO otn_question
     VALUES ('Use explicit?'
           , 'How can I access cursor attributes inside a cursor FOR loop with an explicit cursor?');

COMMIT;

CREATE OR REPLACE PACKAGE otn_question_mp
IS
   PROCEDURE add_update_to_list (
      old_row_in   IN   otn_question%ROWTYPE
    , new_row_in   IN   otn_question%ROWTYPE
   );

   PROCEDURE add_insert_to_list (new_row_in IN otn_question%ROWTYPE);

   PROCEDURE add_delete_to_list (old_row_in IN otn_question%ROWTYPE);

   PROCEDURE process_lists;

   PROCEDURE cleanup;
END otn_question_mp;
/

CREATE OR REPLACE PACKAGE BODY otn_question_mp
IS
   -- Information will not be added at the row level
   -- if the statement level trigger is already processing
   -- the list.
   in_process     BOOLEAN          := FALSE;

   TYPE otn_question_aat IS TABLE OF otn_question%ROWTYPE
      INDEX BY BINARY_INTEGER;

   g_insert_new   otn_question_aat;
   g_update_old   otn_question_aat;
   g_update_new   otn_question_aat;
   g_delete_old   otn_question_aat;

   PROCEDURE add_update_to_list (
      old_row_in   IN   otn_question%ROWTYPE
    , new_row_in   IN   otn_question%ROWTYPE
   )
   IS
   BEGIN
      IF NOT in_process
      THEN
         g_update_old (g_update_old.COUNT + 1) := old_row_in;
         g_update_new (g_update_new.COUNT + 1) := new_row_in;
      END IF;
   END add_update_to_list;

   PROCEDURE add_insert_to_list (new_row_in IN otn_question%ROWTYPE)
   IS
   BEGIN
      IF NOT in_process
      THEN
         g_insert_new (g_insert_new.COUNT + 1) := new_row_in;
      END IF;
   END add_insert_to_list;

   PROCEDURE add_delete_to_list (old_row_in IN otn_question%ROWTYPE)
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
      g_update_old.DELETE;
      g_update_new.DELETE;
      g_delete_old.DELETE;
      g_insert_new.DELETE;
   END cleanup;

   PROCEDURE process_lists
   IS
      l_row   PLS_INTEGER;

      PROCEDURE process_insert (new_row_in IN otn_question%ROWTYPE)
      IS
      BEGIN
         -- Run the logic needed to apply changes or even halt the transaction.
         NULL;
      END process_insert;

      PROCEDURE process_update (
         old_row_in   IN   otn_question%ROWTYPE
       , new_row_in   IN   otn_question%ROWTYPE
      )
      IS
      BEGIN
         -- Run the logic needed to apply changes or even halt the transaction.
         NULL;
      END process_update;

      PROCEDURE process_delete (old_row_in IN otn_question%ROWTYPE)
      IS
      BEGIN
         -- Run the logic needed to apply changes or even halt the transaction.
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
END otn_question_mp;
/

CREATE OR REPLACE TRIGGER otn_question_rtrg
   AFTER INSERT OR UPDATE OR DELETE
   ON otn_question
   FOR EACH ROW
DECLARE
   l_old   otn_question%ROWTYPE;
   l_new   otn_question%ROWTYPE;
BEGIN
   -- Copy OLD and NEW pseudo-records to real records
   -- so they can be passed as arguments.
   IF UPDATING OR DELETING
   THEN
      l_old.title := :OLD.title;
      l_old.description := :OLD.description;
   END IF;

   IF UPDATING OR INSERTING
   THEN
      l_new.title := :NEW.title;
      l_new.description := :NEW.description;
   END IF;

   IF INSERTING
   THEN
      otn_question_mp.add_insert_to_list (l_new);
   ELSIF UPDATING
   THEN
      otn_question_mp.add_update_to_list (l_old, l_new);
   ELSIF DELETING
   THEN
      otn_question_mp.add_delete_to_list (l_old);
   END IF;
END;
/
CREATE OR REPLACE TRIGGER otn_question_strg
   AFTER INSERT OR UPDATE OR DELETE
   ON otn_question
BEGIN
   otn_question_mp.process_lists;
END;
/
