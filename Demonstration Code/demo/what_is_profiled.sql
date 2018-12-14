/* 
   This code is used to determine what lines of code are ignored
   by the PL/SQL profilers. This information is needed in order to
   calculate code coverage.
   
   WARNING: DO NOT AUTO-FORMAT! 

   Line feeds are deliberately inserted into this code for purposes
   of the above anlysis.
*/

CREATE OR REPLACE PROCEDURE show_lines_profiled
/*
Assumptions: the ONLY data inside the profiler tables are for a single
run of what_is_profiled.driver
*/
IS
   l_type varchar2( 10000 );
BEGIN
   DBMS_OUTPUT.put_line( 'Profiling Report' );
   DBMS_OUTPUT.put_line( '  NOT PROFILED = No profile data for this line' );
   DBMS_OUTPUT.put_line( '  ZERO RUNS    = Profiled, but TOTAL_OCCURS = 0' );
   DBMS_OUTPUT.put_line( '  LINE RUN     = This line was executed at least once' );

   DBMS_OUTPUT.put_line( 'Profile Info   Line Source');
   DBMS_OUTPUT.put_line( '============== ==== ==============================================================');

   FOR rec
   IN (  SELECT line, text
           FROM all_source als
          WHERE     als.owner = USER
                AND als.name = 'WHAT_IS_PROFILED'
                AND als.TYPE = 'PACKAGE BODY'
       ORDER BY line )
   LOOP
      BEGIN
         SELECT CASE
                   WHEN total_occur = 0 THEN 'ZERO RUNS'
                   ELSE 'LINE RUN'
                END
                   profile_type
           INTO l_type
           FROM plsql_profiler_data ppd
          WHERE ppd.line# = rec.line AND ppd.unit_number = 2;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_type      := 'NOT PROFILED';
      END;



      DBMS_OUTPUT.put_line(   RPAD( l_type, 15 )
                           || LPAD( rec.line, 4 )
                           || ' '
                           || rtrim (rec.text, chr(10)));
   END LOOP;
END show_lines_profiled;
/


CREATE OR REPLACE PACKAGE what_is_profiled
IS
   TYPE aa1 IS TABLE OF VARCHAR2 (100)
      INDEX BY PLS_INTEGER;

   TYPE aa2 IS TABLE OF VARCHAR2 (100)
      INDEX BY PLS_INTEGER;

   PROCEDURE proc1 (arg IN NUMBER, arg2 OUT VARCHAR2);

   FUNCTION func1
      RETURN VARCHAR2;
      
      procedure driver ;
END what_is_profiled;
/

CREATE OR REPLACE PACKAGE BODY what_is_profiled
IS
   TYPE p_aa1 IS TABLE OF VARCHAR2 (100)
      INDEX BY PLS_INTEGER;

   TYPE p_aa2 IS TABLE OF VARCHAR2 (100)
      INDEX BY PLS_INTEGER;

   PROCEDURE loops (arg IN NUMBER, arg2 OUT VARCHAR2)
   IS
      val
      INTEGER;
      condition1 boolean := true;
      condition2 boolean 
      := 
      true;
      
   BEGIN
      FOR indx IN 1 .. 100
      LOOP
         NULL;
      END LOOP;
            
      FOR 
      indx 
      IN 
      1 
      .. 
      100
      LOOP
         val := 1;
      END 
      LOOP; 
      
      FOR indx IN 1 .. 100 LOOP NULL; END LOOP;      

      FOR rec IN (SELECT *
                    FROM all_source
                   WHERE ROWNUM < 101)
      LOOP
         val := 1;
      END LOOP;

      FOR 
      rec 
      IN 
      (
      SELECT *
                    FROM all_source
                   WHERE ROWNUM < 101
      )
      LOOP
         val := 1;
      END 
      LOOP;
      
      WHILE (condition1 AND condition2)
      LOOP
         condition1 := FALSE;
      END LOOP;

      WHILE 
      (
      condition1 
      AND 
      condition2
      )
      LOOP
         condition1 
         := 
         FALSE
         ;
      END LOOP;
      
      DECLARE
         indx   INTEGER := 1;
      BEGIN
         LOOP
            EXIT WHEN indx > 100;
            indx := indx + 1;
         END LOOP;
      END;
      
      DECLARE
         indx   INTEGER := 1;
      BEGIN
         LOOP
            EXIT 
            WHEN 
            indx 
            > 
            100;
            indx := indx + 
            1
            ;
         END LOOP;
      END;      
   END;

   PROCEDURE conditionals 
   IS
   a 
   boolean;
   b boolean;
   c boolean
   ;
   BEGIN
      IF (a AND b OR c)
      THEN
         NULL;
         elsif
         a
         then
         null;
         else
         dbms_output.put_line ('a');
      END IF;
      
      a := case
      true
      when true
      then
      false
      when 
      false then
      true
      else
      false
      end
      ;
      a := case true
      when true
      then
      false
      when 
      false then
      true
      else
      false
      end
      ;  
      
      case when 
      sysdate > sysdate + 1
      then
      a := false;
      when 1 > 2 then
      b := false;
      when 1
      > 2   
      then
      c := false;
      else null; end case; 
   END;

   FUNCTION p_func1
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN NULL;
   END;

   PROCEDURE proc1 (arg IN NUMBER, arg2 OUT VARCHAR2)
   IS
   BEGIN
      NULL;
   END;

   FUNCTION func1
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN p_func1;
   END;
   
   procedure driver is
   l varchar2(100);
   begin
   loops(1, l);
   conditionals;
   proc1
   (
   1
   ,
   l);
   GOTO checkloop;
   <<CHECKLOOP>>
   dbms_output.put_line ('a');
   end;
