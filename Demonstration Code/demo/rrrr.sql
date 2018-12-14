begin
   p.l ('1999 99 RRRR');
   p.l(to_date ('12-01-1999', 'DD-MM-RRRR'));
   p.l(to_date ('12-01-99', 'DD-MM-RRRR'));
   
   p.l ('2009 09 RRRR');
   p.l(to_date ('12-01-2009', 'DD-MM-RRRR'));
   p.l(to_date ('12-01-09', 'DD-MM-RRRR'));
   
   p.l ('1999 99 YYYY');
   p.l(to_date ('12-01-1999', 'DD-MM-YYYY'));
   p.l(to_date ('12-01-99', 'DD-MM-YY'));

   p.l ('2009 09 YYYY');
   p.l(to_date ('12-01-2009', 'DD-MM-YYYY'));
   p.l(to_date ('12-01-09', 'DD-MM-YY'));
   
end;
/   
