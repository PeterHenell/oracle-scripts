DECLARE
   SUBTYPE local_t IS VARCHAR2(100);
   
   l_counter PLS_INTEGER;
   
      TYPE array_t11 IS TABLE OF NUMBER
                       INDEX BY employees.employee_id%TYPE;
   
   TYPE array_t1 IS TABLE OF NUMBER
                       INDEX BY BINARY_INTEGER;

   TYPE array_t2 IS TABLE OF NUMBER
                       INDEX BY PLS_INTEGER;

   TYPE array_t3 IS TABLE OF NUMBER
                       INDEX BY POSITIVE;

   TYPE array_t4 IS TABLE OF NUMBER
                       INDEX BY NATURAL;

   TYPE array_t5 IS TABLE OF NUMBER
                       INDEX BY SIGNTYPE;

   TYPE array_t6 IS TABLE OF NUMBER
                       INDEX BY VARCHAR2 (64);

   TYPE array_t7 IS TABLE OF NUMBER
                       INDEX BY VARCHAR2 (32767);

   TYPE array_t8 IS TABLE OF NUMBER
                       INDEX BY employees.last_name%TYPE;

   TYPE array_t9 IS TABLE OF NUMBER
                       INDEX BY l_counter%TYPE;
                       
   TYPE array_t10 IS TABLE OF NUMBER
                       INDEX BY local_t;
                       
   /* NOT ALLOWED: A SQL integer is not a valid index by type
      since it does not have the same constrained set of values
      as BINARY_INTEGER.
   
      TYPE array_t11 IS TABLE OF NUMBER
                       INDEX BY employees.employee_id%TYPE;
                       
      So use a subtype to self-document the index:
      
      SUBTYPE emp_pky_t IS pls_integer;
   
      TYPE employees_aat IS TABLE OF employees%ROWTYPE
                            INDEX BY emp_pky_t;                     

   */
BEGIN
   NULL;
END;