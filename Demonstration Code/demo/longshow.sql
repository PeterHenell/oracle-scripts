/* Formatted on 2001/11/01 07:43 (Formatter Plus v4.5.2) */
DECLARE
   my_text   VARCHAR2 (2000)
   := 'Now you are all undoubtedly thinking: "This fellow certainly has a big ego, doesn''t he?" And while that is undoubtedly true, I tell you these things precisely because I have been somewhat baffled and embarrassed by them. Take, for example, the declaration of my book as the best a person has ever read on programming. That stunned me, because I happen to know that I am not a computer scientist. I have very little formal programming education. In fact, I took just 3 computer classes in college, and they were all "101" courses in Algol, Pascal and Lisp. I can still recall an elaborate program I wrote to implement the game of Yahtzee, a game involving 5 die. It was not only a whole lot of fun, but it also foreshadowed my future career in software. You see, I didn''t just let a person play the game, I implemented a "help module" that would give advice to a user on what their next move should be to optimize their score. That was hard to do, but it was an awful lot of fun - and as I look back on the last six years, I have come to understand that this eagerness to give advice has permeated my books and, it seems, made them very useful to other developers.';
BEGIN
   BEGIN
      DBMS_OUTPUT.put_line (my_text);
   EXCEPTION
      WHEN OTHERS
      THEN
         p.l (SQLERRM);
   END;

   p.l (my_text);
END;
/

