/* Examples taken from http://www.orafaq.com/wiki/Send_mail_from_PL/SQL */

/*
With UTL_SMTP
*/

DECLARE
   v_from        VARCHAR2 (80) := 'oracle@mycompany.com';
   v_recipient   VARCHAR2 (80) := 'test@mycompany.com';
   v_subject     VARCHAR2 (80) := 'test subject';
   v_mail_host   VARCHAR2 (30) := 'mail.mycompany.com';
   v_mail_conn   UTL_SMTP.connection;
   crlf          VARCHAR2 (2) := CHR (13) || CHR (10);
BEGIN
   v_mail_conn := UTL_SMTP.open_connection (v_mail_host, 25);
   UTL_SMTP.helo (v_mail_conn, v_mail_host);
   UTL_SMTP.mail (v_mail_conn, v_from);
   UTL_SMTP.rcpt (v_mail_conn, v_recipient);
   UTL_SMTP.data (
      v_mail_conn
    ,    'Date: '
      || TO_CHAR (SYSDATE, 'Dy, DD Mon YYYY hh24:mi:ss')
      || crlf
      || 'From: '
      || v_from
      || crlf
      || 'Subject: '
      || v_subject
      || crlf
      || 'To: '
      || v_recipient
      || crlf
      || crlf
      || 'some message text'
      || crlf
      ||                                                       -- Message body
        'more message text'
      || crlf);
   UTL_SMTP.quit (v_mail_conn);
EXCEPTION
   WHEN UTL_SMTP.transient_error OR UTL_SMTP.permanent_error
   THEN
      raise_application_error (-20000, 'Unable to send mail: ' || SQLERRM);
END;
/

/* 
With UTL_TCP 
*/

CREATE OR REPLACE PROCEDURE send_mail (
   msg_from       VARCHAR2 := 'oracle'
 , msg_to         VARCHAR2
 , msg_subject    VARCHAR2 := 'E-Mail message from your database'
 , msg_text       VARCHAR2 := NULL)
IS
   c    UTL_TCP.connection;
   rc   INTEGER;
BEGIN
   c := UTL_TCP.open_connection ('127.0.0.1', 25); -- open the SMTP port 25 on local machine
   DBMS_OUTPUT.put_line (UTL_TCP.get_line (c, TRUE));
   rc := UTL_TCP.write_line (c, 'HELO localhost');
   DBMS_OUTPUT.put_line (UTL_TCP.get_line (c, TRUE));
   rc := UTL_TCP.write_line (c, 'MAIL FROM: ' || msg_from);
   DBMS_OUTPUT.put_line (UTL_TCP.get_line (c, TRUE));
   rc := UTL_TCP.write_line (c, 'RCPT TO: ' || msg_to);
   DBMS_OUTPUT.put_line (UTL_TCP.get_line (c, TRUE));
   rc := UTL_TCP.write_line (c, 'DATA');                 -- Start message body
   DBMS_OUTPUT.put_line (UTL_TCP.get_line (c, TRUE));
   rc := UTL_TCP.write_line (c, 'Subject: ' || msg_subject);
   rc := UTL_TCP.write_line (c, '');
   rc := UTL_TCP.write_line (c, msg_text);
   rc := UTL_TCP.write_line (c, '.');                   -- End of message body
   DBMS_OUTPUT.put_line (UTL_TCP.get_line (c, TRUE));
   rc := UTL_TCP.write_line (c, 'QUIT');
   DBMS_OUTPUT.put_line (UTL_TCP.get_line (c, TRUE));
   UTL_TCP.close_connection (c);                       -- Close the connection
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (
         -20000
       , 'Unable to send e-mail message from pl/sql because of: ' || SQLERRM);
END;
/


/*
With UTL_MAIL
*/

BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION SET smtp_out_server = ''127.0.0.1''';

   UTL_MAIL.send (sender       => 'me@address.com'
                , recipients   => 'you@address.com'
                , subject      => 'Test Mail'
                , MESSAGE      => 'Hello World'
                , mime_type    => 'text; charset=us-ascii');
END;
/