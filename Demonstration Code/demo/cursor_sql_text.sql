create or replace view cursor_sql_text as
  select cur.user_name, ar.sql_text /* shows more text than v$open_cursor */
    from v$sqlarea ar inner join v$open_cursor cur
    using ( hash_value, address )
    order by cur.user_name
/
