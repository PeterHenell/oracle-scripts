DECLARE
   l_guid_raw   RAW (16);
   l_guid_vc2   VARCHAR2 (32);
BEGIN
   DBMS_OUTPUT.put_line (SYS_GUID);
   l_guid_raw := SYS_GUID;
   l_guid_vc2 := SYS_GUID;
   DBMS_OUTPUT.put_line (l_guid_raw);
   DBMS_OUTPUT.put_line (LENGTH (l_guid_raw));
   DBMS_OUTPUT.put_line (l_guid_vc2);
   DBMS_OUTPUT.put_line (LENGTH (l_guid_vc2));
END;
/
