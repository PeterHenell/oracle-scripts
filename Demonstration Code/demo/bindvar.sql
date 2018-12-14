DECLARE
   v_id INTEGER := 10;  
   CURSOR cur IS
     SELECT salary 
       FROM employee WHERE employee_id = v_id;
BEGIN
   OPEN cur;
END;
/
DECLARE
   v_id INTEGER := 20;  
   CURSOR cur IS
     SELECT SALARY FROM EMPLOYEE WHERE EMPLOYEE_ID = V_ID;
BEGIN
   OPEN cur;
END;
/
DECLARE
   CURSOR cur IS
     SELECT salary FROM employee WHERE employee_id = 20;
   rec cur%ROWTYPE;
BEGIN
   OPEN cur; FETCH cur INTO rec;
END;
/
SELECT salary FROM employee WHERE employee_id = 10;
SELECT salary FROM employee WHERE employee_id = 20;

BEGIN
   insga.show_similar ('%employee%', 1, 25);
   insga.show_similar ('%employee%');
END;
/   
