BEGIN
   UTL_MAIL.send_attachment_raw (
      sender     => 'me@mydomain.com'
     ,recipients => 'you@yourdomain.com, him@hisdomain.com'
     ,cc         => 'mom@momdomain.com'
     ,bcc        => 'me@mydomain.com'
     ,subject    => 'Cool new API for sending email'
     ,message    => '...'
     ,attachment => '...' /* Content of the attachment */
     ,att_inline => TRUE /* Attachment in-line? */
     ,att_filename => '...' 
         /* Name of file to hold the attachment after the mail 
            is received. */
   );
END;
