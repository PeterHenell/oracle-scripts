
/******************************************************************************************/
/* Filename: scorecard.prc																	  */
/*																						  */
/* Purpose: Creation script for scorecard procedure.										  */
/*											 											  */
/* Revision History:																	  */
/*	Date		User	Rev	Description													  */
/*	------------------------------------------------------------------------------- 	  */
/*  08/02/99    Cburg   Inital Release                                                    */
/*                                                                                        */
/******************************************************************************************/

PROMPT Creating stored procedure scorecard . . .

CREATE OR REPLACE PROCEDURE scorecard( 
    p_start_date 	date,
    p_end_date		date,
	p_session_id	NUMBER
  ) as

BEGIN
DECLARE
    v_all_avg		NUMBER;
	v_all_hours		NUMBER;
	v_all_pieces	NUMBER;
	v_all_pph		NUMBER;
BEGIN

/* Convert date string to date format */

--	v_start_date := to_date(p_start_date, 'mm/dd/yyyy');
--	v_end_date := to_date(p_end_date, 'mm/dd/yyyy');
	
/* Delete old records for current session id */
	
	DELETE FROM av12.mes_temp_inspector_score_card
	WHERE session_id = USERENV('SESSIONID');

	COMMIT;
	
/* Insert the PPH detail for each inspector. */

	INSERT INTO av12.mes_temp_inspector_score_card(
		indv_avg_inspection_time,
		indv_inspection_hours,
		indv_pieces_inspected,
		indv_pack_per_hour,
		av_member_id,
		av_shift_name,
		session_id)
	SELECT round(avg(trans.interval),2), 
		 round((sum(trans.interval)/3600),2), 
		 count(trans.interval) as insp_pieces,
		 round((count(trans.interval)/(sum(trans.interval)/3600)),2),
		 trans.av_member_id,
		 shift.av_shift_name,
		 USERENV('SESSIONID')
	FROM  av12.mes_transaction_time trans, av.av_member member, av.av_shift shift
	WHERE trans.av_member_id = member.av_member_id
	AND member.av_shift_id = shift.av_shift_id
	AND trans.transaction_ts BETWEEN p_start_date
	                         AND p_end_date
	AND trans.av_member_id <> 0
	AND shift.av_shift_name IN ('A','B','C','D')
	GROUP BY trans.av_member_id, shift.av_shift_name;

	COMMIT;
	
/* Get the shift and all PPH details. */
	
	UPDATE av12.mes_temp_inspector_score_card
	SET (shift_avg_inspection_time,
		 shift_inspection_hours,
		 shift_pieces_inspected,
		 shift_pack_per_hour) = (SELECT /*+ INDEX(trans MES_TRANSACTION_TIME_N3) INDEX(member AV_MEMBER_N1) PARALLEL*/ 
									round(avg(trans.interval),2) as avg_time, 
		   							round((sum(trans.interval)/3600),2) as total_hrs, 
	    							count(trans.interval) as insp_pieces,
	    							round((count(trans.interval)/(sum(trans.interval)/3600)),2) as pph
								FROM  av12.mes_transaction_time trans, av.av_member member, av.av_shift shifts  
								WHERE trans.av_member_id = member.av_member_id
								AND   member.av_shift_id = shifts.av_shift_id
								AND   trans.transaction_ts BETWEEN p_start_date AND p_end_date
								AND   trans.av_member_id<>0
								AND   shifts.av_shift_name = 'A')
	WHERE av_shift_name = 'A'
	AND session_id = USERENV('SESSIONID');
	
	COMMIT;
END;
END;
/
  
      



