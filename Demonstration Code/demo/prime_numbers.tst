BEGIN
   /*qd_runtime.pl ( MOD ( 17, 2 ));
   qd_runtime.pl ( prime_numbers.is_prime ( 2 ));
   qd_runtime.pl ( prime_numbers.is_prime ( 5 ));
   qd_runtime.pl ( prime_numbers.is_prime ( 17 ));
   qd_runtime.pl ( prime_numbers.is_prime ( 27 ));
   prime_numbers.show_primes ( prefix_in      => 'my_prime($prime) := '
                             , suffix_in      => ';'
                             );*/
   prime_numbers.show_primes
                      ( prefix_in      => 'intval_insert ( ''$prime - a prime number'', '''
                      , suffix_in      => ''', is_expression_in => qu_config.c_no);'
                      );
END;
