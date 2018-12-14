COLUMN obj FORMAT A40
COLUMN type FORMAT A20
TTITLE 'Pinned Objects'
SELECT owner || '.' || name obj, type
  FROM v$db_object_cache
 WHERE kept = 'YES'
 ORDER BY owner, name;
TTITLE OFF