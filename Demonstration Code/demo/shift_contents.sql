CREATE OR REPLACE PROCEDURE shift_contents (
   collection_inout   IN OUT   DBMS_SQL.varchar2s
  ,by_rows_in         IN       PLS_INTEGER
  ,at_row_in          IN       PLS_INTEGER
  ,new_value_in       IN       VARCHAR2 DEFAULT NULL
)
IS
   -- If by_rows_in is negative, then shift BEFORE the at_row,
   -- otherwise, shift after the at_row.
   l_shift_forward   BOOLEAN     := by_rows_in > 0;
   l_by              PLS_INTEGER := ABS (by_rows_in);
   l_first           PLS_INTEGER := collection_inout.FIRST;
   l_last            PLS_INTEGER := collection_inout.LAST;
BEGIN
   IF    l_last < at_row_in
      OR l_first > at_row_in
      OR by_rows_in = 0
      OR at_row_in IS NULL
   THEN
      -- Nothing to do.
      NULL;
   ELSIF l_shift_forward
   THEN
      -- Shift the contents forward.
      FOR indx IN REVERSE at_row_in .. l_last
      LOOP
         collection_inout (indx + l_by) := collection_inout (indx);
      END LOOP;

      -- Clear out the data from the newly created space.
      FOR indx IN 1 .. l_by
      LOOP
         collection_inout (at_row_in + indx - 1) := new_value_in;
      END LOOP;
   ELSE
      -- Shift the contents backwards.
      FOR indx IN l_first .. at_row_in
      LOOP
         collection_inout (indx - l_by) := collection_inout (indx);
      END LOOP;

      -- Clear out the data from the newly created space.
      FOR indx IN 1 .. l_by
      LOOP
         collection_inout (at_row_in - indx + 1) := new_value_in;
      END LOOP;
   END IF;
END shift_contents;
/