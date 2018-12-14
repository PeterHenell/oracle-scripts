CREATE OR REPLACE PACKAGE lets_make_a_deal 
AS
   CURSOR door_number_one 
   IS
      SELECT useless_information
        FROM consumer_products
       WHERE the_price = 'YOUR BEST GUESS';

   PROCEDURE open_door_number_two;
   
   PROCEDURE open_door_number_three;
    
END lets_make_a_deal;
/
CREATE OR REPLACE PACKAGE BODY lets_make_a_deal 
AS
  CURSOR door_number_two 
  IS
     SELECT useless_information
       FROM consumer_products
      WHERE the_price = 'YOUR BEST GUESS';

  PROCEDURE open_door_number_two
  IS
  BEGIN
     OPEN door_number_two;
  END;

  PROCEDURE open_door_number_three
  IS
     CURSOR door_number_three 
     IS
        SELECT useless_information
          FROM consumer_products
         WHERE the_price = 'YOUR BEST GUESS';
  BEGIN
     OPEN door_number_three;
  END;
END lets_make_a_deal;
/
DECLARE
   CURSOR door_number_four 
   IS
      SELECT useless_information
        FROM consumer_products
       WHERE the_price = 'YOUR BEST GUESS';
BEGIN
   OPEN lets_make_a_deal.door_number_one;
   lets_make_a_deal.door_number_two;
   lets_make_a_deal.door_number_three;
   OPEN door_number_four;
END;
/   
