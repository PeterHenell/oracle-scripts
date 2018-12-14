---To my Sir & Great Programming teacher of All Times, Steven Feuerstein
---In my situation i had a gape free primary key of 4 digits so max Numaric value could be 9999. it became insufficent. remaining with in 4 digits i
---created a gape free alpha numaric sequence of limit more then 14,500,000.
---for gape free i had to use my sequence table to hold last values of Alpha digit & Numaric Digit. and i made a Package to get Next AlphaNumaric Sequence.
---my package is not written as clean as it should be. sorry for that Sir.

CREATE TABLE sequence_tbl
(
   seq_name        VARCHAR2 (25),
   seq_maxval      NUMBER (10),
   seq_inc_by      NUMBER (5),
   is_cycle_auto   VARCHAR2 (1),
   seq_nextval     NUMBER (10),
   is_alpha        VARCHAR2 (1),
   seq_nextchar    VARCHAR2 (10)
)
/

INSERT INTO sequence_tbl (seq_name,
                          seq_maxval,
                          seq_inc_by,
                          is_cycle_auto,
                          seq_nextval,
                          is_alpha,
                          seq_nextchar)
     VALUES ('LABSEQ',
             999,
             1,
             'Y',
             1,
             'Y',
             'A')
/

CREATE OR REPLACE PACKAGE gen_sequence
IS
   -- Author  : Fahd Bahoo
   -- Created : 9/13/2013 10:28:25 AM
   -- Purpose : to generate gape free Alpha Numaric Digits Remaining with in 4 Digits. combinations of digits will be more then 14,500,000.
   -- starting from A001..A999, B001..B999, Z001..Z999, AA01..ZZ99, AAA1..ZZZ9, AAAA..AAAZ TO small zzzz "zzzz" will be last Alpha Numaric number.
   -- above "zzzz" is not acomodated by me. going above zzzz will be on your own.

   FUNCTION return_dec_val (num_in VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION next_val_alpha (seq_name_in VARCHAR2)
      RETURN VARCHAR2;
END gen_sequence;
/

CREATE OR REPLACE PACKAGE BODY gen_sequence
IS
   FUNCTION return_dec_val (num_in VARCHAR2)
      RETURN VARCHAR2
   IS
      vstring   CONSTANT VARCHAR2 (70)
         := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' ;
      vmaxchar           NUMBER := 52;
      vfirst             VARCHAR2 (2) := 'A';
      vlast              VARCHAR2 (2) := 'z';
      vok                BOOLEAN := TRUE;
      vctr               NUMBER := 0;
      vnum               VARCHAR2 (10);
      vnumnext           VARCHAR2 (5);
      vnumbefore         VARCHAR2 (5);

      FUNCTION nextchar (vchar_in VARCHAR2)
         RETURN VARCHAR2
      IS
         vnext   VARCHAR2 (5);
         vloc    VARCHAR2 (15);
      BEGIN
         vloc := INSTR (vstring, vchar_in);

         IF vloc = vmaxchar
         THEN
            vnext := SUBSTR (vstring, 1, 1);
         ELSE
            vnext := SUBSTR (vstring, vloc + 1, 1);
         END IF;

         RETURN vnext;
      END nextchar;
   BEGIN
      vnum := num_in;

      -- Do
      WHILE vok AND vctr <> LENGTH (vnum)
      LOOP
         vctr := vctr + 1;

         IF SUBSTR (vnum, vctr, 1) <> '0'
         THEN
            vok := FALSE;
         END IF;
      END LOOP;

      vok := TRUE;
      vctr := LENGTH (vnum);

      WHILE vok
      LOOP
         vnumbefore := SUBSTR (vnum, vctr, 1);

         vnumnext := SUBSTR (vnum, vctr, 1);
         vnumnext := nextchar (vnumnext);

         vnum :=
               SUBSTR (vnum, 1, vctr - 1)
            || vnumnext
            || SUBSTR (vnum, vctr + 1, LENGTH (vnum));

         IF vnumbefore <> 'z'
         THEN
            vok := FALSE;
         END IF;

         vctr := vctr - 1;

         IF vctr = 0
         THEN
            vok := FALSE;
         END IF;
      END LOOP;

      CASE TRIM (num_in)
         WHEN 'z'
         THEN
            vnum := 'AA';
         WHEN 'zz'
         THEN
            vnum := 'AAA';
         WHEN 'zzz'
         THEN
            vnum := 'AAAA';
         ELSE
            NULL;
      END CASE;

      RETURN vnum;
   END return_dec_val;

   PROCEDURE reset_seq (seq_name_in VARCHAR2)
   IS
      l_seq_nextchar   VARCHAR2 (4);
      l_max_seq        NUMBER;
      l_asc            NUMBER;
      first_c          CHAR (1);
      second_c         CHAR (1);
      l_asc1           NUMBER;
      third_c          CHAR (1);
      l_asc2           NUMBER;
   BEGIN
      UPDATE sequence_tbl t
         SET t.seq_nextval = 0,
             t.seq_nextchar = return_dec_val (t.seq_nextchar),
             t.seq_maxval =
                DECODE (
                   LENGTH (return_dec_val (t.seq_nextchar)),
                   4, 0,
                   3, 9,
                   2, 99,
                   1, 999,
                   999) --i want to remain within 4 digits therefore adjust max length of numaric digit. like for AA max numric shout be 99 & for AAA should be 9
       WHERE t.seq_name = seq_name_in;
   END reset_seq;

   FUNCTION next_val_alpha (seq_name_in VARCHAR2)
      RETURN VARCHAR2
   IS
      l_seq_no              NUMBER;
      l_iscycle             CHAR (1);
      l_isalpha             CHAR (1);
      l_seq_nextchar        VARCHAR2 (4);
      l_seq_maxval          NUMBER;
      l_alpha_numaric_seq   VARCHAR2 (20);
   BEGIN
         UPDATE sequence_tbl t
            SET t.seq_nextval = t.seq_nextval + t.seq_inc_by
          WHERE t.seq_name = seq_name_in
      RETURNING t.seq_nextval,
                t.is_cycle_auto,
                t.seq_maxval,
                t.seq_nextchar
           INTO l_seq_no,
                l_iscycle,
                l_seq_maxval,
                l_seq_nextchar;

      --  dbms_output.put_line(L_seq_maxval) ;
      IF     l_iscycle = 'Y'
         AND (l_seq_no = l_seq_maxval OR l_seq_maxval = 0)
      THEN
         reset_seq (seq_name_in);
      END IF;

      IF l_seq_maxval = 0
      THEN
         l_alpha_numaric_seq := l_seq_nextchar;
      ELSE
         l_alpha_numaric_seq :=
               l_seq_nextchar
            || LPAD (TO_CHAR (l_seq_no),
                     LENGTH (l_seq_maxval),
                     '0');
      END IF;

      RETURN (l_alpha_numaric_seq);
   EXCEPTION
      WHEN OTHERS
      THEN
         ----log Error
         RAISE;
   END next_val_alpha;
END gen_sequence;
/

-----Test Case-----

BEGIN
   FOR i IN 1 .. 1000
   LOOP
      DBMS_OUTPUT.put_line (
         gen_sequence.next_val_alpha ('LABSEQ'));
   END LOOP;

   COMMIT;
END;
/