/* Build the stolen lives table for New York */
CONNECT newyork/newyork

DROP TABLE stolen_life;

CREATE TABLE stolen_life (
   dod DATE,
   ethnicity VARCHAR2(100),
   victim VARCHAR2(100),
   age NUMBER,
   description VARCHAR2(2000)
   );

INSERT INTO stolen_life (dod, ethnicity, victim, age, description) VALUES (
   '04-FEB-99', 'West African', 'Amadou Diallo', 22,
   'Shot 19 times by four police officers outside his Bronx apartment. Diallo was a devout Muslim working 12 hour days selling CDs and tapes to earn money to finish his bachelor''s degree. He was unarmed.');

INSERT INTO stolen_life (dod, ethnicity, victim, age, description) VALUES (
   '04-AUG-98', 'Puerto Rican', 'Freddie Rivera', 17,
   'Shot in the chest with dum-dum bullets and killed by an unidentified cop. The cop did not identify himself or yell Freeze!, Police!, Put your hands in the air!, or any such thing. His family described him as a bright kid, always looking forward to the future, who was about to start college in September.');

INSERT INTO stolen_life (dod, ethnicity, victim, age, description) VALUES (
   '24-APR-97', 'Latina', 'Sherly Colon', 33,
   'Sherly was pushed off the roof of the Clinton Houses, a housing project in East Harlem, by the police. She landed in a playground outside the building; witnesses said the police threw a sheet over her body and then removed handcuffs from behind her back; the cops claim they were removing her bracelets. Police claim she committed suicide by jumping, but neighbors and her mother do not believe this. There were several protest marches from the Clinton Houses to the 23rd Precinct in the week after Sherly was killed. She left behind two children, ages 5 and 14. Sherly was a community leader, well-known, well-liked, and respcted in the community.');

INSERT INTO stolen_life (dod, ethnicity, victim, age, description) VALUES (
   '31-JUL-98', 'NOT KNOWN', 'Christopher T. Johnson', 29,
   'Suffolk County Police Officers Robert A. McGee, Jr., and Samuel Barretto spotted Chistopher, who was wanted on charges of driving without a license (a misdemeanor), on Provost Avenue. The cops stepped out of their car and tried to arrest him at 9:43pm; Chris fled into the woods, and the officers chased after him, according to the police. He was sprayed with pepper Mace while being arrested, handcuffed, and brought out of the woods. He died as he was being transported to Brookhaven Memorial Hospital for treatment for the pepper Mace. Chris was an automobile mechanic, a married man with three children ranging in age from 15 months to 13 years. His family said he had no history of repiratory or other medical problems. His lawyer said, Mr. Johnson was not a rapist or a murderer, or anything of that nature. His only crime was using his car to get back and forth to work and getting food for his family. The police are investigating. The family said they would probably seek an independent autopsy.');

COMMIT;
