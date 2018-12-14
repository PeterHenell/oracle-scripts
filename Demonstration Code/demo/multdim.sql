CREATE OR REPLACE PACKAGE multdim
-- Created by John Beresniewicz
IS
   --l_space array (3, 5, 100);
   
   TYPE dim1_t IS TABLE OF VARCHAR2 (32767)
      INDEX BY PLS_INTEGER;

   TYPE dim2_t IS TABLE OF dim1_t
      INDEX BY PLS_INTEGER;

   TYPE dim3_t IS TABLE OF dim2_t
      INDEX BY PLS_INTEGER;

   PROCEDURE setcell (
      array_in   IN OUT   dim3_t
     ,dim1_in             PLS_INTEGER
     ,dim2_in             PLS_INTEGER
     ,dim3_in             PLS_INTEGER
     ,value_in   IN       VARCHAR2
   );

   FUNCTION getcell (
      array_in   IN   dim3_t
     ,dim1_in         PLS_INTEGER
     ,dim2_in         PLS_INTEGER
     ,dim3_in         PLS_INTEGER
   )
      RETURN VARCHAR2;

   FUNCTION EXISTS (
      array_in   IN   dim3_t
     ,dim1_in         PLS_INTEGER
     ,dim2_in         PLS_INTEGER
     ,dim3_in         PLS_INTEGER
   )
      RETURN BOOLEAN;

   -- FUNCTION COUNT (array_in IN dim3_t) RETURN PLS_INTEGER;
END multdim;
/

CREATE OR REPLACE PACKAGE BODY multdim
IS
   PROCEDURE setcell (
      array_in   IN OUT   dim3_t
     ,dim1_in             PLS_INTEGER
     ,dim2_in             PLS_INTEGER
     ,dim3_in             PLS_INTEGER
     ,value_in   IN       VARCHAR2
   )
   IS
   BEGIN
      -- Typical syntax: array_in (dim1_in, dim2_in, dim3_in) := value_in;      
      
      array_in (dim3_in) (dim2_in) (dim1_in) := value_in;
      
      -- array_in (dim1_in) (dim2_in) (dim3_in) := value_in;
   END;

   FUNCTION getcell (
      array_in   IN   dim3_t
     ,dim1_in         PLS_INTEGER
     ,dim2_in         PLS_INTEGER
     ,dim3_in         PLS_INTEGER
   )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN array_in (dim3_in) (dim2_in) (dim1_in);
   END;

   FUNCTION EXISTS (
      array_in   IN   dim3_t
     ,dim1_in         PLS_INTEGER
     ,dim2_in         PLS_INTEGER
     ,dim3_in         PLS_INTEGER
   )
      RETURN BOOLEAN
   IS
      l_value   VARCHAR2 (32767);
   BEGIN
       -- 11/2002 Manchester
       -- The value doesn't matter; what matters is whether
       -- this combination exists or not.
      --
      -- 02/2003 NWOUG Seattle
      -- Note: EXISTS method only applies to a single
      --       collection at a time.

      /*
      IF array_in(dim3_in )(dim2_in )(dim1_in) IS NOT NULL
       THEN
         RETURN TRUE;
       ELSE
         RETURN TRUE;
       END IF;
       */

      -- Disney World approach 4/2003
      l_value := array_in (dim3_in) (dim2_in) (dim1_in);
      RETURN TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND OR VALUE_ERROR
      THEN
         RETURN FALSE;
   END;

   /*
   FUNCTION COUNT (array_in IN dim3_t)
      RETURN PLS_INTEGER
   IS
      FUNCTION dim2_count (array_in IN dim3_t)
         RETURN PLS_INTEGER
      IS
         retval   PLS_INTEGER := 0;
         l_row    PLS_INTEGER := array_in.FIRST;
      BEGIN
         WHILE (l_row IS NOT NULL)
         LOOP
            retval := retval + array_in;
         END LOOP;

         RETURN retval;
      END dim2_count;
   BEGIN
      RETURN array_in.COUNT * dim2_count (array_in);
   END COUNT;
   */
END multdim;
/
