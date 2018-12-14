CREATE OR REPLACE PACKAGE BODY guid_pkg
IS
   FUNCTION is_formatted_guid (string_in IN VARCHAR2)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN string_in LIKE c_mask;
   END is_formatted_guid;

   FUNCTION formatted_guid (guid_in IN VARCHAR2)
      RETURN formatted_guid_t
   IS
   BEGIN
      -- If not already in the 8-4-4-4-rest format, then make it so.
      IF is_formatted_guid (guid_in)
      THEN
         RETURN guid_in;
      -- Is it only missing those squiggly brackets?
      ELSIF is_formatted_guid ('{' || guid_in || '}')
      THEN
         RETURN formatted_guid ('{' || guid_in || '}');
      ELSE
         RETURN    '{'
                || SUBSTR (guid_in, 1, 8)
                || '-'
                || SUBSTR (guid_in, 9, 4)
                || '-'
                || SUBSTR (guid_in, 13, 4)
                || '-'
                || SUBSTR (guid_in, 17, 4)
                || '-'
                || SUBSTR (guid_in, 21)
                || '}';
      END IF;
   END formatted_guid;

   FUNCTION formatted_guid
      RETURN formatted_guid_t
   IS
   BEGIN
      RETURN formatted_guid (SYS_GUID);
   END formatted_guid;
END guid_pkg;
/