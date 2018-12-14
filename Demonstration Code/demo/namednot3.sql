CREATE OR REPLACE PROCEDURE transform_string (
   string_inout    IN OUT   VARCHAR2
 , preference_in   IN       VARCHAR2 DEFAULT 'NO THANKS'
 , date_in         IN       VARCHAR2 
)
IS
BEGIN
   NULL;
END transform_string;
/

DECLARE
   l_string VARCHAR2 ( 100 );
BEGIN
   transform_string ( l_string);
END;

DECLARE
   l_string VARCHAR2 ( 100 );
BEGIN
   transform_string ( l_string, , SYSDATE + 10);
END;

DECLARE
   l_string VARCHAR2 ( 100 );
BEGIN
   transform_string ( l_string, date_in => SYSDATE);
END;

DECLARE
   l_string VARCHAR2 ( 100 );
BEGIN
   transform_string ( l_string, NULL, SYSDATE + 10);
END;
