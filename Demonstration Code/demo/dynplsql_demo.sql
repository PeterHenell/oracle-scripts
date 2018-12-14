-- BEFORE

CREATE TABLE base_table (ID NUMBER PRIMARY KEY, name VARCHAR2(100))
/

CREATE OR REPLACE PROCEDURE bc_test
IS
   TYPE numtab IS TABLE OF NUMBER;

   primary_keys numtab;

   CURSOR c1
   IS
      SELECT ID AS icn
        FROM base_table;
BEGIN
   OPEN c1;

   FETCH c1
   BULK COLLECT INTO primary_keys;

   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'PROVIDERS'
                  , pm_eval.pm_eval_providers ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'AGE'
                  , pm_eval.pm_eval_age ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'LITIGATION'
                  , pm_eval.pm_eval_litig_lowes ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'BODYPART'
                  , pm_eval.pm_eval_bodypart ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'CAUSE'
                  , pm_eval.pm_eval_cause ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'FACILITY'
                  , pm_eval.pm_eval_facility ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'GENDER'
                  , pm_eval.pm_eval_gender ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'INJURY'
                  , pm_eval.pm_eval_injury ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'JOBTITLE'
                  , pm_eval.pm_eval_jobtitle ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'JURIS STATE'
                  , pm_eval.pm_eval_juris ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'LOE'
                  , pm_eval.pm_eval_loe ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'NATURE'
                  , pm_eval.pm_eval_nature ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'REP DELAY'
                  , pm_eval.pm_eval_rep ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'CARRIERTW'
                  , pm_eval.pm_eval_carrier ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'ALLERGIES'
                  , pm_eval.pm_eval_allergies ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'ARTHRITIS'
                  , pm_eval.pm_eval_arthritis ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'DIABETES'
                  , pm_eval.pm_eval_diabetes ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'HTN'
                  , pm_eval.pm_eval_htn ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'OBESITY'
                  , pm_eval.pm_eval_obesity ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'OTHER'
                  , pm_eval.pm_eval_other ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'PREV INJ'
                  , pm_eval.pm_eval_prev_inj ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'PREV TRT'
                  , pm_eval.pm_eval_prev_trt ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'TRT DUR'
                  , pm_eval.pm_eval_trt_dur ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'TRT FLG'
                  , pm_eval.pm_eval_trt_flg ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'TRT FRQ'
                  , pm_eval.pm_eval_trt_frq ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'CLM'
                  , pm_eval.pm_eval_clm ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'DURATION'
                  , pm_eval.pm_eval_duration ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'INCURRED'
                  , pm_eval.pm_eval_incurred ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'IND'
                  , pm_eval.pm_eval_ind ( primary_keys ( i )));
   FORALL i IN primary_keys.FIRST .. primary_keys.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys ( i ), 'REOPEN'
                  , pm_eval.pm_eval_reopen ( primary_keys ( i )));
END;
/

-- AFTER

CREATE TABLE eval_categories (name VARCHAR2(100), program_name VARCHAR2(100)
)
/

DECLARE
   PROCEDURE ins_one ( NAME_IN VARCHAR2, program_suffix_in VARCHAR2
            DEFAULT NULL )
   IS
   BEGIN
      INSERT INTO eval_categories
                  ( name
                  , program_name
                  )
           VALUES ( NAME_IN
                  , 'pm_eval.pm_eval_' || NVL ( program_suffix_in, NAME_IN )
                  );
   END ins_one;
BEGIN
   ins_one ( 'PROVIDERS' );
   ins_one ( 'TRT FRQ', 'trt_frq' );
   ins_one ( 'REP DELAY', 'rep' );
END;
/

CREATE OR REPLACE PROCEDURE bc_test
IS
   TYPE number_aat IS TABLE OF NUMBER
      INDEX BY PLS_INTEGER;

   primary_keys number_aat;
   primary_keys_expanded number_aat;
   function_values number_aat;

   TYPE name_tab IS TABLE OF eval_categories.name%TYPE
      INDEX BY PLS_INTEGER;

   keywords name_aat;

   TYPE program_name_aat IS TABLE OF eval_categories.program_name%TYPE
      INDEX BY PLS_INTEGER;

   program_names program_name_aat;
BEGIN
   SELECT name, program_name
   BULK COLLECT INTO keywords, program_names
     FROM eval_categories;

   SELECT ID
   BULK COLLECT INTO primary_keys
     FROM base_table;

   FOR i IN primary_keys.FIRST .. primary_keys.LAST
   LOOP
      FOR kw_indx IN 1 .. keywords.COUNT
      LOOP
         l_row := primary_keys_expanded.COUNT + 1;
         --
         primary_keys_expanded ( l_row ) := primary_keys ( i );
         names ( l_row ) := keywords ( kw_indx );

         EXECUTE IMMEDIATE    'BEGIN :outval := '
                           || program_names ( i )
                           || '(:inval)); END;'
                     USING OUT function_values ( l_row ), IN primary_keys ( i );
      END LOOP;
   END LOOP;

   FORALL i IN primary_keys_expanded.FIRST .. primary_keys_expanded.LAST
      INSERT INTO pm_temp_eval
           VALUES ( primary_keys_expanded ( i ), keywords ( i )
                  , function_values ( i ));
END;
/
