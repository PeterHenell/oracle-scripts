BEGIN
   UTL_MAIL.send (
      sender     => 'me@mydomain.com'
     ,recipients => 'you@yourdomain.com, him@hisdomain.com'
     ,cc         => 'mom@momdomain.com'
     ,bcc        => 'me@mydomain.com'
     ,subject    => 'Cool new API for sending email'
     ,message    =>
'Hi Ya''ll,
Sending email in PL/SQL is *much* easier with UTL_MAIL in 10g. 
Give it a try!
Mailfully Yours,
Bill'
   );
END;
/
