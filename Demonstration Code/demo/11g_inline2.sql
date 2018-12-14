DECLARE
   v_loops   NUMBER := 100000000;

   v_start   NUMBER;

   v_sum     NUMBER;

   FUNCTION add_numbers (p_1 IN NUMBER, p_2 IN NUMBER)
      RETURN NUMBER
   AS
   BEGIN
      RETURN p_1 + p_2;
   END add_numbers;
BEGIN
   v_start := DBMS_UTILITY.get_time;

   FOR i IN 1 .. v_loops
   LOOP
      PRAGMA INLINE (add_numbers, 'NO');

      v_sum := add_numbers (1, i);
   END LOOP;

   DBMS_OUTPUT.put_line (
         'Elapsed Time: '
      || (DBMS_UTILITY.get_time - v_start)
      || ' Hundredths of a Second');
END;
/

DECLARE
   v_loops   NUMBER := 100000000;

   v_start   NUMBER;

   v_sum     NUMBER;

   FUNCTION add_numbers (p_1 IN NUMBER, p_2 IN NUMBER)
      RETURN NUMBER
   AS
   BEGIN
      RETURN p_1 + p_2;
   END add_numbers;
BEGIN
   v_start := DBMS_UTILITY.get_time;

   FOR i IN 1 .. v_loops
   LOOP
      PRAGMA INLINE (add_numbers, 'YES');

      v_sum := add_numbers (1, i);
   END LOOP;

   DBMS_OUTPUT.put_line (
         'Elapsed Time: '
      || (DBMS_UTILITY.get_time - v_start)
      || ' Hundredths of a Second');
END;
/

/*

First timing without inlining, second with inlining.

10,000,000 iterations

Elapsed Time: 214 Hundredths of a Second
Elapsed Time: 94 Hundredths of a Second

100,000,000 iterations

Elapsed Time: 2075 Hundredths of a Second
Elapsed Time: 950 Hundredths of a Second
*/