create table after_deforestation (name varchar2(100), dummy date);

create table ceo_compensation (
   name varchar2(100), stock_options number, 
   salary number, layoffs number);
	
SELECT COUNT(*) 
  FROM after_deforestation WHERE name = 'STEVEN';

select count(*) 
  from after_deforestation WHERE name = 'STEVEN';

BEGIN
   UPDATE favorites
      SET flavor = 'CHOCOLATE'
    WHERE name = 'STEVEN'; 
END;
/

BEGIN
   update favorites
      set flavor = 'CHOCOLATE'
    where name = 'STEVEN'; 
END;
/

BEGIN
   UPDATE ceo_compensation 
      SET stock_options = 1000000,
       salary = salary * 2.0
    WHERE layoffs > 10000 AND name = 'STEVEN';
END;
/

BEGIN
   update ceo_compensation 
      set stock_options = 1000000,
          salary = salary * 2
    where layoffs > 10000 AND name = 'STEVEN';
END;
/


