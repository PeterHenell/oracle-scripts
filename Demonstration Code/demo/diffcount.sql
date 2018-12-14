CREATE TABLE hmo_coverage (
   denial VARCHAR2(100),
   patient_name VARCHAR2(100));

DECLARE
   denial name_varray := 
     name_varray ('TOO SICK', 'TOO POOR', 'COMPLAINS TOO MUCH');   
   patient_name name_varray :=
     name_varray ('John Lovecanal', 'Sally Works2Jobs');
BEGIN
   FORALL indx IN denial.FIRST .. denial.LAST
      INSERT INTO hmo_coverage 
         VALUES (denial(indx), patient_name(indx));
END;
/

SELECT COUNT(*) FROM hmo_coverage;         
