BEGIN   
   DBMS_APPLICATION_INFO.SET_MODULE ('quickref', 'startup');
END;
/
COLUMN module FORMAT a20
COLUMN action FORMAT a20
SELECT module, action 
  FROM V$SESSION
 WHERE username = USER;
