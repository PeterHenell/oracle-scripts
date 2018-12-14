DROP TABLE employees_copy
/

CREATE TABLE employees_copy
AS
	SELECT *
	  FROM employees
/

CREATE OR REPLACE FUNCTION betwnstr (string_in IN VARCHAR2
											  , start_in  IN INTEGER
											  , end_in	  IN INTEGER
												)
	RETURN VARCHAR2
IS
	PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	DELETE FROM employees_copy;

	COMMIT;
	RETURN (SUBSTR (string_in, start_in, end_in - start_in + 1));
END betwnstr;
/

DECLARE
	l_count	 PLS_INTEGER;
BEGIN
	DBMS_OUTPUT.put_line ('Start name display');

	FOR rec IN (SELECT betwnstr (last_name, 1, 3) first_three
					  FROM employees_copy)
	LOOP
		DBMS_OUTPUT.put_line (rec.first_three);
	END LOOP;

	DBMS_OUTPUT.put_line ('End name display');

	SELECT COUNT ( * )
	  INTO l_count
	  FROM employees_copy;

	DBMS_OUTPUT.put_line ('Count of employees = ' || l_count);
END;
/