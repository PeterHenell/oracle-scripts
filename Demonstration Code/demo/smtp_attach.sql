/* Formatted by PL/Formatter v3.0.5.0 on 2000/05/23 12:26 */

REM
REM   Illustrates how to send attachment in mail using UTL_SMTP
REM

DECLARE
   boundary_text CONSTANT VARCHAR2 (256)
            := '-------------7D81B75CCC90D2974F7A1CBD';
   c utl_smtp.connection;

   -- End the line with a newline character
   PROCEDURE newline
   AS
   BEGIN
      utl_smtp.write_data (c, utl_tcp.crlf);
   END;

   -- Mark a message-part boundary.  Set <last> to TRUE for the last boundary.
   PROCEDURE boundary (LAST IN BOOLEAN DEFAULT FALSE)
   AS
   BEGIN
      utl_smtp.write_data (c, '--' || boundary_text);

      IF (LAST)
      THEN
         utl_smtp.write_data (c, '--');
      END IF;

      newline;
   END;

   -- Send a message (MIME) header
   PROCEDURE header (name IN VARCHAR2, header IN VARCHAR2)
   AS
   BEGIN
      utl_smtp.write_data (
         c,
         name || ': ' || header || utl_tcp.crlf
      );
   END;
BEGIN
   -- Open the connection to a mail (SMTP) server.
   c := utl_smtp.open_connection ('rpang-pc2.us.oracle.com');
   utl_smtp.helo (c, 'us.oracle.com');
   utl_smtp.mail (c, 'rpang@us.oracle.com');
   utl_smtp.rcpt (c, 'rpang@us.oracle.com');
   utl_smtp.open_data (c);
   -- Specify the sender, recipient, and subject.
   header ('From', '"Me" <rpang@us.oracle.com>');
   header ('To', 'You');
   header ('Subject', 'Hello');
   header ('MIME-Version', '1.0');
   -- Note the fact that this message has attachments (multi-part message)
   header (
      'Content-Type',
      'multipart/mixed; boundary="' || boundary_text || '"'
   );
   newline;
   -- Top-level message.  For e-mail programs that don't support MIME
   -- attachment, they will see this message.
   utl_smtp.write_data (
      c,
      'This is a multi-part message in MIME format.' ||
         utl_tcp.crlf
   );
   -- This is the actual e-mail body (i.e. the first part of this multi-part
   -- email) that the recipent will see.
   boundary;      -- opens this message body with a boundary
   header ('Content-Type', 'text/plain');
                -- specify content-type of this message part
   newline;
-- separate the message body from the headers with a newline
   utl_smtp.write_data (
      c,
      'This is the text body of the mail.  See the reports in the attachment.' ||
         utl_tcp.crlf
   );
   -- This is the attachment. It is the second part of the e-mail body.
   boundary;-- opens this message body with another boundary
   header ('Content-Type', 'text/html');
                 -- specify content-type of this attachment 
   -- Also specify filename below
   header (
      'Content-Disposition',
      'inline; filename="report1.html"'
   );
   newline;
-- separate the message body from the headers with a newline
   utl_smtp.write_data (
      c,
      '<body><h1>This is the first report.</h1></body>'
   );
   newline;
   -- This is the 2nd attachment. It is the second part of the e-mail body.
   boundary;-- opens this message body with another boundary
   header ('Content-Type', 'text/html');
                 -- specify content-type of this attachment 
   -- Also specify filename below
   header (
      'Content-Disposition',
      'inline; filename="report2.html"'
   );
   newline;
   
   -- separate the message body from the headers with a newline
   utl_smtp.write_data (
      c,
      '<body><h1>This is the second report.</h1></body>'
   );
   newline;
   
   -- Finally, mark the end of the whole email with the last boundary.
   boundary (TRUE);
   
   -- And close the connection with the mail server.
   utl_smtp.close_data (c);
   utl_smtp.quit (c);
END;
/
