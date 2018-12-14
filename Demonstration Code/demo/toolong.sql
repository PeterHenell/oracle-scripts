DECLARE
/* An attempt to recreate populating a string with more than 32767 characters */
   str1 varchar2(32767);
   str2 varchar2(32767);
   str3 varchar2(32767);
   str4 varchar2(32767);
   str5 varchar2(32767);

   PROCEDURE genString (
      string1_inout IN OUT VARCHAR2,
      string2_inout IN OUT VARCHAR2,
      string3_inout IN OUT VARCHAR2,
      string4_inout IN OUT VARCHAR2,
      string5_inout IN OUT VARCHAR2
      )
   IS
      onstring PLS_INTEGER := 1;
      l_next VARCHAR2(32767);
      l_string VARCHAR2(32767);
   BEGIN 

      /* Move from list to these five strings. */
      string1_inout := NULL; 
      string2_inout := NULL; 
      string3_inout := NULL; 
      string4_inout := NULL; 
      string5_inout := NULL;
      
      LOOP
         BEGIN        
            l_next := RPAD ('abc', 5, 'def');
            IF l_string IS NULL
            THEN
               l_string := l_next;
            ELSE
               l_string := l_string || CHR(10) || l_next;
            END IF;
            
         EXCEPTION
            WHEN VALUE_ERROR
            THEN
               /* Move to next string. */
               IF onstring = 1
               THEN
                  string1_inout := l_string;
            -- p.l ('string1_inout = ' || string1_inout);
                  onstring := 2;
               ELSIF onstring = 2
               THEN
                  string2_inout := l_string;
            -- p.l ('string2_inout = ' || string2_inout);
                  onstring := 3;
               ELSIF onstring = 3
               THEN
                  string3_inout := l_string;
            -- p.l ('string3_inout = ' || string3_inout);
                  onstring := 4;
               ELSIF onstring = 4
               THEN
                  string4_inout := l_string;
            -- p.l ('string4_inout = ' || string4_inout);
                  onstring := 5;
               ELSIF onstring = 5
               THEN
                  string5_inout := l_string;
                  onstring := NULL;
            -- p.l ('string5_inout = ' || string5_inout);
               ELSE
                  EXIT;
               END IF;
               l_string := l_next;
         END;
      END LOOP;
   END;
BEGIN
   genstring (
      str1, str2, str3, str4, str5);
      
   p.l ('string1='||length(str1));
   p.l ('string2='||length(str2));
   p.l ('string3='||length(str3));
   p.l ('string4='||length(str4));
   p.l ('string5='||length(str5));

END;
/   
