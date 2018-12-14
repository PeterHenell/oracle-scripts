SELECT TRUNC (created_on), COUNT (*)
  FROM qdb_users
GROUP BY TRUNC (created_on)
ORDER BY TRUNC (created_on) DESC