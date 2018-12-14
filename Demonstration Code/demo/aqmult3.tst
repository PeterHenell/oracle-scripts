DECLARE
   prez VARCHAR2(100) := 'PresidentRuntheshow';
   counselor VARCHAR2(100) := 'CounselorTwocents';
   psych_dr VARCHAR2(100) := 'DoctorBaddreams';
   ethics_prof VARCHAR2(100) := 'ProfessorWhatswrong';
BEGIN
   conc_pkg.change_it_again ('Steven Feuerstein', conc_pkg.c_philosophy);
   conc_pkg.change_it_again ('Veva Feuerstein', 'English');
   
   COMMIT;

   conc_pkg.show_changers_to (prez);
   conc_pkg.show_changers_to (psych_dr);

   conc_pkg.change_it_again ('Steven Feuerstein', conc_pkg.c_business);
   conc_pkg.change_it_again ('Veva Feuerstein', conc_pkg.c_philosophy);
   
   COMMIT;

   conc_pkg.show_changers_to (counselor);
   conc_pkg.show_changers_to (ethics_prof);
   conc_pkg.show_changers_to (psych_dr);
END;
/