END what_is_profiled;
/

BEGIN
   DELETE FROM plsql_profiler_data;

   DELETE FROM plsql_profiler_units;

   DELETE FROM plsql_profiler_runs;

   DBMS_OUTPUT.put_line(
                         DBMS_PROFILER.start_profiler( 'What is profiled?' )
   );
   what_is_profiled.driver( );
   DBMS_PROFILER.stop_profiler;
   --
   show_lines_profiled();
END;
/

/* OUTPUT ON 11g

NOT PROFILED      1 PACKAGE BODY what_is_profiled
NOT PROFILED      2 IS
NOT PROFILED      3    TYPE p_aa1 IS TABLE OF VARCHAR2 (100)
NOT PROFILED      4       INDEX BY PLS_INTEGER;
NOT PROFILED      5 
NOT PROFILED      6    TYPE p_aa2 IS TABLE OF VARCHAR2 (100)
NOT PROFILED      7       INDEX BY PLS_INTEGER;
NOT PROFILED      8 
ZERO RUNS         9    PROCEDURE loops (arg IN NUMBER, arg2 OUT VARCHAR2)
NOT PROFILED     10    IS
NOT PROFILED     11       val
NOT PROFILED     12       INTEGER;
LINE RUN         13       condition1 boolean := true;
LINE RUN         14       condition2 boolean 
NOT PROFILED     15       := 
NOT PROFILED     16       true;
NOT PROFILED     17       
NOT PROFILED     18    BEGIN
LINE RUN         19       FOR indx IN 1 .. 100
NOT PROFILED     20       LOOP
LINE RUN         21          NULL;
NOT PROFILED     22       END LOOP;
NOT PROFILED     23             
LINE RUN         24       FOR 
NOT PROFILED     25       indx 
NOT PROFILED     26       IN 
NOT PROFILED     27       1 
NOT PROFILED     28       .. 
NOT PROFILED     29       100
NOT PROFILED     30       LOOP
LINE RUN         31          val := 1;
NOT PROFILED     32       END 
NOT PROFILED     33       LOOP; 
NOT PROFILED     34       
LINE RUN         35       FOR indx IN 1 .. 100 LOOP NULL; END LOOP;      
NOT PROFILED     36 
LINE RUN         37       FOR rec IN (SELECT *
NOT PROFILED     38                     FROM all_source
NOT PROFILED     39                    WHERE ROWNUM < 101)
NOT PROFILED     40       LOOP
LINE RUN         41          val := 1;
NOT PROFILED     42       END LOOP;
NOT PROFILED     43 
LINE RUN         44       FOR 
NOT PROFILED     45       rec 
NOT PROFILED     46       IN 
NOT PROFILED     47       (
ZERO RUNS        48       SELECT *
NOT PROFILED     49                     FROM all_source
NOT PROFILED     50                    WHERE ROWNUM < 101
NOT PROFILED     51       )
NOT PROFILED     52       LOOP
LINE RUN         53          val := 1;
NOT PROFILED     54       END 
NOT PROFILED     55       LOOP;
NOT PROFILED     56       
LINE RUN         57       WHILE (condition1 AND condition2)
NOT PROFILED     58       LOOP
NOT PROFILED     59          condition1 := FALSE;
NOT PROFILED     60       END LOOP;
NOT PROFILED     61 
NOT PROFILED     62       WHILE 
NOT PROFILED     63       (
NOT PROFILED     64       condition1 
NOT PROFILED     65       AND 
NOT PROFILED     66       condition2
NOT PROFILED     67       )
NOT PROFILED     68       LOOP
NOT PROFILED     69          condition1 
NOT PROFILED     70          := 
NOT PROFILED     71          FALSE
NOT PROFILED     72          ;
NOT PROFILED     73       END LOOP;
NOT PROFILED     74       
NOT PROFILED     75       DECLARE
LINE RUN         76          indx   INTEGER := 1;
NOT PROFILED     77       BEGIN
LINE RUN         78          LOOP
LINE RUN         79             EXIT WHEN indx > 100;
LINE RUN         80             indx := indx + 1;
NOT PROFILED     81          END LOOP;
NOT PROFILED     82       END;
NOT PROFILED     83       
NOT PROFILED     84       DECLARE
LINE RUN         85          indx   INTEGER := 1;
NOT PROFILED     86       BEGIN
LINE RUN         87          LOOP
LINE RUN         88             EXIT 
NOT PROFILED     89             WHEN 
NOT PROFILED     90             indx 
NOT PROFILED     91             > 
NOT PROFILED     92             100;
LINE RUN         93             indx := indx + 
NOT PROFILED     94             1
NOT PROFILED     95             ;
NOT PROFILED     96          END LOOP;
NOT PROFILED     97       END;      
LINE RUN         98    END;
NOT PROFILED     99 
ZERO RUNS       100    PROCEDURE conditionals 
NOT PROFILED    101    IS
NOT PROFILED    102    a 
NOT PROFILED    103    boolean;
NOT PROFILED    104    b boolean;
NOT PROFILED    105    c boolean
NOT PROFILED    106    ;
NOT PROFILED    107    BEGIN
LINE RUN        108       IF (a AND b OR c)
NOT PROFILED    109       THEN
NOT PROFILED    110          NULL;
NOT PROFILED    111          elsif
LINE RUN        112          a
NOT PROFILED    113          then
NOT PROFILED    114          null;
NOT PROFILED    115          else
LINE RUN        116          dbms_output.put_line ('a');
NOT PROFILED    117       END IF;
NOT PROFILED    118       
LINE RUN        119       a := case
NOT PROFILED    120       true
NOT PROFILED    121       when true
NOT PROFILED    122       then
NOT PROFILED    123       false
NOT PROFILED    124       when 
NOT PROFILED    125       false then
NOT PROFILED    126       true
NOT PROFILED    127       else
NOT PROFILED    128       false
NOT PROFILED    129       end
NOT PROFILED    130       ;
LINE RUN        131       a := case true
NOT PROFILED    132       when true
NOT PROFILED    133       then
NOT PROFILED    134       false
NOT PROFILED    135       when 
NOT PROFILED    136       false then
NOT PROFILED    137       true
NOT PROFILED    138       else
NOT PROFILED    139       false
NOT PROFILED    140       end
NOT PROFILED    141       ;  
NOT PROFILED    142       
LINE RUN        143       case when 
NOT PROFILED    144       sysdate > sysdate + 1
NOT PROFILED    145       then
LINE RUN        146       a := false;
NOT PROFILED    147       when 1 > 2 then
NOT PROFILED    148       b := false;
NOT PROFILED    149       when 1
NOT PROFILED    150       > 2   
NOT PROFILED    151       then
NOT PROFILED    152       c := false;
NOT PROFILED    153       else null; end case; 
NOT PROFILED    154    END;
NOT PROFILED    155 
ZERO RUNS       156    FUNCTION p_func1
NOT PROFILED    157       RETURN VARCHAR2
NOT PROFILED    158    IS
NOT PROFILED    159    BEGIN
ZERO RUNS       160       RETURN NULL;
ZERO RUNS       161    END;
NOT PROFILED    162 
ZERO RUNS       163    PROCEDURE proc1 (arg IN NUMBER, arg2 OUT VARCHAR2)
NOT PROFILED    164    IS
NOT PROFILED    165    BEGIN
LINE RUN        166       NULL;
NOT PROFILED    167    END;
NOT PROFILED    168 
ZERO RUNS       169    FUNCTION func1
NOT PROFILED    170       RETURN VARCHAR2
NOT PROFILED    171    IS
NOT PROFILED    172    BEGIN
ZERO RUNS       173       RETURN p_func1;
ZERO RUNS       174    END;
NOT PROFILED    175    
ZERO RUNS       176    procedure driver is
NOT PROFILED    177    l varchar2(100);
NOT PROFILED    178    begin
LINE RUN        179    loops(1, l);
LINE RUN        180    conditionals;
LINE RUN        181    proc1
NOT PROFILED    182    (
NOT PROFILED    183    1
NOT PROFILED    184    ,
NOT PROFILED    185    l);
LINE RUN        186    GOTO checkloop;
NOT PROFILED    187    <<CHECKLOOP>>
LINE RUN        188    dbms_output.put_line ('a');
LINE RUN        189    end;
NOT PROFILED    190 END what_is_profiled;

*/
