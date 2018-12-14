CREATE OR REPLACE FUNCTION full_name (first_name_in    IN VARCHAR2
                                    , middle_name_in   IN VARCHAR2
                                    , last_name1_in    IN VARCHAR2
                                    , last_name2_in    IN VARCHAR2)
   RETURN VARCHAR2
IS
BEGIN
   RETURN    first_name_in
          || ' '
          || middle_name_in
          || ' '
          || last_name1_in
          || ' '
          || last_name2_in;
END;
/

CREATE OR REPLACE PROCEDURE show_name (first_name_in    IN VARCHAR2
                                     , middle_name_in   IN VARCHAR2
                                     , last_name1_in    IN VARCHAR2
                                     , last_name2_in    IN VARCHAR2)
IS
BEGIN
   DBMS_OUTPUT.put_line (   '"'
                         || full_name (first_name_in
                                     , middle_name_in
                                     , last_name1_in
                                     , last_name2_in)
                         || '"');
END show_name;
/

BEGIN
   DBMS_OUTPUT.put_line ('Simple and Spacey');
   show_name ('Steven'
            , 'Eric'
            , 'Markus'
            , 'Feuerstein');
   show_name (''
            , 'Eric'
            , 'Markus'
            , 'Feuerstein');
   show_name ('Steven'
            , ''
            , 'Markus'
            , 'Feuerstein');
   show_name ('Steven'
            , ''
            , ''
            , 'Feuerstein');
END;
/

CREATE OR REPLACE FUNCTION full_name (first_name_in    IN VARCHAR2
                                    , middle_name_in   IN VARCHAR2
                                    , last_name1_in    IN VARCHAR2
                                    , last_name2_in    IN VARCHAR2)
   RETURN VARCHAR2
IS
   l_name   VARCHAR2 (1000);
BEGIN
   IF first_name_in IS NOT NULL
   THEN
      l_name := first_name_in;
   END IF;

   IF middle_name_in IS NOT NULL
   THEN
      l_name := l_name || ' ' || middle_name_in;
   END IF;

   IF last_name1_in IS NOT NULL
   THEN
      l_name := l_name || ' ' || last_name1_in;
   END IF;

   IF last_name2_in IS NOT NULL
   THEN
      l_name := l_name || ' ' || last_name2_in;
   END IF;

   RETURN LTRIM (l_name);
END;
/

BEGIN
   DBMS_OUTPUT.put_line ('Sequential IF statements');
   show_name ('Steven'
            , 'Eric'
            , 'Markus'
            , 'Feuerstein');
   show_name (''
            , 'Eric'
            , 'Markus'
            , 'Feuerstein');
   show_name ('Steven'
            , ''
            , 'Markus'
            , 'Feuerstein');
   show_name ('Steven'
            , ''
            , ''
            , 'Feuerstein');
END;
/

CREATE OR REPLACE FUNCTION full_name (first_name_in    IN VARCHAR2
                                    , middle_name_in   IN VARCHAR2
                                    , last_name1_in    IN VARCHAR2
                                    , last_name2_in    IN VARCHAR2)
   RETURN VARCHAR2
IS
BEGIN
   RETURN CASE
             WHEN first_name_in IS NULL THEN NULL
             ELSE first_name_in || ' '
          END
          || CASE
                WHEN middle_name_in IS NULL THEN NULL
                ELSE middle_name_in || ' '
             END
          || CASE
                WHEN last_name1_in IS NULL THEN NULL
                ELSE last_name1_in || ' '
             END
          || last_name2_in;
END;
/

BEGIN
   DBMS_OUTPUT.put_line ('Inline CASE');
   show_name ('Steven'
            , 'Eric'
            , 'Markus'
            , 'Feuerstein');
   show_name (''
            , 'Eric'
            , 'Markus'
            , 'Feuerstein');
   show_name ('Steven'
            , ''
            , 'Markus'
            , 'Feuerstein');
   show_name ('Steven'
            , ''
            , ''
            , 'Feuerstein');
END;
/

/* Cannot use IF inline */