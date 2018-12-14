CONNECT u1/p
SET SERVEROUTPUT ON
PROMPT ...as u1, calling u1.P()
CALL u1.authid_with_view_test()
/
PROMPT


CONNECT u1/p
SET SERVEROUTPUT ON
PROMPT ...as u1, calling u2.P()
CALL u2.authid_with_view_test()
/
PROMPT


CONNECT u2/p
SET SERVEROUTPUT ON
PROMPT ...as u2, calling u1.P()
CALL u1.authid_with_view_test()
/
