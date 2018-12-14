DECLARE
  c utl_smtp.connection;

  PROCEDURE send_header(name IN VARCHAR2, header IN VARCHAR2) AS
  BEGIN
    utl_smtp.write_data(c, name || ': ' || header || utl_tcp.CRLF);
  END;

BEGIN
  c := utl_smtp.open_connection('smtp.enteract.com');
  utl_smtp.helo(c, 'enteract.com');
  utl_smtp.mail(c, 'steven@stevenfeuerstein.com');
  utl_smtp.rcpt(c, 'steven@stevenfeuerstein.com');
  utl_smtp.open_data(c);
  send_header('From',    '"Sender" <sender@foo.com>');
  send_header('To',      '"Recipient" <recipient@foo.com>');
  send_header('Subject', 'Hello');
  utl_smtp.write_data(c, utl_tcp.CRLF || 'Hello, world!');
  utl_smtp.close_data(c);
  utl_smtp.quit(c);
EXCEPTION
  WHEN utl_smtp.transient_error OR utl_smtp.permanent_error THEN
    utl_smtp.quit(c);
    raise_application_error(-20000,
      'Failed to send mail due to the following error: ' || sqlerrm);
END;
/
