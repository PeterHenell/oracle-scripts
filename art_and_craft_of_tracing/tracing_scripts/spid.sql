select spid
from v$process p, v$session s
where s.sid = (select sid from v$mystat where rownum < 2)
and s.paddr = p.addr
/
