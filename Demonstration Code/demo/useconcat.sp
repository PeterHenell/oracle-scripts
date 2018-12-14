CREATE OR REPLACE PROCEDURE updnumval (
   col_in     IN   VARCHAR2
 , start_in   IN   DATE
 , end_in     IN   DATE
 , val_in     IN   NUMBER
)
IS
   c_format CONSTANT VARCHAR2 ( 100 ) := 'YYYYMMDDHH24MISS';
BEGIN
   EXECUTE IMMEDIATE    'UPDATE employees SET '
                     || col_in
                     || ' = '
                     || val_in
                     || ' WHERE hire_date BETWEEN TO_DATE ('''
                     || TO_CHAR ( start_in, c_format )
                     || ''', '''
                     || c_format
                     || ''') AND TO_DATE ('''
                     || TO_CHAR ( end_in, c_format )
                     || ''', '''
                     || c_format
                     || ''')';
END;
/
