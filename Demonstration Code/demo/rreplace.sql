CREATE OR REPLACE FUNCTION rreplace (
   p_string             IN   VARCHAR2
  ,p_replace_from       IN   VARCHAR2
  ,p_replace_to         IN   VARCHAR2
  ,p_max_replacements   IN   NUMBER DEFAULT NULL
)
   RETURN VARCHAR2
IS
   l_pos      INTEGER;
   l_length   INTEGER := LENGTH (p_replace_from);
BEGIN
   IF     NVL (p_max_replacements, 1) > 0
      AND SUBSTR (p_string, -l_length) = p_replace_from
   THEN
      RETURN    rreplace (SUBSTR (p_string, 1, LENGTH (p_string) - l_length)
                         ,p_replace_from
                         ,p_replace_to
                         , p_max_replacements - 1
                         )
             || p_replace_to;
   ELSE
      RETURN p_string;
   END IF;
END;
/