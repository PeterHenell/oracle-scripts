DECLARE
   obj layaway_t;
BEGIN
   layaway.make_payment ('Eli', 'Unicorn', 10);

   layaway.make_payment ('Steven', 'Dragon', 5);

   layaway.make_payment ('Veva', 'Sun Conure', 12);

   layaway.make_payment ('Chris', 'Big Fat Cat', 8);

   layaway.display;

   obj := layaway.one_animal ('Veva', 'Sun Conure');

   DBMS_OUTPUT.PUT_LINE ('** Retrieved ' || obj.animal);
END;
/