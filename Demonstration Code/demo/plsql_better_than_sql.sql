/* The SQL Solution */

CREATE OR REPLACE FORCE VIEW qdb_score_daily_avg_v
AS
     SELECT date_used
          , yyyy_ddd
          , AVG (user_score) user_score
          , AVG (user_wscore) user_wscore
          , AVG (user_seconds) user_seconds
          , AVG (overall_rank) overall_rank
          , AVG (overall_percentile) overall_percentile
          , AVG (correct_answers) correct_answers
          , AVG (incorrect_answers) incorrect_answers
          , AVG (pct_correct_answers) pct_correct_answers
       FROM qdb_score_daily_by_user_av
   GROUP BY date_used, yyyy_ddd
/

CREATE OR REPLACE FORCE VIEW qdb_score_daily_best_v
AS
     SELECT date_used
          , yyyy_ddd
          , MAX (user_score) user_score
          , MAX (user_wscore) user_wscore
          , MIN (user_seconds) user_seconds
          , MIN (overall_rank) overall_rank
          , MIN (overall_percentile) overall_percentile
          , MAX (correct_answers) correct_answers
          , MIN (incorrect_answers) incorrect_answers
          , MAX (pct_correct_answers) pct_correct_answers
       FROM qdb_score_daily_by_user_av
   GROUP BY date_used, yyyy_ddd
/

CREATE OR REPLACE FORCE VIEW qdb_score_daily_country_v
AS
     SELECT country
          , date_used
          , yyyy_ddd
          , AVG (user_score) avg_user_score
          , AVG (user_wscore) avg_user_wscore
          , AVG (user_seconds) avg_user_seconds
          , AVG (overall_rank) avg_overall_rank
          , AVG (overall_percentile) avg_overall_percentile
          , AVG (correct_answers) avg_correct_answers
          , AVG (incorrect_answers) avg_incorrect_answers
          , AVG (pct_correct_answers) avg_pct_correct_answers
          , MAX (user_score) best_user_score
          , MAX (user_wscore) best_user_wscore
          , MIN (user_seconds) best_user_seconds
          , MIN (overall_rank) best_overall_rank
          , MIN (overall_percentile) best_overall_percentile
          , MAX (correct_answers) best_correct_answers
          , MIN (incorrect_answers) best_incorrect_answers
          , MAX (pct_correct_answers) best_pct_correct_answers
       FROM qdb_score_daily_by_user_av av, qdb_users u
      WHERE av.user_id = u.user_id
   GROUP BY country, date_used, yyyy_ddd
/

CREATE OR REPLACE FORCE VIEW qdb_past_quiz_summary_v
AS
   SELECT 'You' data_level
        , user_id
        , date_used
        , yyyy_ddd
        , user_score
        , user_wscore
        , user_seconds
        , overall_rank
        , overall_percentile
        , correct_answers
        , incorrect_answers
        , pct_correct_answers
     FROM qdb_score_daily_by_user_av
   UNION
   SELECT 'Average' data_level
        , 0
        , date_used
        , yyyy_ddd
        , user_score
        , user_wscore
        , user_seconds
        , overall_rank
        , overall_percentile
        , correct_answers
        , incorrect_answers
        , pct_correct_answers
     FROM qdb_score_daily_avg_v
   UNION
   SELECT 'Best' data_level
        , 0
        , date_used
        , yyyy_ddd
        , user_score
        , user_wscore
        , user_seconds
        , overall_rank
        , overall_percentile
        , correct_answers
        , incorrect_answers
        , pct_correct_answers
     FROM qdb_score_daily_best_v
   UNION
   SELECT country || ' Average' data_level
        , 0
        , date_used
        , yyyy_ddd
        , avg_user_score
        , avg_user_wscore
        , avg_user_seconds
        , avg_overall_rank
        , avg_overall_percentile
        , avg_correct_answers
        , avg_incorrect_answers
        , avg_pct_correct_answers
     FROM qdb_score_daily_country_v
   UNION
   SELECT country || ' Best' data_level
        , 0
        , date_used
        , yyyy_ddd
        , best_user_score
        , best_user_wscore
        , best_user_seconds
        , best_overall_rank
        , best_overall_percentile
        , best_correct_answers
        , best_incorrect_answers
        , best_pct_correct_answers
     FROM qdb_score_daily_country_v
/

  SELECT s.*
    FROM qdb_past_quiz_summary_v s, qdb_users u
   WHERE ( (    data_level = 'You'
            AND s.user_id = :ai_user_id
            AND date_used = :p651_date_used)
          OR (    data_level = 'Average'
              AND s.user_id = 0
              AND date_used = :p651_date_used)
          OR (    data_level = 'Best'
              AND s.user_id = 0
              AND date_used = :p651_date_used)
          OR (    data_level = u.country || ' Best'
              AND s.user_id = 0
              AND date_used = :p651_date_used)
          OR (    data_level = u.country || ' Average'
              AND s.user_id = 0
              AND date_used = :p651_date_used))
         AND u.user_id = :ai_user_id
