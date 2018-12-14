DECLARE
   l_number          NUMBER := 1;
   l_binary_float1    BINARY_FLOAT := 1;
   l_binary_float2    BINARY_FLOAT := 1;
   l_binary_double1   BINARY_DOUBLE := 1;
   l_binary_double2   BINARY_DOUBLE := 1;
   l_iterations      NUMBER := 10000000;
   l_start           NUMBER;
BEGIN
   sf_timer.start_timer;

   FOR i IN 1 .. l_iterations
   LOOP
      l_number := l_number + l_number;
   END LOOP;

   sf_timer.show_elapsed_time ('Number');

   FOR i IN 1 .. l_iterations
   LOOP
      l_binary_float1 := l_binary_float1 + l_binary_float2;
   END LOOP;

   sf_timer.show_elapsed_time ('Binary Float');

   FOR i IN 1 .. l_iterations
   LOOP
      l_binary_double1 := l_binary_double1 + l_binary_double2;
   END LOOP;

   sf_timer.show_elapsed_time ('Binary Double');
END;
/

/*
11.2
"Number" completed in: .39 seconds
"Binary Float" completed in: .25 seconds
"Binary Double" completed in: .31 seconds
*/