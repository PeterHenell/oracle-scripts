/*
These programs are needed to run the following block:
@file_to_collection.sql
@collection_to_file.sql
@parse.pkg
*/

DECLARE
   l_header   VARCHAR2 (32767) := '-- $REVISION $1.0 $';
   l_items    parse.items_tt;
   l_lines    DBMS_SQL.varchar2a;

   l_dir      VARCHAR2 (100) := 'SCRIPTS';
   l_list     VARCHAR2 (32767)
      := 'add_company.sql,add_contest.sql,add_contest_prize.sql,add_news.sql,Add_nothing_is_correct.sql,add_prize.sql,add_testimonial.sql,'
         || 'add_tw_quiz.sql,answered_all_wrong.sql,approved_wo_mc_options.sql,assign_winner.sql,assign_winners_2010_04.sql,assign_winners_2010_05.sql,'
         || 'assign_winner_quiz_bug.sql,average_times.sql,awful_exception_section.sql,backup_quiz_results.sql,backup_tables.sql,change_quiz.sql,'
         || 'cleanup_affiliations.sql,cleanup_organizations.sql,compute_score.sql,country_participation.sql,DBMSOutput.txt,define_quiz_for.sql,'
         || 'dup_display_names.sql,dup_ip_address.sql,extract_emails.sql,files.txt,fix_dup_names.sql,gen_lookups_by_name.sql,gen_seq_code.sql,'
         || 'gen_set_tip.sql,init_quizzes.sql,launch_beta_winners.sql,load_news.sql,merge_text.sql,move_sequences.sql,next_question.sql,next_question2.sql,'
         || 'no_blank_names.sql,no_correct_answers.sql,no_undefined_expertise.sql,organization_counts.sql,pick_monthly_raffle_winners.sql,'
         || 'pick_winners.sql,players_by_date.sql,player_counts_by_day.sql,prize_choices.sql,qcgu_trigger.qgs,quarterly_ranking.sql,recompute_all_scores.sql,'
         || 'recompute_all_scores_2010_06_03.sql,recompute_all_scores_2010_06_04.sql,recompute_all_scores_2010_06_09.sql,'
         || 'recompute_all_scores_specific_correction.sql,record_answer.sql,refresh_mviews.sql,registered_but_not_playing.sql,'
         || 'remove_answer.sql,remove_feuerstein_users.sql,remove_user.sql,reset_scores.sql,reset_scores_04_09_2010.sql,reset_scores_04_16_2010.sql,'
         || 'reset_scores_for_single_option.sql,review_rankings.sql,rollup.txt,score_distribution.sql,send_email_values.sql,set_tw_quiz.sql,'
         || 'show_answer.sql,show_answers.sql,show_computed_score.sql,show_prizes_for.sql,show_question.sql,show_quiz.sql,show_rollup.sql,'
         || 'show_user.sql,show_winners.sql,snapshot_mviews.sql,synch_sequence.sql,table_counts.sql,td_answer_quizzes.sql,td_clear_test_data.sql,'
         || 'td_create users.sql,td_next_question.sql,temp.sql,test.sql,test_with_exc.sql,test_with_tracing.sql,tf_to_yn.sql,total_prize_value_awarded.sql,'
         || 'user_time_analysis.sql,winner_found_problem.sql';
BEGIN
   EXECUTE IMMEDIATE 'create or replace directory SCRIPTS as ''c:\work\plsqlchallenge\scripts''';

   l_items := PARSE.STRING_TO_LIST (l_list, ',');

   FOR indx IN 1 .. l_items.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_items (indx));
      l_lines := file_to_collection ('SCRIPTS', l_items (indx));

      IF L_lines (L_lines.FIRST) <> l_header
      THEN
         l_lines (l_lines.FIRST - 1) := l_header;

         collection_to_file ('SCRIPTS', l_items (indx), l_lines);
      END IF;
   END LOOP;
END;
/