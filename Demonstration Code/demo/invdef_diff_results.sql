/*
Erik van Roon sent a message using the contact form at  
http://www.stevenfeuerstein.com/contact.


Steven,


Sorry to bother you with this, but I hope you can shed some light on  
something that is a mystery to me and my coworkers.


I thought I had a reasonably good understanding on invoker rights verses  
designer rights.
This 'understanding' led me to believe that if I schema X creates a function  
in it's own schema and this function is used by schema X then there should (I  
thought) not be any difference between running with invoker or designer  
rights.
In this case the designer and the invoker are the same, are they not?


So, I created a function (see code below) in two versions. Identical, except  
for the 'authid'.
I created both in the same schema.
In the same session, right after creating these functions, I call them.
And they give different results.


The test-function is nothing fancy. It does a count for records in all_tables  
and returns the result.
I know, all_tables contents is depending on the user that does the select.
But, again, if I create a function and then straight after that I call it,  
shouldn't it be that definer = invoker?
And if so, shouldn't all_tables be used for the same user.
If not, then what schema is used in the case of definer-rights?
The only schema's that are involved are ERO (my own schema in which the test  
is run) and SYS (being the owner of all_tables).


Below you will find what I did.


Thanks in advance for any time you put into this.


Erik

*/

CREATE OR REPLACE FUNCTION ero_test_inv (p_schema IN VARCHAR2)
   RETURN INTEGER
   AUTHID CURRENT_USER
IS
   CURSOR c_tab (b_schema VARCHAR2)
   IS
      SELECT COUNT (*) table_count
        FROM all_tables
       WHERE owner LIKE b_schema;

   r_tab   c_tab%ROWTYPE;
BEGIN
   OPEN c_tab (p_schema);

   FETCH c_tab INTO r_tab;

   CLOSE c_tab;

   RETURN (r_tab.table_count);
END ero_test_inv;
/

CREATE OR REPLACE FUNCTION ero_test_def (p_schema IN VARCHAR2)
   RETURN INTEGER
   AUTHID DEFINER
IS
   CURSOR c_tab (b_schema VARCHAR2)
   IS
      SELECT COUNT (*) table_count
        FROM all_tables
       WHERE owner LIKE b_schema;

   r_tab   c_tab%ROWTYPE;
BEGIN
   OPEN c_tab (p_schema);

   FETCH c_tab INTO r_tab;

   CLOSE c_tab;

   RETURN (r_tab.table_count);
END ero_test_def;
/

SELECT ero_test_inv ('%') invoker_count FROM DUAL
/

SELECT ero_test_def ('%') definer_count FROM DUAL
/

BEGIN
   DBMS_OUTPUT.put_line ('Invoker = ' || ero_test_inv ('%'));
   DBMS_OUTPUT.put_line ('Definer = ' || ero_test_def ('%'));
END;
/