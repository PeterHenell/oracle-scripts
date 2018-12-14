/*
Created by Noel Portugal
*/

CREATE OR REPLACE PROCEDURE update_twitter (t_user   IN VARCHAR2
                                          , t_pass   IN VARCHAR2
                                          , t_update IN VARCHAR2
                                           )
AS
   http_req        UTL_HTTP.req;
   http_resp       UTL_HTTP.resp;
   h_name          VARCHAR2 (255);
   h_value         VARCHAR2 (1023);
   t_update_send   VARCHAR2 (4000);
   res_value       VARCHAR2 (32767);
   show_header     NUMBER := 0; --0 False, 1 True
   show_xml        NUMBER := 1; --0 False, 1 True
BEGIN
   t_update_send := 'status=' || SUBSTR (t_update, 1, 140) || '';
   --utl_http.set_proxy('http://www,yourpoxy.com:80'); --If you need to specify a proxy un comment this line.
   http_req :=
      UTL_HTTP.
      begin_request ('http://twitter.com/statuses/update.xml'
                   , 'POST'
                   , UTL_HTTP.http_version_1_1
                    );
   UTL_HTTP.set_response_error_check (TRUE);
   UTL_HTTP.set_detailed_excp_support (TRUE);
   UTL_HTTP.set_body_charset (http_req, 'UTF-8');
   UTL_HTTP.set_header (http_req, 'User-Agent', 'Mozilla/4.0');
   UTL_HTTP.
   set_header (http_req, 'Content-Type', 'application/x-www-form-urlencoded');
   UTL_HTTP.
   set_header (http_req, 'Content-Length', TO_CHAR (LENGTH (t_update_send)));
   UTL_HTTP.set_transfer_timeout (TO_CHAR ('60'));
   UTL_HTTP.set_authentication (http_req, t_user, t_pass, 'Basic');
   UTL_HTTP.write_text (http_req, t_update_send);
   http_resp := UTL_HTTP.get_response (http_req);

   DBMS_OUTPUT.put_line ('status code: ' || http_resp.status_code);
   DBMS_OUTPUT.put_line ('reason phrase: ' || http_resp.reason_phrase);

   IF show_header = 1
   THEN
      FOR i IN 1 .. UTL_HTTP.get_header_count (http_resp)
      LOOP
         UTL_HTTP.get_header (http_resp, i, h_name, h_value);
         DBMS_OUTPUT.put_line (h_name || ': ' || h_value);
      END LOOP;
   END IF;

   IF show_xml = 1
   THEN
      BEGIN
         WHILE 1 = 1
         LOOP
            UTL_HTTP.read_line (http_resp, res_value, TRUE);
            DBMS_OUTPUT.put_line (res_value);
         END LOOP;
      EXCEPTION
         WHEN UTL_HTTP.end_of_body
         THEN
            NULL;
      END;
   END IF;

   UTL_HTTP.end_response (http_resp);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQLERRM);
      RAISE;
END update_twitter;
/


BEGIN
   update_twitter (
      'my_twitter_acct'
    , 'my_twitter_pass'
    , 'Hello World from Oracle PL/SQL and APEX http://apextoday.blogspot.com'
   );
END;
/