BEGIN
   pl (insga.lcd_sql (
      'select favorite_flavor 
         from ice_cream'));
      
   pl (insga.lcd_sql (
      'select 
       favorite_flavor 
       from 
       ice_cream'));
       
   -- Only remove carriage return (not spaces or tabs).
   pl (insga.lcd_sql (
      'select favorite_flavor 
         from ice_cream',
      remove_list => CHR(10)));
      
   -- Ignore the WHERE clause.
   pl (insga.lcd_sql (
      'select favorite_flavor 
         from ice_cream where
         name = :bindvar',
      stopat => 'WHERE'));
END;
/
