/*
DECLARE
   /*DECLARE*/
   l_flying_things   DBMS_SQL.varchar2_table;
   l_list            VARCHAR2 (1000);
BEGIN
   l_flying_things (2 ** 31 - 1) := 'Pteromyini';
   l_flying_things (-1 * 2 ** 31 + 1) := 'Exocoetidae';

   l_index := l_flying_things.FIRST;

   /*LOOP*/

   DBMS_OUTPUT.put_line (LTRIM (l_list, ','));
END loop;
*/

DECLARE
   l_index           SIMPLE_INTEGER := 0;
   l_flying_things   DBMS_SQL.varchar2_table;
   l_list            VARCHAR2 (1000);
BEGIN
   l_flying_things (2 ** 31 - 1) := 'Pteromyini';
   l_flying_things (-1 * 2 ** 31 + 1) := 'Exocoetidae';

   l_index := l_flying_things.FIRST;

   WHILE (l_index IS NOT NULL)
   LOOP
      l_list := l_list || ',' || l_flying_things (l_index);

      l_index := l_flying_things.NEXT (l_index);
   END LOOP;

   DBMS_OUTPUT.put_line (LTRIM (l_list, ','));
END loop;
/

DECLARE
   l_index           PLS_INTEGER := 0;
   l_flying_things   DBMS_SQL.varchar2_table;
   l_list            VARCHAR2 (1000);
BEGIN
   l_flying_things (2 ** 31 - 1) := 'Pteromyini';
   l_flying_things (-1 * 2 ** 31 + 1) := 'Exocoetidae';

   l_index := l_flying_things.FIRST;

   WHILE (l_index IS NOT NULL)
   LOOP
      l_list := l_list || ',' || l_flying_things (l_index);

      l_index := l_flying_things.NEXT (l_index);
   END LOOP;

   DBMS_OUTPUT.put_line (LTRIM (l_list, ','));
END loop;
/

DECLARE
   l_index SIMPLE_INTEGER := 0;
   l_flying_things   DBMS_SQL.varchar2_table;
   l_list            VARCHAR2 (1000);
BEGIN
   l_flying_things (2 ** 31 - 1) := 'Pteromyini';
   l_flying_things (-1 * 2 ** 31 + 1) := 'Exocoetidae';

   l_index := l_flying_things.FIRST;

   LOOP
      l_list := l_list || ',' || l_flying_things (l_index);

      EXIT WHEN l_flying_things.NEXT (l_index) IS NULL;
      l_index := l_flying_things.NEXT (l_index);
   END LOOP;

   DBMS_OUTPUT.put_line (LTRIM (l_list, ','));
END loop;
/

DECLARE
   l_index           INTEGER := 0;
   l_flying_things   DBMS_SQL.varchar2_table;
   l_list            VARCHAR2 (1000);
BEGIN
   l_flying_things (2 ** 31 - 1) := 'Pteromyini';
   l_flying_things (-1 * 2 ** 31 + 1) := 'Exocoetidae';

   l_index := l_flying_things.FIRST;

   WHILE (l_index IS NOT NULL)
   LOOP
      l_list := l_list || ',' || l_flying_things (l_index);

      l_index := l_flying_things.NEXT (l_index);
   END LOOP;

   DBMS_OUTPUT.put_line (LTRIM (l_list, ','));
END loop;
/

