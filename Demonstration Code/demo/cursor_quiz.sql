drop table after_deforestation;

CREATE TABLE after_deforestation (
   trees_left NUMBER);
   
drop table favorites;
   
create table favorites (
   flavor VARCHAR2(100),
   name VARCHAR2(100));

drop table ceo_compensation;
   
create table ceo_compensation (
   stock_options integer,
   salary number,
   layoffs integer);
   
select count(*)  
  from after_deforestation;
  
Select COUNT(*) 
  from after_deforestation;
  
BEGIN 
   UPDATE favorites 
      SET flavor = 'CHOCOLATE'
    WHERE name = 'STEVEN'; 
END;
/

BEGIN  update favorites  set flavor = 'CHOCOLATE' where name = 'STEVEN'; END;
/

BEGIN 
   UPDATE ceo_compensation 
      SET stock_options = 1000000,
       salary = salary * 2.0
    WHERE layoffs > 10000;
END;
/

BEGIN 
   update ceo_compensation 
      set stock_options = 1000000,
          salary = salary * 2
    where layoffs > 10000;
END;
/
    
SELECT COUNT (*)
  FROM v$sqlarea
 WHERE (   INSTR (LOWER (sql_text), 'deforestation') > 0
        OR INSTR (LOWER (sql_text), 'favorites') > 0
        OR INSTR (LOWER (sql_text), 'ceo_comp') > 0
       )
   AND INSTR (sql_text, 'v$sqlarea') = 0;


SELECT   sql_text
    FROM v$sqlarea
   WHERE (   INSTR (LOWER (sql_text), 'deforestation') > 0
          OR INSTR (LOWER (sql_text), 'favorites') > 0
          OR INSTR (LOWER (sql_text), 'ceo_comp') > 0
         )
     AND INSTR (sql_text, 'v$sqlarea') = 0
ORDER BY UPPER (sql_text);

  
    
  
  
