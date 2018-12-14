REM Must have already run person.ot file

drop table books;
drop type book_t force;

CREATE TABLE books (title VARCHAR2(30), 
   author Person_ot /* substitutable */); 

BEGIN
   INSERT INTO books
        VALUES ('Oracle PL/SQL Programming', citizen_ot (
            'HUMAN',
            'Steven Feuerstein',
			180,
            '23-SEP-1958',
            'USA',
            'Independent'                    
         ));
END;
/
SELECT author.nation FROM Books;
SELECT TREAT(author AS citizen_ot).nation FROM Books;