ORDER BY CASE data_level
            WHEN 'You' THEN 1
            WHEN 'Average' THEN 2
            WHEN 'Best' THEN 3
            WHEN u.country || ' Average' THEN 4
            WHEN u.country || ' Best' THEN 5
         END
/

/* The PL/SQL Solution */

DROP TYPE  pq_summary_ot FORCE
/

CREATE OR REPLACE TYPE pq_summary_ot IS OBJECT
                  (data_level VARCHAR2 (100)
                 , user_score NUMBER
                 , user_wscore NUMBER
                 , user_seconds NUMBER
                 , overall_rank NUMBER
                 , overall_percentile NUMBER
                 , correct_answers NUMBER
                 , incorrect_answers NUMBER
                 , pct_correct_answers NUMBER)
/

CREATE OR REPLACE TYPE pq_summary_nt IS TABLE OF pq_summary_ot
/

CREATE OR REPLACE FUNCTION pq_summary_tf (user_id_in   IN INTEGER
                                        , date_in      IN DATE)
   RETURN pq_summary_nt
IS
   l_element   pq_summary_ot;
   l_return    pq_summary_nt := pq_summary_nt ();
BEGIN
   SELECT pq_summary_ot ('You'
                       , user_score
                       , user_wscore
                       , user_seconds
                       , overall_rank
                       , overall_percentile
                       , correct_answers
                       , incorrect_answers
                       , pct_correct_answers)
     INTO l_element
     FROM qdb_score_daily_by_user_av av
    WHERE av.user_id = user_id_in AND av.date_used = date_in;

   l_return.EXTEND;
   l_return (l_return.LAST) := l_element;

   SELECT pq_summary_ot ('Best'
                       , MAX (user_score)
                       , MAX (user_wscore)
                       , MIN (user_seconds)
                       , MIN (overall_rank)
                       , MIN (overall_percentile)
                       , MAX (correct_answers)
                       , MIN (incorrect_answers)
                       , MAX (pct_correct_answers))
     INTO l_element
     FROM qdb_score_daily_by_user_av av
    WHERE av.date_used = date_in;

   l_return.EXTEND;
   l_return (l_return.LAST) := l_element;

   SELECT pq_summary_ot ('Average'
                       , ROUND (AVG (user_score))
                       , ROUND (AVG (user_wscore))
                       , ROUND (AVG (user_seconds))
                       , ROUND (AVG (overall_rank))
                       , ROUND (AVG (overall_percentile))
                       , ROUND (AVG (correct_answers))
                       , ROUND (AVG (incorrect_answers))
                       , ROUND (AVG (pct_correct_answers)))
     INTO l_element
     FROM qdb_score_daily_by_user_av av
    WHERE av.date_used = date_in;

   l_return.EXTEND;
   l_return (l_return.LAST) := l_element;

     SELECT pq_summary_ot (country || ' Average'
                         , ROUND (AVG (user_score))
                         , ROUND (AVG (user_wscore))
                         , ROUND (AVG (user_seconds))
                         , ROUND (AVG (overall_rank))
                         , ROUND (AVG (overall_percentile))
                         , ROUND (AVG (correct_answers))
                         , ROUND (AVG (incorrect_answers))
                         , ROUND (AVG (pct_correct_answers)))
       INTO l_element
       FROM qdb_score_daily_by_user_av av, qdb_users u
      WHERE     av.user_id = user_id_in
            AND av.date_used = date_in
            AND u.user_id = user_id_in
   GROUP BY country;

   l_return.EXTEND;
   l_return (l_return.LAST) := l_element;

     SELECT pq_summary_ot (country || ' Best'
                         , MAX (user_score)
                         , MAX (user_wscore)
                         , MIN (user_seconds)
                         , MIN (overall_rank)
                         , MIN (overall_percentile)
                         , MAX (correct_answers)
                         , MIN (incorrect_answers)
                         , MAX (pct_correct_answers))
       INTO l_element
       FROM qdb_score_daily_by_user_av av, qdb_users u
      WHERE     av.user_id = user_id_in
            AND av.date_used = date_in
            AND u.user_id = user_id_in
   GROUP BY country;

   l_return.EXTEND;
   l_return (l_return.LAST) := l_element;

   RETURN l_return;
END;
/

  SELECT data_level
       , user_score "Score"
       , user_wscore "Weighted Score"
       , user_seconds "Time (secs)"
       , overall_rank "Rank"
       , overall_percentile "Percentile"
       , correct_answers "Correct"
       , incorrect_answers "Incorrect"
       , pct_correct_answers "% Correct"
    FROM TABLE (pq_summary_tf (:ai_user_id, :p651_date_used)) s, qdb_users u
   WHERE u.user_id = :ai_user_id
ORDER BY CASE data_level
            WHEN 'You' THEN 1
            WHEN 'Average' THEN 2
            WHEN 'Best' THEN 3
            WHEN u.country || ' Average' THEN 4
            WHEN u.country || ' Best' THEN 5
         END
/