DECLARE
   l_clob1   CLOB := 'abc';
   l_clob2   CLOB := 'def';
BEGIN
   qu_runtime.pl (DBMS_LOB.compare (l_clob1, l_clob1, 3, 1, 1));
   qu_runtime.pl (DBMS_LOB.compare (l_clob1, l_clob2, 3, 1, 1));
   qu_runtime.pl (DBMS_LOB.compare (l_clob2, l_clob1, 3, 1, 1));
END;
/

DECLARE
   l_clob1_first64k_same   CLOB;
   l_clob2_first64k_same   CLOB;

   PROCEDURE bpl (val IN BOOLEAN)
   IS
   BEGIN
      IF val
      THEN
         DBMS_OUTPUT.put_line ('TRUE');
      ELSIF NOT val
      THEN
         DBMS_OUTPUT.put_line ('FALSE');
      ELSE
         DBMS_OUTPUT.put_line ('NULL');
      END IF;
   END bpl;
BEGIN
   l_clob1_first64k_same := RPAD ('abc', 32767, 'def');
   DBMS_LOB.writeappend (l_clob1_first64k_same
                       , 32767
                       , RPAD ('abc', 32767, 'def')
                        );
   l_clob2_first64k_same := l_clob1_first64k_same;
   -- Now make them different
   DBMS_LOB.writeappend (l_clob1_first64k_same
                       , 32767
                       , RPAD ('def', 32767, '123')
                        );
   DBMS_LOB.writeappend (l_clob1_first64k_same
                       , 32767
                       , RPAD ('xyz', 32767, '456')
                        );
   DBMS_LOB.writeappend (l_clob2_first64k_same
                       , 32767
                       , RPAD ('def', 32767, '777')
                        );
   DBMS_LOB.writeappend (l_clob2_first64k_same
                       , 32767
                       , RPAD ('xyz', 32767, 'xxx')
                        );

   DBMS_OUTPUT.put_line(DBMS_LOB.compare (
                           l_clob1_first64k_same
                         , l_clob2_first64k_same
                         , DBMS_LOB.getlength (l_clob1_first64k_same)
                         , 1
                         , 1
                        ));

   bpl (l_clob1_first64k_same = l_clob2_first64k_same);
END;