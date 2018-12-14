CREATE OR REPLACE PACKAGE employees_rp
AS
   TYPE employees_aat IS TABLE OF employees%ROWTYPE
                            INDEX BY PLS_INTEGER;
                            
   c_min_ceo_salary   CONSTANT PLS_INTEGER := 10000000;

   SUBTYPE t_performance_type IS INTEGER;    

   SUBTYPE fullname_t IS VARCHAR2 (10000);

   FUNCTION fullname (l  employees.last_name%TYPE
                    , f  employees.first_name%TYPE
                    , use_f_l_in IN BOOLEAN:= FALSE
                     )
      RETURN fullname_t;

   FUNCTION fullname (l  employees.last_name%TYPE
                    , f  employees.first_name%TYPE
                    , use_f_l_in IN PLS_INTEGER:= 0
                     )
      RETURN fullname_t;

   FUNCTION fullname (employee_id_in IN employees.employee_id%TYPE
                    , use_f_l_in IN BOOLEAN:= FALSE
                     )
      RETURN fullname_t;

   FUNCTION fullname_explicit (employee_id_in IN employees.employee_id%TYPE
                             , use_f_l_in IN BOOLEAN:= FALSE
                              )
      RETURN fullname_t;

   FUNCTION fullname_twosteps (employee_id_in IN employees.employee_id%TYPE
                             , use_f_l_in IN BOOLEAN:= FALSE
                              )
      RETURN fullname_t;
END employees_rp;
/