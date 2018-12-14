CREATE TABLE FAVORITES (name VARCHAR2(100), flavor VARCHAR2(100));

BEGIN
   UPDATE 
        FAVORITES
      SET flavor = 'CHOCOLATE'
    WHERE name = 'STEVEN'; 

   UPDATE FAVORITES
      SET 
	   flavor = 'CHOCOLATE'
    WHERE 
	   name = 'STEVEN'; 
END;
/

begin

   update favorites
      set flavor = 'CHOCOLATE'
    where name = 'STEVEN'; 

   update favorites set flavor = 'CHOCOLATE' where name = 'STEVEN'; 

end;
/
