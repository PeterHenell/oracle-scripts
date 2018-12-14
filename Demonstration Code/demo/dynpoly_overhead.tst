@@food5.ot

CREATE OR REPLACE PROCEDURE show_dynpoly_overhead (count_in IN INTEGER)
IS
   msg               VARCHAR2 (32767);

   TYPE foodstuffs_nt IS TABLE OF food_t;

   fridge_contents   foodstuffs_nt
      := foodstuffs_nt (food_t ('Eggs benedict', 'PROTEIN', 'Farm')
                       ,dessert_t ('Strawberries and cream'
                                  ,'FRUIT'
                                  ,'Backyard'
                                  ,'N'
                                  ,2001
                                  )
                       ,cake_t ('Chocolate Supreme'
                               ,'CARBOHYDATE'
                               ,'Kitchen'
                               ,'Y'
                               ,2001
                               ,8
                               ,'Happy Birthday, Veva'
                               )
                       );
   just_food         foodstuffs_nt
      := foodstuffs_nt (food_t ('Eggs benedict', 'PROTEIN', 'Farm')
                       ,food_t ('Strawberries and cream', 'FRUIT', 'Backyard')
                       ,food_t ('Chocolate Supreme', 'CARBOHYDATE', 'Kitchen')
                       );
BEGIN
   sf_timer.start_timer;

   FOR iteration IN 1 .. count_in
   LOOP
      FOR indx IN fridge_contents.FIRST .. fridge_contents.LAST
      LOOP
         msg :=
                'Price of '
             || fridge_contents (indx).NAME
             || ' = '
             || fridge_contents (indx).price;
      END LOOP;
   END LOOP;

   sf_timer.show_elapsed_time ('Climb the tree to dessert');
   sf_timer.start_timer;

   FOR iteration IN 1 .. count_in
   LOOP
      FOR indx IN just_food.FIRST .. just_food.LAST
      LOOP
         msg :=
                'Price of '
             || just_food (indx).NAME
             || ' = '
             || just_food (indx).price;
      END LOOP;
   END LOOP;

   sf_timer.show_elapsed_time ('Just call food.price');
END show_dynpoly_overhead;
/

BEGIN
    show_dynpoly_overhead (100000);
END;
/    

/* 
For 10g and 100,000 iterations:
Climb the tree to dessert Elapsed: 16.8 seconds.
Just call food.price Elapsed: 9.99 seconds.

For 11g, 100,000 iterations and a faster laptop:
Climb the tree to dessert Elapsed: 2.04 seconds.
Just call food.price Elapsed: .71 seconds.
*/