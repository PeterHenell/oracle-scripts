DROP TYPE pet_t FORCE;

DROP TYPE pet_nt FORCE;

CREATE TYPE pet_t IS OBJECT (
   NAME    VARCHAR2 (60)
 , breed   VARCHAR2 (100)
 , dob     DATE
);
/

CREATE TYPE pet_nt IS TABLE OF pet_t;
/

CREATE OR REPLACE FUNCTION pet_family (dad_in IN pet_t, mom_in IN pet_t)
   RETURN pet_nt
IS
   l_count   PLS_INTEGER;
   retval    pet_nt      := pet_nt ();
BEGIN
   retval.EXTEND;
   retval (retval.LAST) := dad_in;
   retval.EXTEND;
   retval (retval.LAST) := mom_in;

   IF mom_in.breed = 'RABBIT'
   THEN
      l_count := 12;
   ELSIF mom_in.breed = 'DOG'
   THEN
      l_count := 4;
   ELSIF mom_in.breed = 'KANGAROO'
   THEN
      l_count := 1;
   END IF;

   FOR indx IN 1 .. l_count
   LOOP
      retval.EXTEND;
      retval (retval.LAST) := pet_t ('BABY' || indx, mom_in.breed, SYSDATE);
   END LOOP;

   RETURN retval;
END;
/

SELECT *
  FROM TABLE (pet_family (pet_t ('Hoppy', 'RABBIT', SYSDATE)
                        , pet_t ('Hippy', 'RABBIT', SYSDATE)
                        )
             );

REM Pipelined version

CREATE OR REPLACE FUNCTION pet_family (dad_in IN pet_t, mom_in IN pet_t)
   RETURN pet_nt PIPELINED
IS
   l_count   PLS_INTEGER;
   retval    pet_nt      := pet_nt ();
BEGIN
   PIPE ROW (dad_in);
   PIPE ROW (mom_in);

   IF mom_in.breed = 'RABBIT'
   THEN
      l_count := 12;
   ELSIF mom_in.breed = 'DOG'
   THEN
      l_count := 4;
   ELSIF mom_in.breed = 'KANGAROO'
   THEN
      l_count := 1;
   END IF;

   FOR indx IN 1 .. l_count
   LOOP
      PIPE ROW (pet_t ('BABY' || indx, mom_in.breed, SYSDATE));
   END LOOP;

   RETURN;
END;
/

SELECT *
  FROM TABLE (pet_family (pet_t ('Bob', 'KANGAROO', SYSDATE)
                        , pet_t ('Sally', 'KANGAROO', SYSDATE)
                         )
             );