BEGIN
   conc_pkg.change_it_again ('Steven Feuerstein', 'Philosophy');
   conc_pkg.change_it_again ('Veva Feuerstein', 'English');
   conc_pkg.change_it_again ('Eli Feuerstein', 'Strategic Analysis');
   
   COMMIT;

   conc_pkg.show_changers_to ('PresidentRuntheshow');
END;
/
