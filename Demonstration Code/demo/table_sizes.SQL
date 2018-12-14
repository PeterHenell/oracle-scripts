-- Table_sizes.sql
--
-- This code will compute the table size for unpopulated tables using the procedures outlined in Jason
-- Couchman's DBA Certification Exam Guide.
--
-- Note that it selects two inputs, table name and estimated number of rows which are stored in a table
-- named table_size which must be created. see code below:
--
-- Create table TABLE_SIZE (table_name varchar2(32),table_rows number,table_size number);
--
--
-- Insert the table names and estimated number of rows (maximum over time).
-- Note that the tables must exist for this procedure to work.
--
-- This procedure will fill in the table_size based on the number and types of rows.
-- Modify the cur_in query to suit your needs.
--
-- Bob Rudolf Precision Computer Systems 1 November 1999
--
-- This code is contributed to the Revealnet Forum and may be freely copied, altered
-- and given to others.  Bob Rudolf Precision Computer Systems.
--
-- Change History
--
-- Bob Rudolf 13 March 1999 limited CLOB to Varchar2(100)
--
CREATE OR REPLACE PROCEDURE table_sizing
IS
   x INTEGER := 0;
   y INTEGER := 0;
   z INTEGER := 0;
   colsize INTEGER := 0;
   over250 INTEGER := 0;
   under250 INTEGER := 0;
   tsize INTEGER := 0;
   num_blocks INTEGER := 0;
   num_rows INTEGER := 0;
   block_size INTEGER := 8192;
   pct_free FLOAT := 0.15;
   row_num table_size.table_size%TYPE;
   tab_name table_size.table_name%TYPE;
   tab_rows table_size.table_rows%TYPE;

   CURSOR cur_out
   IS
      SELECT UPPER (table_name) table_name, table_rows
        FROM table_size
         FOR UPDATE OF table_size;

   CURSOR cur_in
   IS
      SELECT t.table_name AS t_name, t.data_type
                   AS d_type,
             t.data_length AS d_len
        FROM user_tab_columns t, user_objects o
       WHERE o.object_type = 'TABLE'
         AND o.object_name = tab_name
         AND t.table_name = o.object_name;
BEGIN
   FOR out_rec IN cur_out
   LOOP
      tab_name := out_rec.table_name;
      num_rows := out_rec.table_rows;
      colsize := 0;
      under250 := 0;
      over250 := 0;

      FOR in_rec IN cur_in
      LOOP           
         IF in_rec.d_type = 'CLOB'
         THEN
            colsize := colsize + 100;
            under250 := under250 + 1;
         ELSE
            colsize := colsize + in_rec.d_len;

            IF in_rec.d_len >= 250
            THEN
               over250 := over250 + 1;
            ELSE
               under250 := under250 + 1;
            END IF;
         END IF;
      END LOOP;

      DBMS_OUTPUT.put_line ('-');
      DBMS_OUTPUT.put_line ('-- TABLE SIZE CALCULATIONS --');
      DBMS_OUTPUT.put_line ('-');
      DBMS_OUTPUT.put_line (
         'TABLE NAME ......... = ' || tab_name
      );
      DBMS_OUTPUT.put_line (
         'BLOCK SIZE ......... = ' || TO_CHAR (block_size)
      );
      DBMS_OUTPUT.put_line (
         'FREE SPACE PERCENT . = ' || TO_CHAR (pct_free)
      );
      DBMS_OUTPUT.put_line (
         'TOTAL OF COLUMNS ... = ' || TO_CHAR (colsize)
      );
      DBMS_OUTPUT.put_line (
         'COLUMNS UNDER 250 .. = ' || TO_CHAR (under250)
      );
      DBMS_OUTPUT.put_line (
         'COLUMNS OVER 250 ... = ' || TO_CHAR (over250)
      );
      z := ( (3 + colsize) + under250 + (3 * over250));
      DBMS_OUTPUT.put_line (
         'CALCULATED ROW LENGTH (Z) = ' || TO_CHAR (z)
      );

      IF z < block_size
      THEN
         x := (block_size / z);
      ELSE
         x := (z / block_size);
      END IF;

      y :=
        block_size -
           (pct_free * (block_size - (52 + (4 * x))));
      DBMS_OUTPUT.put_line (
         'BYTES AVAILABLE IN EACH BLOCK FOR ROW DATA (Y) = ' ||
            TO_CHAR (y)
      );

      IF z < block_size
      THEN
         WHILE y < (x * z)
         LOOP
            x := x - 1;
         END LOOP;
      END IF;

      num_blocks := CEIL (num_rows / x);

      IF num_blocks = 0
      THEN
         num_blocks := 1;
      END IF;

      tsize := CEIL ( ( (block_size * num_blocks) / 1024));

      IF z < block_size
      THEN
         DBMS_OUTPUT.put_line (
            'NUMBER OF ROWS CONTAINED IN A BLOCK (X)  = ' ||
               TO_CHAR (x)
         );
      ELSE
         DBMS_OUTPUT.put_line (
            'NUMBER OF BLOCKS NEEDED FOR EACH ROW (X) = ' ||
               TO_CHAR (x)
         );
      END IF;

      DBMS_OUTPUT.put_line (
         'NUMBER OF ' || TO_CHAR (block_size) ||
            ' BLOCKS REQUIRED = ' ||
            TO_CHAR (num_blocks)
      );

      IF num_rows > 1000
      THEN
         DBMS_OUTPUT.put_line (
            'SIZE OF TABLE FOR ' || TO_CHAR (num_rows) ||
               ' ROWS = ' ||
               TO_CHAR (tsize / 1000) ||
               'MB'
         );
      ELSE
         DBMS_OUTPUT.put_line (
            'SIZE OF TABLE FOR ' || TO_CHAR (num_rows) ||
               ' ROWS = ' ||
               TO_CHAR (tsize) ||
               'KB'
         );
      END IF;

      UPDATE table_size
         SET table_size = tsize
       WHERE CURRENT OF cur_out;
   END LOOP;                                   -- OUTER LOOP
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (
         'ERROR MESSAGE FOLLOWS... ' || SQLERRM
      );
END;
/
SHOW ERRORS

      
