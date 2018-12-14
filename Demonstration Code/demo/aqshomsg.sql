SELECT msg_state, user_data
  FROM aq$&&firstparm
 WHERE msg_id = HEXTORAW ('&&secondparm');