/*
From: Jan-Hendrik van Heusden [jhvheusden@promedico.nl]
Sent: Tuesday, September 17, 2013 10:49 AM
To: Steven Feuerstein
Subject: Query to analyse identifier usages in PL/SQL


Hi Steven,

I was working in a project where quite some obsolete code was being removed, 
and I wanted to know if certain methods, variables were actually used yet. 
I first made sure that everything was compiled with the appropriate settings (IDENTIFIERS:ALL).

Then I created the attached query, I thought you might be interested in it. 
Note that this query does of course not show all possible usages; 
it does not list usages in views or over database links, and it definitely 
does not list usage in external souces (sql files, queries made from external applications etc.).
 
Nevertheless I found it very useful for what it does (usage of PL/SQL 
identifiers within PL/SQL). Other PL/SQL developers may be interested, 
so feel free to use or publish it. You may also want to change things like 
the sorting order, feel free to do so.

Best regards, 
Jan-Hendrik van Heusden
*/

  SELECT pl_id.declaring_owner,
         pl_id.declaring_object_type,
         pl_id.declaring_object_name,
         pl_id.declaring_line,
         pl_id.declared_type,
         pl_id.declared_name,
         pl_id.overload,
         pl_id.referring_owner,
         pl_id.referring_object_type,
         pl_id.referring_object_name,
         pl_id.usage,
         pl_id.external_call,
         pl_id.referring_line,
         pl_id.referring_column,
         pl_id.referring_source_text,
         CASE
            WHEN     pl_id.usage = 'DECLARATION'
                 AND pl_id.declared_type NOT IN ('PACKAGE', 'TRIGGER')
            THEN
               COUNT (
                  CASE
                     WHEN pl_id.usage NOT IN ('DECLARATION', 'DEFINITION')
                     THEN
                        1
                  END)
               OVER (PARTITION BY pl_id.signature)
         END
            nr_of_references,
         CASE
            WHEN     pl_id.usage = 'DECLARATION'
                 AND pl_id.declared_type NOT IN ('PACKAGE',
                                                 'FUNCTION',
                                                 'PROCEDURE',
                                                 'TRIGGER')
            THEN
               COUNT (CASE
                         WHEN pl_id.usage NOT IN ('DECLARATION',
                                                  'DEFINITION',
                                                  'ASSIGNMENT',
                                                  'CALL')
                         THEN
                            1
                      END)
               OVER (PARTITION BY pl_id.signature)
         END
            var_read_references,
         CASE
            WHEN     pl_id.usage = 'DECLARATION'
                 AND pl_id.declaring_object_type != 'TRIGGER'
                 AND pl_id.declared_type NOT IN ('PACKAGE', 'TRIGGER', 'LABEL')
            THEN
               COUNT (pl_id.external_call) OVER (PARTITION BY pl_id.signature)
         END
            nr_of_external_references,
         CASE
            WHEN UPPER (
                    SUBSTR (pl_id.referring_source_text,
                            pl_id.referring_column,
                            LENGTH (pl_id.declared_name))) =
                    pl_id.declared_name
            THEN
                  REGEXP_SUBSTR (
                     SUBSTR (pl_id.referring_source_text,
                             1,
                             pl_id.referring_column - 1),
                     '("?[a-zA-Z][a-zA-Z0-9_$#]*"?[.%]"?)*"?$')
               || SUBSTR (pl_id.referring_source_text,
                          pl_id.referring_column,
                          LENGTH (pl_id.declared_name))
               || REGEXP_SUBSTR (
                     SUBSTR (
                        pl_id.referring_source_text,
                        pl_id.referring_column + LENGTH (pl_id.declared_name),
                        1),
                     '"')
         END
            qualified_called_name,
         pl_id.signature
    FROM (WITH pl_declaration
               AS (SELECT decl.*,
                          CASE
                             WHEN TYPE IN ('FUNCTION', 'PROCEDURE')
                             THEN
                                DENSE_RANK ()
                                   OVER (PARTITION BY decl.owner,
                                                      decl.object_type,
                                                      decl.object_name,
                                                      decl.TYPE,
                                                      decl.name
                                         ORDER BY decl.line, decl.col)
                          END
                             overload
                     FROM all_identifiers decl
                    WHERE decl.usage = 'DECLARATION' -- Leave out calls to Oracle internals
                          AND decl.owner != 'SYS')
          SELECT pld.owner declaring_owner,
                 pld.object_type declaring_object_type,
                 pld.object_name declaring_object_name,
                 pld.line declaring_line,
                 pld.TYPE declared_type,
                 pld.name declared_name,
                 pld.overload,
                 i.owner referring_owner,
                 i.object_type referring_object_type,
                 i.object_name referring_object_name,
                 i.usage,
                 CASE
                    WHEN    i.object_name != pld.object_name
                         OR i.owner != pld.owner
                    THEN
                       'External'
                 END
                    external_call,
                 i.line referring_line,
                 i.col referring_column,
                 (SELECT s.text
                    FROM all_source s
                   WHERE     s.owner = i.owner
                         AND s.TYPE = i.object_type
                         AND s.name = i.object_name
                         AND s.line = i.line)
                    referring_source_text,
                 pld.signature
            FROM pl_declaration pld
                 JOIN all_identifiers i ON i.signature = pld.signature) pl_id
   WHERE     -- leave out obvious references to a package, these are always redundant
             -- because you can not just refer to a packagewithout referring
             -- to a subprogram, constant etc.; these are included in the query result anyway
             NOT (pl_id.declared_type = 'PACKAGE' AND pl_id.usage = 'REFERENCE')
         -- leave out obvious self references to a type, these are always redundant
         AND NOT (    pl_id.declared_type = 'TYPE'
                  AND pl_id.usage = 'REFERENCE'
                  AND pl_id.declaring_owner = pl_id.referring_owner
                  AND pl_id.declaring_object_name = pl_id.referring_object_name
                  AND pl_id.declaring_object_type = 'TYPE'
                  AND pl_id.referring_object_type = 'TYPE')
         AND (   pl_id.declaring_owner IN (USER,
                                           SYS_CONTEXT ('userenv',
                                                        'current_schema'))
              OR pl_id.referring_owner IN (USER,
                                           SYS_CONTEXT ('userenv',
                                                        'current_schema')))
