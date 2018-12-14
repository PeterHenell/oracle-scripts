BEGIN
   create_file (loc_in        => 'TEMP'
              , file_in       => 'LondonCalling.txt'
              , lines_in      => 'The|Clash'
               );
   xfile.showdircontents ('TEMP', 'L%');
END;