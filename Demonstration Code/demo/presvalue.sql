CREATE OR REPLACE PACKAGE pv
IS
   fixed_count PLS_INTEGER := 0;
   var_count PLS_INTEGER := 0;
   
   /* Table structure to hold the lease accumulations. */
   TYPE pv_table_type IS TABLE OF NUMBER(9) INDEX BY BINARY_INTEGER;
   pv_table pv_table_type;

   PROCEDURE showtab; 
   PROCEDURE build_lease_schedule1(disp IN BOOLEAN := FALSE);
   PROCEDURE build_lease_schedule2(disp IN BOOLEAN := FALSE);
   PROCEDURE build_lease_schedule3(disp IN BOOLEAN := FALSE);
END;
/
CREATE OR REPLACE PACKAGE BODY pv
IS
   FUNCTION pv_of_fixed (year IN INTEGER) RETURN NUMBER IS
   BEGIN
      fixed_count := fixed_count + 1;
      /* Dummy computation */
      RETURN (year * 1.25);
   END;
   
   FUNCTION pv_of_variable (year IN INTEGER) RETURN NUMBER IS
   BEGIN
      var_count := var_count + 1;
      /* Dummy computation */
      RETURN (year / 1.25);
   END;

   PROCEDURE showtab IS
      indx INTEGER;
   BEGIN
      /* Display the results */
      indx := pv_table.FIRST;
      LOOP
         EXIT WHEN indx IS NULL;
         DBMS_OUTPUT.PUT_LINE (
            'PV in year ' || indx || ' = ' || pv_table(indx));
         indx := pv_table.NEXT (indx);       
      END LOOP;
   END;
   
   PROCEDURE build_lease_schedule1(disp IN BOOLEAN := FALSE) 
   /* Construct present value lease schedule over 20 years. */
   IS
      /* Temporary variable to hold lease accumulation. */
      pv_total_lease NUMBER(9);
   BEGIN      
      fixed_count := 0;
      var_count := 0;
      FOR year_count in 1 .. 20
      LOOP
         /* Reset the lease amount for this year. */
         pv_total_lease := 0;
         /* 
         || Build the PV based on the remaining years
         || plus the fixed and variable amounts.
         */
         FOR year_count2 in year_count..20
         LOOP
            /* Add annual total lease amount to cummulative. */
            pv_total_lease := 
               pv_total_lease +
               pv_of_fixed (year_count2) +
               pv_of_variable (year_count2);
         END LOOP;
         
         /* Add the annual PV to the table. */
         pv_table (year_count) := pv_total_lease;
      END LOOP;
      
      IF disp THEN showtab; END IF;
   END;

   PROCEDURE build_lease_schedule2 
      (disp IN BOOLEAN := FALSE)
   IS
      one_year_pv NUMBER(9) := 0;
      pv_total_lease NUMBER(9) := 0;
   BEGIN
      fixed_count := 0;
      var_count := 0;
      /*
      || Build the 20-year accumulated total and save each
      || of the annual lease amounts to the PL/SQL table. Notice that
      || pv_table (N) is set to the annual lease amount for year N-1.
      */
      FOR year_count in 1 .. 20
      LOOP
         one_year_pv := 
            pv_of_fixed (year_count) + pv_of_variable (year_count);
         pv_total_lease := pv_total_lease + one_year_pv;
         IF year_count < 20
         THEN
            pv_table (year_count+1) := one_year_pv;
         END IF;
      END LOOP;

      /* Save the 20-year total in the first row. */
      pv_table (1) := pv_total_lease;

      /* For each of the remaining years... */
      FOR year_count IN 2 .. 20
      LOOP
         /* Subtract the annual amount from the remaining total. */
         pv_total_lease := pv_total_lease - pv_table (year_count);
         /*
         || Save the Nth accumulation to the table (this writes right
         || over the annual lease amount, which is no longer needed.
         || I get double use out of the pv_table in this way.
         */
         pv_table (year_count) := pv_total_lease;
      END LOOP;
      
      IF disp THEN showtab; END IF;
   END;

   PROCEDURE build_lease_schedule3
      (disp IN BOOLEAN := FALSE)
   IS
      pv_total_lease NUMBER(9) := 0;
      one_year_pv NUMBER(9) := 0;
   BEGIN
      fixed_count := 0;
      var_count := 0;
      FOR year_count IN REVERSE 1..20 
      LOOP
         one_year_pv := pv_of_fixed(year_count) +
                        pv_of_variable(year_count);
         pv_total_lease := pv_total_lease + one_year_pv;
         pv_table (year_count) := pv_total_lease;
      END LOOP;
      
      IF disp THEN showtab; END IF;
   END;            
END pv;
/

BEGIN
   pv.pv_table.DELETE;
   pv.build_lease_schedule1 (TRUE);
   pv.pv_table.DELETE;
   pv.build_lease_schedule2 (TRUE);
   pv.pv_table.DELETE;
   pv.build_lease_schedule3 (TRUE);
END;
/

/* Now compare them in terms of performance */
@@ssoo
DECLARE
   vers1_tmr tmr_t := tmr_t.make ('Version 1', &&firstparm);
   vers2_tmr tmr_t := tmr_t.make ('Version 2', &&firstparm);
   vers3_tmr tmr_t := tmr_t.make ('Version 3', &&firstparm);
BEGIN
   pv.pv_table.DELETE;
   vers1_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      pv.build_lease_schedule1;
   END LOOP;
   vers1_tmr.stop;
   
   p.l ('Fixed : ' || pv.fixed_count);
   p.l ('Variable : ' || pv.var_count);
   
   pv.pv_table.DELETE;
   vers2_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      pv.build_lease_schedule2;
   END LOOP;
   vers2_tmr.stop;
   
   p.l ('Fixed : ' || pv.fixed_count);
   p.l ('Variable : ' || pv.var_count);

   pv.pv_table.DELETE;
   vers3_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      pv.build_lease_schedule3;
   END LOOP;
   vers3_tmr.stop;
   
   p.l ('Fixed : ' || pv.fixed_count);
   p.l ('Variable : ' || pv.var_count);
/*
Elapsed time for "Version 1" = 7.36 seconds. Per repetition timing = .00736 seconds.
Elapsed time for "Version 2" = 1.3 seconds. Per repetition timing = .0013 seconds.
Elapsed time for "Version 3" = .97 seconds. Per repetition timing = .00097 seconds.
*/
END;   
/
