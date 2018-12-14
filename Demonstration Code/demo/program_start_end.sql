CREATE OR REPLACE PROCEDURE set_program_start_ends (
   package_in   IN   VARCHAR2
 , owner_in     IN   VARCHAR DEFAULT NULL
)
  
IS
   TYPE all_source_aat IS TABLE OF all_source%ROWTYPE
      INDEX BY BINARY_INTEGER;

   TYPE all_procedures_aat IS TABLE OF all_procedures%ROWTYPE
      INDEX BY BINARY_INTEGER;

   l_owner      program_start_end.program_name%TYPE
                                              := UPPER (NVL (owner_in, USER));
   l_package    program_start_end.package_name%TYPE   := UPPER (package_in);
   l_programs   all_procedures_aat;
   l_source     all_source_aat;
   l_row        PLS_INTEGER;

   PROCEDURE initialize
   IS
   BEGIN
      DELETE FROM program_start_end
            WHERE owner = l_owner AND package_name = l_package;
   END initialize;

   PROCEDURE retrieve_package_programs
   IS
   BEGIN
      SELECT   *
      BULK COLLECT INTO l_programs
          FROM all_procedures
         WHERE owner = l_owner AND object_name = l_package
      ORDER BY procedure_name;

      SELECT   *
      BULK COLLECT INTO l_source
          FROM all_source
         WHERE owner = l_owner AND NAME = l_package AND TYPE = 'PACKAGE BODY'
      ORDER BY line;
   END retrieve_package_programs;

   FUNCTION program_type (
      owner_in     IN   VARCHAR2
    , package_in   IN   VARCHAR2
    , program_in   IN   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      c_function_pos   CONSTANT PLS_INTEGER      := 0;

      TYPE overload_aat IS TABLE OF all_arguments.overload%TYPE
         INDEX BY PLS_INTEGER;

      l_overloads               overload_aat;
      retval                    VARCHAR2 (32767);

      FUNCTION list_to_string (
         list_in       IN   overload_aat
       , delim_in      IN   VARCHAR2 DEFAULT ','
       , distinct_in   IN   BOOLEAN DEFAULT FALSE
      )
         RETURN VARCHAR2
      IS
         l_row         PLS_INTEGER;
         l_add_value   BOOLEAN;
         retval        VARCHAR2 (32767);

         PROCEDURE add_item
         IS
         BEGIN
            retval := retval || delim_in || list_in (l_row);
         END add_item;
      BEGIN
         l_row := list_in.FIRST;

         WHILE (l_row IS NOT NULL)
         LOOP
            -- Decide if this value should be added.
            -- Only an issue if the user has specified DISTINCT.
            IF NOT distinct_in OR retval IS NULL
            THEN
               add_item;
            ELSIF     distinct_in
                  AND INSTR (retval, delim_in || list_in (l_row)) = 0
            THEN
               add_item;
            END IF;

            l_row := list_in.NEXT (l_row);
         END LOOP;

         RETURN LTRIM (retval, delim_in);
      END list_to_string;
   BEGIN
      SELECT   DECODE (MIN (POSITION), 0, 'FUNCTION', 'PROCEDURE')
      BULK COLLECT INTO l_overloads
          FROM all_arguments
         WHERE owner = owner_in
           AND package_name = package_in
           AND object_name = program_in
      GROUP BY overload;

      IF l_overloads.COUNT > 0
      THEN
         retval := list_to_string (l_overloads, ',', distinct_in => TRUE);
      END IF;

      RETURN retval;
   END program_type;

   PROCEDURE set_start_ends (program_in IN all_procedures%ROWTYPE)
   IS
      l_row         PLS_INTEGER;
      l_start_end   program_start_end%ROWTYPE;
      l_started     BOOLEAN;
      l_overload    PLS_INTEGER                 := 0;

      FUNCTION starting_program (NAME_IN IN VARCHAR2, text_in IN VARCHAR2)
         RETURN BOOLEAN
      IS
         l_upper_text   VARCHAR2 (32767) := UPPER (text_in);
      BEGIN
         RETURN    INSTR (l_upper_text, 'PROCEDURE ' || NAME_IN || ' ') > 0
                OR INSTR (l_upper_text, 'FUNCTION ' || NAME_IN || ' ') > 0;
      END starting_program;

      FUNCTION ending_program (NAME_IN IN VARCHAR2, text_in IN VARCHAR2)
         RETURN BOOLEAN
      IS
         l_upper_text   VARCHAR2 (32767) := UPPER (text_in);
      BEGIN
         RETURN INSTR (l_upper_text, 'END ' || NAME_IN) > 0;
      END ending_program;
   BEGIN
      l_start_end.owner := program_in.owner;
      l_start_end.package_name := program_in.object_name;
      l_start_end.program_name := program_in.procedure_name;
      l_row := l_source.FIRST;

      WHILE (l_row IS NOT NULL)
      LOOP
         IF starting_program (program_in.procedure_name
                            , l_source (l_row).text
                             )
         THEN
            l_started := TRUE;
            l_overload := l_overload + 1;
            l_start_end.start_line := l_source (l_row).line;
         ELSIF     ending_program (program_in.procedure_name
                                 , l_source (l_row).text
                                  )
               AND l_started
         THEN
            l_start_end.end_line := l_source (l_row).line;
            l_start_end.overload := l_overload;
            l_start_end.program_type :=
               program_type (l_start_end.owner
                           , l_start_end.package_name
                           , l_start_end.program_name
                            );

            INSERT INTO program_start_end
                 VALUES l_start_end;

            l_started := FALSE;
         END IF;

         l_row := l_source.NEXT (l_row);
      END LOOP;
   END set_start_ends;
BEGIN
   initialize;
   retrieve_package_programs;
   --
   l_row := l_programs.FIRST;

   WHILE (l_row IS NOT NULL)
   LOOP
      set_start_ends (l_programs (l_row));
      l_row := l_programs.NEXT (l_row);
   END LOOP;

   COMMIT;
END set_program_start_ends;
/
