SELECT id untested_requirement
  FROM requirements
 WHERE id LIKE 'B%'
MINUS
SELECT requirement
  FROM qu_test_case tc
 WHERE unit_test_guid = '{10CF847D-7CA8-4DC0-90D6-72A23E9A4D59}'