ORDER BY pl_id.declaring_owner,
         CASE pl_id.declaring_object_type
            WHEN 'PACKAGE' THEN 10
            WHEN 'PACKAGE BODY' THEN 20
            WHEN 'TYPE' THEN 30
            WHEN 'TYPE BODY' THEN 40
            WHEN 'FUNCTION' THEN 50
            WHEN 'PROCEDURE' THEN 60
            WHEN 'TRIGGER' THEN 70
            ELSE 900
         END,
         pl_id.declaring_object_name,
         CASE WHEN pl_id.declared_type LIKE 'FORMAL%' THEN 20 ELSE 10 END,
         CASE pl_id.declared_type
            WHEN 'PACKAGE' THEN 10
            WHEN 'PACKAGE BODY' THEN 15
            WHEN 'TYPE' THEN 20
            WHEN 'TYPE BODY' THEN 20
            WHEN 'FUNCTION' THEN 20
            WHEN 'PROCEDURE' THEN 20
            WHEN 'CURSOR' THEN 30
            WHEN 'REFCURSOR' THEN 40
            WHEN 'CONSTANT' THEN 50
            WHEN 'NESTED TABLE' THEN 60
            WHEN 'VARRAY' THEN 70
            WHEN 'RECORD' THEN 80
            WHEN 'VARIABLE' THEN 90
            ELSE 500
         END,
         pl_id.declared_type,
         pl_id.declared_name,
         pl_id.overload,
         pl_id.signature,
         CASE pl_id.usage
            WHEN 'DECLARATION' THEN 10
            WHEN 'DEFINITION' THEN 20
            WHEN 'CALL' THEN 600
            WHEN 'ASSIGNMENT' THEN 600
            WHEN 'REFERENCE' THEN 900
            ELSE 500
         END,
         pl_id.external_call ASC NULLS FIRST,
         pl_id.usage,
         pl_id.referring_owner,
         pl_id.referring_object_type,
         pl_id.referring_object_name,
         pl_id.referring_line,
         pl_id.referring_column
/