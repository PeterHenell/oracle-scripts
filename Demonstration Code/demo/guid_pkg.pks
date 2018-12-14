CREATE OR REPLACE PACKAGE guid_pkg
IS
   SUBTYPE guid_t IS RAW (16);

   SUBTYPE formatted_guid_t IS VARCHAR2 (38);

   --                Example: {34DC3EA7-21E4-4C8A-BAA1-7C2F21911524}
   c_mask   CONSTANT formatted_guid_t
                                  := '{________-____-____-____-____________}';

   FUNCTION is_formatted_guid (string_in IN VARCHAR2)
      RETURN BOOLEAN;

   FUNCTION formatted_guid (guid_in IN VARCHAR2)
      RETURN formatted_guid_t;

   FUNCTION formatted_guid
      RETURN formatted_guid_t;
END guid_pkg;
/