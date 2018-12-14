DECLARE
   /* 
   || PL/SQL block illustrating use of 
   || DBMS_PIPE.PACK_MESSAGE to pack and send
   || a PL/SQL record to a pipe
   */
   TYPE friend_rectype IS RECORD
      (name       VARCHAR2(60)
      ,birthdate  DATE
      ,weight_lbs NUMBER
      );

   friend_rec  friend_rectype;

   PROCEDURE pack_send_friend
      (friend_rec_IN IN friend_rectype
      ,pipename_IN IN VARCHAR2)
   IS
      call_status   INTEGER;
   BEGIN
      /* 
      ||notice the PACK_MESSAGE overloading 
      */
      DBMS_PIPE.PACK_MESSAGE(friend_rec_IN.name);
      DBMS_PIPE.PACK_MESSAGE(friend_rec_IN.birthdate);
      DBMS_PIPE.PACK_MESSAGE(friend_rec_IN.weight_lbs);
      
      call_status := DBMS_PIPE.SEND_MESSAGE
                        (pipename=>pipename_IN,timeout=>0);

      call_status := DBMS_PIPE.SEND_MESSAGE
                        (pipename=>pipename_IN,timeout=>0);

   END pack_send_friend;

BEGIN
   friend_rec.name := 'John Smith';
   friend_rec.birthdate := TO_DATE('01/14/55','MM/DD/YY');
   friend_rec.weight_lbs := 175;

   pack_send_friend(friend_rec,'OBIP_TEST_PIPE');
END;
/

DECLARE
   /* 
   || PL/SQL block illustrating use of 
   || DBMS_PIPE.UNPACK_MESSAGE to receive and
   || unpack a PL/SQL record from a pipe
   */
   TYPE friend_rectype IS RECORD
      (name       VARCHAR2(60)
      ,birthdate  DATE
      ,weight_lbs NUMBER
      );

   friend_rec  friend_rectype;

   PROCEDURE receive_unpack_friend
      (friend_rec_OUT OUT friend_rectype
      ,pipename_IN IN VARCHAR2)
   IS
      call_status   INTEGER;
   BEGIN

      call_status := DBMS_PIPE.RECEIVE_MESSAGE
                        (pipename=>pipename_IN,timeout=>0);
      /* 
      ||NOTE: UNPACK_MESSAGE overloaded but we must
      ||      call the correct version 
      */
      DBMS_PIPE.UNPACK_MESSAGE(friend_rec_OUT.name);
      DBMS_PIPE.UNPACK_MESSAGE(friend_rec_OUT.birthdate);
      DBMS_PIPE.UNPACK_MESSAGE(friend_rec_OUT.weight_lbs);
      
   END receive_unpack_friend;

BEGIN
   /* OK test the procedure, get rec from other example */
   receive_unpack_friend(friend_rec,'OBIP_TEST_PIPE');

   /* display results */
   DBMS_OUTPUT.PUT_LINE('Friend name: '||friend_rec.name);
   DBMS_OUTPUT.PUT_LINE('Friend birthdate: '||
                     TO_CHAR(friend_rec.birthdate));
   DBMS_OUTPUT.PUT_LINE('Friend weight: '||
                     TO_CHAR(friend_rec.weight_lbs));   

   /* OK test the procedure, get rec from other example */
   receive_unpack_friend(friend_rec,'OBIP_TEST_PIPE');

   /* display results */
   DBMS_OUTPUT.PUT_LINE('Friend name: '||friend_rec.name);
   DBMS_OUTPUT.PUT_LINE('Friend birthdate: '||
                     TO_CHAR(friend_rec.birthdate));
   DBMS_OUTPUT.PUT_LINE('Friend weight: '||
                     TO_CHAR(friend_rec.weight_lbs));   

END;
/

