BEGIN
   intab ('employee'
         ,colin_filter_in      => 
		    'employee_id,commission,job_id,salary'
         ,where_in => 'department_id = 10'
		 ,trace_in => true);
END;
/
BEGIN
   intab ('employee'
         ,collike_filter_in      => 
		    '%I%E%'
           ,trace_in => true);
END;
/
