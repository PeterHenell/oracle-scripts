DECLARE
   c_format   CONSTANT VARCHAR2 (22)
      := 'YYYY-MM-DD HH24:MI:SS' ;
   l_new_year          DATE
      := TO_DATE (
            '2012-01-02 00:00:01'
          ,  c_format);
BEGIN
   DBMS_OUTPUT.put_line (
      TO_CHAR (
         l_new_year - 24
       ,  c_format));
END;
/

DECLARE
   c_format   CONSTANT VARCHAR2 (22)
      := 'YYYY-MM-DD HH24:MI:SS' ;
   l_new_year          DATE
      := TO_DATE (
            '2012-01-02 00:00:01'
          ,  c_format);
BEGIN
   DBMS_OUTPUT.put_line (
      TO_CHAR (l_new_year - 1
             ,  c_format));
END;
/

DECLARE
   c_format   CONSTANT VARCHAR2 (22)
      := 'YYYY-MM-DD HH24:MI:SS' ;
   l_new_year          DATE
      := TO_DATE (
            '2012-01-02 00:00:01'
          ,  c_format);
BEGIN
   DBMS_OUTPUT.put_line (
      TO_CHAR (
           l_new_year
         - 24 * 60 * 60
       ,  c_format));
END;
/

DECLARE
   c_format   CONSTANT VARCHAR2 (22)
      := 'YYYY-MM-DD HH24:MI:SS' ;
   l_new_year          DATE
      := TO_DATE (
            '2012-01-02 00:00:01'
          ,  c_format);
BEGIN
   DBMS_OUTPUT.put_line (
      TO_CHAR (
           TRUNC (l_new_year)
         - 1
         + 1 / (24 * 60 * 60)
       ,  c_format));
END;
/