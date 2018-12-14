/* Formatted on 2002/06/24 15:03 (Formatter Plus v4.6.6) */
DECLARE
   req     UTL_HTTP.req;
   resp    UTL_HTTP.resp;
   NAME    VARCHAR2 (255);
   VALUE   VARCHAR2 (1023);
   v_msg   VARCHAR2 (80);
   v_url   VARCHAR2 (32767) := 'http://otn.oracle.com/';
BEGIN
   /* request that exceptions are raised for error Status Codes */
   UTL_HTTP.set_response_error_check (ENABLE => TRUE );
   
   /* allow testing for exceptions like Utl_Http.Http_Server_Error */
   UTL_HTTP.set_detailed_excp_support (ENABLE => TRUE );
   
   UTL_HTTP.set_proxy (
      proxy                 => 'www-proxy.us.oracle.com',
      no_proxy_domains      => 'us.oracle.com'
   );
   req := UTL_HTTP.begin_request (url => v_url, method => 'GET');
   /*
    Alternatively use method => 'POST' and Utl_Http.Write_Text to
    build an arbitrarily long message
  */
   UTL_HTTP.set_authentication (
      r              => req,
      username       => 'SomeUser',
      PASSWORD       => 'SomePassword',
      scheme         => 'Basic',
      for_proxy      => FALSE /* this info is for the target web server */
   );
   UTL_HTTP.set_header (r => req, NAME => 'User-Agent', VALUE => 'Mozilla/4.0');
   resp := UTL_HTTP.get_response (r => req);
   DBMS_OUTPUT.put_line ('Status code: ' || resp.status_code);
   DBMS_OUTPUT.put_line ('Reason phrase: ' || resp.reason_phrase);

   FOR i IN 1 .. UTL_HTTP.get_header_count (r => resp)
   LOOP
      UTL_HTTP.get_header (r => resp, n => i, NAME => NAME, VALUE => VALUE);
      DBMS_OUTPUT.put_line (NAME || ': ' || VALUE);
   END LOOP;

   BEGIN
      LOOP
         UTL_HTTP.read_text (r => resp, DATA => v_msg);
         DBMS_OUTPUT.put_line (v_msg);
      END LOOP;
   EXCEPTION
      WHEN UTL_HTTP.end_of_body
      THEN
         NULL;
   END;

   UTL_HTTP.end_response (r => resp);
EXCEPTION
   /*
    The exception handling illustrates the use of "pragma-ed" exceptions
    like Utl_Http.Http_Client_Error. In a realistic example, the program
    would use these when it coded explicit recovery actions.

    Request_Failed is raised for all exceptions after calling
    Utl_Http.Set_Detailed_Excp_Support ( enable=>false )
    And it is NEVER raised after calling with enable=>true
  */
   WHEN UTL_HTTP.request_failed
   THEN
      DBMS_OUTPUT.put_line (
         'Request_Failed: ' || UTL_HTTP.get_detailed_sqlerrm
      );
   /* raised by URL http://xxx.oracle.com/ */
   WHEN UTL_HTTP.http_server_error
   THEN
      DBMS_OUTPUT.put_line (
         'Http_Server_Error: ' || UTL_HTTP.get_detailed_sqlerrm
      );
   /* raised by URL http://otn.oracle.com/xxx */
   WHEN UTL_HTTP.http_client_error
   THEN
      DBMS_OUTPUT.put_line (
         'Http_Client_Error: ' || UTL_HTTP.get_detailed_sqlerrm
      );
   /* code for all the other defined exceptions you can recover from */
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQLERRM);
END;
