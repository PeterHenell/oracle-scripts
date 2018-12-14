SELECT /* Ohio OUG 10/99 */ 
  TYPE || ' ' || owner || '.' || NAME
  FROM v$db_object_cache
 WHERE kept = 'YES';
