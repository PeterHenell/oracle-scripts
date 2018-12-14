CREATE OR REPLACE PROCEDURE order_seeds (
   food_in   IN   food_t
)
IS
BEGIN
   p.l (food_in.grown_in);
END;
/

DECLARE
   my_favorite_vegetable   food_t
      := food_t (
            'Brussel Sprouts',
            'VEGETABLE',
            'Farm,Greenhouse,Backyard'
         );
BEGIN
   DBMS_OUTPUT.put_line (
      my_favorite_vegetable.NAME
   );
   my_favorite_vegetable.food_group :=
                                   'SATISFACTION';

   IF INSTR (
         my_favorite_vegetable.grown_in,
         'yard'
      ) > 0
   THEN
      order_seeds (my_favorite_vegetable);
   END IF;
END;
/

