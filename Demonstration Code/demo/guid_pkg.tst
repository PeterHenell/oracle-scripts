DECLARE
   l_guid   guid_pkg.guid_t;

   PROCEDURE bpl (val IN BOOLEAN)
   IS
   BEGIN
      IF val
      THEN
         DBMS_OUTPUT.put_line ('TRUE');
      ELSIF NOT val
      THEN
         DBMS_OUTPUT.put_line ('FALSE');
      ELSE
         DBMS_OUTPUT.put_line ('NULL');
      END IF;
   END;
BEGIN
   DBMS_OUTPUT.put_line (guid_pkg.formatted_guid);
   bpl (guid_pkg.is_formatted_guid (guid_pkg.formatted_guid));
   bpl (guid_pkg.is_formatted_guid (SYS_GUID));
   bpl (guid_pkg.is_formatted_guid ('Steven'));
   DBMS_OUTPUT.put_line (guid_pkg.formatted_guid (SYS_GUID));
END;
/