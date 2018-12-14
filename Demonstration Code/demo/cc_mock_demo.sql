CREATE OR REPLACE FUNCTION my_function
   RETURN VARCHAR2
IS
   l_return VARCHAR2(32767);
BEGIN
$IF $$mock_case_1
$THEN
   DBMS_OUTPUT.PUT_LINE ('Mocking case 1 behavior of my_function...');
   l_return := 'MAXIMUM';
$ELSIF $$mock_case_2
$THEN
   DBMS_OUTPUT.PUT_LINE ('Mocking case 2 behavior of my_function...');
   l_return := 'MINIMUM';
$ELSE
   DBMS_OUTPUT.PUT_LINE ('Normal behavior of my_function...');
   l_return := 'AVERAGE';
$END      
   RETURN l_return;
END my_function;
/

CREATE OR REPLACE PROCEDURE my_procedure
IS
   l_value VARCHAR2 ( 100 );
BEGIN
   l_value := my_function;
   DBMS_OUTPUT.put_line ( 'Value returned = ' || l_value );
END my_procedure;
/
