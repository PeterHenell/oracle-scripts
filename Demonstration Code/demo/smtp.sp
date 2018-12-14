/* Formatted by PL/Formatter v3.1.2.1 on 2000/08/27 10:32 */

CREATE OR REPLACE PROCEDURE sendmail (
   isp_in IN VARCHAR2,
   mail_in IN VARCHAR2,
   rcpt_in IN VARCHAR2,
   text_in IN VARCHAR2)
AS
   c utl_smtp.connection;

   PROCEDURE send_header (
      name IN VARCHAR2,
      header IN VARCHAR2
   )
   AS
   BEGIN
      utl_smtp.write_data (c,
         name || ': ' || header || utl_tcp.crlf
      );
   END;
BEGIN
   c := utl_smtp.open_connection (isp_in || '.com');
   utl_smtp.helo (c, isp_in || '.com');
   utl_smtp.mail (c, mail_in || '@' || isp_in || '.com');
   utl_smtp.rcpt (c, rcpt_in || '@' || isp_in || '.com');
   utl_smtp.open_data (c);
   send_header ('From', '"Sender" ');
   send_header ('To', '"Recipient" ');
   send_header ('Subject', 'Hello');
   utl_smtp.write_data (c, utl_tcp.crlf || text_in);
   utl_smtp.close_data (c);
   utl_smtp.quit (c);
EXCEPTION
   WHEN utl_smtp.transient_error OR utl_smtp.permanent_error
   THEN
      utl_smtp.quit (c);
      raise_application_error (-20000,
         'Failed to send mail due to the following error: ' ||
            SQLERRM
      );
END; 
/
